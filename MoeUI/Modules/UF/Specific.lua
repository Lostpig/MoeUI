local addon, namespace = ...
local Moe = namespace.Moe
local Lib = Moe.Lib
local Media = Moe.Media
local Theme = Moe.Theme
local MoeUF = Moe.Modules:Get("UnitFrame")
local oUF = namespace.oUF

local F = MoeUF.F
local Specific = {}
MoeUF.Specific = Specific

Specific.player = function(self, unit)
	local theme = Theme:Get("UnitFrame")
	local p, g = theme.Unit.player, theme.Global
	
	F.InitFrame(self)
	self.unit = unit
	self:SetSize(p.width, p.height)
    if not p.health.disable then
        F.CreateMainBar(self, unit, "Health", p.health)
    end
    if not p.power.disable then
        F.CreateMainBar(self, unit, "Power", p.power)
        self.Power.colorPower = p.power.usepowercolor
    end
    if not p.castbar.disable then
        F.CreateCastingBar(self, unit, p.castbar, g.castbar)
    end
    F.CreateHighlight(self, p.highlight or g.highlight)

    
	BuffFrame:Hide()
	F.PlayerBuffs(self, p.buffs)
	F.PlayerDebuffs(self, p.debuffs)
    
	if g.classbar.show then
		F.CreateClassBar(self, g.classbar)
	end
	if g.altpowerbar.show then
		F.CreateAltPower(self, g.altpowerbar)
	end
    if g.threatbar.show then
		F.CreateThreatBar(self, g.threatbar)
	end

	for k, v in pairs(p.tags) do
		F.CreateTag(self, unit, v)
	end
	for k, v in pairs(p.icons) do
		F.CreateIcon(self, unit, k, v)
	end
	
	if p.style and type(p.style) == "function" then p.style(self, unit) end
end
Specific.target = function(self, unit)
	local theme = Theme:Get("UnitFrame")
	local p, g = theme.Unit.target, theme.Global
	
	F.InitFrame(self)
	self.unit = unit
	self:SetSize(p.width, p.height)
	
	F.CreateMainBar(self, unit, "Health", p.health)
	F.CreateMainBar(self, unit, "Power", p.power)
	self.Power.colorPower = p.power.usepowercolor
	F.CreateHighlight(self, p.highlight or g.highlight)
	F.CreateCastingBar(self, unit, p.castbar, g.castbar)
	F.CreateAuras(self, p.auras)

	
	for k, v in pairs(p.tags) do
		F.CreateTag(self, unit, v)
	end
	for k, v in pairs(p.icons) do
		F.CreateIcon(self, unit, k, v)
	end
	
	if p.style and type(p.style) == "function" then p.style(self, unit) end
end
Specific.pet = function(self, unit)
	local theme = Theme:Get("UnitFrame")
	local p, g = theme.Unit.pet, theme.Global
	
	F.InitFrame(self)
	self.unit = unit
	self:SetSize(p.width, p.height)
	F.CreateMainBar(self, unit, "Health", p.health)
	F.CreateHighlight(self, p.highlight or g.highlight)
	
	if p.tags then 
		for k, v in pairs(p.tags) do
			F.CreateTag(self, unit, v)
		end
	end
	if p.icons then 
		for k, v in pairs(p.icons) do
			F.CreateIcon(self, unit, k, v)
		end
	end
	
	if p.style and type(p.style) == "function" then p.style(self, unit) end
end
Specific.targettarget = function(self, unit)
	local theme = Theme:Get("UnitFrame")
	local p, g = theme.Unit.targettarget, theme.Global
	
	F.InitFrame(self)
	self.unit = unit
	self:SetSize(p.width, p.height)
	F.CreateMainBar(self, unit, "Health", p.health)
	F.CreateHighlight(self, p.highlight or g.highlight)
	
	if p.tags then 
		for k, v in pairs(p.tags) do
			F.CreateTag(self, unit, v)
		end
	end
	if p.icons then 
		for k, v in pairs(p.icons) do
			F.CreateIcon(self, unit, k, v)
		end
	end
	
	if p.style and type(p.style) == "function" then p.style(self, unit) end
end
Specific.focus = function(self, unit)
	local theme = Theme:Get("UnitFrame")
	local p, g = theme.Unit.focus, theme.Global
	
	F.InitFrame(self)
	self.unit = unit
	self:SetSize(p.width, p.height)
	F.CreateMainBar(self, unit, "Health", p.health)
	F.CreateMainBar(self, unit, "Power", p.power)
	F.CreateHighlight(self, p.highlight or g.highlight)
	self.Power.colorPower = p.power.usepowercolor
	
	if p.auras.show then
		F.CreateAuras(self, p.auras)
	end
	if p.castbar.show then
		F.CreateCastingBar(self, unit, p.castbar, g.castbar)
	end
	
	if p.tags then 
		for k, v in pairs(p.tags) do
			F.CreateTag(self, unit, v)
		end
	end
	if p.icons then 
		for k, v in pairs(p.icons) do
			F.CreateIcon(self, unit, k, v)
		end
	end
	
	if p.style and type(p.style) == "function" then p.style(self, unit) end
end
Specific.focustarget = function(self, unit)
	local theme = Theme:Get("UnitFrame")
	local p, g = theme.Unit.focustarget, theme.Global
	
	F.InitFrame(self)
	self.unit = unit
	self:SetSize(p.width, p.height)
	F.CreateMainBar(self, unit, "Health", p.health)
	F.CreateHighlight(self, p.highlight or g.highlight)
	
	if p.tags then 
		for k, v in pairs(p.tags) do
			F.CreateTag(self, unit, v)
		end
	end
	if p.icons then 
		for k, v in pairs(p.icons) do
			F.CreateIcon(self, unit, k, v)
		end
	end
	
	if p.style and type(p.style) == "function" then p.style(self, unit) end
end
Specific.boss = function(self, unit)
	local theme = Theme:Get("UnitFrame")
	local p, g = theme.Unit.boss, theme.Global
	
	F.InitFrame(self)
	self.unit = unit
	self:SetSize(p.width, p.height)
	F.CreateMainBar(self, unit, "Health", p.health)
	F.CreateHighlight(self, p.highlight or g.highlight)
	
	if p.tags then 
		for k, v in pairs(p.tags) do
			F.CreateTag(self, unit, v)
		end
	end
	if p.icons then 
		for k, v in pairs(p.icons) do
			F.CreateIcon(self, unit, k, v)
		end
	end
	
	if p.style and type(p.style) == "function" then p.style(self, unit) end
end

