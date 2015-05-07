local addon, namespace = ...
local Lib = namespace.Moe.Lib
local Media = namespace.Moe.Media
local Modules = namespace.Moe.Modules
local Theme = namespace.Moe.Theme

local COLOR_ROLE_TANK = "E06D1B"
local COLOR_ROLE_HEALER = "1B70E0"
local COLOR_ROLE_DAMAGER  = "E01B35"

local speclootmenuFrame = CreateFrame("Frame", "MoeSpecLootMenu", UIParent, "UIDropDownMenuTemplate")
local InfoFs = { size = 14, outline = "THINOUTLINE",
    anchor = "CENTER", align = "CENTER",
    x_off = 0, y_off = 0, textcolor = {1,1,1,.9},
    font = Media.Fonts.Default,
}

local FramesDB = {
	--左侧信息部分--
	{name = "Player_LV",parent = "UIParent",					--1.LV & EXP
	point = {"BOTTOMLEFT",UIParent,"BOTTOMLEFT", 10, 2},
	color = {1, 1, 1, 0},level = 2,
	button = true,fontstring = InfoFs,
	event = {"PLAYER_LEVEL_UP","PLAYER_ENTERING_WORLD"},
	text = "",
	script = {
		OnEvent = function(self, event, level)
            if event ~= "PLAYER_LEVEL_UP" then level = UnitLevel("player") end
			self.text:SetText("LV |cff"..Lib.ColorTurn(1,.85,0)..level.."|r")
		end,
		OnEnter = function(self)
			GameTooltip:SetOwner(self,"ANCHOR_TOPRIGHT",0,0)
			GameTooltip:ClearLines()
			local expur,expmax = UnitXP("player"),UnitXPMax("player")
			local expperc = floor(expur/expmax*100)
			local expex = GetXPExhaustion() or 0
			GameTooltip:AddLine(format("经验: %d/%d(%d%%)",expur,expmax,expperc))
			GameTooltip:AddLine(format("双倍: %d(%d%%)",expex,floor(expex/expmax*100)))
			GameTooltip:Show()
		end,
		OnLeave = function(self) GameTooltip:Hide() end,
		},
	},
	{name = "Player_Talent",parent = "UIParent",				--2.Talent
	point = {"BOTTOMLEFT",UIParent,"BOTTOMLEFT", 70, 1},
	color = {1, 1, 1, 0},level = 2,
	button = true,fontstring = InfoFs,
	text = "NONE",
	event = {"ACTIVE_TALENT_GROUP_CHANGED","CONFIRM_TALENT_WIPE","PLAYER_TALENT_UPDATE","PLAYER_ENTERING_WORLD"},
	script = {
		OnEvent = function(self,event)
			local classname, class = UnitClass("player")
			classname = "|c"..RAID_CLASS_COLORS[class].colorStr..classname.."|r"
			
			local activetalent = GetSpecialization() 
			if activetalent then
				local _,sname,_,_,_,srole = GetSpecializationInfo(activetalent)
				local roletex = ""
				if srole == "TANK" then 
					roletex = INLINE_TANK_ICON
					sname = "|cff"..COLOR_ROLE_TANK..sname.."|r"
				elseif srole == "HEALER" then 
					roletex = INLINE_HEALER_ICON
					sname = "|cff"..COLOR_ROLE_HEALER..sname.."|r"
				elseif srole == "DAMAGER" then 
					roletex = INLINE_DAMAGER_ICON 
					sname = "|cff"..COLOR_ROLE_DAMAGER..sname.."|r"
				end
				classname = roletex .. sname .. " " .. classname
			end
			self.text:SetText(classname)
		end,
		OnClick = function() ToggleTalentFrame() end,
		},
	},
	{name = "Player_TalentLoot",parent = "UIParent",			--3.Loot
	point = {"BOTTOMLEFT",UIParent,"BOTTOMLEFT", 175, 2},
	color = {1, 1, 1, 0},level = 2,
	button = true,fontstring = InfoFs,
	text = "NONE",
	event = {"PLAYER_LOOT_SPEC_UPDATED","PLAYER_ENTERING_WORLD"},
	script = {
		OnEvent = function(self,event)
			local text = "|cfff0f033拾取|r:"
			local loot = GetLootSpecialization()
			local activetalent = GetSpecialization() 
			if activetalent then
				local nowsid, nowsname = GetSpecializationInfo(activetalent)
				if (loot == 0) then
					if activetalent then text = text.."当前专精("..nowsname..")" end
				else
					local sname = select(2,GetSpecializationInfoByID(loot))
					text = text..sname
				end
				self.text:SetText(text)
					
				self.menuList = {}
				tinsert(self.menuList,{
					text = "当前专精("..nowsname..")", arg1 = 0, checked = (loot == 0),
					func = function(s,arg1) SetLootSpecialization(arg1) end
				})
				for i = 1,3 do 
					local sid, sname = GetSpecializationInfo(i)
					tinsert(self.menuList,{
						text = sname, arg1 = sid, checked = (loot == sid),
						func = function(s,arg1) SetLootSpecialization(arg1) end
					})
				end
            else
                self.text:SetText("")
			end
		end,
		OnMouseUp = function(self, button) 
			if(button == "RightButton") then
                local activetalent = GetSpecialization() 
                if not activetalent then return end
                speclootmenuFrame:SetPoint("BOTTOMLEFT",self,"CENTER",0,0)
				EasyMenu(self.menuList, speclootmenuFrame, speclootmenuFrame, 0, 0, "MENU", 2)
			end
		end,
		},
	},
	--右侧信息部分--
	{name = "Info_Guild",parent = "UIParent",					--1.Guild
	point = {"BOTTOMRIGHT",UIParent,"BOTTOMRIGHT", -25, 2},
	--height = 16,width = 25,
	color = {1, 1, 1, 0},level = 2,
	button = true,fontstring = InfoFs,
	text = function()
		if IsInGuild() then 
			local online, total = 0, GetNumGuildMembers(true)
			for i = 0, total do 
				if select(9, GetGuildRosterInfo(i)) then online = online + 1 end 
			end
			return format("公会:|cff%s%d|r",Lib.ColorTurn(.1,1,.1),online)
		else return "无公会" end
	end,
	script = {
		OnClick = function(self) ToggleGuildFrame(1) end
		},
	},
	{name = "Info_Friend",parent = "UIParent",					--2.Friend
	point = {"BOTTOMRIGHT","Moe_Info_Guild","BOTTOMRIGHT", -95, 0},
	--height = 16,width = 25,
	color = {1, 1, 1, 0},level = 2,
	button = true,fontstring = InfoFs,
	event = {"PLAYER_LOGIN","FRIENDLIST_UPDATE","BN_FRIEND_LIST_SIZE_CHANGED","ADDON_LOADED"},
	script = {
		OnEvent = function(self,event)
			local numBNetTotal, numBNetOnline = BNGetNumFriends()
			local online, total = 0, GetNumFriends()
			for i = 0, total do if select(5, GetFriendInfo(i)) then online = online + 1 end end
			online = online + numBNetOnline
			total = total + numBNetTotal
			self.text:SetText(format("好友:|cff%s%d|r", Lib.ColorTurn(.1,1,.1),online))
		end,
		OnClick = function(self) ToggleFriendsPanel() end,
		},
	},

    {   name = "Exp_Bar",                parent = "UIParent",
        point = {"BOTTOM", "UIParent", "BOTTOM", 0, 0}, 
        level = 2, bar = true,
        height = 10, width = GetScreenWidth(),
        texture = Media.Bar.GradV,
        color = {.44, .44, .44, .38},
        event = {"PLAYER_LEVEL_UP","PLAYER_XP_UPDATE","PLAYER_ENTERING_WORLD"},
        script = {
            OnEvent = function(self, event, level)
                if event == "PLAYER_ENTERING_WORLD" then 
                    self:SetMinMaxValues(0, 1000) 
                    self:SetStatusBarColor(.74, .2, .95, 1)
                end
                local expur,expmax = UnitXP("player"),UnitXPMax("player")
                local expperc = floor(expur / expmax * 1000)
                self:SetValue(expperc)
            end,
        },
    },    
}

local function Load()
    local theme = Theme:Get("GUI")
    
    for _, sets in pairs(FramesDB) do
        Lib.CreatePanel(sets)
    end
    
    for _, sets in pairs(theme.Frames) do
        Lib.CreatePanel(sets)
    end
    
    --if theme.StyleAddons then theme.StyleAddons() end
    if theme.Welcome then theme.Welcome() end
end

Modules:AddModule("GUI", Load, nil)
