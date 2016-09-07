local addon, namespace = ...
local Modules = namespace.Moe.Modules
local Media = namespace.Moe.Media
local Lib = namespace.Moe.Lib
local MM = Modules:Get("Monitor")

local IconStore = {}

local function ClearUp(frame)
	while #frame.Icons > 0 do 
		local icon = tremove(frame.Icons)
        icon:SetParent(UIParent)
		icon:Hide()
		tinsert(IconStore, icon)
	end
end
local function IconUpdate(self)
    local isUsable, notEnoughMana = IsUsableSpell(self.SpellID)
    local inrange = self.Slot and IsSpellInRange(self.Slot, "spell") or nil

    if (not isUsable) then self.Icon:SetVertexColor(.3,.3,.3)
    elseif inrange == 0 then self.Icon:SetVertexColor(1,.2,.2) 
    elseif notEnoughMana then self.Icon:SetVertexColor(.2,.2,1) 
    else self.Icon:SetVertexColor(1,1,1) end

    local count = GetSpellCount(self.SpellID)
    if count and count > 0 then
        self.Count:SetText(count)
    else
        self.Count:SetText(nil)
    end   

    local cooldown = self.Cooldown
    local charges, maxcharges, cstart, cduration = GetSpellCharges(self.SpellID)
    if not charges then
        cstart, cduration = GetSpellCooldown(self.SpellID)
        charges, maxcharges = 1, 1
        if cstart > 0 then charges = 0 end
    end
    if charges < maxcharges then
        cooldown:Show()
        CooldownFrame_Set(cooldown, cstart, cduration, 1)
    else
        cooldown:Hide()
    end
    if maxcharges > 1 then
        self.Count:SetText(charges)
    end
end
local function GetIcon(frame)
    local icon
	if #IconStore > 0 then 
		icon = tremove(IconStore)
		icon:SetParent(frame)
	else
		icon = Lib.CreateIcon(frame, frame.Set)
        icon.Update = IconUpdate
	end
	return icon
end
local function SetBarSize(frame, count)
    local Set = frame.Set
    local rowcount = math.ceil(count/Set.column)
    local colcount = count >= Set.column and Set.column or count
	frame:SetWidth(colcount * Set.size + (colcount - 1) * Set.spacing + Set.margin * 2)
	frame:SetHeight(rowcount * Set.size + (rowcount - 1) * Set.spacing + Set.margin * 2)
end

local Change = function(self, event)
    ClearUp(self)
    local spec = GetSpecialization()
    local SpellList = self.SpellList
    if spec and SpellList[spec] then
        local last, lastCol
        local index = 0
        for _, spell in next, SpellList[spec] do
            local isLearned, name, solt, texture = Lib.IsSpellLearned(spell.SpellID)
            if isLearned then
                local icon = GetIcon(self)
                icon.SpellID = spell.SpellID
                icon.Slot = solt
                icon.Icon:SetTexture(texture)
                
                if last and index % self.Set.column ~= 0 then
                    icon:SetPoint("LEFT", last, "RIGHT", self.Set.spacing, 0)
                elseif index == 0 then
                    icon:SetPoint("TOPLEFT", self, "TOPLEFT", self.Set.margin, -self.Set.margin)
                    lastCol = icon
                else
                    icon:SetPoint("TOPLEFT", lastCol, "BOTTOMLEFT", 0, -self.Set.spacing)
                    lastCol = icon
                end
                icon:Show()
                
                index = index + 1
                last = icon
                tinsert(self.Icons, icon)
            end
        end
        
        SetBarSize(self, index)
    else 
        self:disable()
    end
end
local Update = function(self)
    for _, icon in next, self.Icons do
        icon:Update()
    end
end
local FrequentUpdate = function(self, elapsed)
    self.timer = self.timer + elapsed
    if self.timer > self.Set.frequentUpdates then
        Update(self)
    end
end
local Event = function(self, event, ...)
    if event == "ACTIVE_TALENT_GROUP_CHANGED" or event == "CONFIRM_TALENT_WIPE" or
       event == "PLAYER_TALENT_UPDATE" or event == "UPDATE_SHAPESHIFT_FORM"
    then
        return (self.Change or Change)(self, event, ...)
    else
        return (self.Override or Update)(self, event, ...)
    end
end
local Enable = function(self)
    self:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
    self:RegisterEvent('CONFIRM_TALENT_WIPE')
    self:RegisterEvent('PLAYER_TALENT_UPDATE')
    self:RegisterEvent('UPDATE_SHAPESHIFT_FORM')
    
    if self.Set.frequentUpdates and self.Set.frequentUpdates > 0 then
        self.timer = 0
        self:SetScript("OnUpdate", FrequentUpdate)
    else
        self:RegisterEvent('SPELL_UPDATE_COOLDOWN')
        self:RegisterEvent('PLAYER_TARGET_CHANGED')
        self:RegisterEvent('SPELL_UPDATE_CHARGES')
        self:RegisterEvent('ACTIONBAR_UPDATE_USABLE')
        self:RegisterEvent('CURRENT_SPELL_CAST_CHANGED')
    end
    self:SetScript("OnEvent", Event)
    
    Change(self, 'ACTIVE_TALENT_GROUP_CHANGED')
end
local Disable = function(self)
    self:UnregisterEvent('SPELL_UPDATE_COOLDOWN')
    self:UnregisterEvent('PLAYER_TARGET_CHANGED')
    self:UnregisterEvent('SPELL_UPDATE_CHARGES')
    self:UnregisterEvent('CURRENT_SPELL_CAST_CHANGED')
    self:UnregisterEvent('ACTIONBAR_UPDATE_USABLE')
    
    if self.Set.frequentUpdates then
        self:SetScript("OnUpdate", nil)
    end
end

local Create = function(region, name, sets, spelllist)
    local CDBar = CreateFrame("Frame", name, region)
    CDBar:SetPoint(sets.anchor, region, sets.relative, sets.x, sets.y)
    
    CDBar.Icons = {}
    CDBar.SpellList = spelllist
    CDBar.Set = sets
    CDBar.enable = Enable
    CDBar.disable = Disable
    region[name] = CDBar
    return CDBar
end

MM:AddElement("Cooldown", Create)