local addon, namespace = ...
local Media = namespace.Moe.Media
local Modules = namespace.Moe.Modules
local Lib = namespace.Moe.Lib
local MoeStatus = Modules:Get("Status")

local cuversion = "1.07"
local tplayerClass, tmaintalent
local config = {
	font = Media.Fonts.T,
	fontsize = 14,
	fontflags = "THINOUTLINE",
    spacing = 4,
    vfont = Media.Fonts.Default,
    vfontsize = 16,
    vfontflags = "THINOUTLINE",
}

local Language = {
	zhCN={
		["AttackPower"]	= "攻强",
		["SpellPower"]	= "法强",
		["Armor"]		= "护甲",
		
		["Mastery"]		= "精通",
		["Crit"]		= "暴击",
		["Haste"]		= "急速",
		["Multistrike"]	= "溅射",
		["Versatility"]	= "全能",
		
		["AttackSpeed"]	= "攻速",
		
		["Regen"] 		= "回复",
		["ManaRegen"]	= "法力回复",
		["EnergyRegen"]	= "能量回复",
		["RuneRegen"]	= "符文回复",
		["FocusRegen"]	= "集中回复",
		
		["BonusArmor"]	= "护甲加成",
		["Dodge"]		= "躲闪",
		["Parry"]		= "招架",
		["Block"]		= "格挡",
		
		["LifeSteal"]	= "吸血",
		["Avoidance"]	= "闪避",
		
		["OK"]			= "确定",
	}
}
local L = Language.zhCN
local DUTY = {
	MELEE = 1,
	SPELL = 2,
	HEALTH = 3,
	TANK = 4,
}
local STASTR = {
	ATTACKPOWER = "|cffff3333%d|r",
	SPELLPOWER 	= "|cff1166ee%d|r",
	ARMOR 		= "|cffffff00%d|r",
	
	MASTERY 	= "|cff33ff00%.2F%%|r",
	CRIT 		= "|cffff8800%.2F%%|r",
	HASTE 		= "|cff33aaff%.2F%%|r",
	MULTISTRIKE = "|cffcc8844%.2F%%|r",
	VERSATILITY = "|cffffff33%.2F%%|r/|cffffff33%.2F%%|r",
	
	ATTACKSPEED = "|cff33ff99%.2F|r",
	TWOHANDSATTACKSPEED = "|cff33ff99%.2F|r/|cff33ff99%.2F|r",
	
	ENERGYREGEN = "|cff" .. Lib.ColorTurn(PowerBarColor["ENERGY"].r,PowerBarColor["ENERGY"].g,PowerBarColor["ENERGY"].b) .. "%d|r",
	RUNEREGEN 	= "|cff" .. Lib.ColorTurn(PowerBarColor["RUNIC_POWER"].r,PowerBarColor["RUNIC_POWER"].g,PowerBarColor["RUNIC_POWER"].b) .. "%d|r",
	FOCUSREGEN 	= "|cff" .. Lib.ColorTurn(PowerBarColor["FOCUS"].r,PowerBarColor["FOCUS"].g,PowerBarColor["FOCUS"].b) .. "%d|r",
	MANAREGEN 	= "|cff13e6ff%d|r",
	
	BONUSARMOR 	= "|cffff3333%d|r",
	DODGE 		= "|cffff3333%d|r",
	PARRY		= "|cffff3333%d|r",
	BLOCK		= "|cffff3333%d|r",
	
	LIFESTEAL	= "|cff888888%d|r",
	AVOIDANCE	= "|cff888888%d|r",
}

local ClassSets = {
	--战士        1武器2狂暴3防
	["WARRIOR"]     = {[1] = DUTY.MELEE,  [2] = DUTY.MELEE,  [3] = DUTY.TANK, },
	--法师        3系都是法系DPS
	["MAGE"]        = {[1] = DUTY.SPELL,  [2] = DUTY.SPELL,  [3] = DUTY.SPELL, },
	--盗贼        3系都是物理DPS
	["ROGUE"]       = {[1] = DUTY.MELEE,  [2] = DUTY.MELEE,  [3] = DUTY.MELEE, },
	--德鲁伊      1鸟2猫3熊4奶
	["DRUID"]       = {[1] = DUTY.SPELL,  [2] = DUTY.MELEE,  [3] = DUTY.TANK, [4] = DUTY.HEALTH, },
	--猎人        3系都是物理DPS
	["HUNTER"]      = {[1] = DUTY.MELEE,  [2] = DUTY.MELEE,  [3] = DUTY.MELEE, },
	--萨满        1元素2增强3恢复
	["SHAMAN"]      = {[1] = DUTY.SPELL,  [2] = DUTY.MELEE,  [3] = DUTY.HEALTH, },
	--牧师        1戒2神3暗影
	["PRIEST"]      = {[1] = DUTY.HEALTH, [2] = DUTY.HEALTH, [3] = DUTY.SPELL, },
	--术士        3系都是法系DPS
	["WARLOCK"]     = {[1] = DUTY.SPELL,  [2] = DUTY.SPELL,  [3] = DUTY.SPELL, },
	--圣骑士      1奶2放3惩戒
	["PALADIN"]     = {[1] = DUTY.HEALTH,   [2] = DUTY.TANK,  [3] = DUTY.MELEE, },
	--死亡骑士    1血2冰3邪
	["DEATHKNIGHT"]	= {[1] = DUTY.TANK,   [2] = DUTY.MELEE,  [3] = DUTY.MELEE, },
	--武僧        1酒仙2织雾3踏风
	["MONK"]		= {[1] = DUTY.TANK,   [2] = DUTY.HEALTH, [3] = DUTY.MELEE, },
}
local StatusSets = {
	--基础属性
	["AttackPower"] = {
		Des = L["AttackPower"],
		Value = function() 
			local rangedWeapon = IsRangedWeapon()
			local base, posBuff, negBuff
			
			if ( rangedWeapon ) then
				base, posBuff, negBuff = UnitRangedAttackPower("player")
			else 
				base, posBuff, negBuff = UnitAttackPower("player")
			end
			
			return format(STASTR.ATTACKPOWER, base + posBuff + negBuff)
		end
	},
	["SpellPower"] = {
		Des = L["SpellPower"],
		Value = function()
			local maxspellpower = 0
			local holySchool = 2
			-- Start at 2 to skip physical damage
			maxspellpower = GetSpellBonusDamage(holySchool);
		
			for i = (holySchool + 1), MAX_SPELL_SCHOOLS do
				local bonusDamage = GetSpellBonusDamage(i);
				maxspellpower = min(maxspellpower, bonusDamage);
			end
			return format(STASTR.SPELLPOWER, maxspellpower)
		end
	},
	["Armor"] = {
		Des = L["Armor"],
		Value = function()
			local bonusArmor = UnitBonusArmor("player")
			return format(STASTR.ARMOR, bonusArmor)
		end
	},
	--强化属性
	["Mastery"] = {
		Des = L["Mastery"],
		Value = function()
			local masteryValue
			if UnitLevel("player") < SHOW_MASTERY_LEVEL then masteryValue = 0.0 
			else masteryValue = GetMasteryEffect() end
			return format(STASTR.MASTERY, masteryValue)
		end
	},
	["Crit"] = {
		Des = L["Crit"],
		Value = function(duty)
			local rangedWeapon = IsRangedWeapon()
			local critchance
			if ( rangedWeapon ) then
				critchance =  GetRangedCritChance()
			elseif (duty == DUTY.MELEE or duty == DUTY.TANK) then
				critchance =  GetCritChance()
			else
				local holySchool = 2
				critchance = GetSpellCritChance(holySchool)
				for i = (holySchool + 1), MAX_SPELL_SCHOOLS do
					if (GetSpellCritChance(i) > critchance) then critchance = GetSpellCritChance(i) end
				end
			end
			return format(STASTR.CRIT, critchance)
		end
	},
	["Haste"] = {
		Des = L["Haste"],
		Value = function(duty)
			return format(STASTR.HASTE, GetHaste())
		end
	},
	["Multistrike"] = {
		Des = L["Multistrike"],
		Value = function(duty)
			return format(STASTR.MULTISTRIKE, GetMultistrike())
		end
	},
	["Versatility"] = {
		Des = L["Versatility"],
		Value = function(duty)
			local versatility = GetCombatRating(CR_VERSATILITY_DAMAGE_DONE)
			local versatilityDamageBonus = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)
			local versatilityDamageTakenReduction = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_TAKEN) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_TAKEN)
			return format(STASTR.VERSATILITY, versatilityDamageBonus, versatilityDamageTakenReduction)
		end
	},

	["AttackSpeed"] = {
		Des = L["AttackSpeed"],
		Value = function(duty)
			local speed, offhandSpeed = UnitAttackSpeed("player")
			local atkspd
			if ( offhandSpeed ) then atkspd = format(STASTR.TWOHANDSATTACKSPEED, speed, offhandSpeed) 
			else atkspd = format(STASTR.ATTACKSPEED, speed) end
			return atkspd
		end
	},
	["Regen"] = {
		--[[Des = function(duty) 
			local powerType, powerToken = UnitPowerType("player")
			local des
			if (powerToken == "ENERGY") then des = L["EnergyRegen"]
			elseif (powerToken == "FOCUS") then des = L["FocusRegen"]
			elseif (tplayerClass == "DEATHKNIGHT") then des = L["RuneRegen"]
			else des = L["ManaRegen"] end
		end,]]--
		Des = L["Regen"],
		Value = function(duty)
			local powerType, powerToken = UnitPowerType("player")
			local regen
			
			if (powerToken == "ENERGY") then regen = format(STASTR.ENERGYREGEN, GetPowerRegen())
			elseif (powerToken == "FOCUS") then regen = format(STASTR.FOCUSREGEN, GetPowerRegen())
			elseif (tplayerClass == "DEATHKNIGHT") then regen = format(STASTR.RUNEREGEN, GetRuneCooldown(1))
			elseif (duty == DUTY.HEALTH) then
				local base, combat = GetManaRegen()
				regen = format(STASTR.MANAREGEN, (combat * 5)) 
			else
				regen = "0"
			end
			
			return regen
		end
	},

	["BonusArmor"] = {
		Des = L["BonusArmor"],
		Value = function(duty)
			local bonusArmor, isNegatedForSpec = UnitBonusArmor("player")
			return format(STASTR.BONUSARMOR, bonusArmor)
		end
	},
	["Dodge"] = {
		Des = L["Dodge"],
		Value = function(duty)
			return format(STASTR.DODGE, GetDodgeChance())
		end
	},
	["Parry"] = {
		Des = L["Parry"],
		Value = function(duty)
			return format(STASTR.PARRY, GetParryChance())
		end
	},
	["Block"] = {
		Des = L["Block"],
		Value = function(duty)
			return format(STASTR.BLOCK, GetBlockChance())
		end
	},
	--附加属性
	["LifeSteal"] = {
		Des = L["LifeSteal"],
		Value = function(duty)
			return format(STASTR.LIFESTEAL, GetLifesteal())
		end
	},
	["Avoidance"] = {
		Des = L["Avoidance"],
		Value = function(duty)
			return format(STASTR.AVOIDANCE, GetAvoidance())
		end
	},
}
local DutySets = {
	[DUTY.TANK] = {
		"Armor",
		"Versatility",
		"Mastery",
		"BonusArmor",
		"Dodge",
		"Parry",
		"Block",
	},
	[DUTY.MELEE] = {
		"AttackPower",
		"Mastery",
		"Crit",
		"Haste",
		"Multistrike",
		"Versatility",
		"AttackSpeed",
	},
	[DUTY.SPELL] = {
		"SpellPower",
		"Mastery",
		"Crit",
		"Haste",
		"Multistrike",
		"Versatility",
		"LifeSteal",
	},
	[DUTY.HEALTH] = {
		"SpellPower",
		"Mastery",
		"Crit",
		"Haste",
		"Multistrike",
		"Versatility",
		"Regen",
	},
}
local PlayerDuty = DUTY.MELEE
local StatusItems = {}

local function UpdateItems(f, elapsed)
	f.timeSpace = f.timeSpace + elapsed
	if (f.timeSpace > 1) then
		for i = 1, #DutySets[PlayerDuty] do
			StatusItems[i]:SetValue(StatusSets[DutySets[PlayerDuty][i]].Value(PlayerDuty))
		end
		f.timeSpace = 0
	end
end
local function CreateItem(f, index)
	local item = {}
    local d = f.dir
    local fd = (d == "LEFT") and "RIGHT" or "LEFT"
    local fz = index == 1 and  config.fontsize * 1.1 or config.fontsize
    local vfz = index == 1 and  config.vfontsize * 1.1 or config.vfontsize
    
	item.Des = f:CreateFontString(nil, 'OVERLAY')
	item.Des:SetFont(config.font, fz, config.fontflags)

    if index == 1 then
        item.Des:SetPoint('TOP'..d, f, 'TOP'..d, 0, -config.spacing)
    else
        item.Des:SetPoint('TOP'..d, StatusItems[index - 1].Des, 'BOTTOM'..d, 0, -config.spacing)
    end
    item.Des:SetJustifyH(d)
    
	item.Value = f:CreateFontString(nil, 'OVERLAY')
	item.Value:SetFont(config.vfont, vfz, config.vfontflags)
	item.Value:SetPoint('BOTTOM'..d, item.Des, 'BOTTOM'..fd, 0, 0)
	item.Value:SetJustifyH(d)
	
	item.SetDes = function(self,des) self.Des:SetText(des) end
	item.SetValue = function(self,value) self.Value:SetText(value) end
	
	return item
end
local function InitItems(f, duty)
	for i = 1, #DutySets[duty] do
		if (not StatusItems[i]) then StatusItems[i] = CreateItem(f,i) end
		StatusItems[i]:SetDes(StatusSets[DutySets[duty][i]].Des)
	end
	
    local count = #DutySets[duty]
    local height = count * config.fontsize + (count+2) * config.spacing
    f:SetSize(100,height)
    
	f.timeSpace = 0
	f:SetScript("OnUpdate",UpdateItems)
end
local function SetDir(f, dir)
    if f.dir == dir then return end
    f.dir = dir
    local d = f.dir
    local fd = (d == "LEFT") and "RIGHT" or "LEFT"
    
    for index, item in next, StatusItems do
        item.Des:ClearAllPoints()
        item.Value:ClearAllPoints()
        
        if index == 1 then
            item.Des:SetPoint('TOP'..d, f, 'TOP'..d, 0, -config.spacing )
        else
            item.Des:SetPoint('TOP'..d, StatusItems[index - 1].Des, 'BOTTOM'..d, 0, -config.spacing)
        end
        item.Des:SetJustifyH(d)
        
        item.Value:SetPoint('BOTTOM'..d, item.Des, 'BOTTOM'..fd, 0, 0)
        item.Value:SetJustifyH(d)
    end
end

local function InitConfig(f)
	if not MoeDB["Status"] or MoeDB["Status"].version ~= cuversion then
        print("Moe Status 设置初始化")
		MoeDB["Status"] = {
			a1 = "BOTTOM", a2 = "BOTTOM", version = cuversion,
			x = -275, y = 15, dir = "RIGHT",
		}
	end
	f:SetPoint(MoeDB["Status"].a1,UIParent,MoeDB["Status"].a2,MoeDB["Status"].x,MoeDB["Status"].y)
    f.dir = MoeDB["Status"].dir
end
local function SaveConfig(f)
	local a1,p,a2,x,y = f:GetPoint()
	MoeDB["Status"].a1 = a1
    MoeDB["Status"].a2 = a2
    MoeDB["Status"].x = x
    MoeDB["Status"].y = y
    MoeDB["Status"].dir = f.dir
end

local function Load()
    MoeStatus.MainFrame = CreateFrame("Frame", "Moe_Status_Frame", UIParent)
    MoeStatus.MainFrame:SetWidth(100)
    MoeStatus.MainFrame:SetHeight(60)
    MoeStatus.MainFrame:SetScale(1)

    MoeStatus.MainFrame.locked = true
    MoeStatus.MainFrame.timeSpace = 0

    InitConfig(MoeStatus.MainFrame)
    
    tplayerClass = string.upper(select(2, UnitClass('player')))
    tmaintalent = GetSpecialization()
    if (tmaintalent) then PlayerDuty = ClassSets[tplayerClass][tmaintalent]
    else PlayerDuty = DUTY.MELEE end
    InitItems(MoeStatus.MainFrame, PlayerDuty)
    
    MoeStatus.MainFrame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
    MoeStatus.MainFrame:RegisterEvent("PLAYER_TALENT_UPDATE")
    MoeStatus.MainFrame:SetScript("OnEvent",function(self, event)
        tmaintalent = GetSpecialization()
        if (tmaintalent) then PlayerDuty = ClassSets[tplayerClass][tmaintalent]
        else PlayerDuty = DUTY.MELEE end
        InitItems(self, PlayerDuty)
    end)
end
Modules:AddModule("Status", Load, nil)

SLASH_MOESTATUS1 = "/moesta"
SlashCmdList["MOESTATUS"] = function(msg)
	if (msg == "clear") then 
		MoeDB["Status"] = nil
		InitConfig(MoeStatus.MainFrame)
		return
    elseif msg:upper() == "LEFT" then
        SetDir(MoeStatus.MainFrame, "LEFT")
        SaveConfig(MoeStatus.MainFrame)
        return
    elseif msg:upper() == "RIGHT" then
        SetDir(MoeStatus.MainFrame, "RIGHT")
        SaveConfig(MoeStatus.MainFrame)
        return
	end
	if (MoeStatus.MainFrame.locked) then
		MoeStatus.MainFrame.locked = false
		Lib.CreateShadow(MoeStatus.MainFrame,1,{0,0,0,.4},{0,0,0,1})
		MoeStatus.MainFrame:EnableMouse(true)
		MoeStatus.MainFrame:SetMovable(true)
		MoeStatus.MainFrame:SetScript("OnMouseDown", MoeStatus.MainFrame.StartMoving)
		MoeStatus.MainFrame:SetScript("OnMouseUp", MoeStatus.MainFrame.StopMovingOrSizing)
	else
		MoeStatus.MainFrame.locked = true
		Lib.RemoveBorder(MoeStatus.MainFrame)
		MoeStatus.MainFrame:EnableMouse(false)
		MoeStatus.MainFrame:SetMovable(false)
		MoeStatus.MainFrame:SetScript("OnMouseDown", nil)
		MoeStatus.MainFrame:SetScript("OnMouseWheel", nil)
		
		SaveConfig(MoeStatus.MainFrame)
	end
end












