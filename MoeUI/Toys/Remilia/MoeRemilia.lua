local addon, namespace = ...
local Moe = namespace.Moe
local Lib = Moe.Lib
local Remilia = Moe.Modules:Get("Remilia")

local unlock = false

local basePath = Moe.Media.Path.."Remilia"
local Path = basePath.."\\default"
local FrameChangeTime = 0
local IsDead = false
local rw = 240
local rh = 240
local Moe_RemiliaSave_default = {
		["ver"] = "0.17",
		["IsHide"] = false,
		["Flandre"] = false,
		["Scale"] = 1.0,
		["ArchorX"] = -36,
		["ArchorY"] = 16,
		["Point"] = "LEFT",
		["Relay"] = "LEFT",
}

function BaseAction(self,elapsed)
	FrameChangeTime = FrameChangeTime + elapsed;
	if FrameChangeTime > 0.1 then
		self.bg:SetTexture(Path.."\\Stand\\stand"..self.AcNum,true);
		self.AcNum = self.AcNum + 1;
		FrameChangeTime = 0;
		if self.AcNum >= 8 then self.AcNum = 0 end
	end
end;
function DownAction(self, elapsed)
	FrameChangeTime = FrameChangeTime + elapsed;
	if FrameChangeTime > 0.08 and self.AcNum < 11 then
		self.bg:SetTexture(Path.."\\Down\\down"..self.AcNum,true);
		self.AcNum = self.AcNum + 1;
		FrameChangeTime = 0;
	end
end;
function StandUpAction(self,elapsed)
	FrameChangeTime = FrameChangeTime + elapsed;
	if FrameChangeTime > 0.08 then
		self.bg:SetTexture(Path.."\\StandUp\\standUp"..self.AcNum,true);
		self.AcNum = self.AcNum + 1;
		FrameChangeTime = 0;
		if self.AcNum > 8 then 
			self:Hide()
		end
	end
end;
function HPLowAction(self,elapsed)
	FrameChangeTime = FrameChangeTime + elapsed;
	if FrameChangeTime > 0.1 and self.AcNum < 2 then
		self.bg:SetTexture(Path.."\\GuardUnder\\guardUnder"..self.AcNum,true);
		self.AcNum = self.AcNum + 1;
		FrameChangeTime = 0;
	end
end;

local function lockRemilia()
	unlock = false
	MoeDB["Remilia"]["IsHide"] = false
	
	Lib.RemoveBorder(Remilia.MainFrame)
	Remilia.MainFrame:EnableMouse(false)
	Remilia.MainFrame:SetMovable(false)
	Remilia.MainFrame:EnableMouseWheel(false)
	Remilia.MainFrame:SetScript("OnMouseDown", nil)

	Remilia.MainFrame:SetScript("OnMouseWheel", nil)
	MoeDB["Remilia"]["Point"],archor,MoeDB["Remilia"]["Relay"],MoeDB["Remilia"]["ArchorX"],MoeDB["Remilia"]["ArchorY"] = Remilia.MainFrame:GetPoint()
	MoeDB["Remilia"]["Scale"] = Remilia.MainFrame:GetScale()
end

local function Create(ParentFrame)
    local BaseFrame = CreateFrame("Frame","RemiliaBase",ParentFrame)
    local DownFrame = CreateFrame("Frame","RemiliaDown",ParentFrame)
    local HPLowFrame = CreateFrame("Frame","RemiliaDown",ParentFrame)
    local StandUpFrame = CreateFrame("Frame","RemiliaDown",ParentFrame)

    BaseFrame:SetAllPoints(ParentFrame)
    BaseFrame.bg = BaseFrame:CreateTexture(nil,"BACKGROUND")
    BaseFrame.bg:SetTexture(Path.."\\Stand\\stand0",true)
    BaseFrame.bg:SetAllPoints(BaseFrame)
    BaseFrame.AcNum = 0
    BaseFrame:SetScript("OnUpdate",BaseAction)
    BaseFrame:Show()

    DownFrame:SetAllPoints(ParentFrame)
    DownFrame.bg = DownFrame:CreateTexture(nil,"BACKGROUND")
    DownFrame.bg:SetTexture(Path.."\Down\down0",true)
    DownFrame.bg:SetAllPoints(DownFrame)
    DownFrame.AcNum = 0
    DownFrame:Hide()
    DownFrame:RegisterEvent("PLAYER_DEAD")
    DownFrame:SetScript("OnEvent",function(self,event)
        if event == "PLAYER_DEAD" then
            self.AcNum = 0
            IsDead = true
            self:SetScript("OnUpdate",DownAction)
            BaseFrame:Hide()
            HPLowFrame:Hide()
            self:Show()
        end
    end)

    StandUpFrame:SetAllPoints(ParentFrame)
    StandUpFrame.bg = StandUpFrame:CreateTexture(nil,"BACKGROUND")
    StandUpFrame.bg:SetTexture(Path.."\StandUp\standUp0",true)
    StandUpFrame.bg:SetAllPoints(StandUpFrame)
    StandUpFrame.AcNum = 0
    StandUpFrame:Hide()
    StandUpFrame:RegisterEvent("PLAYER_UNGHOST")
    StandUpFrame:RegisterEvent("PLAYER_ALIVE")
    StandUpFrame:SetScript("OnEvent",function(self,event)
        if event == "PLAYER_UNGHOST" or event == "PLAYER_ALIVE" then
            if UnitHealth('player') > 5 then
                self.AcNum = 0
                self:SetScript("OnUpdate",StandUpAction)
                DownFrame:Hide()
                self:Show()
            end
        end
    end)
    StandUpFrame:SetScript("OnHide",function(self)
        IsDead = false
        BaseFrame:Show()
    end)

    HPLowFrame:SetAllPoints(ParentFrame)
    HPLowFrame.bg = HPLowFrame:CreateTexture(nil,"BACKGROUND")
    HPLowFrame.bg:SetTexture(Path.."\StandUp\standUp0",true)
    HPLowFrame.bg:SetAllPoints(HPLowFrame)
    HPLowFrame.AcNum = 0
    HPLowFrame.LowHpFlag = true
    HPLowFrame:Hide()
    HPLowFrame:RegisterEvent("UNIT_HEALTH")
    HPLowFrame:RegisterEvent("UNIT_AURA")
    HPLowFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    HPLowFrame:SetScript("OnEvent",function(self,event)
        local CurHP, MaxHP = UnitHealth('player'), UnitHealthMax('player')
        local PerHP = CurHP/MaxHP
        if PerHP<0.3 then 
            if self.LowHpFlag == true and not IsDead then
                self.AcNum = 0
                self.LowHpFlag = false
                self:SetScript("OnUpDate",HPLowAction)
                BaseFrame:Hide()
                self:Show()
            end
        elseif not IsDead then
            self.LowHpFlag = true
            self:Hide()
            BaseFrame:Show()
        end
    end)
end
local function Startf(self, event)
	if (not MoeDB["Remilia"]) or MoeDB["Remilia"]["ver"] ~= MoeDB["Remilia"]["ver"] then MoeDB["Remilia"] = Moe_RemiliaSave_default end
	Remilia.MainFrame:ClearAllPoints()
	Remilia.MainFrame:SetPoint(MoeDB["Remilia"]["Point"], nil, MoeDB["Remilia"]["Relay"], MoeDB["Remilia"]["ArchorX"], MoeDB["Remilia"]["ArchorY"])
	Remilia.MainFrame:SetScale(MoeDB["Remilia"]["Scale"])
	Remilia.MainFrame:SetWidth(rw)
	Remilia.MainFrame:SetHeight(rh)
	if MoeDB["Remilia"]["Flandre"] then Path = basePath.."\\flandre" end
	if MoeDB["Remilia"]["IsHide"] then Remilia.MainFrame:Hide()
	else Remilia.MainFrame:Show() end
end

local menuFrame = CreateFrame("Frame", "MoeEmoteMenu", UIParent, "UIDropDownMenuTemplate")
local menuList = {
	{text = "雷米莉亚", notCheckable = true, func = function() 
		Path = basePath.."\\default"
		MoeDB["Remilia"]["Flandre"] = false
	end},
	{text = "芙兰朵露",notCheckable = true, func = function() 
		Path = basePath.."\\flandre"
		MoeDB["Remilia"]["Flandre"] = true
	end},
	{text = "解锁",notCheckable = true, func = function()
		SlashCmdList["REMILIA"]()
	end},
}
local function ClickMenu(self,btn)
	if (btn == "RightButton") then
		EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)
	end
end

local function Load()
    Remilia.MainFrame = CreateFrame("Frame", "Remilia2", UIParent)
    Remilia.MainFrame:SetWidth(rw)
    Remilia.MainFrame:SetHeight(rh)
    Remilia.MainFrame:SetPoint("BOTTOMLEFT",UIParent,"LEFT",0,-75);
    Remilia.MainFrame:Show()
    Create(Remilia.MainFrame)

    local Trigger = CreateFrame("Frame", nil ,Remilia.MainFrame)
    Trigger:RegisterEvent(	"PLAYER_ENTERING_WORLD")
    Trigger:SetWidth(rw/2)
    Trigger:SetHeight(rh/2)
    Trigger:SetPoint("BOTTOM",0,0)
    Trigger:SetScript("OnEvent", Startf)

    Trigger:SetScript("OnMouseUp", ClickMenu)
end

Moe.Modules:AddModule("Remilia", Load, nil)

SLASH_REMILIA1 = "/remilia"
SlashCmdList["REMILIA"] = function(msg)
	if msg == "info" then
		print(rw.." , "..rh)
	elseif msg == "reset" then
		MoeDB["Remilia"] = Moe_RemiliaSave_default
		Startf(Remilia.MainFrame, "PLAYER_ENTERING_WORLD")
	elseif not unlock then
		unlock = true
		if not Remilia.MainFrame:IsVisible() then
			Remilia.MainFrame:Show()
		end
		
		StaticPopupDialogs["RemiliaLocked"] = {
			text = "MoeRemilia解锁",
			button1 = "锁定",
			button2 = "隐藏MoeRemilia",
			OnAccept = function() lockRemilia() end,
			OnCancel = function() 
				unlock = false
				MoeDB["Remilia"]["IsHide"] = true
				Remilia.MainFrame:Hide() 
			end,
			timeout = 0,
			whileDead = 1,
			hideOnEscape = false
		}
		
		Lib.CreateShadow(Remilia.MainFrame,1,{0,0,0,.5},{0,0,0,1})
		Remilia.MainFrame:EnableMouse(true)
		Remilia.MainFrame:SetMovable(true)
		Remilia.MainFrame:EnableMouseWheel()
		Remilia.MainFrame:SetScript("OnMouseDown", Remilia.MainFrame.StartMoving)
		Remilia.MainFrame:SetScript("OnMouseUp", Remilia.MainFrame.StopMovingOrSizing)
		local FrameSacle = Remilia.MainFrame:GetScale()
		Remilia.MainFrame:SetScript("OnMouseWheel", function(self, direction)
			if(direction > 0) then
				Remilia.MainFrame:SetScale(Remilia.MainFrame:GetScale() + 0.05)
			else
				Remilia.MainFrame:SetScale(Remilia.MainFrame:GetScale() - 0.05)
			end
		end)
		StaticPopup_Show("RemiliaLocked")
	end
end
