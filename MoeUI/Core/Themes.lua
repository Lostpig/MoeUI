local addon, namespace = ...
local Lib = namespace.Moe.Lib
local Media = namespace.Moe.Media
local Modules = namespace.Moe.Modules
local Config = namespace.Moe.Config
local Theme = namespace.Moe.Theme

local themeList = {}

Theme.New = function(self, name, logo) 
    if themeList[name] then return Lib.Error("Theme [%s]已存在", name) end
    themeList[name] = {}
    if logo then themeList[name].Logo = logo end
end
Theme.Register = function(self, name, module, theme)
    if not themeList[name] then themeList[name] = {} end
    if themeList[name][module] then return Lib.Error("Theme [%s]的Module [%s]已注册", name, module) end
    themeList[name][module] = theme
end
Theme.Active = function(self, name)
    if not themeList[name] then return Lib.Error("Theme [%s]不存在", name) end
    
    if themeList[name].GUI.StyleAddons then themeList[name].GUI.StyleAddons() end
    MoeDB["Theme"] = name
end
Theme.Get = function(self, module)
    local name = MoeDB["Theme"]
    if not themeList[name] then return Lib.Error("激活的Theme [%s] 不存在,请重置", name) end
    if not themeList[name][module] then return Lib.Error("激活的Theme [%s] 中不存在Module [%s]", name, module) end
    return themeList[name][module]
end
Theme.Init = function(self)
    if not MoeDB["Theme"] or not themeList[MoeDB["Theme"]] then 
        StaticPopup_Show("INITTHEME_RELOADUI")
        return false
    end
    return true
end

StaticPopupDialogs["APPLYTHEME_RELOADUI"] = {
	text = "加载主题需要重载插件，是否立即重载?",
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		ReloadUI()
	end,
}
StaticPopupDialogs["INITTHEME_RELOADUI"] = {
	text = "没有启用任何主题,MoeUI未加载\r\n是否重载插件启用默认主题？",
	button1 = YES,
	button2 = NO,
	OnAccept = function()
        Theme:Active("Default") 
		ReloadUI()
	end,
}
local ThemePanel
local function ApplyTheme(self)
    local tid = self:GetParent().ThemeID
    if themeList[tid] then 
        Theme:Active(tid) 
        StaticPopup_Show("APPLYTHEME_RELOADUI")
    end
end
local function CreateThemeItem(index)
    local Item = CreateFrame("Frame", nil, ThemePanel)
    Item:SetHeight(140)
    Item:SetWidth(640)
    --Lib.CreateBorder(Item, 1, {0,0,0,0}, {1,0,0,1})
    
    Item.Name = Lib.EasyFontString(Item, Media.Fonts.Default, 14, "THINOUTLINE")
    Item.Name:SetWidth(500)
    Item.Name:SetHeight(15)
    Item.Name:SetPoint("TOPLEFT", 25, -5)
    Item.Name:SetJustifyH("LEFT")
    
    Item.Button = CreateFrame("Button", nil, Item)
    Item.Button:SetHeight(24)
    Item.Button:SetWidth(90)
    Item.Button:SetPoint("RIGHT",-10,0)
    Item.Button.text = Lib.EasyFontString(Item.Button, Media.Fonts.Default, 14, "THINOUTLINE")
    Item.Button.text:SetPoint("CENTER",0,0)
    Item.Button.text:SetText("启用")
    Item.Button:SetScript("OnEnter", function(self) self.text:SetTextColor(1,1,0) end)
    Item.Button:SetScript("OnLeave", function(self) self.text:SetTextColor(1,1,1) end)
    Item.Button:SetScript("OnClick", ApplyTheme)
    
    Lib.CreateBorder(Item.Button, 1, {0,0,0,0}, {0,0,0,1})
    
    Item.Logo = CreateFrame("Frame", nil, Item)
    Item.Logo:SetHeight(100)
    Item.Logo:SetWidth(400)
    Item.Logo:SetPoint("TOPLEFT", 25, -30)
    Item.Logo.bg = Item.Logo:CreateTexture(nil, "ARTWORK")
    Item.Logo.bg:SetAllPoints()
    Lib.CreateBorder(Item.Logo, 1, {0,0,0,0}, {0,0,0,1})
    
    Item.ShowTheme = function(self, name, theme)
        if theme.Logo then self.Logo.bg:SetTexture(theme.Logo) 
        else self.Logo.bg:SetTexture(nil) end
        self.ThemeID = name
        
        if name == MoeDB["Theme"] then 
            self.Name:SetText(format("|cffffff00%s (已启用)|r", name))
            self.Button:Hide()
        else
            self.Name:SetText(format("%s", name))
            self.Button:Show()
        end
    end
    
    Item:SetPoint("TOPLEFT", 40, (index - 1) * -160 - 30)
    return Item
end
local function UpdateItems(self)
    local i = 1
    for k, v in pairs(themeList) do
        if i >= self.Index then
            local ii = i - self.Index + 1
            if ii <= 3 then
                if not self.Items[ii] then self.Items[ii] = CreateThemeItem(ii) end
                self.Items[ii]:ShowTheme(k, v)
            end
        end
        i = i + 1
    end
    if i - self.Index > 3 then self.Next:Show() else self.Next:Hide() end
    if self.Index > 1 then self.Prev:Show() else self.Prev:Hide() end
end
local function OnEnter(self)
    self.bg:SetVertexColor(.9,.9,.1)
end
local function OnLeave(self)
    self.bg:SetVertexColor(.7,.7,.7)
end
local function ToPrve(self)
    local tp = self:GetParent()
    tp.Index = tp.Index - 1
    UpdateItems(tp)
end
local function ToNext(self)
    local tp = self:GetParent()
    tp.Index = tp.Index + 1
    UpdateItems(tp)
end
local function ClosePanel(self)
    self:GetParent():Hide()
end
local function CreateThemePanel() 
    ThemePanel = CreateFrame("Frame", "MoeThemePanel")
    ThemePanel:SetHeight(540)
    ThemePanel:SetWidth(720)
    ThemePanel:SetPoint("CENTER", UIParent, "CENTER", 0, 50)
    ThemePanel:SetFrameStrata("HIGH")
    Lib.CreateShadow(ThemePanel,2,{.3,.3,.3,.7},{0,0,0,1})
    
    ThemePanel.Items = {}
    ThemePanel:SetScript("OnShow",UpdateItems)
    
    ThemePanel.Prev = CreateFrame("Button", nil, ThemePanel)
    ThemePanel.Prev.bg = ThemePanel.Prev:CreateTexture(nil,"ARTWORK")
    ThemePanel.Prev.bg:SetTexture(Media.Texture.Arrow)
    ThemePanel.Prev.bg:SetVertexColor(.7,.7,.7)
    ThemePanel.Prev.bg:SetAllPoints()
    ThemePanel.Prev:SetSize(120, 16)
    ThemePanel.Prev:SetPoint("TOP",0,-3)
    ThemePanel.Prev:SetScript("OnEnter", OnEnter)
    ThemePanel.Prev:SetScript("OnLeave", OnLeave)
    ThemePanel.Prev:SetScript("OnClick", ToPrve)
    Lib.CreateBorder(ThemePanel.Prev, 1, {0,0,0,0}, {0,0,0,1})

    ThemePanel.Next = CreateFrame("Button", nil, ThemePanel)
    ThemePanel.Next.bg = ThemePanel.Next:CreateTexture(nil,"ARTWORK")
    ThemePanel.Next.bg:SetAllPoints()
    ThemePanel.Next.bg:SetTexture(Media.Texture.Arrow)
    ThemePanel.Next.bg:SetVertexColor(.7,.7,.7)
    Lib.Flip(ThemePanel.Next.bg, "VERTICAL")
    ThemePanel.Next:SetSize(120, 16)
    ThemePanel.Next:SetPoint("BOTTOM",0,3)
    ThemePanel.Next:SetScript("OnEnter", OnEnter)
    ThemePanel.Next:SetScript("OnLeave", OnLeave)
    ThemePanel.Next:SetScript("OnClick", ToNext)
    Lib.CreateBorder(ThemePanel.Next, 1, {0,0,0,0}, {0,0,0,1})

    
    ThemePanel.Close = CreateFrame("Button", nil, ThemePanel)
    ThemePanel.Close:SetHeight(20)
    ThemePanel.Close:SetWidth(20)
    ThemePanel.Close:SetPoint("TOPRIGHT",0,0)
    ThemePanel.Close.text = Lib.EasyFontString(ThemePanel.Close, Media.Fonts.Default, 14, "THINOUTLINE")
    ThemePanel.Close.text:SetPoint("CENTER", 0, 0)
    ThemePanel.Close.text:SetText("X")
    ThemePanel.Close:SetScript("OnEnter", function(self) self.text:SetTextColor(1,0,0) end)
    ThemePanel.Close:SetScript("OnLeave", function(self) self.text:SetTextColor(1,1,1) end)
    ThemePanel.Close:SetScript("OnClick", ClosePanel)
    Lib.CreateBorder(ThemePanel.Close, 1, {0,0,0,0}, {0,0,0,1})
    ThemePanel:Hide()
end
local function ShowThemePanel()
    if not ThemePanel then CreateThemePanel() end
    ThemePanel.Index = 1
    ThemePanel:Show()
end

Theme.ShowOption = ShowThemePanel