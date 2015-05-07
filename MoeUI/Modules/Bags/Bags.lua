local addon, namespace = ...
local Lib = namespace.Moe.Lib
local Config = namespace.Moe.Config
local Media = namespace.Moe.Media
local Modules = namespace.Moe.Modules

local cfg = Config["Bag"]

local bagBackdrop = {
	bgFile = Media.Texture.Blank,
	edgeFile = Media.Texture.Glow,
	edgeSize = 2,
	insets = {left = 3, right = 3, top = 3, bottom = 3},
}
local ST = {
	BAG = "Bag",
	BANK = "Bank",
	REAGENT = "Reagent",
	UNKNOWN = "unknown",
}
local STNAME = {
	BAG = "MoeBag_"..ST.BAG,
	BANK = "MoeBag_"..ST.BANK,
	REAGENT = "MoeBag_"..ST.REAGENT,
}
local function itemIn(item)
	if (item.bagID >= 0 and item.bagID <= 4) then return BT.BAG
	elseif (item.bagID == -1 or item.bagID >= 5 and item.bagID <= 11) then return BT.BANK
	elseif (item.bagID == -3) then return BT.REAGENT
	else return BT.UNKNOWN end
end

local Boxes = {
	BagItemSearchBox,
	BankItemSearchBox,
}
local BlizzardBags = {
	CharacterBag0Slot,
	CharacterBag1Slot,
	CharacterBag2Slot,
	CharacterBag3Slot,
}
local BlizzardBank = {
	BankFrameBag1,
	BankFrameBag2,
	BankFrameBag3,
	BankFrameBag4,
	BankFrameBag5,
	BankFrameBag6,
	BankFrameBag7,
}

local function HideBLZ()
	local TokenFrame = _G["BackpackTokenFrame"]
	local Inset = _G["BankFrameMoneyFrameInset"]
	local Border = _G["BankFrameMoneyFrameBorder"]
	local BankClose = _G["BankFrameCloseButton"]
	local BankPortraitTexture = _G["BankPortraitTexture"]
	local BankSlotsFrame = _G["BankSlotsFrame"]

	TokenFrame:GetRegions():SetAlpha(0)
	Inset:Hide()
	Border:Hide()
	BankClose:Hide()
	BankPortraitTexture:Hide()
	Lib.Destroy(BagHelpBox)
	BankFrame:EnableMouse(false)
	BankFrame:DisableDrawLayer("BACKGROUND")
	BankFrame:DisableDrawLayer("BORDER")
	BankFrame:DisableDrawLayer("OVERLAY")

	for i = 1, 12 do
		local CloseButton = _G["ContainerFrame" .. i .. "CloseButton"]
		CloseButton:Hide()
		for k = 1, 7 do
			local Container = _G["ContainerFrame" .. i]
			select(k, Container:GetRegions()):SetAlpha(0)
		end
	end

	for i = 1, BankFrame:GetNumRegions() do
		local Region = select(i, BankFrame:GetRegions())
		Region:SetAlpha(0)
	end

	for i = 1, BankSlotsFrame:GetNumRegions() do
		local Region = select(i, BankSlotsFrame:GetRegions())
		Region:SetAlpha(0)
	end

	for i = 1, 2 do
		local Tab = _G["BankFrameTab" .. i]
		Tab:Hide()
	end
end
local function SetBorder(f)
	Lib.CreateShadow(f, 1, {0,0,0,.4}, {0,0,0,.8})
end
local function StripTextures(object, destroy)
	for i=1, object:GetNumRegions() do
		local region = select(i, object:GetRegions())
		if region:GetObjectType() == "Texture" then
			if destroy then Lib.Destroy(region) else region:SetTexture(nil) end
		end
	end
end
local function SkinButton(f)
	if f:GetName() then
		local l = _G[f:GetName().."Left"]
		local m = _G[f:GetName().."Middle"]
		local r = _G[f:GetName().."Right"]

		if l then l:SetAlpha(0) end
		if m then m:SetAlpha(0) end
		if r then r:SetAlpha(0) end
	end

	if f.Left then f.Left:SetAlpha(0) end
	if f.Right then f.Right:SetAlpha(0) end	
	if f.Middle then f.Middle:SetAlpha(0) end
	if f.SetNormalTexture then f:SetNormalTexture("") end
	if f.SetHighlightTexture then f:SetHighlightTexture("") end
	if f.SetPushedTexture then f:SetPushedTexture("") end
	if f.SetDisabledTexture then f:SetDisabledTexture("") end
	SetBorder(f)
end
local function SetInside(obj, anchor)
	anchor = anchor or obj:GetParent()
	if obj:GetPoint() then obj:ClearAllPoints() end
	obj:SetPoint("TOPLEFT", anchor, "TOPLEFT", 3, -3)
	obj:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", -3, 3)
end
local function SkinBagButton(Button)
	if Button.IsSkinned then return end

	local Icon = _G[Button:GetName()  ..  "IconTexture"]
	local Quest = _G[Button:GetName()  ..  "IconQuestTexture"]
	local JunkIcon = Button.JunkIcon
	local Border = Button.IconBorder
	local BattlePay = Button.BattlepayItemTexture

	Border:SetAlpha(0)

	Icon:SetTexCoord(.08, .92, .08, .92)
	SetInside(Icon,Button)
	if Quest then Quest:SetAlpha(0) end
	if JunkIcon then JunkIcon:SetAlpha(0) end
	if BattlePay then BattlePay:SetAlpha(0) end

	Button:SetNormalTexture("")
	Button:SetPushedTexture("")
	SetBorder(Button)
	Button:SetBackdropColor(0, 0, 0,0)
	Button.IsSkinned = true
end

local function CreateReagentContainer()
	StripTextures(ReagentBankFrame)
	local Reagent = CreateFrame("Frame", STNAME.REAGENT, UIParent)
	local SwitchBankButton = CreateFrame("Button", nil, Reagent)
	local SortButton = CreateFrame("Button", nil, Reagent)
	local NumButtons = ReagentBankFrame.size
	local NumRows, LastRowButton, NumButtons, LastButton = 0, ReagentBankFrameItem1, 1, ReagentBankFrameItem1
	local Deposit = ReagentBankFrame.DespositButton

	Reagent:SetWidth(((cfg.reagent.size + cfg.reagent.spacing) * cfg.reagent.column) + 22 - cfg.reagent.spacing)
	Reagent:SetPoint("LEFT", UIParent, "LEFT", 25, 0)
	SetBorder(Reagent)
	Reagent:SetFrameStrata(_G[STNAME.BANK]:GetFrameStrata())
	Reagent:SetFrameLevel(_G[STNAME.BANK]:GetFrameLevel())

	SwitchBankButton:SetSize(75, 23)
	SkinButton(SwitchBankButton)
	SwitchBankButton:SetPoint("BOTTOMLEFT", Reagent, "BOTTOMLEFT", 10, 7)
	Lib.CreateFontString(SwitchBankButton, {
		attrname = "Text", size = 15, outline = "THINOUTLINE", 
		anchor = "CENTER", x_off = 0, y_off = 0,
		textcolor = {1, 1, 1, 1},
		font = Media.Fonts.Default
	}):SetText(BANK)
	SwitchBankButton:SetScript("OnClick", function()
		Reagent:Hide()
		_G[STNAME.BANK]:Show()
		BankFrame_ShowPanel(BANK_PANELS[1].name)
		for i = 5, 11 do
			if (not IsBagOpen(i)) then OpenBag(i, 1) end
		end
	end)

	Deposit:SetParent(Reagent)
	Deposit:ClearAllPoints()
	Deposit:SetSize(120, 23)
	Deposit:SetPoint("BOTTOM", Reagent, "BOTTOM", 0, 7)
	SkinButton(Deposit)

	SortButton:SetSize(75, 23)
	SortButton:SetPoint("BOTTOMRIGHT", Reagent, "BOTTOMRIGHT", -10, 7)
	SkinButton(SortButton)
	Lib.CreateFontString(SortButton, {
		attrname = "Text", size = 15, outline = "THINOUTLINE", 
		anchor = "CENTER", x_off = 0, y_off = 0,
		textcolor = {1, 1, 1, 1},
		font = Media.Fonts.Default
	}):SetText(BAG_FILTER_CLEANUP)
	SortButton:SetScript("OnClick", BankFrame_AutoSortButtonOnClick)	

	for i = 1, 98 do
		local Button = _G["ReagentBankFrameItem" .. i]
		local Icon = _G[Button:GetName() .. "IconTexture"]

		ReagentBankFrame:SetParent(Reagent)
		ReagentBankFrame:ClearAllPoints()
		ReagentBankFrame:SetAllPoints()

		Button:ClearAllPoints()
		Button:SetSize(cfg.reagent.size, cfg.reagent.size)
		Button:SetNormalTexture("")
		Button:SetPushedTexture("")
		Button:SetHighlightTexture("")
		SetBorder(Button)
		Button:SetBackdropColor(0, 0, 0,0)
		Button.IconBorder:SetAlpha(0)


		if (i == 1) then
			Button:SetPoint("TOPLEFT", Reagent, "TOPLEFT", 10, -10)
			LastRowButton = Button
			LastButton = Button
		elseif (NumButtons == cfg.reagent.column) then
			Button:SetPoint("TOPRIGHT", LastRowButton, "TOPRIGHT", 0, -(cfg.reagent.spacing + cfg.reagent.size))
			Button:SetPoint("BOTTOMLEFT", LastRowButton, "BOTTOMLEFT", 0, -(cfg.reagent.spacing + cfg.reagent.size))
			LastRowButton = Button
			NumRows = NumRows + 1
			NumButtons = 1
		else
			Button:SetPoint("TOPRIGHT", LastButton, "TOPRIGHT", (cfg.reagent.spacing + cfg.reagent.size), 0)
			Button:SetPoint("BOTTOMLEFT", LastButton, "BOTTOMLEFT", (cfg.reagent.spacing + cfg.reagent.size), 0)
			NumButtons = NumButtons + 1
		end
		Icon:SetTexCoord(.08, .92, .08, .92)
		SetInside(Icon)
		LastButton = Button
	end
	Reagent:SetHeight(((cfg.reagent.size + cfg.reagent.spacing) * (NumRows + 1) + 50) - cfg.reagent.spacing)

	local Unlock = ReagentBankFrameUnlockInfo
	local UnlockButton = ReagentBankFrameUnlockInfoPurchaseButton
	StripTextures(Unlock)
	Unlock:SetAllPoints(Reagent)
	SetBorder(Unlock)
	Unlock:SetBackdropColor(0, 0, 0,0)
	SkinButton(UnlockButton)
end
local function CreateContainer(storeType, point)
	local Container = CreateFrame("Frame", "MoeBag_" .. storeType, UIParent)
	
	Container:SetScale(1)
	Container:SetPoint(unpack(point))
	Container:SetFrameStrata("HIGH")
	Container:SetFrameLevel(1)
	Container:Hide()
	Container:EnableMouse(true)
	Container:SetMovable(true)
	Container:SetUserPlaced(false)
	Container:SetClampedToScreen(false)
	Container:SetScript("OnMouseDown", function() Container:StartMoving() end)
	Container:SetScript("OnMouseUp", function() Container:StopMovingOrSizing() end)
	SetBorder(Container)
	
	if (storeType == ST.BAG) then
		Container:SetWidth(((cfg.bag.size + cfg.bag.spacing) * cfg.bag.column) + 22 - cfg.bag.spacing)
		local Sort = BagItemAutoSortButton
		local SortButton = CreateFrame("Button", nil, Container)
		local BagsContainer = CreateFrame("Frame", nil, UIParent)
		local ToggleBagsContainer = CreateFrame("Frame")

		BagsContainer:SetParent(Container)
		BagsContainer:SetWidth(10)
		BagsContainer:SetHeight(10)
		BagsContainer:SetPoint("BOTTOM", Container, "TOP", 0, 3)
		BagsContainer:Hide()
		SetBorder(BagsContainer)

		SortButton:SetSize(75, 23)
		SortButton:ClearAllPoints()
		SortButton:SetPoint("BOTTOMRIGHT", Container, "BOTTOMRIGHT", -10, 5)
		SortButton:SetFrameLevel(Container:GetFrameLevel() + 1)
		SortButton:SetFrameStrata(Container:GetFrameStrata())
		StripTextures(SortButton)
		SkinButton(SortButton)

		SortButton:SetScript('OnMouseDown', function(self, button) 
			if InCombatLockdown() then return end
			SortBags()
		end)
		Lib.CreateFontString(SortButton, {
			attrname = "Text", size = 15, outline = "THINOUTLINE", 
			anchor = "CENTER", x_off = 0, y_off = 0,
			textcolor = {1, 1, 1, 1},
			font = Media.Fonts.Default
		}):SetText(BAG_FILTER_CLEANUP)
		SortButton.ClearAllPoints = Lib.GetDummy()
		
		ToggleBagsContainer:SetHeight(BagItemSearchBox:GetHeight())
		ToggleBagsContainer:SetWidth(20)
		ToggleBagsContainer:SetPoint("TOPRIGHT", Container, "TOPRIGHT", -12, -6)
		ToggleBagsContainer:SetParent(Container)
		ToggleBagsContainer:EnableMouse(true)
		SkinButton(ToggleBagsContainer)
		ToggleBagsContainer.Text = ToggleBagsContainer:CreateFontString("button")
		ToggleBagsContainer.Text:SetPoint("CENTER", ToggleBagsContainer, "CENTER",0,0)
		ToggleBagsContainer.Text:SetFont(Media.Fonts.Default, 15)
		ToggleBagsContainer.Text:SetText("X")
		ToggleBagsContainer.Text:SetTextColor(.9, .9, .9)
		ToggleBagsContainer:SetScript("OnMouseUp", function(self, button)
			local Purchase = BankFramePurchaseInfo
			if (button == "RightButton") then
				local BanksContainer = _G[STNAME.BANK].BagsContainer
				local Purchase = BankFramePurchaseInfo
				local ReagentButton = _G[STNAME.BANK].ReagentButton
				if (ReplaceBags == 0) then
					ReplaceBags = 1
					BagsContainer:Show()
					BanksContainer:Show()
					BanksContainer:ClearAllPoints()
					ToggleBagsContainer.Text:SetTextColor(1, 1, 1)
					BanksContainer:SetPoint("BOTTOM", _G[STNAME.BANK], "TOP", 0, 2)
				else
					ReplaceBags = 0
					BagsContainer:Hide()
					BanksContainer:Hide()
					ToggleBagsContainer.Text:SetTextColor(.4, .4, .4)
				end
			else
				if BankFrame:IsShown() then
					CloseBankFrame()
				else
					ToggleAllBags()
				end
			end
		end)
		
		Container.BagsContainer = BagsContainer
		Container.CloseButton = ToggleBagsContainer
		Container.SortButton = Sort
	else
		Container:SetWidth(((cfg.bank.size + cfg.bank.spacing) * cfg.bank.column) + 22 - cfg.bank.spacing)
		local PurchaseButton = BankFramePurchaseButton
		local CostText = BankFrameSlotCost
		local TotalCost = BankFrameDetailMoneyFrame
		local Purchase = BankFramePurchaseInfo
		local BankBagsContainer = CreateFrame("Frame", nil, Container)

		CostText:ClearAllPoints()
		CostText:SetPoint("BOTTOMLEFT", 60, 10)
		TotalCost:ClearAllPoints()
		TotalCost:SetPoint("LEFT", CostText, "RIGHT", 0, 0)
		PurchaseButton:ClearAllPoints()
		PurchaseButton:SetPoint("BOTTOMRIGHT", -10, 10)
		SkinButton(PurchaseButton)
		BankItemAutoSortButton:Hide()

		local SwitchReagentButton = CreateFrame("Button", nil, Container)
		SwitchReagentButton:SetSize(75, 23)
		SkinButton(SwitchReagentButton)
		SwitchReagentButton:SetPoint("BOTTOMLEFT", Container, "BOTTOMLEFT", 10, 7)
		Lib.CreateFontString(SwitchReagentButton, {
			attrname = "Text", size = 15, outline = "THINOUTLINE", 
			anchor = "CENTER", x_off = 0, y_off = 0,
			textcolor = {1, 1, 1, 1},
			font = Media.Fonts.Default
		}):SetText(REAGENT_BANK)
		SwitchReagentButton:SetScript("OnClick", function()
			BankFrame_ShowPanel(BANK_PANELS[2].name)
			if (not ReagentBankFrame.isMade) then
				CreateReagentContainer()
				ReagentBankFrame.isMade = true
			else
				_G[STNAME.REAGENT]:Show()
			end
			for i = 5, 11 do CloseBag(i) end
		end)

		Purchase:ClearAllPoints()
		Purchase:SetWidth(Container:GetWidth() + 50)
		Purchase:SetHeight(70)
		Purchase:SetPoint("BOTTOMLEFT", SwitchReagentButton, "TOPLEFT", 0, -100)

		BankBagsContainer:SetSize(Container:GetWidth(), BankSlotsFrame.Bag1:GetHeight() + (cfg.bank.spacing * 2))
		SetBorder(BankBagsContainer)
		BankBagsContainer:SetPoint("BOTTOMLEFT", SwitchReagentButton, "TOPLEFT", 0, 2)
		BankBagsContainer:SetFrameLevel(Container:GetFrameLevel())
		BankBagsContainer:SetFrameStrata(Container:GetFrameStrata())

		for i = 1, 7 do
			local Bag = BankSlotsFrame["Bag" .. i]
			Bag:SetParent(BankBagsContainer)
			Bag:SetWidth(cfg.bank.size)
			Bag:SetHeight(cfg.bank.size)
			Bag.IconBorder:SetAlpha(0)
			Bag.icon:SetTexCoord(.08, .92, .08, .92)
			SetInside(Bag.icon)
--			SkinButton(Bag)
			Bag:ClearAllPoints()
			if i == 1 then 
				Bag:SetPoint("TOPLEFT", BankBagsContainer, "TOPLEFT", cfg.bank.spacing, -cfg.bank.spacing) 
			else 
				Bag:SetPoint("LEFT", BankSlotsFrame["Bag" .. i-1], "RIGHT", cfg.bank.spacing, 0) 
			end
		end

		BankBagsContainer:SetWidth((cfg.bank.size * 7) + (cfg.bank.spacing * (7 + 1)))
		BankBagsContainer:SetHeight(cfg.bank.size + (cfg.bank.spacing * 2))
		BankBagsContainer:Hide()

		BankFrame:EnableMouse(false)

		_G[STNAME.BANK].BagsContainer = BankBagsContainer
		_G[STNAME.BANK].ReagentButton = SwitchReagentButton
		Container.SortButton = SortButton
	end
end

local function SlotUpdate(id, Button)
	local ItemLink = GetContainerItemLink(id, Button:GetID())
	local _, _, Lock = GetContainerItemInfo(id, Button:GetID())
	local IsQuestItem = GetContainerItemQuestInfo(id, Button:GetID())

	if IsQuestItem then
		Button:SetBackdropBorderColor(1, 1, 0)
		return
	end
	
	if Button:GetID() ~= 0 then
		if ItemLink then
			local Name, _, Rarity, level, _, Type,t1,_,t2 = GetItemInfo(ItemLink)
			if Rarity and Rarity > 1 then
				Button:SetBackdropBorderColor(GetItemQualityColor(Rarity))
			else
				Button:SetBackdropBorderColor(0, 0, 0,.9)
			end
		else
			Button:SetBackdropColor(0, 0, 0,0)
			Button:SetBackdropBorderColor(0, 0, 0,.9)
		end
	end
end
local function BagUpdate(id)
	local size = GetContainerNumSlots(id)
	for slotindex = 1, size do
		local Button = _G["ContainerFrame" .. (id + 1) .. "Item" .. slotindex]
		SlotUpdate(id, Button)
	end
end
local function UpdateAllBags()
	local NumRows, LastRowButton, NumButtons, LastButton = 0, ContainerFrame1Item1, 1, ContainerFrame1Item1
	local bagFrame = _G[STNAME.BAG]
	for Bag = 1, 5 do
		local ID = Bag - 1
		local Slots = GetContainerNumSlots(ID)
		for Item = Slots, 1, -1 do
			local Button = _G["ContainerFrame"  ..  Bag  ..  "Item"  ..  Item]
			local Money = ContainerFrame1MoneyFrame

			Button:ClearAllPoints()
			Button:SetSize(cfg.bag.size, cfg.bag.size)
			Button:SetScale(1)
			Button:SetFrameStrata("HIGH")
			Button:SetFrameLevel(2)

			Money:ClearAllPoints()
			Money:Show()
			Money:SetPoint("BOTTOMLEFT", bagFrame, "BOTTOMLEFT", 25, 7)
			Money:SetFrameStrata("HIGH")
			Money:SetFrameLevel(2)
			Money:SetScale(1)
			if (Bag == 1 and Item == 16) then
				Button:SetPoint("TOPLEFT", bagFrame, "TOPLEFT", 10, -25)
				LastRowButton = Button
				LastButton = Button
			elseif (NumButtons == cfg.bag.column) then
				Button:SetPoint("TOPRIGHT", LastRowButton, "TOPRIGHT", 0, -(cfg.bag.spacing + cfg.bag.size))
				Button:SetPoint("BOTTOMLEFT", LastRowButton, "BOTTOMLEFT", 0, -(cfg.bag.spacing + cfg.bag.size))
				LastRowButton = Button
				NumRows = NumRows + 1
				NumButtons = 1
			else
				Button:SetPoint("TOPRIGHT", LastButton, "TOPRIGHT", (cfg.bag.spacing + cfg.bag.size), 0)
				Button:SetPoint("BOTTOMLEFT", LastButton, "BOTTOMLEFT", (cfg.bag.spacing + cfg.bag.size), 0)
				NumButtons = NumButtons + 1
			end
			SkinBagButton(Button)
			LastButton = Button
		end
		BagUpdate(ID)
	end
	bagFrame:SetHeight(((cfg.bag.size + cfg.bag.spacing) * (NumRows + 1) + 75) - cfg.bag.spacing)
end
local function UpdateAllBankBags()
	local NumRows, LastRowButton, NumButtons, LastButton = 0, ContainerFrame1Item1, 1, ContainerFrame1Item1
	local bankFrame = _G[STNAME.BANK]
	for Bank = 1, 28 do
		local Button = _G["BankFrameItem" .. Bank]
		Button:ClearAllPoints()
		Button:SetSize(cfg.bank.size, cfg.bank.size)
		Button:SetFrameStrata("HIGH")
		Button:SetFrameLevel(2)
		Button.IconBorder:SetAlpha(0)

		BankFrameMoneyFrame:Hide()
		if (Bank == 1) then
			Button:SetPoint("TOPLEFT", bankFrame, "TOPLEFT", 10, -10)
			LastRowButton = Button
			LastButton = Button
		elseif (NumButtons == cfg.bank.column) then
			Button:SetPoint("TOPRIGHT", LastRowButton, "TOPRIGHT", 0, -(cfg.bank.spacing + cfg.bank.size))
			Button:SetPoint("BOTTOMLEFT", LastRowButton, "BOTTOMLEFT", 0, -(cfg.bank.spacing + cfg.bank.size))
			LastRowButton = Button
			NumRows = NumRows + 1
			NumButtons = 1
		else
			Button:SetPoint("TOPRIGHT", LastButton, "TOPRIGHT", (cfg.bank.spacing + cfg.bank.size), 0)
			Button:SetPoint("BOTTOMLEFT", LastButton, "BOTTOMLEFT", (cfg.bank.spacing + cfg.bank.size), 0)
			NumButtons = NumButtons + 1
		end
		SkinBagButton(Button)
		SlotUpdate(-1, Button)
		LastButton = Button
	end

	for Bag = 6, 12 do
		local ID = Bag - 1
		local Slots = GetContainerNumSlots(ID)
		for Item = Slots, 1, -1 do
			local Button = _G["ContainerFrame"  ..  Bag  ..  "Item" .. Item]
			Button:ClearAllPoints()
			Button:SetWidth(cfg.bank.size, cfg.bank.size)
			Button:SetFrameStrata("HIGH")
			Button:SetFrameLevel(2)
			Button.IconBorder:SetAlpha(0)
			if i==2 then Text(Button) end
			
			if (NumButtons == cfg.bank.column) then
				Button:SetPoint("TOPRIGHT", LastRowButton, "TOPRIGHT", 0, -(cfg.bank.spacing + cfg.bank.size))
				Button:SetPoint("BOTTOMLEFT", LastRowButton, "BOTTOMLEFT", 0, -(cfg.bank.spacing + cfg.bank.size))
				LastRowButton = Button
				NumRows = NumRows + 1
				NumButtons = 1
			else
				Button:SetPoint("TOPRIGHT", LastButton, "TOPRIGHT", (cfg.bank.spacing+cfg.bank.size), 0)
				Button:SetPoint("BOTTOMLEFT", LastButton, "BOTTOMLEFT", (cfg.bank.spacing+cfg.bank.size), 0)
				NumButtons = NumButtons + 1
			end
			SkinBagButton(Button)
			LastButton = Button
		end
		BagUpdate(ID)
	end
	
	bankFrame:SetHeight(((cfg.bank.size + cfg.bank.spacing) * (NumRows + 1) + 50) - cfg.bank.spacing)
end

local Currency = {
	[1] = 392, --Honor Points荣誉
	[2] = 390, --Conquest Points征服
	[3] = 994, --Seal of Tempered Fate钢化命运印记
	[4] = 824, --Garrison Resources要塞资源
	[5] = 823, --Apexis Crystal埃匹希斯水晶
	[6] = 738, --Lesser Charm of Good Fortune
	[7] = 980, --Dingy Iron Coins肮脏的铁币
	[8] = 944, --Artifact Fragment神器碎片
	[9] = 810, --Black Iron Fragment黑铁碎片
	[10] = 776, --Warforged Seal战火铸币
	[11] = 789, --Bloody Coin染血的铸币
	[12] = 241, --Champion's Seal冠军的印记
	[13] = 402, --Ironpaw Token铁掌印记
	[14] = 416, --Mark of the World Tree世界之树的印记
	[15] = 777, --Timeless Coin永恒铸币
	[16] = 391, --Tol Barad Commendation托尔巴拉德奖章
	[17] = 515, --Darkmoon Prize Ticket暗月票
}
local CurrencyN = 7 --显示的货币数量 the amount of currencies to display
local function CreateCurrencyBar()
	local Frame={}
	local Text={}
	local bagFrame = _G[STNAME.BAG]
	function Icon(f,i)
		f:SetBackdrop({
			bgFile = select(3,GetCurrencyInfo(Currency[i])),
			edgeFile = 'Interface\\Buttons\\WHITE8x8', edgeSize = 1, insets = {left = 0, right = 0, top = 0, bottom = 0}
		})
		f:SetBackdropColor(1, 1, 1, 1)
		f:SetBackdropBorderColor(0, 0, 0, 1)
	end
	
	for i =1, CurrencyN do 
		Frame[i] = CreateFrame("frame", nil, bagFrame)
		Icon(Frame[i],i)
		Frame[i]:SetWidth(14)
		Frame[i]:SetHeight(14)
		if i == 1 then
			Frame[i]:SetPoint("BOTTOMRIGHT",bagFrame,"BOTTOMLEFT", 35, 30)
		else
			Frame[i]:SetPoint("BOTTOMLEFT",Text[i-1],"BOTTOMRIGHT" ,10, 0)
		end
		Text[i] = bagFrame:CreateFontString(nil,"OVERLAY","NumberFontNormalSmall");
		Text[i]:SetPoint("BOTTOMLEFT",Frame[i],"BOTTOMRIGHT" ,10, 0);
		Text[i]:SetTextColor(1,1,1,1);
		Text[i]:SetFont(Media.Fonts.Default, 14, "THINOUTLINE")
		
		Text[i]:SetText(select(2,GetCurrencyInfo(Currency[i])))
	end
	
	bagFrame.UpdateCurrency = function()
		for i = 1, CurrencyN do
			Text[i]:SetText(select(2,GetCurrencyInfo(Currency[i])))
		end
	end
end

local function SetBagsSearchPosition()
	local BagItemSearchBox = BagItemSearchBox
	local BankItemSearchBox = BankItemSearchBox

	BagItemSearchBox:SetParent(_G[STNAME.BAG])
	BagItemSearchBox:SetFrameLevel(_G[STNAME.BAG]:GetFrameLevel() + 2)
	BagItemSearchBox:SetFrameStrata(_G[STNAME.BAG]:GetFrameStrata())
	BagItemSearchBox:ClearAllPoints()
	BagItemSearchBox:SetPoint("TOPRIGHT", _G[STNAME.BAG], "TOPRIGHT", -40, -4)
	StripTextures(BagItemSearchBox)
	SetBorder(BagItemSearchBox)
	BagItemSearchBox:SetBackdropColor(0, 0, 0,0)
	BagItemSearchBox.SetParent = Lib.GetDummy()
	BagItemSearchBox.ClearAllPoints = Lib.GetDummy()
	BagItemSearchBox.SetPoint = Lib.GetDummy()
	BankItemSearchBox:Hide()
end
local function OpenBag(id, IsBank)
	if (not CanOpenPanels()) then
		if (UnitIsDead("player")) then NotWhileDeadError() end
		return
	end

	local SetSize = GetContainerNumSlots(id)
	local OpenFrame = ContainerFrame_GetOpenFrame()

	if OpenFrame.size and OpenFrame.size ~= SetSize then
		for i = 1, OpenFrame.size do
			local Button = _G[OpenFrame:GetName() .. "Item" .. i]
			Button:Hide()
		end
	end

	for i = 1, SetSize, 1 do
		local Index = SetSize - i + 1
		local Button = _G[OpenFrame:GetName() .. "Item" .. i]
		Button:SetID(Index)
		Button:Show()
	end
	OpenFrame.size = SetSize
	OpenFrame:SetID(id)
	OpenFrame:Show()

	if (id == 4 ) then UpdateAllBags()   elseif (id == 11) then UpdateAllBankBags()  end
end
local function F_ToggleAllBags()
	if ContainerFrame1:IsShown() then
		if not BankFrame:IsShown() then
			_G[STNAME.BAG]:Hide()
			CloseBag(0)
			for i = 1, 4 do CloseBag(i) end
		end
	else
		_G[STNAME.BAG]:Show()
		OpenBag(0, 1)
		for i = 1, 4 do OpenBag(i, 1) end
	end

	if BankFrame:IsShown() and not ReagentBankFrame:IsShown() then
		_G[STNAME.BANK]:Show()
		
		for i = 5, 11 do
			if i < 3 then i = i + 1 end
			if not IsBagOpen(i) then OpenBag(i, 1) end
		end
	else
		_G[STNAME.BANK]:Hide()
		for i = 5, 11 do CloseBag(i) end
	end
end

local function ReplaceBLZToggle()
	UpdateContainerFrameAnchors = Lib.GetDummy()
    ToggleAllBags   = F_ToggleAllBags
	ToggleBag 		= F_ToggleAllBags
	ToggleBackpack 	= F_ToggleAllBags
	OpenAllBags 	= F_ToggleAllBags
	OpenBackpack 	= F_ToggleAllBags
end
local function Init()
	HideBLZ()

	ContainerFrame1Item1:SetScript("OnHide", function()
		_G[STNAME.BAG]:Hide()
		if _G[STNAME.REAGENT] and _G[STNAME.REAGENT]:IsShown() then
			_G[STNAME.REAGENT]:Hide()
		end
	end)
	BankFrameItem1:SetScript("OnHide", function() _G[STNAME.BANK]:Hide() end)
	BankFrameItem1:SetScript("OnShow", function() _G[STNAME.BANK]:Show() end)
	
	CreateContainer(ST.BAG, {"BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 200}) 
	CreateContainer(ST.BANK, {"LEFT", UIParent, "LEFT", 25, 0})
	
	SetBagsSearchPosition()
    
    Lib.NewTrigger("MoeBag",{
        Events = {"BAG_UPDATE","PLAYERBANKSLOTS_CHANGED","CURRENCY_DISPLAY_UPDATE"},
        Script = function(self, event, ...)
            if event == "BAG_UPDATE" then BagUpdate(...)
            elseif event == "PLAYERBANKSLOTS_CHANGED" then
                local ID = ...
                if ID <= 28 then
                    local Button = _G["BankFrameItem" .. ID]
                    SlotUpdate(-1, Button)
                else
                    CloseBankFrame()
                end
            elseif event == "CURRENCY_DISPLAY_UPDATE" then
                _G[STNAME.BAG].UpdateCurrency()
            end
        end,
    })
end

Modules:AddModule("Bags", function() 
    Init()
    ReplaceBLZToggle()
    CreateCurrencyBar()
end, nil)
