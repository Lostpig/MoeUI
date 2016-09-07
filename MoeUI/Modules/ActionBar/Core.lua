local addon, namespace = ...
local Lib = namespace.Moe.Lib
local Modules = namespace.Moe.Modules
local Media = namespace.Moe.Media
local Theme = namespace.Moe.Theme
local config = namespace.Moe.Config["ActionBar"]
local ActBar = Modules:Get("ActionBar")

local ButtonStyle        = ActBar.ButtonStyle
local ExtraButtonStyle   = ActBar.ExtraButtonStyle
local PetButtonStyle     = ActBar.PetButtonStyle
local StanceButtonStyle  = ActBar.StanceButtonStyle
local PossessButtonStyle = ActBar.PossessButtonStyle
local LeaveButtonStyle   = ActBar.LeaveButtonStyle

local num = NUM_ACTIONBAR_BUTTONS
local dummy = Lib.GetDummy()

local function HideBLZ()
	--hide override bar art
	local overridebarTexList =  {
		"_BG",
		"EndCapL",
		"EndCapR",
		"_Border",
		"Divider1",
		"Divider2",
		"Divider3",
		"ExitBG",
		"MicroBGL",
		"MicroBGR",
		"_MicroBGMid",
		"ButtonBGL",
		"ButtonBGR",
		"_ButtonBGMid",
    }
    for _,ortex in pairs(overridebarTexList) do
		OverrideActionBar[ortex]:SetAlpha(0)
    end
	
	Lib.BindHider(MainMenuBar,
		MainMenuBarPageNumber,
		ActionBarDownButton,
		ActionBarUpButton,
		OverrideActionBarExpBar,
		OverrideActionBarHealthBar,
		OverrideActionBarPowerBar,
		OverrideActionBarPitchFrame
    )
		
	StanceBarLeft:SetTexture(nil)
	StanceBarMiddle:SetTexture(nil)
	StanceBarRight:SetTexture(nil)
	SlidingActionBarTexture0:SetTexture(nil)
	SlidingActionBarTexture1:SetTexture(nil)
	PossessBackground1:SetTexture(nil)
	PossessBackground2:SetTexture(nil)
	
	MainMenuBarTexture0:SetTexture(nil)
    MainMenuBarTexture1:SetTexture(nil)
    MainMenuBarTexture2:SetTexture(nil)
    MainMenuBarTexture3:SetTexture(nil)
    MainMenuBarLeftEndCap:SetTexture(nil)
    MainMenuBarRightEndCap:SetTexture(nil)
end
local function SetFadeing(bar, buttonList, inalpha, outalpha, fadetime)
	bar:SetScript("OnEnter",function(self) UIFrameFadeOut(self, fadetime, bar:GetAlpha(), inalpha) end)
	bar:SetScript("OnLeave",function(self) UIFrameFadeOut(self, fadetime, bar:GetAlpha(), outalpha) end)
	
	for _, button in pairs(buttonList) do
		if button then
			button:HookScript("OnEnter", function() UIFrameFadeIn(bar, fadetime, bar:GetAlpha(), inalpha) end)
			button:HookScript("OnLeave", function() UIFrameFadeOut(bar, fadetime, bar:GetAlpha(), outalpha) end)
		end
	end
	
	bar:SetAlpha(outalpha)
end

local function SetMainBar(theme)
	local cfg = config.bar1
	if cfg.enable == false then return end
	local barFrame = CreateFrame("Frame", "Moe_ActBar_Main", UIParent, "SecureHandlerStateTemplate")
	barFrame:SetWidth(num * cfg.size + (num + 1) * cfg.spacing)
    barFrame:SetHeight(cfg.size + 2 * cfg.spacing)
	barFrame:SetPoint(unpack(cfg.point))
	barFrame:SetScale(cfg.scale)
	
	MainMenuBarArtFrame:SetParent(barFrame)
	MainMenuBarArtFrame:EnableMouse(false)
	
	for i = 1, num do
		local button = _G["ActionButton"..i]
		button:SetSize(cfg.size, cfg.size)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", barFrame, "BOTTOMLEFT", cfg.spacing, cfg.spacing)
		else
			local prevBtn = _G["ActionButton"..(i-1)]
			button:SetPoint("LEFT", prevBtn, "RIGHT", cfg.spacing, 0)
		end
		ButtonStyle(button, theme)
    end
	
	RegisterStateDriver(barFrame, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")
end
local function SetBar(baseBar, barcfg, index, theme)
	local cfg = barcfg
	local barFrame = CreateFrame("Frame", "Moe_ActBar_"..index, UIParent, "SecureHandlerStateTemplate")
	local buttonList = {}
	
	if (cfg.vertical) then
		barFrame:SetWidth(cfg.size + 2 * cfg.spacing)
		barFrame:SetHeight(num * cfg.size + (num + 1) * cfg.spacing)
	else
		barFrame:SetWidth(num * cfg.size + (num + 1) * cfg.spacing)
		barFrame:SetHeight(cfg.size + 2 * cfg.spacing)
	end
	barFrame:SetPoint(unpack(cfg.point))
	barFrame:SetScale(cfg.scale)
	
	baseBar:SetParent(barFrame)
	baseBar:EnableMouse(false)

	for i = 1, num do
		local button = _G[baseBar:GetName() .. "Button" .. i]
		table.insert(buttonList, button)
		
		button:SetSize(cfg.size, cfg.size)
		button:ClearAllPoints()
		if i == 1 then
			if (cfg.vertical) then
				button:SetPoint("TOPLEFT", barFrame, "TOPLEFT", cfg.spacing, -cfg.spacing)
			else
				button:SetPoint("BOTTOMLEFT", barFrame, "BOTTOMLEFT", cfg.spacing, cfg.spacing)
			end
		else
			local prevBtn = _G[baseBar:GetName() .. "Button" .. (i-1)]
			if (cfg.vertical) then
				button:SetPoint("TOP", prevBtn, "BOTTOM", 0, -cfg.spacing)
			else
				button:SetPoint("LEFT", prevBtn, "RIGHT", cfg.spacing, 0)
			end
		end
		ButtonStyle(button, theme)
	end

	RegisterStateDriver(barFrame, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")
	if (cfg.fade) then SetFadeing(barFrame, buttonList, cfg.fadein, cfg.fadeout, cfg.fadetime) end
end

local function SetPetBar(theme)
	local cfg = config.petbar
	local barFrame = CreateFrame("Frame", "Moe_ActBar_Pet", UIParent, "SecureHandlerStateTemplate")
	barFrame:SetWidth(cfg.size * NUM_PET_ACTION_SLOTS + (NUM_PET_ACTION_SLOTS + 1) * cfg.spacing)
	barFrame:SetHeight(cfg.size + 2 * cfg.spacing)
	barFrame:SetPoint(unpack(cfg.point))
	barFrame:SetScale(cfg.scale)
	
	PetActionBarFrame:SetParent(barFrame)
	PetActionBarFrame:EnableMouse(false)
	
	for i=1, NUM_PET_ACTION_SLOTS do
		local button = _G["PetActionButton"..i]
		button:SetSize(cfg.size, cfg.size)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", barFrame, "BOTTOMLEFT", cfg.spacing, cfg.spacing)
		else
			local previous = _G["PetActionButton"..i-1]
			button:SetPoint("LEFT", previous, "RIGHT", cfg.spacing, 0)
		end
		--cooldown fix
		local cd = _G["PetActionButton"..i.."Cooldown"]
		cd:SetAllPoints(button)
		PetButtonStyle(button, theme)
	end
	RegisterStateDriver(barFrame, "visibility", "[petbattle][overridebar][vehicleui] hide; [@pet,exists,nodead] show; hide")
end
local function SetStanceBar(theme)
	local cfg = config.stancebar
	local barFrame = CreateFrame("Frame", "Moe_ActBar_Stance", UIParent, "SecureHandlerStateTemplate")
	barFrame:SetWidth(NUM_STANCE_SLOTS * cfg.size + (NUM_STANCE_SLOTS + 1)*cfg.spacing)
	barFrame:SetHeight(cfg.size + 2 * cfg.spacing)
	barFrame:SetPoint(unpack(cfg.point))
	barFrame:SetScale(cfg.scale)
	
	StanceBarFrame:SetParent(barFrame)
	StanceBarFrame:EnableMouse(false)
	for i=1, NUM_STANCE_SLOTS do
		local button = _G["StanceButton"..i]
		button:SetSize(cfg.size, cfg.size)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", barFrame, "BOTTOMLEFT",cfg.spacing, cfg.spacing)
		else
			local previous = _G["StanceButton"..i-1]
			button:SetPoint("LEFT", previous, "RIGHT", cfg.spacing, 0)
		end
		StanceButtonStyle(button, theme)
	end
	
	PossessBarFrame:SetParent(barFrame)
	PossessBarFrame:EnableMouse(false)
	for i=1, NUM_POSSESS_SLOTS do
		local button = _G["PossessButton"..i]
		button:SetSize(cfg.size, cfg.size)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", barFrame, "BOTTOMLEFT", cfg.spacing, cfg.spacing)
		else
			local previous = _G["PossessButton"..i-1]
			button:SetPoint("LEFT", previous, "RIGHT", cfg.spacing, 0)
		end
		PossessButtonStyle(button, theme)
	end
	RegisterStateDriver(barFrame, "visibility", "[petbattle][overridebar][vehicleui] hide; show")
end
local function SetExtraBar(theme)
	local cfg = config.extrabar
	local barFrame = CreateFrame("Frame", "Moe_ActBar_Extra", UIParent, "SecureHandlerStateTemplate")
	barFrame:SetWidth(cfg.size + 2*cfg.spacing)
	barFrame:SetHeight(cfg.size + 2*cfg.spacing)
	barFrame:SetPoint(unpack(cfg.point))
	barFrame:SetScale(cfg.scale)

	ExtraActionBarFrame:SetParent(barFrame)
	ExtraActionBarFrame:EnableMouse(false)
	ExtraActionBarFrame:ClearAllPoints()
	ExtraActionBarFrame:SetPoint("CENTER", 0, 0)
	ExtraActionBarFrame.ignoreFramePositionManager = true

	local button = ExtraActionButton1
	button:SetSize(cfg.size,cfg.size)
	ExtraButtonStyle(button, theme)
	
	RegisterStateDriver(barFrame, "visibility", "[petbattle][overridebar][vehicleui] hide; show")
end
local function SetLeaveVehicle(theme)
	local cfg = config.leavevehicle
	local barFrame = CreateFrame("Frame", "Moe_ActBar_LeaveVehicle", UIParent, "SecureHandlerStateTemplate")
	barFrame:SetWidth(cfg.size + 2*cfg.spacing)
	barFrame:SetHeight(cfg.size + 2*cfg.spacing)
	barFrame:SetPoint(unpack(cfg.point))
	barFrame:SetScale(cfg.scale)

	local button = CreateFrame("BUTTON", "Moe_ActBar_LeaveVehicleButton", barFrame, "SecureHandlerClickTemplate, SecureHandlerStateTemplate");
	button:SetSize(cfg.size, cfg.size)
	button:SetPoint("BOTTOMLEFT", barFrame, cfg.spacing, cfg.spacing)
	button:RegisterForClicks("AnyUp")
	button:SetScript("OnClick", function(self) VehicleExit() end)

	button:SetNormalTexture("INTERFACE\\PLAYERACTIONBARALT\\NATURAL")
	button:SetPushedTexture("INTERFACE\\PLAYERACTIONBARALT\\NATURAL")
	button:SetHighlightTexture("INTERFACE\\PLAYERACTIONBARALT\\NATURAL")
	local nt = button:GetNormalTexture()
	local pu = button:GetPushedTexture()
	local hi = button:GetHighlightTexture()
	nt:SetTexCoord(0.0859375,0.1679688,0.359375,0.4414063)
	pu:SetTexCoord(0.001953125,0.08398438,0.359375,0.4414063)
	hi:SetTexCoord(0.6152344,0.6972656,0.359375,0.4414063)
	hi:SetBlendMode("ADD")

	LeaveButtonStyle(OverrideActionBarLeaveFrameLeaveButton, theme)
    LeaveButtonStyle(button, theme)
	
	RegisterStateDriver(button, "visibility", "[petbattle][overridebar][vehicleui] hide; [possessbar][@vehicle,exists] show; hide")
	RegisterStateDriver(barFrame, "visibility", "[petbattle][overridebar][vehicleui] hide; show")
end
local function SetOverrideBar(theme)
	local cfg = config.overridebar
	local barFrame = CreateFrame("Frame", "Moe_ActBar_Override", UIParent, "SecureHandlerStateTemplate")
	barFrame:SetWidth(num*cfg.size + (num+1)*cfg.spacing)
	barFrame:SetHeight(cfg.size + 2*cfg.spacing)
	barFrame:SetPoint(unpack(cfg.point))
	barFrame:SetScale(cfg.scale)

	--move the buttons into position and reparent them
	OverrideActionBar:SetParent(barFrame)
	OverrideActionBar:EnableMouse(false)
	OverrideActionBar:SetScript("OnShow", nil) --remove the onshow script

	local leaveButtonPlaced = false
	for i=1, num do
		local button =  _G["OverrideActionBarButton"..i]
		if not button and not leaveButtonPlaced then
			button = OverrideActionBar.LeaveButton --the magic 7th button
			leaveButtonPlaced = true
		end
		if not button then break end

		button:SetSize(cfg.size, cfg.size)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", barFrame, "BOTTOMLEFT", cfg.spacing, cfg.spacing)
		else
			local previous = _G["OverrideActionBarButton"..i-1]
			button:SetPoint("LEFT", previous, "RIGHT", cfg.spacing, 0)
		end
		ButtonStyle(button, theme)
	end

	--show/hide the frame on a given state driver
	RegisterStateDriver(barFrame, "visibility", "[petbattle] hide; [overridebar][vehicleui] show; hide")
	RegisterStateDriver(OverrideActionBar, "visibility", "[overridebar][vehicleui] show; hide")
end

local function SetMicroMenu()
	local buttonList = {
		CharacterMicroButton,
		SpellbookMicroButton,
		TalentMicroButton,
		AchievementMicroButton,
		QuestLogMicroButton,
		GuildMicroButton,
		LFDMicroButton,
		EJMicroButton,
        CollectionsMicroButton,
		MainMenuMicroButton,
		HelpMicroButton,
		StoreMicroButton,
        --CompanionsMicroButton,
        --PVPMicroButton,
	}
	local cfg = config.micromenu
	
	local NUM_MICROBUTTONS = #buttonList
	local buttonWidth = CharacterMicroButton:GetWidth()
	local buttonHeight = CharacterMicroButton:GetHeight()
	local gap = -3

	--create the frame to hold the buttons
	local menuFrame = CreateFrame("Frame", "Moe_MicroMenuBar", UIParent, "SecureHandlerStateTemplate")
	menuFrame:SetWidth(NUM_MICROBUTTONS * buttonWidth + (NUM_MICROBUTTONS - 1) * gap + 2 * cfg.spacing)
	menuFrame:SetHeight(buttonHeight + 2 * cfg.spacing)
	menuFrame:SetPoint(unpack(cfg.point))
	menuFrame:SetScale(cfg.scale)

	--move the buttons into position and reparent them
	for _, button in pairs(buttonList) do
		button:SetParent(menuFrame)
	end
	CharacterMicroButton:ClearAllPoints();
	CharacterMicroButton:SetPoint("LEFT", cfg.spacing, 0)
  
	--disable reanchoring of the micro menu by the petbattle ui
	PetBattleFrame.BottomFrame.MicroButtonFrame:SetScript("OnShow", nil) --remove the onshow script

	--show/hide the frame on a given state driver
	RegisterStateDriver(menuFrame, "visibility", "[petbattle] hide; show")
	if (cfg.hide) then Lib.BindHider(menuFrame) end
end
local function SetBagsBar()
	local buttonList = {
		MainMenuBarBackpackButton,
		CharacterBag0Slot,
		CharacterBag1Slot,
		CharacterBag2Slot,
		CharacterBag3Slot,
	}
	local cfg = config.bagbar
	
	local NUM_BAG_BUTTONS = #buttonList
	local buttonWidth = MainMenuBarBackpackButton:GetWidth()
	local buttonHeight = MainMenuBarBackpackButton:GetHeight()
	local gap = 2

	--create the frame to hold the buttons
	local bagFrame = CreateFrame("Frame", "Moe_BagsBar", UIParent, "SecureHandlerStateTemplate")
	bagFrame:SetWidth(NUM_BAG_BUTTONS*buttonWidth + (NUM_BAG_BUTTONS-1)*gap + 2*cfg.spacing)
	bagFrame:SetHeight(buttonHeight + 2*cfg.spacing)
	bagFrame:SetPoint(unpack(cfg.point))
	bagFrame:SetScale(cfg.scale)

	--move the buttons into position and reparent them
	for _, button in pairs(buttonList) do
		button:SetParent(bagFrame)
	end
	MainMenuBarBackpackButton:ClearAllPoints();
	MainMenuBarBackpackButton:SetPoint("RIGHT", -cfg.spacing, 0)
	
	RegisterStateDriver(bagFrame, "visibility", "[petbattle] hide; show")
	if cfg.hide then Lib.BindHider(bagFrame) end
end

local function CreateBarSwitch(theme)
	local switchEnter = theme.Enter or function(self) self:SetAlpha(1) end
	local switchLeave = theme.Leave or function(self) self:SetAlpha(.7) end
	local switchClick = function(self, button)
        if InCombatLockdown() then return end
		local bar = _G["Moe_ActBar_Main"]
		local bar2 = _G["Moe_ActBar_2"]
		local bar3 = _G["Moe_ActBar_3"] 
		local stance = _G["Moe_ActBar_Stance"] 
		local pet = _G["Moe_ActBar_Pet"] 
		if Lib.IsHide(bar) then 
			Lib.UnbindHider(bar, bar2, bar3)
            if self.enable then self:enable() end
		else 
			Lib.BindHider(bar, bar2, bar3) 
			if self.disable then self:disable() end
		end
	end
	
	local switch = Lib.CreatePanel({ 
		name = "BarSwitch", parent = "UIParent",
		texture = theme.texture,
		point = theme.point,
		level = 3, height = theme.height, width = theme.width,
		color = theme.color,
		script = { OnMouseUp = switchClick, OnEnter = switchEnter, OnLeave = switchLeave,}
	})
    switch.enable = theme.enable
    switch.disable = theme.disable
	if not theme.show then switch:Hide() end
    if theme.style then theme.style(switch) end
    
    if not config.showmainbar then switchClick(switch,"") end
end

local function Load()
    HideBLZ()
    local theme = Theme:Get("ActionBar")
    
    SetMicroMenu()
    SetBagsBar()
    
    SetMainBar(theme.Button)
    SetBar(MultiBarBottomLeft,  config.bar2, 2, theme.Button)
    SetBar(MultiBarBottomRight, config.bar3, 3, theme.Button)
    SetBar(MultiBarRight,       config.bar4, 4, theme.Button)
    SetBar(MultiBarLeft,        config.bar5, 5, theme.Button)
    
    SetPetBar(theme.Button)
    SetStanceBar(theme.Button)
    SetExtraBar(theme.Button)
    SetLeaveVehicle(theme.Button)
    SetOverrideBar(theme.Button)
    
    CreateBarSwitch(theme.Switch)
    
    if (theme.StyleBars) then theme.StyleBars() end
end

Modules:AddModule("ActionBar", Load, nil)




