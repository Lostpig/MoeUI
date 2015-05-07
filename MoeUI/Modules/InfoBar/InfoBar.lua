local addon, namespace = ...
local Lib = namespace.Moe.Lib
local Modules = namespace.Moe.Modules
local Media = namespace.Moe.Media
local Theme = namespace.Moe.Theme

local path = Media.Path
local slotTable = "1HEAD3SHOULDER5CHEST6WAIST7LEGS8FEET9WRIST10HANDS16MAINHAND17SECONDARYHAND18RANGED"
local InfoFs = { size = 14, outline = "THINOUTLINE",
    anchor = "CENTER", align = "CENTER",
    x_off = 0, y_off = 0, textcolor = {0.91,0.98,0.94,.9},
    font = Media.Fonts.Default,
}
local MenuFs = { size = 14, outline = "THINOUTLINE",
    anchor = "CENTER", align = "CENTER",
    x_off = 0, y_off = 0, textcolor = {0.41,0.8,0.94,.6},
    font = Media.Fonts.Default,
}

local function EnterAlpha(self)             --按钮的alpha
	self.text:SetAlpha(1)
end
local function LeaveAlpha(self)
	self.text:SetAlpha(.6)
end

local function ChangeMenuInfo()
    local menu = Lib.GetPanel("MenuRegion")
    local info = Lib.GetPanel("InfoRegion")
    local switch = Lib.GetPanel("InfoBarSwitch")
    if menu:IsShown() then 
        menu:Hide()
        info:Show()
        switch.text:SetText("Info")
    else
        menu:Show()
        info:Hide()
        switch.text:SetText("Menu")
    end
end
local function CreateBarMover(frame)
    local movepx = frame:GetWidth()
    local moveh = frame:GetHeight() + 1
    Lib.Anime.New(frame, "rightin", {
        {Action = "Move", duration = 1, order = 1, params = {x = -movepx, y = 0, mode = "OUT"}}
    }, function(self) 
        self:GetParent():SetPoint("TOPLEFT", UIParent, "TOPLEFT", -movepx, 0)
    end)
    Lib.Anime.New(frame, "rightout", {
        {Action = "Move", duration = 1, order = 1, params = {x = movepx, y = 0, mode = "IN"}}
    }, function(self) 
        self:GetParent():SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0)
    end)
    
    Lib.Anime.New(frame, "upTrun", {
        {Action = "Move", duration = 1, order = 1, params = {x = 0, y = moveh, mode = "OUT"}, callback = ChangeMenuInfo},
        {Action = "Move", duration = 1, order = 2, params = {x = 0, y = -moveh, mode = "IN"}}
    })
end

local MenuBarList = {
    {   name = "MenuButtonMacro",   parent = "Moe_MenuRegion",      --1.Macro
        point = {"LEFT", 0, 0},
        level = 2,
        height = 16, width = 70, color = {1, 1, 1, 0},
        button = true, fontstring = MenuFs,
        text = "Macro",
        script = {
            OnClick = function(self)
                if(not MacroFrame) then ShowMacroFrame()
                elseif (MacroFrame:IsVisible()) then MacroFrame:Hide()
                else MacroFrame:Show() end
            end,
            OnEnter = EnterAlpha,
            OnLeave = LeaveAlpha,
		}
	},
	{   name = "MenuButtonPaper",   parent = "Moe_MenuRegion",      --2.Character
        point = {"LEFT", 70, 0},
        level = 2,
        height = 16, width = 70, color = {1, 1, 1, 0},
        button = true, fontstring = MenuFs,
        text = "Role",
        script = {
            OnClick = function(self) ToggleCharacter("PaperDollFrame") end,
            OnEnter = EnterAlpha,
            OnLeave = LeaveAlpha,
		}
	},
	{   name = "MenuButtonSpell",   parent = "Moe_MenuRegion",      --3.SpellBook
        point = {"LEFT", 140, 0},
        level = 2,
        height = 16, width = 70,color = {1, 1, 1, 0},
        button = true, fontstring = MenuFs,
        text = "Spell",
        script = {
            OnClick = function(self) ToggleSpellBook("spell") end,
            OnEnter = EnterAlpha,
            OnLeave = LeaveAlpha,
		}
	},
	{   name = "MenuButtonTalent",  parent = "Moe_MenuRegion",	    --4.Talent
        point = {"LEFT", 210, 0},
        level = 2,
        height = 16,width = 70,color = {1, 1, 1, 0},
        button = true, fontstring = MenuFs,
        text = "Talent",
        script = {
            OnClick = function(self) ToggleTalentFrame() end,
            OnEnter = EnterAlpha,
            OnLeave = LeaveAlpha,
		}
	},
    {   name = "MenuButtonLFD",     parent = "Moe_MenuRegion",	    --5.LFD
        point = {"LEFT", 280, 0},
        level = 2,
        height = 16, width = 70, color = {1, 1, 1, 0},
        button = true, fontstring = MenuFs,
        text = "LFD",
        script = {
            OnClick = function(self) PVEFrame_ToggleFrame() end,
            OnEnter = EnterAlpha,
            OnLeave = LeaveAlpha,
        }
	},
    {   name = "MenuButtonEJ",      parent = "Moe_MenuRegion",	    --6.EJ
        point = {"LEFT", 350, 0},
        level = 2,
        height = 16, width = 70, color = {1, 1, 1, 0},
        button = true, fontstring = MenuFs,
        text = "EJ",
        script = {
            OnClick = function(self) ToggleEncounterJournal() end,
            OnEnter = EnterAlpha,
            OnLeave = LeaveAlpha,
        }
	},    
    {   name = "MenuButtonTheme",   parent = "Moe_MenuRegion",	    --7.Theme
        point = {"LEFT", 420, 0},
        level = 2,
        height = 16, width = 70, color = {1, 1, 1, 0},
        button = true, fontstring = MenuFs,
        text = "Theme",
        script = {
            OnClick = function(self) namespace.Moe.Theme.ShowOption() end,
            OnEnter = EnterAlpha,
            OnLeave = LeaveAlpha,
        }
	},

}
local InfoBarList = {
	--信息栏部分--
	{   name = "Info_Memory",       parent = "Moe_InfoRegion",    --1.Memory
        point = {"LEFT", 0, 0},
        level = 3,
        height = 16, width = 80, color = {1, 1, 1, 0},
        button = true, fontstring = InfoFs,
        text = function()
            local totle = 0
            --local MemoryTable = {}
            UpdateAddOnMemoryUsage()
            for i = 1, GetNumAddOns() do 
                local name,title = GetAddOnInfo(i)
                if IsAddOnLoaded(i) then 
                    totle = totle + GetAddOnMemoryUsage(i)
                end
            end	
            local r,g,b = 1,1,1
            if totle < 5120 then r,g,b = 0,1,0
            elseif totle < 10240 then r,g,b = 1,1,0
            else r,g,b = 1,0,0 end
            return format("Mem:|cff%s%s|r",Lib.ColorTurn(r,g,b),Lib.MemoryCount(totle))
        end,
        script = {
            OnUpdate = function(self,elapsed)
                if not self.hoved then return end
                if IsAltKeyDown() and not self.altdown then self.altdown = true self:GetScript("OnEnter")(self)
                elseif not IsAltKeyDown() and self.altdown then self.altdown = false self:GetScript("OnEnter")(self) end
            end,
            OnEnter = function(self)
                self.hoved = true
                local totle = 0
                local MemoryTable = {}
                GameTooltip:SetOwner(self,"ANCHOR_BOTTOMRIGHT",0,0)
                GameTooltip:ClearLines()
                GameTooltip:AddLine("插件列表:")
                UpdateAddOnMemoryUsage()
                for i = 1, GetNumAddOns() do 
                    local name,title = GetAddOnInfo(i)
                    if IsAddOnLoaded(i) then 
                        totle = totle + GetAddOnMemoryUsage(i)
                        tinsert(MemoryTable,{title or name,GetAddOnMemoryUsage(i)})
                    end
                end	
                table.sort(MemoryTable, function(a,b) return a[2] > b[2] end)
                for i,v in ipairs(MemoryTable) do
                    if not IsAltKeyDown() and i < 15 then 
                        GameTooltip:AddDoubleLine(v[1]..":",Lib.MemoryCount(v[2]))
                    elseif IsAltKeyDown() then
                        GameTooltip:AddDoubleLine(v[1]..":",Lib.MemoryCount(v[2]))
                    end
                end
                GameTooltip:AddLine("--------------------")
                GameTooltip:AddDoubleLine("|cffffffff总占用|r: ",Lib.MemoryCount(collectgarbage("count")))
                GameTooltip:AddDoubleLine("|cffffffffBLZ默认占用|r: ",Lib.MemoryCount(collectgarbage("count") - totle))
                if getn(MemoryTable) > 15 then
                    GameTooltip:AddLine("按ALT显示全部插件")
                end
                GameTooltip:Show()
            end,
            OnLeave = function(self) 
                self.hoved = false
                GameTooltip:Hide() 
            end,
        }
    },
	{   name = "Info_FPS",          parent = "Moe_InfoRegion",    --2.FPS
        point = {"LEFT", 80, 0},
        level = 3, ref = 0.5,
        height = 16, width = 80, color = {1, 1, 1, 0},
        button = true, fontstring = InfoFs,
        text = function()
            return format("FPS:%d", floor(GetFramerate()))
        end,
	},
	{   name = "Info_Latency",      parent = "Moe_InfoRegion",    --3.Latency
        point = {"LEFT", 160, 0},
        level = 3,ref = 5,
        height = 16, width = 80, color = {1, 1, 1, 0},
        button = false, fontstring = InfoFs,
        text = function()
            local latency = select(3,GetNetStats())
            return format("Lag:%d",latency)
        end,
        script = {
            OnEnter = function(self)
                local download, upload, latencyHome, latencyWorld = GetNetStats()
                GameTooltip:SetOwner(self,"ANCHOR_BOTTOMRIGHT",0,0)
                GameTooltip:ClearLines()
                GameTooltip:AddDoubleLine("本地延遲:",format("%d ms",latencyHome))
                GameTooltip:AddDoubleLine("世界延遲:",format("%d ms",latencyWorld))
                GameTooltip:AddDoubleLine("上行速率:",format("%.2f KB/S",download))
                GameTooltip:AddDoubleLine("下行速率:",format("%.2f KB/S",upload))
                GameTooltip:Show()
            end,
            OnLeave = function(self)
                GameTooltip:Hide()
            end,
		}
	},
	{   name = "Info_Durability",   parent = "Moe_InfoRegion",    --4.Durability
        point = {"LEFT", 240, 0},
        level = 3,
        height = 16, width = 80, color = {1, 1, 1, 0},
        button = false, fontstring = InfoFs,
        event = {"UPDATE_INVENTORY_DURABILITY","PLAYER_LOGIN"},
        script = {
            OnEvent = function(self,event)
                local dmin = 100
                for id = 1, 18 do
                    local dur, dmax = GetInventoryItemDurability(id)
                    if dur ~= dmax then dmin = floor(min(dmin,dur/dmax*100)) end
                end
                self.text:SetText(format("Dur:|cff%s%d %%|r",Lib.PercentColor(dmin/100),dmin))
            end,
            OnEnter = function(self)
                GameTooltip:SetOwner(self,"ANCHOR_BOTTOMRIGHT",0,0)
                GameTooltip:ClearLines()
                for slot, string in gmatch(slotTable,"(%d+)([^%d]+)") do
                    local string = _G[string.."SLOT"]
                    local dur, dmax = GetInventoryItemDurability(slot)
                    if dur ~= dmax then 
                        GameTooltip:AddDoubleLine(string,format("|cff%s%d%%|r",Lib.PercentColor(dur/dmax),floor(dur/dmax*100)))
                    end
                end
                GameTooltip:Show()
            end,
            OnLeave = function(self) GameTooltip:Hide() end,
        }
	},
	{   name = "Info_Gold",         parent = "Moe_InfoRegion",    --5.Gold
        point = {"LEFT", 320, 0},
        level = 3,
        height = 16, width = 80, color = {1, 1, 1, 0},
        button = false,fontstring = InfoFs,
        event = {"PLAYER_LOGIN", "PLAYER_MONEY", "PLAYER_ENTERING_WORLD", "ADDON_LOADED"},
        script = {
            OnEvent = function(self,event)
                local money = GetMoney()
                local gold, silver, copper = floor(money/10000), floor(mod(money/100, 100)), floor(mod(money, 100))
                local goldstr = "|cffffd700%d|r|cffc7c7cf%d|r|cffeda55f%d|r"
                if gold > 10000 then goldstr = "|cffffd700%d|r" 
                elseif gold > 100 then goldstr = "|cffffd700%d|r|cffc7c7cf%d|r" end
                local goldtext = format(goldstr, gold, silver, copper)
                
                self.text:SetText("Gold:"..goldtext)
            end
		},
	},
	{   name = "Info_Bags",         parent = "Moe_InfoRegion",    --6.Bags
        point = {"LEFT", 400, 0},
        level = 3,
        height = 16, width = 80, color = {1, 1, 1, 0},
        button = true, fontstring = InfoFs,
        event = {"PLAYER_LOGIN", "BAG_UPDATE"},
        script = {
            OnEvent = function(self,event)
                local free, total = 0, 0
                for i = 0, NUM_BAG_SLOTS do
                    free, total = free + GetContainerNumFreeSlots(i), total + GetContainerNumSlots(i)
                end
                self.text:SetText(format("Bag:|cff%s%d/%d|r", Lib.PercentColor(free/total), free, total))
            end,
            OnClick = function(self)
                ToggleBag(0)
            end,
        }
	},
}

local function CreateRegions(theme)
    local infobar = Lib.CreatePanel({ --InfoBar
        name = "InfoBar", parent = "UIParent",
        point = {"TOPLEFT", UIParent, "TOPLEFT", -theme.barwidth, 0},
        height = theme.barheight, width = theme.barwidth, 
        level = 1, grad = theme.bargrad, --{"HORIZONTAL", .1, .1, .1, .6, .1, .1, .1, 0},
        texture = theme.barbg, color = theme.barcolor,
        backdrop = theme.backdrop, bordercolor = theme.bordercolor,
        flip_h = theme.flip_h, flip_v = theme.flip_v,
        event = {"PLAYER_REGEN_ENABLED", "PLAYER_REGEN_DISABLED"},
        script = {
            OnLoad = function(self)
                CreateBarMover(self)
            end,
            OnEvent = function(self, event)
                if event == "PLAYER_REGEN_DISABLED" then self:EnableMouse(false)
                else self:EnableMouse(true) end
            end,
        },
	})
    local switch = Lib.CreatePanel({ --InfoBar Switch
        name = "InfoBarSwitch", parent = "Moe_InfoBar",
        point = {"RIGHT", infobar, "RIGHT", 0, 0},
        texture = theme.switch.texture, level = 4,
        height = theme.switch.height, width = theme.switch.width, 
        color = theme.switch.color,
        flip_h = theme.switch.flip_h, flip_v = theme.switch.flip_v,
        backdrop = theme.switch.backdrop, bordercolor = theme.switch.bordercolor,
        button = true, fontstring = theme.switch.fs or InfoFs,
        text = "Menu",
        script = {
            OnClick = function(self) self:GetParent().upTrun:Play() end,
            OnEnter = EnterAlpha,
            OnLeave = LeaveAlpha,
		}
    })
    local mover = Lib.CreatePanel({ --InfoBar Move
        name = "InfoBarMover", parent = "Moe_InfoBar", 
        point = {"LEFT", infobar, "RIGHT", 0, 0},
        texture = theme.mover.texture, level = 4,
        height = theme.mover.height, width = theme.mover.width, 
        color = theme.mover.color,
        backdrop = theme.mover.backdrop, bordercolor = theme.mover.bordercolor,
        flip_h = theme.mover.flip_h, flip_v = theme.mover.flip_v,
        button = true, fontstring = theme.mover.fs or InfoFs,
        text = theme.mover.outtext, 
        attr = {status = "in"},
        script = {
            OnClick = function(self)
                if self:GetAttribute("status") == "in" then 
                    self:GetParent().rightout:Play() 
                    self:SetAttribute("status", "out")
                    self.text:SetText(theme.mover.intext)
                else 
                    self:GetParent().rightin:Play() 
                    self:SetAttribute("status", "in")
                    self.text:SetText(theme.mover.outtext)
                end
            end,
            OnEnter = EnterAlpha,
            OnLeave = LeaveAlpha,
		}
    })

    local menuregion = Lib.CreatePanel({ --Menu容器
        name = "MenuRegion", parent = "Moe_InfoBar",
        point = {"TOPLEFT", 0, 0},
        height = theme.barheight, width = theme.barwidth, 
        level = 1, color = {0, 0, 0, 0},
	})
    local inforegion = Lib.CreatePanel({ --Info容器
        name = "InfoRegion", parent = "Moe_InfoBar",
        point = {"TOPLEFT", 0, 0},
        height = theme.barheight, width = theme.barwidth, 
        level = 1, color = {0, 0, 0, 0}, hide = true,
	})
end

local function Load()
    local theme = Theme:Get("InfoBar")
    CreateRegions(theme)
    for index, sets in next, MenuBarList do
        local menuItem = Lib.CreatePanel(sets)
        if theme.StyleMenuItem then theme.StyleMenuItem(menuItem, index) end
    end
    for index, sets in next, InfoBarList do
        local infoItem = Lib.CreatePanel(sets)
        if theme.StyleInfoItem then theme.StyleInfoItem(infoItem, index) end
    end
end
Modules:AddModule("InfoBar", Load, nil)