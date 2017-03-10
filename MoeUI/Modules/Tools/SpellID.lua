local addon, ns = ...

--if not GeomDB.SpellID then return end

hooksecurefunc(GameTooltip, "SetUnitBuff", function(self,...)
	local id = select(11,UnitBuff(...))
	if id then
		self:AddDoubleLine("法術編號:",id)
		self:Show()
	end
end)

hooksecurefunc(GameTooltip, "SetUnitDebuff", function(self,...)
	local id = select(11,UnitDebuff(...))
	if id then
		self:AddDoubleLine("法術編號:",id)
		self:Show()
	end
end)

hooksecurefunc(GameTooltip, "SetUnitAura", function(self,...)
	local id = select(11,UnitAura(...))
	if id then
		self:AddDoubleLine("法術編號:",id)
		self:Show()
	end
end)

hooksecurefunc("SetItemRef", function(link, text, button, chatFrame)
	if string.find(link,"^spell:") then
		local id = string.sub(link,7)
		ItemRefTooltip:AddDoubleLine("SpellID:",id)
		ItemRefTooltip:Show()
	end
end)

GameTooltip:HookScript("OnTooltipSetItem", function(self)
	local _, link = self:GetItem()
	if link then
		self:AddDoubleLine("物品ID:", string.match(link, "|Hitem:(%d+):"))
		self:Show()
	end
end)

GameTooltip:HookScript("OnTooltipSetSpell", function(self)
	local id = select(3,self:GetSpell())
	if id then
		self:AddDoubleLine("法術編號:",id)
		self:Show()
	end
end)

function dishook()
--hooksecurefunc(GameTooltip, "SetUnitBuff", nil)

--hooksecurefunc(GameTooltip, "SetUnitDebuff", nil)

--hooksecurefunc(GameTooltip, "SetUnitAura", nil)

hooksecurefunc("SetItemRef", nil)
end
