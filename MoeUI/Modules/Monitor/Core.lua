local addon, namespace = ...
local Modules = namespace.Moe.Modules
local Media = namespace.Moe.Media
local Lib = namespace.Moe.Lib
local MM = Modules:Get("Monitor")

local argcheck = MM.Private.argcheck
local print    = MM.Private.print
local error    = MM.Private.error

local Region = {}
local Elements = {}
local ClassSets = {}
local Triggers = {}
local ActiveTrigger

local function GetAnchor(anchor)
    if anchor == "UIParent" then return UIParent
    elseif Region[anchor] then return Region[anchor]
    elseif _G[anchor] then return _G[anchor]
    else return error('找不到锚点框体 [%s]', anchor) end
end

local Fade = function(self, event)
    if event == "PLAYER_REGEN_DISABLED" then
        UIFrameFadeOut(self, 1, self.lcalpha, 1)
    elseif event == "PLAYER_REGEN_ENABLED" then
        UIFrameFadeOut(self, 1, 1, self.lcalpha)
    end
end
MM.AddRegion = function(self, name, sets)
    argcheck(name, 2, 'string')
    argcheck(sets, 2, 'table')
    
    if Region[name] then return error('Region [%s] 已注册', name) end
    
    local region = CreateFrame("Frame", name, UIParent)
    region:SetWidth(sets.width)
    region:SetHeight(sets.height)
    
    local anchorparent = GetAnchor(sets.point.parent)
    region:SetPoint(sets.point.anchor, anchorparent, sets.point.relative, sets.point.x, sets.point.y)
    
    if sets.bg then 
        region.bg = region:CreateTexture(nil, "BACKGROUND")
        region.bg:SetAllPoints(region)
		region.bg:SetTexture(sets.bg.texture)
        region.bg:SetVertexColor(sets.bg.color.r, sets.bg.color.g, sets.bg.color.b, sets.bg.color.a or .8)
    end
        
    if sets.showcombat or sets.fadecombat then
        if sets.fadecombat then region.lcalpha = 0.2 end
        if sets.showcombat then region.lcalpha = 0 end

        region:RegisterEvent("PLAYER_REGEN_ENABLED")
        region:RegisterEvent("PLAYER_REGEN_DISABLED")
        region:SetScript("OnEvent", Fade)
        
        if UnitAffectingCombat("player") then region:SetAlpha(1)
        else region:SetAlpha(region.lcalpha) end
    end
    
    Region[name] = region
end
MM.AddElement = function(self, name, create)
    argcheck(name,   2, 'string')
    argcheck(create, 3, 'function')

	if (Elements[name]) then return error('Element [%s] 已注册.', name) end
	Elements[name] = { create = create, }
end
MM.AddClassSet = function(self, class, create, start, pause)
    argcheck(class,  2, 'string')
    argcheck(create, 3, 'function')
    argcheck(start,  4, 'function')
    argcheck(pause,  5, 'function')
    
    if(ClassSets[class]) then return error('职业设置 [%s] 已注册.', class) end
    ClassSets[class] = {
        create = create,
        start = start,
        pause = pause,
    }
end

local EnableElement = function(region, name)
    argcheck(name, 2, 'string')
    if not Region[region][name] then return error("Region[%s]中没有找到Element [%s]", region, name) end
    Region[region][name]:enable()
end
local DisableElement = function(region, name)
    argcheck(name, 2, 'string')
    if not Region[region][name] then return error("Region[%s]中没有找到Element [%s]", region, name) end
    Region[region][name]:disable()
end
MM.Spawn = function(self, element, region, name, ...)
    argcheck(element, 2, 'string')
    argcheck(region,  3, 'string')
    argcheck(name,    3, 'string')

    if not Elements[element] then return error("没有找到Element [%s]", element)
    elseif not Region[region] then return error("没有找到Region [%s]", region)
    else 
        return Elements[element].create(Region[region], name, ...) 
    end
end
MM.EnableElements = function(self, region, ...)
    argcheck(region, 2, 'string')
    if not Region[region] then return error("没有找到Region [%s]", region) end
    
    for _, name in next, {...} do
        EnableElement(region, name)
    end
end
MM.DisableElements = function(self, region, ...)
    argcheck(region, 2, 'string')
    if not Region[region] then return error("没有找到Region [%s]", region) end
    for _, name in next, {...} do
        DisableElement(region, name)
    end
end

MM.ActiveClass = function(self, class)
    if not ClassSets[class] then return error("没有找到[%s]职业模块",class) end
    if not ClassSets[class].isCreated then
        ClassSets[class].create()
        ClassSets[class].isCreated = true
    end
    ClassSets[class].start()
end
MM.PauseClass = function(self, class)
    if not ClassSets[class] then return error("没有找到[%s]职业模块",class)
    elseif not ClassSets[class].isCreated then return error("[%s]职业模块尚未启用,无法停用",class) end
    ClassSets[class].pause()
end

local DefaultTrigger = function()
    local class = select(2, UnitClass("player"))
    MM:ActiveClass(class)
end
MM.RegisterTrigger = function(self, name, trigger)
    argcheck(name,    2, 'string')
    argcheck(trigger, 3, 'function')
    
    if Triggers[name] then return error('Trigger [%s] 已注册', name) end
    Triggers[name] = trigger
end
MM.ActiveTrigger = function(self, name)
    argcheck(name,    2, 'string')
    if not Triggers[name] then return error('没有找到Trigger [%s]', name) end
    ActiveTrigger = name
end
MM.GetTrigger = function(self)
    if not Triggers[ActiveTrigger] then return error('没有找到激活的Trigger [%s], Moe Monitor无法启用', name) end
    return Triggers[ActiveTrigger]
end

MM:RegisterTrigger("Default", DefaultTrigger)
MM:ActiveTrigger("Default")

local function Load()
    local trigger = MM:GetTrigger()
    trigger()
end
Modules:AddModule("Monitor", Load, nil)
