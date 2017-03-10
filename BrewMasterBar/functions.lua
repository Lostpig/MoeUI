local addon, namespace = ...

local BMB = {}
namespace.BMB = BMB

local Func = {}
BMB.Func = Func

Func.CreateShadow = function(f, size, bgcolor, shadowcolor, offset)
	if not f.border then Func.CreateBorder(f, 1, {0,0,0,0}, shadowcolor, offset and offset - 2 or 1) end
	if not f.shadow then
		local frameLevel = f:GetFrameLevel() > 1 and f:GetFrameLevel() - 1 or 1
		local shadow = CreateFrame("Frame", nil, f)
		shadow:SetFrameLevel(frameLevel - 1)
		f.shadow = shadow
	end
	
	if not offset then offset = 3 end
	f.shadow:SetPoint("TOPLEFT", f, "TOPLEFT", -offset, offset)
	f.shadow:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", offset, -offset)
			
	f.shadow:SetBackdrop({ 
		edgeFile = [=[Interface\BUTTONS\WHITE8X8]=],
		bgFile = [=[Interface\BUTTONS\WHITE8X8]=], 
		edgeSize = size,
		tile = false,
		tileSize = 0,
		insets = {left = size, right = size, top = size, bottom = size},
	})
	f.shadow:SetBackdropColor(unpack(bgcolor))
	f.shadow:SetBackdropBorderColor(unpack(shadowcolor))
end
Func.CreateBorder = function(f, size, bgcolor, bordercolor, offset)
	if not f.border then
		local frameLevel = f:GetFrameLevel() > 1 and f:GetFrameLevel() + 1 or 2
		local border = CreateFrame("Frame", nil, f)
		border:SetFrameLevel(frameLevel)
		f.border = border
	end
	
	if not offset then offset = 1 end
	f.border:SetPoint("TOPLEFT", f, "TOPLEFT", -offset, offset)
	f.border:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", offset, -offset)

	f.border:SetBackdrop({
		edgeFile = [=[Interface\BUTTONS\WHITE8X8]=], 
		edgeSize = size, 
		tile = false,
		tileSize = 0,
	})
	f.border:SetBackdropColor(unpack(bgcolor))
	f.border:SetBackdropBorderColor(unpack(bordercolor))
end
Func.EasyFontString = function(f, font, fontsize, fontflag)
	local fs = f:CreateFontString(nil, "OVERLAY")
	fs:SetFont(font, fontsize, fontflag)
	return fs
end
Func.ConvertColor = function(r, g, b)
	return format("%02x%02x%02x", r*255, g*255, b*255)
end
Func.RemoveBorder = function(f)
	if not f.border then return end
	f.border:SetBackdrop(nil)
	f.border:SetBackdropColor(0,0,0,0)
	f.border:SetBackdropBorderColor(0,0,0,0)
	if f.shadow then 
		f.shadow:SetBackdrop(nil)
		f.shadow:SetBackdropColor(0,0,0,0)
		f.shadow:SetBackdropBorderColor(0,0,0,0)
	end
end

local dummy = function() end
Func.GetDummy = function()
	return dummy
end

Func.NewTrigger = function(name, triggerSets)
	local trigger = CreateFrame("Frame", name and "MoeTrigger_"..name or nil)
	if (triggerSets.Events) then
		for _,v in pairs(triggerSets.Events) do trigger:RegisterEvent(v) end
	end
	if (triggerSets.Script) then
		trigger:SetScript("OnEvent", triggerSets.Script)
	end
	trigger.Destroy = function(self) 
		Func.Destroy(self)
	end
	trigger.ResetEvents = function(self, eventsSet)
		self:UnregisterAllEvents()
		for _,v in pairs(eventsSet) do trigger:RegisterEvent(v) end
	end
	trigger.ResetScript = function(self, scriptFunc)
		trigger:SetScript("OnEvent", triggerSets.Script)
	end
	return trigger
end
Func.Destroy = function(obj)
	if obj.UnregisterAllEvents then obj:UnregisterAllEvents() end
	obj.Show = Func.GetDummy()
	obj:Hide()
end
