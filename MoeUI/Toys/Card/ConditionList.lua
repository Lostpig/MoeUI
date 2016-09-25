local addon, namespace = ...
local Moe = namespace.Moe
local Card = Moe.Modules:Get("Card")

local function GetCurrentSpecName()
    local text = ""
    local spec = GetSpecialization()
    if spec then text = select(2, GetSpecializationInfo(spec)) 
    else text = UnitClass("player") end
    return text
end

local SpellList = {
    --布
	["PRIEST"] = {
		["ALL"] = {
			{	--死亡
				Condition = function() return UnitIsDead("player") or UnitIsGhost("player") end,
				Priority = 0,
				CardNo = 1,Text = "你挂了"
			},
			{	--生命低下
				Condition = function()
					local hpperc = UnitHealth("player")/UnitHealthMax("player") 
					return (hpperc < 0.3) 
				end,
				Priority = 1,
				CardNo = 5,Text = "危险"
			},
			{	--法力低下
				Condition = function()
					local mpperc = UnitMana('player')/UnitManaMax('player')
					if mpperc < 0.25 then return true
					else return false end
				end,
				Priority = 9,
				CardNo = 9,Text = "法力枯竭"
			},
			{	--当前天赋
				Condition = function()
					return true
				end,
				Priority = 99,
				CardNo = 10,
				Text = function()
					return GetCurrentSpecName()
				end
			},
		},
		[1] = { --戒律
		},
		[2] = { --神圣
		},
		[3] = { --暗影
			{					--暗言术:灭
				Condition = function()
					if not UnitAffectingCombat("player") then return false end
					if not UnitCanAttack("player", "target") then return false end
					local xs, xd = GetSpellCooldown(32379)
					local isUsable, notEnoughMana = IsUsableSpell(32379)
					return (xs + xd - GetTime() < 1.5 and isUsable)
				end,
				Priority = 3,
				CardNo = 2, Text = "暗言术:灭"
			},
			{					--心爆
				Condition = function()
					if not UnitAffectingCombat("player") then return false end
					if not UnitCanAttack("player", "target") then return false end
					local xs,xd = GetSpellCooldown(8092)
					return xs+xd - GetTime() < 1.5  
				end,
				Priority = 4,
				CardNo = 3,Text = "心灵震爆"
			},
			{					--暗影魔
				Condition = function()
					if not UnitAffectingCombat("player") then return false end
					if not UnitCanAttack("player", "target") then return false end
					local xs,xd = GetSpellCooldown(34433)
					return (xs+xd-GetTime() < 1.5) 
				end,
				Priority = 5,
				CardNo = 7,Text = "暗影魔"
			}
		},
	},
    ["WARLOCK"] = {
		["ALL"] = {
			{	--死亡
				Condition = function() return UnitIsDead("player") or UnitIsGhost("player") end,
				Priority = 0,
				CardNo = 1,Text = "你挂了"
			},
			{	--生命低下
				Condition = function()
					local hpperc = UnitHealth("player")/UnitHealthMax("player") 
					return (hpperc < 0.3) 
				end,
				Priority = 1,
				CardNo = 5,Text = "危险"
			},
			{	--法力低下
				Condition = function()
					local mpperc = UnitMana('player')/UnitManaMax('player')
					if mpperc < 0.25 then return true
					else return false end
				end,
				Priority = 9,
				CardNo = 9,Text = "法力枯竭"
			},
			{	--当前天赋
				Condition = function()
					return true
				end,
				Priority = 99,
				CardNo = 10,
				Text = function()
					return GetCurrentSpecName()
				end
			},
		},
		[1] = { --痛苦
		},
		[2] = { --恶魔
		},
		[3] = { --毁灭
			{					--混乱之箭
				Condition = function()
					if not UnitAffectingCombat("player") then return false end
					if not UnitCanAttack("player", "target") then return false end
					local ember = UnitPower("player", SPELL_POWER_BURNING_EMBERS, true)
					return ember > 35
				end,
				Priority = 3,
				CardNo = 2, Text = "混乱之箭"
			},
		},
	},
    ["MAGE"] = {
        ["ALL"] = {
			{	--死亡
				Condition = function() return UnitIsDead("player") or UnitIsGhost("player") end,
				Priority = 0,
				CardNo = 1,Text = "你挂了"
			},
			{	--生命低下
				Condition = function()
					local hpperc = UnitHealth("player")/UnitHealthMax("player") 
					return (hpperc < 0.3) 
				end,
				Priority = 1,
				CardNo = 5,Text = "危险"
			},
			{	--当前天赋
				Condition = function()
					return true
				end,
				Priority = 99,
				CardNo = 10,
				Text = function()
					return GetCurrentSpecName()
				end
			},
		},
    },
    --锁
    ["SHAMAN"] = {
        ["ALL"] = {
			{	--死亡
				Condition = function() return UnitIsDead("player") or UnitIsGhost("player") end,
				Priority = 0,
				CardNo = 1,Text = "你挂了"
			},
			{	--生命低下
				Condition = function()
					local hpperc = UnitHealth("player")/UnitHealthMax("player") 
					return (hpperc < 0.3) 
				end,
				Priority = 1,
				CardNo = 5,Text = "危险"
			},
			{	--当前天赋
				Condition = function()
					return true
				end,
				Priority = 99,
				CardNo = 10,
				Text = function()
					return GetCurrentSpecName()
				end
			},
		},
    },
    ["HUNTER"] = {
        ["ALL"] = {
			{	--死亡
				Condition = function() return UnitIsDead("player") or UnitIsGhost("player") end,
				Priority = 0,
				CardNo = 1,Text = "你挂了"
			},
			{	--生命低下
				Condition = function()
					local hpperc = UnitHealth("player")/UnitHealthMax("player") 
					return (hpperc < 0.3) 
				end,
				Priority = 1,
				CardNo = 5,Text = "危险"
			},
			{	--当前天赋
				Condition = function()
					return true
				end,
				Priority = 99,
				CardNo = 10,
				Text = function()
					return GetCurrentSpecName()
				end
			},
		},
    },
    --皮
    ["DRUID"] = {
        ["ALL"] = {
			{	--死亡
				Condition = function() return UnitIsDead("player") or UnitIsGhost("player") end,
				Priority = 0,
				CardNo = 1,Text = "你挂了"
			},
			{	--生命低下
				Condition = function()
					local hpperc = UnitHealth("player")/UnitHealthMax("player") 
					return (hpperc < 0.3) 
				end,
				Priority = 1,
				CardNo = 5,Text = "危险"
			},
			{	--当前天赋
				Condition = function()
					return true
				end,
				Priority = 99,
				CardNo = 10,
				Text = function()
					return GetCurrentSpecName()
				end
			},
		},
    },
    ["ROGUE"] = {
        ["ALL"] = {
			{	--死亡
				Condition = function() return UnitIsDead("player") or UnitIsGhost("player") end,
				Priority = 0,
				CardNo = 1,Text = "你挂了"
			},
			{	--生命低下
				Condition = function()
					local hpperc = UnitHealth("player")/UnitHealthMax("player") 
					return (hpperc < 0.3) 
				end,
				Priority = 1,
				CardNo = 5,Text = "危险"
			},
			{	--当前天赋
				Condition = function()
					return true
				end,
				Priority = 99,
				CardNo = 10,
				Text = function()
					return GetCurrentSpecName()
				end
			},
		},
    },
    ["MONK"] = {
        ["ALL"] = {
			{	--死亡
				Condition = function() return UnitIsDead("player") or UnitIsGhost("player") end,
				Priority = 0,
				CardNo = 1,Text = "你挂了"
			},
			{	--生命低下
				Condition = function()
					local hpperc = UnitHealth("player")/UnitHealthMax("player") 
					return (hpperc < 0.3) 
				end,
				Priority = 1,
				CardNo = 5,Text = "危险"
			},
			{	--当前天赋
				Condition = function()
					return true
				end,
				Priority = 99,
				CardNo = 10,
				Text = function()
					return GetCurrentSpecName()
				end
			},
		},
        [1] = { --酒仙
        },
        [2] = { --织雾
            {   --复苏之雾不在CD
                Condition = function()
                    if not UnitAffectingCombat("player") then return false end
                    local xs, xd = GetSpellCooldown(115151)
					return (xs + xd - GetTime() < 1.5)
				end,
				Priority = 5,
				CardNo = 9,Text = "复苏之雾"
            },
            {	--法力茶
				Condition = function()
					local mpperc = UnitMana('player')/UnitManaMax('player')
                    local count = GetSpellCount(123761)
					if mpperc < 0.5 and count > 2 then return true
					else return false end
				end,
				Priority = 7,
				CardNo = 9,Text = "喝茶"
			},
            {	--法力低下
				Condition = function()
					local mpperc = UnitMana('player')/UnitManaMax('player')
					if mpperc < 0.25 then return true
					else return false end
				end,
				Priority = 9,
				CardNo = 9,Text = "法力枯竭"
			},
        },
        [3] = { --踏风
            {   --轮回可用
                Condition = function()
                    if not UnitAffectingCombat("player") then return false end
					if not UnitCanAttack("player", "target") then return false end
                    local xs, xd = GetSpellCooldown(115080)
					local isUsable, notEnoughMana = IsUsableSpell(115080)
					return (xs + xd - GetTime() < 1.5 and isUsable and not notEnoughMana)
				end,
				Priority = 2,
				CardNo = 9,Text = "轮回之触"
            }
        },
    },
    --板
    ["WARRIOR"] = {
        ["ALL"] = {
			{	--死亡
				Condition = function() return UnitIsDead("player") or UnitIsGhost("player") end,
				Priority = 0,
				CardNo = 1,Text = "你挂了"
			},
			{	--生命低下
				Condition = function()
					local hpperc = UnitHealth("player")/UnitHealthMax("player") 
					return (hpperc < 0.3) 
				end,
				Priority = 1,
				CardNo = 5,Text = "危险"
			},
			{	--当前天赋
				Condition = function()
					return true
				end,
				Priority = 99,
				CardNo = 10,
				Text = function()
					return GetCurrentSpecName()
				end
			},
		},
    },
    ["DEATHKNIGHT"] = {
        ["ALL"] = {
			{	--死亡
				Condition = function() return UnitIsDead("player") or UnitIsGhost("player") end,
				Priority = 0,
				CardNo = 1,Text = "你挂了"
			},
			{	--生命低下
				Condition = function()
					local hpperc = UnitHealth("player")/UnitHealthMax("player") 
					return (hpperc < 0.3) 
				end,
				Priority = 1,
				CardNo = 5,Text = "危险"
			},
			{	--当前天赋
				Condition = function()
					return true
				end,
				Priority = 99,
				CardNo = 10,
				Text = function()
					return GetCurrentSpecName()
				end
			},
		},
    },
    ["PALADIN"] = {
        ["ALL"] = {
			{	--死亡
				Condition = function() return UnitIsDead("player") or UnitIsGhost("player") end,
				Priority = 0,
				CardNo = 1,Text = "你挂了"
			},
			{	--生命低下
				Condition = function()
					local hpperc = UnitHealth("player")/UnitHealthMax("player") 
					return (hpperc < 0.3) 
				end,
				Priority = 1,
				CardNo = 5,Text = "危险"
			},
			{	--当前天赋
				Condition = function()
					return true
				end,
				Priority = 99,
				CardNo = 10,
				Text = function()
					return GetCurrentSpecName()
				end
			},
		},
    }  
}
Card.SpellList = SpellList