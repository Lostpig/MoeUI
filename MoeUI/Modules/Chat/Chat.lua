local addon, namespace = ...
local gsub = _G.string.gsub
local _G = _G
local Lib = namespace.Moe.Lib
local Modules = namespace.Moe.Modules

local dummy = Lib.GetDummy()
local tabfont = namespace.Moe.Media.Fonts.Default
local tabfontsize = 13

local function LinkStr(text, type, value, color)
    return "|H" .. type .. ":" .. tostring(value) .. "|h|cff" .. (color or "ffffff") .. tostring(text) .. "|r|h"
end
local function HighlightUrl(before,url,after)
	foundurl = true
    return " " .. LinkStr("["..url.."]", "url", url, color) .. " "
end
local function ChatFrameScroll(self, dir)
	if(dir > 0) then
		if(IsShiftKeyDown()) then self:ScrollToTop()
		else self:ScrollUp() end
	else
		if(IsShiftKeyDown()) then self:ScrollToBottom()
		else self:ScrollDown() end
	end
end
local function FoundUrl(frame, text, ...)
	local foundurl = false
    if string.find(text, "%pTInterface%p+") then 
      foundurl = true
    end
    if not foundurl then
      --192.168.1.1:1234
      text = string.gsub(text, "(%s?)(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?:%d%d?%d?%d?%d?)(%s?)", HighlightUrl)
    end
    if not foundurl then
      --192.168.1.1
      text = string.gsub(text, "(%s?)(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?)(%s?)", HighlightUrl)
    end
    if not foundurl then
      --www.teamspeak.com:3333
      text = string.gsub(text, "(%s?)([%w_-]+%.?[%w_-]+%.[%w_-]+:%d%d%d?%d?%d?)(%s?)", HighlightUrl)
    end
    if not foundurl then
      --http://www.google.com
      text = string.gsub(text, "(%s?)(%a+://[%w_/%.%?%%=~&-'%-]+)(%s?)", HighlightUrl)
    end
    if not foundurl then
      --www.google.com
      text = string.gsub(text, "(%s?)(www%.[%w_/%.%?%%=~&-'%-]+)(%s?)", HighlightUrl)
    end
    if not foundurl then
      --lol@lol.com
      text = string.gsub(text, "(%s?)([_%w-%.~-]+@[_%w-]+%.[_%w-%.]+)(%s?)", HighlightUrl)
    end
    frame.am(frame,text,...)
end

local function SetChatFrames()
	for i = 1, NUM_CHAT_WINDOWS do
		local cfBtn = _G["ChatFrame"..i.."ButtonFrame"]
		if (cfBtn) then 
			cfBtn:Hide()
			cfBtn.Show = dummy
		end
		
		local ebtl = _G["ChatFrame"..i.."EditBoxLeft"]
		if ebtl then ebtl:Hide() end
		local ebtm = _G["ChatFrame"..i.."EditBoxMid"]
		if ebtm then ebtm:Hide() end      
		local ebtr = _G["ChatFrame"..i.."EditBoxRight"]
		if ebtr then ebtr:Hide() end

        local ebtfl = _G["ChatFrame"..i.."EditBoxFocusLeft"]
		if ebtfl then Lib.BindHider(ebtfl) end
		local ebtfm = _G["ChatFrame"..i.."EditBoxFocusMid"]
		if ebtfm then Lib.BindHider(ebtfm) end     
		local ebtfr = _G["ChatFrame"..i.."EditBoxFocusRight"]
		if ebtfr then Lib.BindHider(ebtfr) end    

		local cf = _G["ChatFrame"..i]
		if cf then 
			cf:SetFont(NAMEPLATE_FONT, 12, "THINOUTLINE") 
			cf:SetShadowOffset(1,-1)
			cf:SetShadowColor(0,0,0,0.6)
			cf:SetFrameStrata("LOW")
			cf:SetFrameLevel(2)
		end
		
		local eb = _G["ChatFrame"..i.."EditBox"]
		if eb and cf then
			cf:SetClampRectInsets(0,0,0,0)
            eb:SetHeight(18)
			eb:SetAltArrowKeyMode(false)
			eb:ClearAllPoints()
			eb:SetPoint("BOTTOM", cf, "TOP", 0, 6)
			eb:SetPoint("LEFT", cf, -5, 0)
			eb:SetPoint("RIGHT", cf, 10, 0)
			eb:SetAlpha(0)
            
            Lib.CreateShadow(eb, 1, {0,0,0,.6}, {0,0,0,0})
		end
		
		local tab = _G["ChatFrame"..i.."Tab"]
		if tab then
			tab:GetFontString():SetFont(NAMEPLATE_FONT, 11, "THINOUTLINE")
			--fix for color and alpha of undocked frames
			tab:GetFontString():SetTextColor(1,0.7,0)
			tab:GetFontString():SetShadowOffset(1,-1)
			tab:GetFontString():SetShadowColor(0,0,0,0.6)
			tab:SetAlpha(1)
		end
	end
end
local function InitChatFrame()
    local cfmBtn = _G["ChatFrameMenuButton"]
    if cfmBtn then 
		cfmBtn:Hide() 
		cfmBtn.Show = dummy
    end
    
    local fmBtn = _G["FriendsMicroButton"]
    if fmBtn then 
		fmBtn:Hide()
		fmBtn.Show = dummy
    end

    ChatFontNormal:SetFont(NAMEPLATE_FONT, 12, "THINOUTLINE") 
    ChatFontNormal:SetShadowOffset(1,-1)
    ChatFontNormal:SetShadowColor(0,0,0,0.6)
    
    local bcq = _G["CombatLogQuickButtonFrame_Custom"];
    if bcq then
		bcq:Hide()
		bcq:HookScript("OnShow", function(s) s:Hide(); end)
		bcq:SetHeight(0)
    end
end  
local function HideChatFrameBG()
	local TAB_TEXTURES = {
		"Left",
		"Middle",
		"Right",
		"SelectedLeft",
		"SelectedMiddle",
		"SelectedRight",
		"Glow",
		"HighlightLeft",
		"HighlightMiddle",
		"HighlightRight",
    }
	
	for i = 1, NUM_CHAT_WINDOWS do
		for index, value in pairs(TAB_TEXTURES) do
			local texture = _G["ChatFrame"..i.."Tab"..value]
			texture:SetTexture(nil)
		end
    end
	--remove fade func
	FCF_FlashTab = dummy
	FCFTab_UpdateAlpha = dummy
	FCF_FadeInChatFrame = function(chatFrame) chatFrame.hasBeenFaded = true end
	FCF_FadeOutChatFrame = function(chatFrame) chatFrame.hasBeenFaded = false end
end
local function ResetAddMessage()
	for i = 1, NUM_CHAT_WINDOWS do
		if ( i ~= 2 ) then
			local cf = _G["ChatFrame"..i]
			local am = cf.AddMessage
			cf.AddMessage = function(frame, text, ...)
				return am(frame, text:gsub("|h%[(%d+)%. .-%]|h", "|h%1|h"), ...)
			end
		end
	end 
end
local function ResetRefFunc()
	local origSetItemRef = SetItemRef
	SetItemRef = function(link, text, button)
		local linkType = string.sub(link, 1, 6)
		if IsAltKeyDown() and linkType == "player" then
			local name = string.match(link, "player:([^:]+)")
			InviteUnit(name)
			return nil
		end
		return origSetItemRef(link, text, button)
	end
end
local function SetUrlFound()
	for i = 1, NUM_CHAT_WINDOWS do
		if ( i ~= 2 ) then
			local cf = _G["ChatFrame"..i]
			cf.am = cf.AddMessage
			cf.AddMessage = FoundUrl
		end
	end
	
	local orig = ChatFrame_OnHyperlinkShow
	ChatFrame_OnHyperlinkShow = function(frame, link, text, button)
		local type, value = link:match("(%a+):(.+)")
		if ( type == "url" ) then
			--local eb = _G[frame:GetName().."EditBox"] --sometimes this is not the active chatbox. thus use the last active one for this
			local eb = LAST_ACTIVE_CHAT_EDIT_BOX or _G[frame:GetName().."EditBox"]
			if eb then
				eb:SetText(value)
				eb:SetFocus()
				eb:HighlightText()
			end
		else
			orig(self, link, text, button)
		end
	end
end

local function ChatFrame2_SetAlpha(self, alpha)
	if(CombatLogQuickButtonFrame_Custom) then
		CombatLogQuickButtonFrame_Custom:SetAlpha(alpha)
	end
end
local function ChatFrame2_GetAlpha(self)
	if(CombatLogQuickButtonFrame_Custom) then
		return CombatLogQuickButtonFrame_Custom:GetAlpha()
	end
end
local function ChatTabStyle(tab)
	local i = tab:GetID()
    
	if(not tab.isStyled) then
		tab.leftTexture:Hide()
		tab.middleTexture:Hide()
		tab.rightTexture:Hide()

		tab.leftSelectedTexture:Hide()
		tab.middleSelectedTexture:Hide()
		tab.rightSelectedTexture:Hide()

		tab.leftSelectedTexture.Show = tab.leftSelectedTexture.Hide
		tab.middleSelectedTexture.Show = tab.middleSelectedTexture.Hide
		tab.rightSelectedTexture.Show = tab.rightSelectedTexture.Hide

		tab.leftHighlightTexture:Hide()
		tab.middleHighlightTexture:Hide()
		tab.rightHighlightTexture:Hide()

		tab:HookScript("OnEnter", function(self) 
			local sizePlus = _G["ChatFrame"..self:GetID().."TabFlash"]:IsShown() and 1 or 0
			local fstring = self:GetFontString()
			fstring:SetFont(tabfont, tabfontsize + sizePlus, "OUTLINE")
			fstring:SetTextColor(.64, .207, .933)
		end)
		tab:HookScript("OnLeave", function(self)
			local r, g, b
			local id = self:GetID()
			local emphasis = _G["ChatFrame"..id..'TabFlash']:IsShown()
			local sizePlus = emphasis and 1 or 0
			
			if (_G["ChatFrame"..id] == SELECTED_CHAT_FRAME) then
				r, g, b = .64, .207, .933
			elseif emphasis then
				r, g, b = 1, 0, 0
			else
				r, g, b = 1, 1, 1
			end
			
			local fstring = self:GetFontString()
			fstring:SetFont(tabfont, tabfontsize + sizePlus, nil)
			fstring:SetTextColor(r, g, b)
		end)

		tab:SetAlpha(1)

		if(i ~= 2) then
			tab.SetAlpha = UIFrameFadeRemoveFrame
		else
			tab.SetAlpha = ChatFrame2_SetAlpha
			tab.GetAlpha = ChatFrame2_GetAlpha

			-- We do this here as people might be using AddonLoader together with Fane.
			if(CombatLogQuickButtonFrame_Custom) then
				CombatLogQuickButtonFrame_Custom:SetAlpha(.4)
			end
		end

		tab.isStyled = true
	end

	local fstring = tab:GetFontString()
	if(i == SELECTED_CHAT_FRAME:GetID()) then		
		fstring:SetFont(tabfont, tabfontsize, nil)
		fstring:SetTextColor(.64, .207, .933)
	else
		fstring:SetFont(tabfont, tabfontsize, nil)
		fstring:SetTextColor(1, 1, 1)
	end
end
local function SetChatTabs()
	for i = 1, NUM_CHAT_WINDOWS do
		local tab = _G["ChatFrame" .. i .. "Tab"]
		if (tab) then
			ChatTabStyle(tab)
		end
	end
	hooksecurefunc('FCF_StartAlertFlash', function(frame)
		local tab = _G['ChatFrame' .. frame:GetID() .. 'Tab']
		local fstring = tab:GetFontString()
		fstring:SetFont(tabfont, tabfontsize + 1, nil)
		fstring:SetTextColor(1, 0, 0)
	end)
	hooksecurefunc('FCFTab_UpdateColors', ChatTabStyle)
end

local function LayoutChatFrame()
    local cf1 = _G["ChatFrame1"]
    local p, x, y = GetChatWindowSavedPosition(cf1:GetID())
    if p then
        cf1:ClearAllPoints()
        cf1:SetPoint(p, x * GetScreenWidth(), y * GetScreenHeight())
        cf1:SetUserPlaced(true)
    end
end

local function ReplaceConst()
	--color
	CHAT_TAB_SHOW_DELAY = 0
	CHAT_TAB_HIDE_DELAY = 0

	CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = 1
	CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 1
	CHAT_FRAME_TAB_ALERTING_MOUSEOVER_ALPHA = 1
	CHAT_FRAME_TAB_ALERTING_NOMOUSE_ALPHA = 1
	CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = 1
	CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 1

	DEFAULT_CHATFRAME_ALPHA = 0

	--guild
	CHAT_GUILD_GET = "|Hchannel:GUILD|hG|h %s "
	CHAT_OFFICER_GET = "|Hchannel:OFFICER|hO|h %s "
    
	--raid
	CHAT_RAID_GET = "|Hchannel:RAID|hR|h %s "
	CHAT_RAID_WARNING_GET = "RW %s "
	CHAT_RAID_LEADER_GET = "|Hchannel:RAID|hRL|h %s "
  
	--party
	CHAT_PARTY_GET = "|Hchannel:PARTY|hP|h %s "
	CHAT_PARTY_LEADER_GET =  "|Hchannel:PARTY|hPL|h %s "
	CHAT_PARTY_GUIDE_GET =  "|Hchannel:PARTY|hPG|h %s "

	--bg
	CHAT_BATTLEGROUND_GET = "|Hchannel:BATTLEGROUND|hB|h %s "
	CHAT_BATTLEGROUND_LEADER_GET = "|Hchannel:BATTLEGROUND|hBL|h %s "
  
	--whisper  
	CHAT_WHISPER_INFORM_GET = "to %s "
	CHAT_WHISPER_GET = "from %s "
	CHAT_BN_WHISPER_INFORM_GET = "to %s "
	CHAT_BN_WHISPER_GET = "from %s "

	--say / yell
	CHAT_SAY_GET = "%s "
	CHAT_YELL_GET = "%s "

	--flags
	CHAT_FLAG_AFK = "[AFK] "
	CHAT_FLAG_DND = "[DND] "
	CHAT_FLAG_GM = "[GM] "
end

Modules:AddModule("Chat", function() 
    SetChatFrames()
    HideChatFrameBG()
    ReplaceConst()

    ResetAddMessage()
    ResetRefFunc()
    SetUrlFound()
    FloatingChatFrame_OnMouseScroll = ChatFrameScroll
    
    SetChatTabs()
    InitChatFrame()
    
    LayoutChatFrame()
end, nil)

--replace constant
