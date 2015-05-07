local addon, namespace = ...
local Media = namespace.Moe.Media
local Modules = namespace.Moe.Modules
local Lib = namespace.Moe.Lib
local MoeEmote = Modules:Get("Emote")

local iconTable = {}
local packTable = {}
local EmoteDB = {}
local config = 
{
	font = Media.Fonts.Default,
	Size = 30,
}

local path = Media.Path
local DefaultPack = {
	name = "Default",
	size = 24,
	emo = {
	["{天使}"] =	path .. [=[Emote\Angel]=],
	["{生气}"] =	path .. [=[Emote\Angry]=],
	["{大笑}"] =	path .. [=[Emote\Biglaugh]=],
	["{鼓掌}"] =	path .. [=[Emote\Clap]=],
	["{酷}"] =		path .. [=[Emote\Cool]=],
	["{哭}"] =		path .. [=[Emote\Cry]=],
	["{可爱}"] =	path .. [=[Emote\Cutie]=],
	["{鄙视}"] =	path .. [=[Emote\Despise]=],
	["{美梦}"] =	path .. [=[Emote\Dreamsmile]=],
	["{尴尬}"] =	path .. [=[Emote\Embarrass]=],  
	--10
	["{邪恶}"] =	path .. [=[Emote\Evil]=],
	["{兴奋}"] =	path .. [=[Emote\Excited]=],
	["{晕}"] =		path .. [=[Emote\Faint]=],
	["{打架}"] =	path .. [=[Emote\Fight]=],
	["{流感}"] =	path .. [=[Emote\Flu]=],
	["{呆}"] =		path .. [=[Emote\Freeze]=],
	["{皱眉}"] =	path .. [=[Emote\Frown]=],
	["{致敬}"] =	path .. [=[Emote\Greet]=],
	["{鬼脸}"] =	path .. [=[Emote\Grimace]=],
	["{龇牙}"] =	path .. [=[Emote\Growl]=],
	--20
	["{开心}"] =	path .. [=[Emote\Happy]=],
	["{心}"] =		path .. [=[Emote\Heart]=],
	["{恐惧}"] =	path .. [=[Emote\Horror]=],
	["{生病}"] =	path .. [=[Emote\Ill]=],
	["{无辜}"] =	path .. [=[Emote\Innocent]=],
	["{功夫}"] =	path .. [=[Emote\Kongfu]=],
	["{花痴}"] =	path .. [=[Emote\Love]=],
	["{邮件}"] =	path .. [=[Emote\Mail]=],
	["{化妆}"] =	path .. [=[Emote\Makeup]=],
	["{马里奥}"] =	path .. [=[Emote\Mario]=],
	--30
	["{沉思}"] =	path .. [=[Emote\Meditate]=],
	["{可怜}"] =	path .. [=[Emote\Miserable]=],
	["{好}"] =		path .. [=[Emote\Okay]=],
	["{漂亮}"] =	path .. [=[Emote\Pretty]=],
	["{吐}"] =		path .. [=[Emote\Puke]=],
	["{握手}"] =	path .. [=[Emote\Shake]=],
	["{喊}"] =		path .. [=[Emote\Shout]=],
	["{闭嘴}"] =	path .. [=[Emote\Shuuuu]=],
	["{害羞}"] =	path .. [=[Emote\Shy]=],
	["{睡觉}"] =	path .. [=[Emote\Sleep]=],
	--40
	["{微笑}"] =	path .. [=[Emote\Smile]=],
	["{吃惊}"] =	path .. [=[Emote\Suprise]=],
	["{失败}"] =	path .. [=[Emote\Surrender]=],
	["{流汗}"] =	path .. [=[Emote\Sweat]=],
	["{流泪}"] =	path .. [=[Emote\Tear]=],
	["{悲剧}"] =	path .. [=[Emote\Tears]=],
	["{想}"] =		path .. [=[Emote\Think]=],
	["{偷笑}"] =	path .. [=[Emote\Titter]=],
	["{猥琐}"] =	path .. [=[Emote\Ugly]=],
	["{胜利}"] =	path .. [=[Emote\Victory]=],
	--50
	["{雷锋}"] =	path .. [=[Emote\Volunteer]=],
	["{委屈}"] =	path .. [=[Emote\Wronged]=],
	}
}

local function CreateBorder(f)
    Lib.FramePx(f, 1, {.09,.09,.09,.5}, {1,1,1,.33})
end
--聊天框显示表情
local function MoeChatFilter(self, event, msg, ...)	--将语句中的{表情}替换为icon
	local fmtstr = format("\124T%%s:%d\124t",max(floor(select(2,SELECTED_CHAT_FRAME:GetFont())),EmoteDB.size))
	for k,v in pairs(EmoteDB.emo) do
		if msg:find(k) then
			msg = msg:gsub(k,format(fmtstr,v),1)
			break
		end
	end
	return false, msg, ...
end
--使用函数
local function ToggleEmoteFrame()
	if (not EmoteFrameP1) then CreateEmoteFrame() end
	if (EmoteFrameP1:IsShown() or EmoteFrameP2:IsShown()) then
		EmoteFrameP1:Hide()
		EmoteFrameP2:Hide()
		page1:Hide()
		page2:Hide()
	else
		EmoteFrameP1:Show()
		page1:Show()
		page2:Show()
		--EmoteFrameP2:Show()
	end
end
local function EmoteIconMouseUp(frame, button)
	if (button == "LeftButton") then
		local ChatFrameEditBox = ChatEdit_ChooseBoxForSend()
		if (ChatFrameEditBox:GetFrameStrata() ~= "DIALOG") then
			ChatEdit_ActivateChat(ChatFrameEditBox)
			--print("NOOOOOOO!!!")
		end
		ChatFrameEditBox:Insert(frame.text)
	end
	ToggleEmoteFrame()
end
--更改表情包函数
function MoeEmote:ApplyPack(pack)
	EmoteDB = pack
	for k,v in pairs(iconTable) do
		v.texture:SetTexture(EmoteDB.emo[v.text])
	end
end
function MoeEmote:RegisterPack(pack)
	tinsert(packTable,pack)
end
local function SelectPack(packname)
	local isfind = false
	for k, v in pairs(packTable) do
		if v.name == packname then
			MoeEmote:ApplyPack(v)
			MoeDB["Emote"] = v.name
			isfind = true
			break;
		end
	end
	if not isfind then 
		MoeEmote:ApplyPack(DefaultPack)
		MoeDB["Emote"] = "Default"
		print(format("|cfff0ff00MoeEmote|r:|cffff0000错误:未找到设置的表情包！！|r"))
	end
end
--右键菜单
local menuList = {}
local menuFrame = CreateFrame("Frame", "MoeEmoteMenu", UIParent, "UIDropDownMenuTemplate")
local function SetMenuList()
	for k,v in pairs(packTable) do
		se = {text = v.name,
			func = function() SelectPack(v.name) end}
		tinsert(menuList,se)
	end
end
--创建框体函数
local function EmoteButtonClick(self,btn)
	if (btn == "LeftButton") then
		ToggleEmoteFrame()
	elseif (btn == "RightButton") then
		EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)
	else
		return
	end
end
local function CreateEmoteFrame()
	EmoteFrameP1 = CreateFrame("Frame", "MoeEmoteFrame1", UIParent)
	EmoteFrameP1:SetFrameStrata("DIALOG")
	EmoteFrameP1:SetWidth((config.Size+3) * 7+6)
	EmoteFrameP1:SetHeight((config.Size+3) * 4+6)
	CreateBorder(EmoteFrameP1)
	
	EmoteFrameP2 = CreateFrame("Frame", "MoeEmoteFrame2", UIParent)
	EmoteFrameP2:SetFrameStrata("DIALOG")
	EmoteFrameP2:SetWidth((config.Size+3) * 7+6)
	EmoteFrameP2:SetHeight((config.Size+3) * 4+6)
	CreateBorder(EmoteFrameP2)
	
	local row = 1
	local col = 1
	local i=1
	local page = EmoteFrameP1
	for k,v in pairs(EmoteDB.emo) do
		local icon = CreateFrame("Frame", format("IconButton%d",i), page)
		icon:SetWidth(config.Size)
		icon:SetHeight(config.Size)
		icon.text = k
		icon.texture = icon:CreateTexture(nil,"ARTWORK")
		icon.texture:SetTexture(v)
		icon.texture:SetAllPoints(icon)
		icon:Show()
		icon:SetPoint("TOPLEFT", (col-1)*(config.Size+2)+3, -(row-1)*(config.Size+2)-3)
		icon:SetScript("OnMouseUp", EmoteIconMouseUp)
		icon:EnableMouse(true)
		tinsert(iconTable, icon)
		
		col = col + 1 
		if (col>7) then
			row = row + 1
			col = 1
		end
		
		if(i==28) then
			page = EmoteFrameP2
			row = 1
			col = 1
		end
		i = i+1
	end
end
local function CreateEmoteButton()
	local eb = _G['ChatFrame1EditBox']
	local button = CreateFrame("Button","EmoteButton",UIParent)
	button:SetPoint("RIGHT",eb,"RIGHT",0,-22)
	button:SetHeight(19)
	button:SetWidth(19)
	button:SetAlpha(0.7)
	
	CreateBorder(button)
	
	local buttontext = button:CreateFontString(nil,"OVERLAY",nil)
	buttontext:SetFont(config.font,12,"OUTLINE")
	buttontext:SetText("M")
	buttontext:SetTextColor(1,1,0)
	buttontext:SetPoint("CENTER")
	buttontext:SetJustifyH("CENTER")
	buttontext:SetJustifyV("CENTER")
	
	button:SetScript("OnMouseUp", EmoteButtonClick)
	button:SetScript("OnEnter", function() button:SetAlpha(1) end)
	button:SetScript("OnLeave", function() button:SetAlpha(0.7) end)
	button:Show()
end
local function CreatePageButton()
	page1 = CreateFrame("Button","PageButton1",UIParent)
	page1:SetPoint("TOPLEFT",EmoteFrameP1,"BOTTOMLEFT",0,-3)
	page1:SetHeight(16)
	page1:SetWidth(44)
	page1:SetAlpha(0.6)
	CreateBorder(page1)
	
	page1.text = page1:CreateFontString(nil,"OVERLAY",nil)
	page1.text:SetFont(config.font,13,"OUTLINE")
	page1.text:SetText("第一页")
	page1.text:SetTextColor(0.41,0.8,0.94)
	page1.text:SetPoint("CENTER")
	page1.text:SetJustifyH("CENTER")
	page1.text:SetJustifyV("CENTER")
	
	page1:SetScript("OnMouseUp", function(self, btn)
		EmoteFrameP1:Show()
		EmoteFrameP2:Hide()
	end)
	page1:SetScript("OnEnter", function(self) self:SetAlpha(1) end)
	page1:SetScript("OnLeave", function(self) self:SetAlpha(0.6) end)
	page1:Hide()
	--page2
	page2 = CreateFrame("Button","PageButton2",UIParent)
	page2:ClearAllPoints()
	page2:SetPoint("LEFT",page1,"RIGHT",5,0)
	page2:SetHeight(16)
	page2:SetWidth(44)
	page2:SetAlpha(0.6)
	CreateBorder(page2)
	
	page2.text = page2:CreateFontString(nil,"OVERLAY",nil)
	page2.text:SetFont(config.font,13,"OUTLINE")
	page2.text:SetText("第二页")
	page2.text:SetTextColor(0.41,0.8,0.94)
	page2.text:SetPoint("CENTER")
	page2.text:SetJustifyH("CENTER")
	page2.text:SetJustifyV("CENTER")
	
	page2:SetScript("OnMouseUp", function(self, btn)
		EmoteFrameP2:Show()
		EmoteFrameP1:Hide()
	end)
	page2:SetScript("OnEnter", function(self) self:SetAlpha(1) end)
	page2:SetScript("OnLeave", function(self) self:SetAlpha(0.6) end)
	page2:Hide()
end
--绑定
local function handingFilter()
	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", MoeChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", MoeChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", MoeChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", MoeChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", MoeChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", MoeChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", MoeChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", MoeChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", MoeChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", MoeChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", MoeChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND", MoeChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", MoeChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", MoeChatFilter)
end

local function Init()
    MoeEmote:RegisterPack(DefaultPack)
    EmoteDB = DefaultPack
    CreateEmoteButton()
    CreateEmoteFrame()
    CreatePageButton()
    EmoteFrameP1:SetPoint("LEFT",_G["EmoteButton"],"RIGHT",4,-30)
    EmoteFrameP2:SetPoint("LEFT",_G["EmoteButton"],"RIGHT",4,-30)
    EmoteFrameP1:Hide()
    EmoteFrameP2:Hide()
    local ebl = _G['ChatFrame1EditBoxLanguage']
    ebl:Hide()
    ebl:HookScript("OnShow", function(s) s:Hide(); end)
end
local function Load()
    if not MoeDB["Emote"] then MoeDB["Emote"] = "Default" end
    Init()
	SetMenuList()
	handingFilter()
	SelectPack(MoeDB["Emote"])
end
Modules:AddModule("Emote", Load, nil)


