---- SETTING HERE ---- ---- ---- ---- ----
local addon, ns = ...
local nfont = "Fonts\\ARHei.TTF" -- This is the font`s of all errors
local nfontsize = 18 -- This is Font Size
local nfontcolor = {1,.3,.1} -- This is Font color ({RED,GREEN,BLUE,ALPHA}, only values from 0 to 1), 1 is deff
local Yoffset = -5 -- "y" layout coordinate ("VERTICAL") - Zero starts from TOP-CENTER of ur monitor
local Xoffset = 0 -- "x" layout coordinate ("HORIZONTAL") - Zero starts from TOP-CENTER of ur monitor
local framestrata = "TOOLTIP" -- frame strata ("BACKGROUND", "LOW", "MEDIUM", "HIGH", "TOOLTIP")
local framelevel = 30 -- frame level
local holdtime = 2 -- hold time (seconds)
local fadeintime = 0.2 -- fadein time (seconds)
local fadeouttime = 0.4 -- fade out time (seconds)
-------------------------------------------

local Error = CreateFrame("Frame")
	UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")
	
--/Errors` Frame/--
local FirstErrorFrame = CreateFrame ("Frame",nil,UIParent)
	FirstErrorFrame:SetScript("OnUpdate", FadingFrame_OnUpdate)
	FirstErrorFrame.fadeInTime = fadeintime
	FirstErrorFrame.fadeOutTime = fadeouttime
	FirstErrorFrame.holdTime = holdtime
	FirstErrorFrame:Hide()
	FirstErrorFrame:SetFrameStrata(framestrata)
	FirstErrorFrame:SetFrameLevel(framelevel)
local SecondErrorFrame = CreateFrame ("Frame",nil,UIParent)
	SecondErrorFrame:SetScript("OnUpdate", FadingFrame_OnUpdate)
	SecondErrorFrame.fadeInTime = fadeintime
	SecondErrorFrame.fadeOutTime = fadeouttime
	SecondErrorFrame.holdTime = holdtime
	SecondErrorFrame:Hide()
	SecondErrorFrame:SetFrameStrata(framestrata)
	SecondErrorFrame:SetFrameLevel(framelevel)
	
--/Text Mess/--
local TextOne = FirstErrorFrame:CreateFontString(nil, "OVERLAY")
	TextOne:SetShadowOffset(1,-1)
	TextOne:SetPoint("TOP", UIParent, Xoffset, Yoffset)
	TextOne:SetFont(nfont,nfontsize,"THINOUTLINE")
	TextOne:SetTextColor(unpack(nfontcolor))
local TextTwo = SecondErrorFrame:CreateFontString(nil, "OVERLAY")
	TextTwo:SetShadowOffset(1,-1)
	TextTwo:SetPoint("TOP", UIParent, Xoffset, Yoffset - nfontsize - 1)
	TextTwo:SetFont(nfont,nfontsize,"THINOUTLINE")
	TextTwo:SetTextColor(unpack(nfontcolor))
	
--/Alert Switch
local state = 0
FirstErrorFrame:SetScript("OnHide",function() state = 0 end)
local allertIt = function(_,_,_,error)
	if state == 0 then 
		TextOne:SetText(error)
		FadingFrame_Show(FirstErrorFrame)
		state = 1
	 else 
		TextTwo:SetText(error)
		FadingFrame_Show(SecondErrorFrame)
		state = 0
	 end
end
Error:RegisterEvent("UI_ERROR_MESSAGE")
Error:SetScript("OnEvent",allertIt)

