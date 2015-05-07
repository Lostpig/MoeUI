local addon, namespace = ...
local Media = namespace.Moe.Media
local Modules = namespace.Moe.Modules
local Lib = namespace.Moe.Lib
local cfg = namespace.Moe.Config["Tip"]

local classification = {
    elite = "+",
    rare = " R",
    rareelite = " R+",
}

local find = string.find
local format = string.format
local hex = function(color)
    return format('|cff%02x%02x%02x', color.r * 255, color.g * 255, color.b * 255)
end

local function unitColor(unit)
    local color = { r=1, g=1, b=1 }
    if UnitIsPlayer(unit) then
        local _, class = UnitClass(unit)
        color = RAID_CLASS_COLORS[class]
        return color
    else
        local reaction = UnitReaction(unit, "player")
        if reaction then
            color = FACTION_BAR_COLORS[reaction]
            return color
        end
    end
    return color
end
local function GameTooltip_UnitColor(unit)
    local color = unitColor(unit)
    return color.r, color.g, color.b
end
local function getTarget(unit)
    if UnitIsUnit(unit, "player") then
        return ("|cffff0000%s|r"):format(cfg.you)
    else
        return hex(unitColor(unit))..UnitName(unit).."|r"
    end
end

local numberize = function(val)
    if (val >= 1e6) then
        return ("%.1fm"):format(val / 1e6)
    elseif (val >= 1e3) then
        return ("%.1fk"):format(val / 1e3)
    else
        return ("%d"):format(val)
    end
end
local TipSetUnit = function(self)
    local name, unit = self:GetUnit()

    if unit then
        if cfg.combathide and InCombatLockdown() then
            return self:Hide()
        end

        local color = unitColor(unit)
        local textleft1 = GameTooltipTextLeft1:GetText()
        GameTooltipTextLeft1:SetText(hex(color)..textleft1.."|r")
        
        local ricon = GetRaidTargetIndex(unit)

        if ricon then
            local text = GameTooltipTextLeft1:GetText()
            GameTooltipTextLeft1:SetText(("%s %s"):format(ICON_LIST[ricon].."18|t", text))
        end

        if UnitIsPlayer(unit) then
            self:AppendText((" |cff00cc00%s|r"):format(UnitIsAFK(unit) and CHAT_FLAG_AFK or 
            UnitIsDND(unit) and CHAT_FLAG_DND or 
            not UnitIsConnected(unit) and "<DC>" or ""))

            if cfg.hideTitles then
                local title = UnitPVPName(unit)
                if title then
                    local text = GameTooltipTextLeft1:GetText()
                    title = title:gsub(name, "")
                    text = text:gsub(title, "")
                    if text then GameTooltipTextLeft1:SetText(text) end
                end
            end

            if cfg.hideRealm then
                local _, realm = UnitName(unit)
                if realm then
                    local text = GameTooltipTextLeft1:GetText()
                    text = text:gsub("- "..realm, "")
                    if text then GameTooltipTextLeft1:SetText(text) end
                end
            end

            local unitGuild = GetGuildInfo(unit)
            local text2 = GameTooltipTextLeft2:GetText()
            if unitGuild and text2 and text2:find("^"..unitGuild) then	
                GameTooltipTextLeft2:SetTextColor(cfg.gcolor.r, cfg.gcolor.g, cfg.gcolor.b)
            end
        end


        local alive = not UnitIsDeadOrGhost(unit)
        local level = UnitLevel(unit)

        if level then
            local unitClass = UnitIsPlayer(unit) and hex(color)..UnitClass(unit).."|r" or ""
            local creature = not UnitIsPlayer(unit) and UnitCreatureType(unit) or ""
            local diff = GetQuestDifficultyColor(level)

            if level == -1 then
                level = "|cffff0000"..cfg.boss
            end

            local classify = UnitClassification(unit)
            local textLevel = ("%s%s%s|r"):format(hex(diff), tostring(level), classification[classify] or "")

            for i=2, self:NumLines() do
                local tiptext = _G["GameTooltipTextLeft"..i]
                if tiptext:GetText():find(LEVEL) then
                    if alive then
                        tiptext:SetText(("%s %s%s %s"):format(textLevel, creature, UnitRace(unit) or "", unitClass):trim())
                    else
                        tiptext:SetText(("%s %s"):format(textLevel, "|cffCCCCCC"..DEAD.."|r"):trim())
                    end
                end

                if tiptext:GetText():find(PVP) then
                    tiptext:SetText(nil)
                end
            end
        end

        if not alive then
            GameTooltipStatusBar:Hide()
        end

        if UnitExists(unit.."target") then
            local tartext = ("%s: %s"):format(TARGET, getTarget(unit.."target"))
            self:AddLine(tartext)
        end

        GameTooltipStatusBar:SetStatusBarColor(color.r, color.g, color.b)
    else
        for i=2, self:NumLines() do
            local tiptext = _G["GameTooltipTextLeft"..i]

            if tiptext:GetText():find(PVP) then
                tiptext:SetText(nil)
            end
        end

        GameTooltipStatusBar:SetStatusBarColor(0, .9, 0)
    end

    if GameTooltipStatusBar:IsShown() then
        self:AddLine(" ")
        GameTooltipStatusBar:ClearAllPoints()
        GameTooltipStatusBar:SetPoint("TOPLEFT", self:GetName().."TextLeft"..self:NumLines(), "TOPLEFT", 0, -4)
        GameTooltipStatusBar:SetPoint("TOPRIGHT", self, -10, 0)
    end
end
local TipChangeValue = function(self, value)
    if not value then
        return
    end
    local min, max = self:GetMinMaxValues()
    if (value < min) or (value > max) then
        return
    end
    local _, unit = GameTooltip:GetUnit()
    if unit then
        min, max = UnitHealth(unit), UnitHealthMax(unit)
        if not self.text then
            self.text = self:CreateFontString(nil, "OVERLAY")
            self.text:SetPoint("CENTER", GameTooltipStatusBar)
            self.text:SetFont(cfg.font, 12, cfg.outline)
        end
        self.text:Show()
        local hp = numberize(min).." / "..numberize(max)
        self.text:SetText(hp)
    end
end
local TipSetAnchor = function(tooltip, parent)
    local frame = GetMouseFocus()
    if cfg.cursor and frame == WorldFrame then
        tooltip:SetOwner(parent, "ANCHOR_CURSOR")
    else
		 tooltip:SetPoint(cfg.point[1], UIParent, cfg.point[2], cfg.point[3], cfg.point[4])
    end
    tooltip.default = 1
end

local function setBakdrop(frame)
    frame:SetBackdrop(nil)
    Lib.CreateShadow(frame, 1, {.05,.05,.05,.7}, {0,0,0,.9}, 2)
    frame:SetScale(cfg.scale)

    frame.freebBak = true
end

local function style(frame)
    if not frame.freebBak then
        setBakdrop(frame)
    end

    --frame:SetBackdropColor(cfg.bgcolor.r, cfg.bgcolor.g, cfg.bgcolor.b, cfg.bgcolor.t)
    --frame:SetBackdropBorderColor(cfg.bdrcolor.r, cfg.bdrcolor.g, cfg.bdrcolor.b)

    if frame.GetItem then
        local _, item = frame:GetItem()
        if item then
            local quality = select(3, GetItemInfo(item))
            if(quality) then
                local r, g, b = GetItemQualityColor(quality)
                frame:SetBackdropBorderColor(r, g, b)
            end
        else
            frame:SetBackdropBorderColor(cfg.bdrcolor.r, cfg.bdrcolor.g, cfg.bdrcolor.b)
        end
    end

    if cfg.colorborderClass then
        local _, unit = GameTooltip:GetUnit()
        if UnitIsPlayer(unit) then
            frame:SetBackdropBorderColor(GameTooltip_UnitColor(unit))
        end
    end

    if frame.NumLines then
        for index=1, frame:NumLines() do
            if index == 1 then
                _G[frame:GetName()..'TextLeft'..index]:SetFont(cfg.font, cfg.fontsize+2, cfg.outline)
            else
                _G[frame:GetName()..'TextLeft'..index]:SetFont(cfg.font, cfg.fontsize, cfg.outline)
            end
            _G[frame:GetName()..'TextRight'..index]:SetFont(cfg.font, cfg.fontsize, cfg.outline)
        end
    end
end

local tooltips = {
    GameTooltip,
    ItemRefTooltip,
    ShoppingTooltip1,
    ShoppingTooltip2, 
    ShoppingTooltip3,
    WorldMapTooltip,
    DropDownList1MenuBackdrop, 
    DropDownList2MenuBackdrop,
}
local itemrefScripts = {
    "OnTooltipSetItem",
    "OnTooltipSetAchievement",
    "OnTooltipSetQuest",
    "OnTooltipSetSpell",
}

local COLOR_TANK = "E06D1B";
local COLOR_HEAL = "1B70E0";
local COLOR_DPS  = "E01B35";
local COLOR_NONE = "B5B5B5";

local function GetLFDRole(unit)
   local role = UnitGroupRolesAssigned(unit);
   
   if(role == "NONE") then
      return "|cFF" .. COLOR_NONE .. "无|r";--如果要改成中文："無定位|r"
   elseif (role == "TANK") then
      return "|cFF" .. COLOR_TANK .. "坦克|r";--"坦克|r"
   elseif(role == "HEALER") then
      return "|cFF" .. COLOR_HEAL .. "治疗|r";--"治療|r"
   else  -- if(role == "DPS") then
      return "|cFF" .. COLOR_DPS  .. "伤害输出|r";--"輸出|r"
   end
end

local function Load()
    GameTooltip:HookScript("OnTooltipSetUnit", TipSetUnit)
    GameTooltipStatusBar:SetStatusBarTexture(cfg.tex)
    GameTooltipStatusBar:SetScript("OnValueChanged", TipChangeValue)
    hooksecurefunc("GameTooltip_SetDefaultAnchor", TipSetAnchor)

    for i, frame in ipairs(tooltips) do
        frame:SetScript("OnShow", function(frame) style(frame) end)
    end

    for i, script in ipairs(itemrefScripts) do
        ItemRefTooltip:HookScript(script, function(self)
            style(self)
        end)
    end

    for i, frame in ipairs(tooltips) do
        setBakdrop(frame)
    end

    GameTooltip:HookScript("OnTooltipSetUnit", function(self, ...)
       local name, unit = GameTooltip:GetUnit();
       if(unit and UnitIsPlayer(unit) and (UnitInParty(unit) or UnitInRaid(unit))) then
             GameTooltip:AddLine("Role: " .. GetLFDRole(unit))
       end
    end)
end

Modules:AddModule("Tooltip", Load, nil)


