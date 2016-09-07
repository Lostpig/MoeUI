local addon, namespace = ...
local Moe = namespace.Moe
local Lib = Moe.Lib
local Anime = Lib.Anime
local KanWarning = Moe.Modules:Get("Warning")
local cfg = Moe.Config["Warning"]

local duration = cfg.duration or 1
local delay = cfg.delay or 1
local brokenHealth = cfg.broken or 0.3
local mediumHealth = cfg.medium or 0.6
local maxcount = 17

local Path = Moe.Media.Path.."Warning\\"
local BBTex = Path.."BB"
local MBTex = Path.."MB"
local STATUS = {
    BROKEN = 1,
    MEDIUM = 2,
    FULL = 3,
}

local Fadein = {Action = "Fade", name = "Fadein", duration = duration, order = 1, params = {from = 0, to  = 1}, enddelay = delay}
local Fadeout = {Action = "Fade", name = "Fadeout", duration = duration, order = 2, params = {from = 1, to  = 0},}

local InActs = {
    {Action = "Move",  name = "IFLB", duration = duration, order = 1, params = {mode = "IN", x = 75,  y = 75},},
    {Action = "Move",  name = "IFL",  duration = duration, order = 1, params = {mode = "IN", x = 75,  y = 0},},
    {Action = "Scale", name = "IVS",  duration = duration, order = 1, params = {fromv = 2, tov = 1, fromh = 1, toh = 1},},
    {Action = "Scale", name = "IHS",  duration = duration, order = 1, params = {fromv = 1, tov = 1, fromh = 2, toh = 1},},
    {Action = "Scale", name = "IMS",  duration = duration, order = 1, params = {fromv = 2, tov = 1, fromh = 2, toh = 1},},
}
local OutActs = {
    {Action = "Move",  name = "OFL",  duration = duration, order = 2, params = {mode = "OUT", x = 75,  y = 0},},
    {Action = "Move",  name = "OFR",  duration = duration, order = 2, params = {mode = "OUT", x = -75, y = 0},},
    {Action = "Scale", name = "OVS",  duration = duration, order = 2, params = {fromv = 1, tov = 2, fromh = 1, toh = 1},},
    {Action = "Scale", name = "OHS",  duration = duration, order = 2, params = {fromv = 1, tov = 1, fromh = 1, toh = 2},},
    {Action = "Scale", name = "IMS",  duration = duration, order = 2, params = {fromv = 1, tov = 2, fromh = 1, toh = 2},},
}

local function SetStatus(frame, status)
    frame.Status = status
    if status == STATUS.BROKEN then
        frame.SIcon:SetTexture(BBTex)
    elseif status == STATUS.MEDIUM then 
        frame.SIcon:SetTexture(MBTex)
    else
        frame.SIcon:SetTexture(nil)
    end
end
local function StartAct(frame)
    if frame.Acting then return end
    local num = Lib.RandNum(frame.MaxAct)
    local inAct = math.ceil(num / #InActs)
    if InActs[inAct].Action == "Move" then
        frame:SetPoint("LEFT", 25 - InActs[inAct].params.x, 75 -  InActs[inAct].params.y)
    else
        frame:SetPoint("LEFT", 25 , 75)
    end
    
    frame.TexNo = Lib.RandNum(maxcount, frame.TexNo)
    frame.bg:SetTexture(Path .. "texture\\"..frame.TexNo)
    PlaySoundFile(Path .. "sound\\"..frame.TexNo ..".ogg", "Master")
    
    frame[num]:Play()
    frame.Acting = true
end
local function FinishAct(frame)
    frame:GetParent().Acting = false
end
local function CreateAnimeGroups(frame)
    frame.acts = {}
    local i = 1
    for _, inact in pairs(InActs) do
        for _, outact in pairs(OutActs) do
            Anime.New(frame, i, {Fadein,inact,Fadeout,outact}, FinishAct)
            i = i + 1
        end
    end
    return i - 1
end
local function CreateStatusIcon(frame)
    frame.SIcon = frame:CreateTexture(nil, "OVERLAY")
    frame.SIcon:SetSize(96,96)
    frame.SIcon:SetPoint("RIGHT", -15, -75)
end

local function StatusChange(self, event, unit)
    if unit ~= "player" then return end
    local hp , maxhp = UnitHealth(unit), UnitHealthMax(unit)
    if maxhp == 0 then return end
    local perc = hp / maxhp
    if perc < 0.3 and self.Status > STATUS.BROKEN then 
        SetStatus(self, STATUS.BROKEN)
        StartAct(self)
    elseif perc < 0.6 and self.Status > STATUS.MEDIUM then 
        SetStatus(self, STATUS.MEDIUM)
        StartAct(self)
    elseif perc > 0.65 then
        SetStatus(self, STATUS.FULL)
    end
end
local function Test(self, status)
    SetStatus(self, status or STATUS.BROKEN)
    StartAct(self)
end

local function Load()
    KanWarning.Main = Lib.CreatePanel({
        name = "WarningFrame", parent = "UIParent",
        point = {"LEFT", 0, -25},
        width = 360, height = 450, color = {1,1,1},
    })
    KanWarning.Main:SetAlpha(0)
    KanWarning.Main.TexNo = 1
    KanWarning.Main.MaxAct = CreateAnimeGroups(KanWarning.Main)
    CreateStatusIcon(KanWarning.Main)
    KanWarning.Main.Status = STATUS.FULL
    KanWarning.test = function(status) Test(KanWarning.Main, status) end
    
    KanWarning.Main:RegisterEvent("UNIT_HEALTH")
    KanWarning.Main:SetScript("OnEvent", StatusChange)
end
Moe.Modules:AddModule("Warning", Load, nil)

SLASH_WARNINGTEST1 = "/warningtest"
SlashCmdList["WARNINGTEST"] = function(msg)
    Test(KanWarning.Main);
end



