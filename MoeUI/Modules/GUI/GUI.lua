local addon, namespace = ...
local Lib = namespace.Moe.Lib
local Media = namespace.Moe.Media
local Modules = namespace.Moe.Modules
local Theme = namespace.Moe.Theme

local COLOR_ROLE_TANK = "E06D1B"
local COLOR_ROLE_HEALER = "1B70E0"
local COLOR_ROLE_DAMAGER  = "E01B35"
local MOE_INLINE_TANK_ICON = "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES.blp:13:13:0:-1:64:64:0:19:22:41|t";
local MOE_INLINE_HEALER_ICON = "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES.blp:13:13:0:-1:64:64:20:39:1:20|t";
local MOE_INLINE_DAMAGER_ICON = "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES.blp:13:13:0:-1:64:64:20:39:22:41|t"

local speclootmenuFrame = CreateFrame("Frame", "MoeSpecLootMenu", UIParent, "UIDropDownMenuTemplate")
local InfoFs = { size = 14, outline = "THINOUTLINE",
    anchor = "CENTER", align = "CENTER",
    x_off = 0, y_off = 0, textcolor = {1,1,1,.9},
    font = Media.Fonts.Default,
}

local FramesDB = {
	--左侧信息部分--
	{	--1.LV & EXP
		name = "Player_LV",parent = "UIParent",					
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
	{	--2.Talent
		name = "Player_Talent",parent = "UIParent",				
		point = {"BOTTOMLEFT", "Moe_Player_LV", "BOTTOMRIGHT", 20, 0},
		color = {1, 1, 1, 0},level = 2,
		button = true, fontstring = InfoFs,
		text = "NONE",
		event = {"ACTIVE_TALENT_GROUP_CHANGED","CONFIRM_TALENT_WIPE","PLAYER_TALENT_UPDATE", "PLAYER_ENTERING_WORLD"},
		script = {
			OnEvent = function(self,event)
				local classname, class = UnitClass("player")
				classname = "|c"..RAID_CLASS_COLORS[class].colorStr..classname.."|r"
				
				local activetalent = GetSpecialization() 
				if activetalent then
					local _,sname,_,_,_,srole = GetSpecializationInfo(activetalent)
					local roletex = ""
					if srole == "TANK" then 
						roletex = MOE_INLINE_TANK_ICON
						sname = "|cff"..COLOR_ROLE_TANK..sname.."|r"
					elseif srole == "HEALER" then 
						roletex = MOE_INLINE_HEALER_ICON
						sname = "|cff"..COLOR_ROLE_HEALER..sname.."|r"
					elseif srole == "DAMAGER" then 
						roletex = MOE_INLINE_DAMAGER_ICON 
						sname = "|cff"..COLOR_ROLE_DAMAGER..sname.."|r"
					else
						sname = ""
					end
					classname = roletex .. sname .. " " .. classname
				end
				self.text:SetText(classname)
			end,
			OnClick = function() ToggleTalentFrame() end,
		},
	},
	{	--3.Loot
		name = "Player_TalentLoot",parent = "UIParent",			
		point = {"BOTTOMLEFT", "Moe_Player_Talent", "BOTTOMRIGHT", 20, 0},
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
	{	--4.Faction
		name = "Player_Watched_Faction", parent = "UIParent",
		point = {"BOTTOMLEFT", "Moe_Player_TalentLoot", "BOTTOMRIGHT", 20, 0},
		color = {1, 1, 1, 0}, level = 2,
		button = true, fontstring = InfoFs,
		text = "NONE",
		event = {"UPDATE_FACTION", "PLAYER_ENTERING_WORLD"},
		script = {
			OnEvent = function(self, event, unit)
				if event == "UPDATE_FACTION" and unit ~= "player" then return end
				local name, reaction, fmin, fmax, value, factionID = GetWatchedFactionInfo()
				if name then
					local colors = FACTION_BAR_COLORS[reaction]
					local text = name..":".."|cff"..Lib.ColorTurn(colors.r, colors.g, colors.b).._G['FACTION_STANDING_LABEL'..reaction].."|r"
					self.text:SetText(text)
				else
					self.text:SetText("")
				end
			end,
			OnEnter = function(self)
				GameTooltip:SetOwner(self,"ANCHOR_TOPRIGHT",0,0)
				GameTooltip:ClearLines()

				local name, reaction, fmin, fmax, value, factionID = GetWatchedFactionInfo()
				local num = value - fmin
				local nummax = fmax - fmin
				
				GameTooltip:AddLine(format("%s: %d/%d(%s)", name, num, nummax, _G['FACTION_STANDING_LABEL'..reaction]))
				GameTooltip:Show()
			end,
			OnLeave = function(self) GameTooltip:Hide() end,
		},
	},
	--右侧信息部分--
	{	--1.Guild
		name = "Info_Guild",parent = "UIParent",					
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
	{	--2.Friend
		name = "Info_Friend",parent = "UIParent",					
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
	{	--3.Currency	7.0 远古魔力
		name = "Info_Currency",parent = "UIParent",				
		point = {"BOTTOMRIGHT","Moe_Info_Friend","BOTTOMLEFT", -35, 0},
		color = {1, 1, 1, 0},level = 2,
		button = true, fontstring = InfoFs,
		event = {"CURRENCY_DISPLAY_UPDATE", "PLAYER_ENTERING_WORLD"},
		script = {
			OnEvent = function(self, event)
				--local name,count,icon,currencyID = GetBackpackCurrencyInfo(i)
				local name, count, icon, _, _, maxcount = GetCurrencyInfo(1155)
				local iconStr = " |T"..icon..":0:0:0:0|t "
				local colorStr = count >= maxcount and "ffff00" or "ffffff"
				local countStr = "|cff"..colorStr..count.."/"..maxcount.."|r"
				
				self.text:SetText(iconStr..countStr)
			end,
			OnClick = function(self) 
				ToggleCharacter("TokenFrame") 
			end,
		},
	},
	--经验/声望栏
    {   name = "Exp_Bar", parent = "UIParent",
        point = {"BOTTOM", "UIParent", "BOTTOM", 0, 0}, 
        level = 2, bar = true,
        height = 10, width = GetScreenWidth(),
        texture = Media.Bar.GradV,
        color = {.44, .44, .44, .38},
        event = {"PLAYER_LEVEL_UP", "PLAYER_XP_UPDATE", "PLAYER_ENTERING_WORLD", "UI_SCALE_CHANGED", "UPDATE_FACTION"},
        script = {
            OnEvent = function(self, event)
				if event == "PLAYER_ENTERING_WORLD" then 
                    self:SetWidth(GetScreenWidth())
                    self:SetMinMaxValues(0, 1000) 
                    self:SetStatusBarColor(.74, .2, .95, 1)
                elseif event == "UI_SCALE_CHANGED" then 
                    self:SetWidth(GetScreenWidth())
                end
			
				local level = UnitLevel("player")
				if level >= MAX_PLAYER_LEVEL then
					local name, reaction, fmin, fmax, value, factionID = GetWatchedFactionInfo()
					if name then
						local colors = FACTION_BAR_COLORS[reaction]
						local repperc = floor((value - fmin) / (fmax - fmin) * 1000)
						
						self:SetStatusBarColor(colors.r, colors.g, colors.b, 1)
						self:SetValue(repperc)
					else
						self:SetValue(0)
					end
				else
					local expur, expmax = UnitXP("player"),UnitXPMax("player")
					local expperc = floor(expur / expmax * 1000)
					self:SetValue(expperc)
				end
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
