local addon, namespace = ...
local Moe = namespace.Moe
local Lib = Moe.Lib
local Card = Moe.Modules:Get("Card")
local cfg = Moe.Config["Card"]

local MoeCard = CreateFrame("Frame", "MoeCard")
Card.Main = MoeCard

local SpellList = Card.SpellList

local SList = {}
local CList = {}

local eventsDB = {
	"UNIT_AURA",
	"UNIT_ATTACK",
	"UNIT_SPELLCAST_CHANNEL_START",
	"UNIT_SPELLCAST_START",
	"UNIT_SPELLCAST_SUCCEEDED",
	"PLAYER_TARGET_CHANGED",
	"PLAYER_REGEN_DISABLED",
	"PLAYER_REGEN_ENABLED",
	"UNIT_MANA",
	"UNIT_HEALTH",
}

local function ClearList(list)
	while #list > 0 do tremove(list) end
end
local function GetCardNo(maxcount, oldNo)
    local newNo = math.random(maxcount)
    if newNo == oldNo then
        if newNo >= maxcount then newNo = newNo - 1
        else newNo = newNo + 1 end
    end
	return newNo
end

local menuFrame = CreateFrame("Frame", "MoeCardMenu", UIParent, "UIDropDownMenuTemplate")
local function MenuClick(s,arg1,arg2)
	MoeCard:ApplyTheme(arg1)
    MoeCard:Play()
end
local function ShowMenu(self,btn)
    if UnitAffectingCombat("player") then return end
	if (btn == "RightButton") then
		local menuList = {}
		for k,v in pairs(MoeCard.Themes) do 
			tinsert(menuList, {
				text = v.name, notCheckable = true, func = MenuClick, arg1 = k
			})
		end
		if (MoeCard.islocked) then
			tinsert(menuList, {
				text = "解锁", notCheckable = true, func = function() MoeCard:Lock(false) end, arg1 = k
			})
		else
			tinsert(menuList, {
				text = "锁定", notCheckable = true, func = function() MoeCard:Lock(true) end, arg1 = k
			})
		end
		
		EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)
	end
end

local function InTurn(self)
    local f = self:GetParent():GetParent()
    f.bg:SetTexture(f.Path..f.CardNo) 
end
local function AfterTurn(self)
    local f = self:GetParent()
    f.text:SetText(type(SList[f.SCID].Text) == "function" and SList[f.SCID].Text() or SList[f.SCID].Text)
    f.Action = false
end
local function AddTurnAnime(frame)
    Lib.Anime.New(frame, "turn", {
        {Action = "Scale", name = "turnoff", duration = frame.Speed, order = 1, params = {fromv = 1, tov = 1, fromh = 1, toh = 0.05}, callback = InTurn},
        {Action = "Scale", name = "turnon", duration = frame.Speed, order = 2, params = {fromv = 1, tov = 1, fromh = 1, toh = 20},},
    }, AfterTurn)
end
local function ChangeDuration(frame)
    frame.turn.turnoff:SetDuration(frame.Speed)
    frame.turn.turnon:SetDuration(frame.Speed)
end

MoeCard.Themes = {
	["Default"] = {
		name = "默认",
		path = Moe.Media.Path.."Cards\\",
		randomcard = true,
		cardcount = 22,
		speed = 0.6,
		
		height = 150,
		width = 120,
		color = {1,0.9,0.8},
		showfont = true,
		font = Moe.Media.Fonts.Default,
		fontsize = 20,
		fontflag = "OUTLINE",
		fontpos= {"BOTTOM", 0, 9},
		fontcolor = {1,.9,0},
	}
}
MoeCard.RegisterTheme = function(self, themename, themeconfig)
	self.Themes[themename] = themeconfig
end
MoeCard.ApplyTheme = function(self, themename)
	MoeDB["Card"].Theme = themename
	local c = self.Themes[MoeDB["Card"].Theme]
	if not c then return end
	self:SetWidth(c.width)
	self:SetHeight(c.height)
	self.bg:SetVertexColor(unpack(c.color))
	self.text:SetFont(c.font, c.fontsize, c.fontflag) 
	self.text:SetTextColor(unpack(c.fontcolor)) 
	self.text:SetPoint(unpack(c.fontpos))
    --self.text:SetJustifyH("CENTER")
	
	if not c.showfont then 
		self.text:SetAlpha(0)
	else 
		self.text:SetAlpha(1)
	end
	
	if c.SetTheme and type(c.SetTheme) == "function" then c.SetTheme(self) end
	self.Width = c.width
	self.Height = c.height
	self.Speed = c.speed
	self.Count = c.cardcount
	self.Path = c.path
	self.Random = c.randomcard
    self.Action = false
    self.SCID = nil
    
    if self.turn then
        ChangeDuration(self)
    else
        AddTurnAnime(self)
    end
end
MoeCard.CreateCard = function(self)
	self.bg = self:CreateTexture(nil,"HIGH")
	self.bg:SetTexture(nil)
	self.bg:SetAllPoints()
	self.text = self:CreateFontString(nil, "OVERLAY")
	self.Time = 0
	self.SCID = 0
	self.CardNo = 0
	self.Action = false
end

MoeCard.RegEvents = function(self, eventsSet)
	for k,v in pairs(eventsSet) do
		self:RegisterEvent(v)
	end
end
MoeCard.Trigger = function(self,event)
	for k,v in ipairs(SList) do
		if SList[k].Condition() then
			if self.SCID == k or self.Action then 
				break
			else
				self.SCID = k
				self.Time = 0
				self.text:SetText(nil)
				if self.Random then self.CardNo = GetCardNo(self.Count, self.CardNo) else self.CardNo = SList[k].CardNo end
				--if SList[k].Sound then PlaySoundFile(SList[k].Sound) end --播放声效
				self.Action = true
                self.turn:Play()
				break
			end
		end
	end
end
MoeCard.Pause = function(self)
	self:Hide() 
	self:SetScript("OnEvent",nil)
end
MoeCard.Play = function(self)
	self:Show()
	self:Trigger("")
	self:SetScript("OnEvent",self.Trigger)
end
MoeCard.Lock = function(self, locked)
	self.islocked = locked
	if (self.islocked) then
		local a1, p, a2, x, y = self:GetPoint()
        if a1 ~= "CENTER" then --为了绕中轴转必须定位为CENTER
            if a1:find("BOTTOM") then y = y + self:GetHeight()/2
            elseif a1:find("TOP") then y = y - self:GetHeight()/2 end
            
            if a1:find("LEFT") then x = x + self:GetHeight()/2
            elseif a1:find("RIGHT") then x = x - self:GetHeight()/2 end
            a1 = "CENTER"
            
            self:ClearAllPoints()
            self:SetPoint(a1, p, a2, x, y)
        end
		MoeDB["Card"].Pos = { a1 = a1, a2 = a2, x = x, y = y }

		self:SetMovable(false)
		self:SetScript("OnMouseDown", nil)
		self:SetScript("OnMouseWheel", nil)
	else
		self:SetMovable(true)
		self:SetScript("OnMouseDown", self.StartMoving)
		self:HookScript("OnMouseUp", self.StopMovingOrSizing)
	end
end

local function OnSpecChange(self, event)
    local Spec = GetSpecialization()
    if not CList[Spec] and not CList["ALL"] then 
        MoeCard:Pause() 
    else 
        ClearList(SList)
        if CList["ALL"] then
            for k,v in pairs(CList["ALL"]) do tinsert(SList,v) end
        end
        if CList[Spec] then
            for k,v in pairs(CList[Spec]) do tinsert(SList,v) end
        end
        table.sort(SList, function(a,b) return a.Priority < b.Priority end)
        MoeCard:Play()
    end
end

local Load = function()
    local PlayerClass = select(2,UnitClass("player"))
    if not MoeDB["Card"] then MoeDB["Card"] = cfg end
    if not SpellList[PlayerClass] then 
        wipe(SpellList)
        return 
    end

    CList = SpellList[PlayerClass]
    wipe(SpellList)
    
    MoeCard:CreateCard()
    MoeCard:SetPoint(MoeDB["Card"].Pos.a1,UIParent,MoeDB["Card"].Pos.a2,MoeDB["Card"].Pos.x,MoeDB["Card"].Pos.y)
    MoeCard:SetScript("OnMouseUp",ShowMenu)
    MoeCard:RegEvents(eventsDB)
    MoeCard:ApplyTheme(MoeDB["Card"].Theme)
    MoeCard:Lock(true)
    
    Lib.NewTrigger("CardTrigger",{
    	Events = {"ACTIVE_TALENT_GROUP_CHANGED", "CONFIRM_TALENT_WIPE", "PLAYER_TALENT_UPDATE"},
        Script = OnSpecChange
    })
    OnSpecChange(MoeCard,"ACTIVE_TALENT_GROUP_CHANGED")
end

Moe.Modules:AddModule("Card", Load, nil)

SLASH_MCARD1 = "/mcard"
SlashCmdList["MCARD"] = function(msg)
	if msg == "test" then
		for k,v in pairs(SList) do
			print(type(v.Text) == "function" and v.Text() or v.Text)
		end
	elseif msg == "reset" then
		MoeDB["Card"] = cfg
		MoeCard:ApplyTheme(MoeDB["Card"].Theme)
		MoeCard:SetPoint(MoeDB["Card"].Pos.a1,UIParent,MoeDB["Card"].Pos.a2,MoeDB["Card"].Pos.x,MoeDB["Card"].Pos.y)
	elseif msg == "db" then
		for k,v in pairs(MoeDB["Card"]) do
			print(k, v)
		end
    elseif msg == "rand" then
        local x = 0
        for i = 1, 10 do 
            if GetCardNo(9,9) > 9 then x = x + 1 end
        end
        print(x)
	elseif msg == "init" then
		SList = {}
	elseif msg == "show" then
		MoeCard:Show()
	elseif msg == "hide" then
		MoeCard:Show()
	end
end

