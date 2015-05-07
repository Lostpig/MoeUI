local addon, namespace = ...
local Lib = namespace.Moe.Lib
local Modules = namespace.Moe.Modules
local Media = namespace.Moe.Media
local Theme = namespace.Moe.Theme
local _G = getfenv(0)
local MoeMiniMap = Modules:Get("Minimap")

local cfg = namespace.Moe.Config["Minimap"]
local font = Media.Fonts.Default
local fontstringSet = {	
	size = 14, 
	outline = "THINOUTLINE",
	anchor = "BOTTOMLEFT",
	x_off = 0,
	y_off = 0,
	textcolor = {1, 1, 1, 1},
	font = font
}
local shadows = {
	edgeFile = Media.Texture.Glowtex, 
	edgeSize = 3,
	insets = { left = 3, right = 3, top = 3, bottom = 3 }
}

local function GetZoneColor(pvpt)           --区域颜色
	if pvpt == "friendly" then return 0.1,1,0.1
	elseif pvpt == "contested" then return 1,0.7,0
	elseif pvpt == "hostile" then return 1,0.1,0.1
	elseif pvpt == "sanctuary" then return 0.41,0.8,0.94
	else return 1,0.93,0.76 end
end

local function HideBlzFrames()
	local dummy = Lib.GetDummy()
	local hideframes = {
		"GameTimeFrame",
		"MinimapBorderTop",
		"MinimapNorthTag",
		"MinimapBorder",
		"MinimapZoneTextButton",
		"MinimapZoomOut",
		"MinimapZoomIn",
		"MiniMapVoiceChatFrame",
		"MiniMapWorldMapButton",
		"MiniMapMailBorder",
		"GuildInstanceDifficulty",
		--"MiniMapBattlefieldBorder",
	}
	for i in pairs(hideframes) do
		_G[hideframes[i]]:Hide()
		_G[hideframes[i]].Show = dummy
	end
	
	MiniMapMailFrame:Hide()
	TimeManagerClockButton:Hide()	--隐藏时间框
	GameTimeFrame:Hide()			--隐藏时间框
	MiniMapWorldMapButton:Hide()	--隐藏小地图上的世界地图按钮
	MinimapZoneTextButton:Hide()	--隐藏小地图上的地域文本
end
local function SetMapItems()
	--Tracking
	MiniMapTrackingBackground:SetAlpha(0)
	MiniMapTrackingButton:SetAlpha(0)
	MiniMapTracking:SetAlpha(0)
	MiniMapTracking:ClearAllPoints()
	MiniMapTracking:SetPoint("BOTTOMRIGHT", Minimap, 0, 0)
	MiniMapTracking:SetScale(.9)
	
	local Trackingtxt = Minimap:CreateFontString(nil)
	Trackingtxt:SetFont(font, 10, "THINOUTLINE")
	Trackingtxt:SetText("追踪")
	Trackingtxt:SetAllPoints(MiniMapTracking)
	--InstanceDifficulty
	MiniMapInstanceDifficulty:ClearAllPoints()
	MiniMapInstanceDifficulty:Hide()
end
local function SetMap()
	Minimap:ClearAllPoints()
	Minimap:SetPoint(cfg.anchor, UIParent, cfg.relative, cfg.x, cfg.y)
	Minimap:SetSize(cfg.size, cfg.size)
	MinimapCluster:EnableMouse(false)

	Minimap:EnableMouseWheel(true)
	Minimap:SetScript("OnMouseWheel", function(self, d)
		if d > 0 then
			_G.MinimapZoomIn:Click()
		elseif d < 0 then
			_G.MinimapZoomOut:Click()
		end
	end)
	
	Minimap:SetScript("OnMouseUp", function(self, btn)
		Minimap_OnClick(self)
	end)
	Minimap:SetMaskTexture('Interface\\ChatFrame\\ChatFrameBackground')
	MoeMiniMap.Map = Minimap
end
local function SetMapInfos(theme)
	--Clock
	MoeMiniMap.Clock = Lib.CreatePanel({
		name = "MMInfo_Clock",
		parent = "Minimap",	
		point = theme.ClockPos,
		level = 3,
		button = true,
		fontstring = fontstringSet,
		text = function()
			local hour,minute = GetGameTime()
			return format("%02d : %02d",hour,minute)
		end,
		script = {
			OnEnter = function(self)
				GameTooltip:SetOwner(self,"ANCHOR_BOTTOMLEFT",0,0)
				GameTooltip:ClearLines()
				GameTooltip:AddLine(" ")
				GameTooltip:AddDoubleLine(gsub(TIMEMANAGER_TOOLTIP_LOCALTIME,':',''),GameTime_GetLocalTime(true))
				GameTooltip:AddDoubleLine(gsub(TIMEMANAGER_TOOLTIP_REALMTIME,':',''),GameTime_GetGameTime(true))
				for i = 1, 2 do
					local _, localizedName, isActive, _, startTime, _ = GetWorldPVPAreaInfo(i)
					GameTooltip:AddDoubleLine(format(localizedName,""), 
						isActive and WINTERGRASP_IN_PROGRESS or (startTime==0) and "N/A" or Lib.TimeTurn(startTime),
						.75, .90, 1,1,1,1)
				end
				GameTooltip:AddLine("-------------------")
				GameTooltip:AddLine("右键-闹钟,左键-日历")
				GameTooltip:Show()
			end,
			OnLeave = function(self) GameTooltip:Hide() end,
			OnMouseUp = function(self,button)
				if button == "RightButton" then ToggleTimeManager() 
				else ToggleCalendar() end
			end,
		}
	})
	--Mail
	MoeMiniMap.Mail = Lib.CreatePanel({
		name = "MMInfo_Mail",
		parent = "Minimap",	
		point = theme.MailPos,
		level = 3, ref = 15,
		button = false,
		fontstring = {	
			size = 12, 
			outline = "THINOUTLINE",
			anchor = "BOTTOMLEFT",
			x_off = 0,
			y_off = 0,
			textcolor = {1, 1, 1, 1},
			font = font
		},
		text = function()
			if MiniMapMailFrame:IsVisible() then MiniMapMailFrame:Hide() end
			return HasNewMail() and ("|cff"..Lib.ColorTurn(0,1,0).."新邮件！|r") or ""
		end,
		script = {
			OnEnter = function(self)
				if not HasNewMail() then return end
				GameTooltip:SetOwner(self,"ANCHOR_BOTTOMLEFT",0,0)
				MinimapMailFrameUpdate()
				GameTooltip:Show()
			end,
			OnLeave = function(self) GameTooltip:Hide() end,
		}
	})
	--Location
	MoeMiniMap.Location = Lib.CreatePanel({
		name = "MMInfo_Location",
		parent = "UIParent",				--3.Location
		point = theme.LocationPos,
		level = 3,
		--texture = path.."tex\\Button",
		color = {1, 1, 1, 0},
		height = 16,
		width = 125,
		button = true,
		fontstring = { size = 14, outline = "THINOUTLINE",
			anchor = "CENTER",
			x_off = 0,y_off = 0,textcolor = {1,1,1,1},
			font = font
		},
		event = {"ZONE_CHANGED","ZONE_CHANGED_INDOORS","ZONE_CHANGED_NEW_AREA","PLAYER_ENTERING_WORLD","PLAYER_LOGIN"},
		script = {
			OnEvent = function(self,event)
				local subzone,zone,zonepvp = GetSubZoneText(), GetZoneText(), {GetZonePVPInfo()}
				self.text:SetText(subzone ~= "" and subzone or zone)
				self.text:SetTextColor(GetZoneColor(zonepvp[1]))
			end,
			OnMouseUp = function(self,button)
				if button == "RightButton" then ToggleFrame(WorldMapFrame) end
				if IsShiftKeyDown() then
					local x,y = GetPlayerMapPosition("player")
					ChatFrame1EditBox:Show()
					ChatFrame1EditBox:Insert(format("%s: %s",GetZoneText(),format("(%s,%s)",x*100,y*100)))
				else 
					if (Minimap:IsShown()) then Minimap:Hide() 
					else Minimap:Show() end
				end
			end,
			--OnEnter = function(self) self.bg:SetVertexColor(1, 1, .8, .8) end,
			--OnLeave = function(self) self.bg:SetVertexColor(1, 1, .8, 0) end,
		}
	})
	--Coords
	MoeMiniMap.Coords = Lib.CreatePanel({
		name = "MMInfo_Coords",
		parent = "Minimap",	
		point = theme.CoordsPos,
		level = 9,ref = 1, strata = "HIGH",
		button = false,
		fontstring = { 
			size = 11, outline = "THINOUTLINE",
			anchor = "CENTER",
			x_off = 0,y_off = 0,textcolor = {1,1,1,1},
			font = font
		},
		text = function()
			local x,y = GetPlayerMapPosition("player")
			return format("%d,%d",x*100,y*100)
		end,
	})
end

local function Load()
    local theme = Theme:Get("Minimap")
    HideBlzFrames()
	SetMap()
	SetMapItems()
	SetMapInfos(theme)

    if theme.Style and type(theme.Style) == "function" then theme.Style(MoeMiniMap) end
end

Modules:AddModule("Minimap", Load, nil)


