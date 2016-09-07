local addon, ns = ...
local oUF = ns.oUF

local function DotVal(val)
	if val then
		local valm, valk, vals = floor(val/1e6), floor(mod(val/1e3, 1e3)), floor(mod(val, 1e3))
		if val >= 1e6 then return ("|cffff3333%d|r'|cffffff33%03d|r'|cff33ff33%03d|r"):format(valm,valk,vals)
		elseif val >= 1e3 then return ("|cffffff33%d|r'|cff33ff33%03d|r"):format(valk,vals)
		else return ("|cff33ff33%d|r"):format(vals) end
	end
end
local function hex(r, g, b)
	if r then
		if (type(r) == 'table') then
			if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
		end
		return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
	end
end
local function SVal(val)
	if val then
		if (val >= 1e6) then
			return ("%.1fm"):format(val / 1e6)
		elseif (val >= 1e3) then
			return ("%.1fk"):format(val / 1e3)
		else
			return ("%d"):format(val)
		end
	end
end

oUF.Tags.Methods["DDG"] = function(unit)
	if UnitIsDead(unit) then
		return "|cffCFCFCF Dead|r"
	elseif UnitIsGhost(unit) then
		return "|cffCFCFCF Ghost|r"
	elseif not UnitIsConnected(unit) then
		return "|cffCFCFCF D/C|r"
	end
end
oUF.Tags.Events["DDG"] = "UNIT_HEALTH"

oUF.Tags.Methods["dothp"] = function(unit) 
	if UnitIsDead(unit) or UnitIsGhost(unit) or not UnitIsConnected(unit) then
		return oUF.Tags.Methods['DDG'](unit)
	elseif unit == "player" or unit == "target" then
		local hp = UnitHealth(unit)
		return DotVal(hp)
    else
        return oUF.Tags.Methods["perhp"](unit)
    end
end
oUF.Tags.Events["dothp"] = "UNIT_HEALTH"

oUF.Tags.Methods["shp"] = function(unit) 
	if UnitIsDead(unit) or UnitIsGhost(unit) or not UnitIsConnected(unit) then
		return oUF.Tags.Methods['DDG'](unit)
	elseif unit == "player" or unit == "target" then
		local hp = UnitHealth(unit)
		return SVal(hp)
    else
        return oUF.Tags.Methods["perhp"](unit)
    end
end
oUF.Tags.Events["dothp"] = "UNIT_HEALTH"

oUF.Tags.Methods["dperhp"]  = function(unit) 
	if UnitIsDead(unit) or UnitIsGhost(unit) or not UnitIsConnected(unit) then
		return oUF.Tags.Methods["DDG"](unit)
	else
		local per = oUF.Tags.Methods["perhp"](unit) or 0
		local colorstr = "|cffffffff"
		if per < 15 then colorstr = "|cffff1505"
		elseif per < 30 then colorstr = "|cffefef05" end
		return format("%s%03d|r", colorstr, per)
	end
end
oUF.Tags.Events["dperhp"] = "UNIT_HEALTH"

oUF.Tags.Methods["dperpp"]  = function(unit) 
    local m, per = UnitPowerMax(unit), 0
    local powerType, powerToken, altR, altG, altB = UnitPowerType(unit)
    
    if(m ~= 0) then
        if powerType == 0 then per = math.floor(UnitPower(unit)/m*100+.5)
        else per = UnitPower(unit) end
    end
        
	local color = "|cffA0A0A0"
	if powerType == 0 then
		color = hex(0,.5,.8)
	elseif powerType == 1 then
		color = hex(PowerBarColor["RAGE"])
	elseif powerType == 2 then
		color = hex(PowerBarColor["FOCUS"])
	elseif powerType == 3 then
		color = hex(PowerBarColor["ENERGY"])
	elseif powerType == 6 then
		color = hex(PowerBarColor["RUNIC_POWER"])
	end
	return format("%s%03d|r", color, per)
end
oUF.Tags.Events["dperpp"] = "UNIT_HEALTH"

oUF.Tags.Methods["powercolor"]  = function(unit)
	local powerType, powerToken, altR, altG, altB = UnitPowerType(unit)
	local power = UnitPower(unit)
	local color = "|cffA0A0A0"
	if powerType == 0 then
		color = hex(0,.5,.8)
	elseif powerType == 1 then
		color = hex(PowerBarColor["RAGE"])
	elseif powerType == 2 then
		color = hex(PowerBarColor["FOCUS"])
	elseif powerType == 3 then
		color = hex(PowerBarColor["ENERGY"])
	elseif powerType == 6 then
		color = hex(PowerBarColor["RUNIC_POWER"])
	end
	return format("%s%s|r", color, SVal(power))
end
oUF.Tags.Events["powercolor"] = "UNIT_POWER UNIT_MAXPOWER"

oUF.Tags.Methods["powercolor"]  = function(unit)
	local powerType, powerToken, altR, altG, altB = UnitPowerType(unit)
	local power = UnitPower(unit)
	local color = "|cffA0A0A0"
	if powerType == 0 then
		color = hex(0,.5,.8)
	elseif powerType == 1 then
		color = hex(PowerBarColor["RAGE"])
	elseif powerType == 2 then
		color = hex(PowerBarColor["FOCUS"])
	elseif powerType == 3 then
		color = hex(PowerBarColor["ENERGY"])
	elseif powerType == 6 then
		color = hex(PowerBarColor["RUNIC_POWER"])
	end
	return format("%s%s|r", color, SVal(power))
end
oUF.Tags.Events["powercolor"] = "UNIT_POWER UNIT_MAXPOWER"

oUF.Tags.Methods["eclipsecolor"]  = function(unit)
    local p = UnitPower('player', SPELL_POWER_ECLIPSE)
    local color = "|cffFFFFFF"
    if p < 0 then 
        p = -p
        color = "|cff6BAFFF"
    elseif p > 0 then 
        color = "|cffFFA51F"
    end
    return format("%s%s|r", color, p)
end
oUF.Tags.Events["eclipsecolor"] = "UNIT_POWER"
        
        
oUF.Tags.Methods["level"] = function(unit)
	local c = UnitClassification(unit)
	local l = UnitLevel(unit)
	local d = GetQuestDifficultyColor(l)
	
	local str = l
		
	if l <= 0 then 
		l = "??"
		d = { r = 250/255 , g = 20/255 , b = 0}
	end
	
	if c == "worldboss" then
		str = string.format("|cff%02x%02x%02xBoss|r",250,20,0)
	elseif c == "eliterare" then
		str = string.format("|cff%02x%02x%02x%s|r|cff0080FFR|r+",d.r*255,d.g*255,d.b*255,l)
	elseif c == "elite" then
		str = string.format("|cff%02x%02x%02x%s|r+",d.r*255,d.g*255,d.b*255,l)
	elseif c == "rare" then
		str = string.format("|cff%02x%02x%02x%s|r|cff0080FFR|r",d.r*255,d.g*255,d.b*255,l)
	else
		if not UnitIsConnected(unit) then
			d = GetQuestDifficultyColor(UnitLevel('player') - 11)
			str = string.format("|cff%02x%02x%02x|off",d.r*255,d.g*255,d.b*255)
		else
			if UnitIsPlayer(unit) then
				str = string.format("|cff%02x%02x%02x%s",d.r*255,d.g*255,d.b*255,l)
			elseif UnitPlayerControlled(unit) then
				str = string.format("|cff%02x%02x%02x%s",d.r*255,d.g*255,d.b*255,l)
			else
				str = string.format("|cff%02x%02x%02x%s",d.r*255,d.g*255,d.b*255,l)
			end
		end		
	end
	
	return str
end
oUF.Tags.Events["level"] = "UNIT_LEVEL PLAYER_LEVEL_UP UNIT_CLASSIFICATION_CHANGED"

oUF.Tags.Methods["afkdnd"] = function(unit)
	return UnitIsAFK(unit) and "|cffCFCFCF <afk>|r" or UnitIsDND(unit) and "|cffCFCFCF <dnd>|r" or ""
end
oUF.Tags.Events["afkdnd"] = "PLAYER_FLAGS_CHANGED"

oUF.Tags.Methods["color"] = function(unit)
	local _, class = UnitClass(unit)
	local reaction = UnitReaction(unit, "player")
	
	if UnitIsDead(unit) or UnitIsGhost(unit) or not UnitIsConnected(unit) then
		return "|cffA0A0A0"
	--elseif (UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit)) then
	--	return hex(oUF.colors.tapped)
	elseif (UnitIsPlayer(unit)) then
		return hex(oUF.colors.class[class])
	elseif reaction then
		return hex(oUF.colors.reaction[reaction])
	else
		return hex(1, 1, 1)
	end
end
oUF.Tags.Events["color"] = "UNIT_REACTION UNIT_HEALTH UNIT_HAPPINESS"

oUF.Tags.Methods["DemonicFuryText"]  = function(u)
	local min, max = UnitPower(u,SPELL_POWER_DEMONIC_FURY), UnitPowerMax(u,SPELL_POWER_DEMONIC_FURY)
	if min~=max then 
		return min
	else
		return max
	end
end
oUF.Tags.Events["DemonicFuryText"] = 'UNIT_POWER'

oUF.Tags.Methods["altpower"] = function(unit)
	local cur = UnitPower(unit, ALTERNATE_POWER_INDEX)
	local max = UnitPowerMax(unit, ALTERNATE_POWER_INDEX)
	if(max > 0 and not UnitIsDeadOrGhost(unit)) then
		return ("%s%%"):format(math.floor(cur/max*100+.5))
	end
end
oUF.Tags.Events["altpower"] = "UNIT_POWER"

