local addon, namespace = ...
local Lib = namespace.Moe.Lib
local DefaultSets = namespace.Moe.DefaultSets
local Media = namespace.Moe.Media

local degreestable = setmetatable({}, {					--旋转角度表
	__index = function(t, k)
		local k = floor(k % 360)
		if k == 0 then
			t[k] = {0,0,0,1,1,0,1,1}
			return t[k]
		end
		local A = cos(k)
		local B = sin(k)
		local ULx, ULy = (-0.5 * A - -0.5 * B) + 0.5, (-0.5 * B + -0.5 * A) + 0.5
		local LLx, LLy = (-0.5 * A - 0.5 * B) + 0.5, (-0.5 * B + 0.5 * A) + 0.5
		local URx, URy = (0.5 * A - -0.5 * B) + 0.5, (0.5 * B + -0.5 * A) + 0.5
		local LRx, LRy = (0.5 * A - 0.5 * B) + 0.5, (0.5 * B + 0.5 * A) + 0.5
		t[k] = {ULx,ULy,LLx,LLy,URx,URy,LRx,LRy}
		return t[k]
	end
})

Lib.CreateShadow = function(f, size, bgcolor, shadowcolor, offset)
	if not f.border then Lib.CreateBorder(f, 1, {0,0,0,0}, shadowcolor, offset and offset - 2 or 1) end
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
		edgeFile = Media.Button.Shadow,
		bgFile = Media.Texture.Blank, 
		edgeSize = size,
		tile = false,
		tileSize = 0,
		insets = {left = size, right = size, top = size, bottom = size},
	})
	f.shadow:SetBackdropColor(unpack(bgcolor))
	f.shadow:SetBackdropBorderColor(unpack(shadowcolor))
end
Lib.CreateBorder = function(f, size, bgcolor, bordercolor, offset)
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
		edgeFile = Media.Texture.Blank, 
		edgeSize = size, 
		tile = false,
		tileSize = 0,
	})
	f.border:SetBackdropColor(unpack(bgcolor))
	f.border:SetBackdropBorderColor(unpack(bordercolor))
end
Lib.FramePx = function(f, size, bgcolor, bordercolor)
	f:SetBackdrop({
		bgFile =  Media.Texture.BackGround,
        edgeFile = Media.Texture.Blank, 
        edgeSize = size, 
		insets = {left = -1 * size, right = -1 * size, top = -1 * size, bottom = -1 * size} 
	})
	f:SetBackdropColor(unpack(bgcolor))
	f:SetBackdropBorderColor(unpack(bordercolor))
end
Lib.RemoveBorder = function(f)
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
Lib.Flip = function(texture, mode)
	mode = mode:upper()
	
	local ULx,ULy,LLx,LLy,URx,URy,LRx,LRy = texture:GetTexCoord()
	if mode == "DIAGONAL" then 
		texture:SetTexCoord(LRx,LRy,URx,URy,LLx,LLy,ULx,ULy) 
	elseif mode == "VERTICAL" then 
		texture:SetTexCoord(LLx,LLy,ULx,ULy,LRx,LRy,URx,URy) 
	elseif mode == "HORIZONTAL" then 
		texture:SetTexCoord(URx,URy,LRx,LRy,ULx,ULy,LLx,LLy) 
	end
end
Lib.Rotation = function(texture, degrees)
    texture:SetTexCoord(unpack(degreestable[degrees]))
end

Lib.CreateFontString = function(f, sets)
	local fs = f:CreateFontString(nil, "OVERLAY")
	if not sets then sets = DefaultSets.FontString end
	fs:SetFont(sets.font, sets.size, sets.outline)
	fs:SetPoint(sets.anchor,sets.x_off,sets.y_off)
	if (sets.align) then fs:SetJustifyH(sets.align) end
	if (sets.attrname) then f[sets.attrname] = fs end
	return fs
end
Lib.EasyFontString = function(f, font, fontsize, fontflag)
	local fs = f:CreateFontString(nil, "OVERLAY")
	fs:SetFont(font, fontsize, fontflag)
	return fs
end

Lib.ColorTurn = function(r, g, b)
	return format("%02x%02x%02x", r*255, g*255, b*255)
end
Lib.PercentColor = function(perc)	        --百分比颜色
	perc = perc > 1 and 1 or perc < 0 and 0 or perc -- Stay between 0-1
	local seg, relperc = math.modf(perc*2)
	local r1,g1,b1,r2,g2,b2 = select(seg*3+1,1,0,0,1,1,0,0,1,0,0,0,0) -- R -> Y -> G
	local r,g,b = r1+(r2-r1)*relperc,g1+(g2-g1)*relperc,b1+(b2-b1)*relperc
	return Lib.ColorTurn(r,g,b)
end
Lib.TimeTurn = function(second)
	if second > 3600 then return format("%02d:%02d:%02d",floor(second/3600),floor(mod(second,3600)/60),floor(mod(second,60)))
	elseif second > 60 then return format("00:%02d:%02d",floor(second/60),floor(mod(second,60)))
	else return format("00:00:%02d",second) end
end
Lib.TimeUnitTurn = function(second)
	if second > 3600 then return format("%dh",floor(second/3600))
	elseif second > 60 then return format("%dm",floor(second/60))
	else return format("%d",second) end
end
Lib.MemoryCount = function(memory)
	return memory > 1024 and string.format("%.1f MB", memory/1024) or string.format("%d KB", memory)
end
Lib.Split = function(str, delim)
    if type(delim) ~= "string" or string.len(delim) <= 0 then
        return
    end

    local start = 1
    local t = {}
    while true do
    local pos = string.find(str, delim, start, true) -- plain find
        if not pos then
            break
        end

        tinsert(t, string.sub(str, start, pos - 1))
        start = pos + string.len(delim)
    end
    tinsert (t, string.sub(str, start))

    return t
end

local panelList = {}
Lib.CreatePanel = function(panelSet)
	if panelList[panelSet.name] then 
		print("|cffff0000error|r:MoeUI Panel ["..panelSet.name.."] Is Alive")
		return
	end
    
    local frameType = "Frame"
    if (panelSet.button == true) then frameType = "Button" 
    elseif (panelSet.bar == true) then frameType = "StatusBar" end
    
	local frame = CreateFrame(frameType, "Moe_"..panelSet.name, _G[panelSet.parent])
	frame:SetPoint(unpack(panelSet.point))
	frame:SetFrameStrata(panelSet.strata or "BACKGROUND")
	
	frame.bg = frame:CreateTexture(nil, "BACKGROUND")
	frame.bg:SetTexture(panelSet.texture or Media.Texture.Blank, true)
	frame.bg:SetAllPoints()
	frame.bg:SetVertexColor(unpack(panelSet.color or {1,1,1,0}))
	
    if panelSet.bar then
        frame:SetStatusBarTexture(panelSet.texture or Media.Texture.Blank, true)
        frame:GetStatusBarTexture():SetHorizTile(panelSet.horiziile or false)
    end
    
	if panelSet.attr then 
		for attrname, attrvalue in pairs(panelSet.attr) do 
            frame:SetAttribute(attrname, attrvalue)
        end
	end
    
	if panelSet.ref then frame.ref = panelSet.ref end
	if panelSet.width then frame:SetWidth(panelSet.width) end
	if panelSet.height then frame:SetHeight(panelSet.height) end
	
	if panelSet.backdrop then
		frame:SetBackdrop(panelSet.backdrop)
		frame:SetBackdropBorderColor(unpack(panelSet.bordercolor or {1,1,1,1}))
	end
	
	if panelSet.level then
		frame:SetFrameLevel(panelSet.level)
	end
	
	if panelSet.grad then 
		frame.bg:SetGradientAlpha(unpack(panelSet.grad))
		frame.bg:SetTexture(Media.Texture.Blank)
		if panelSet.grad_mod then
			frame.bg:SetBlendMode(panelSet.grad_mod)
		end
	end
	
	if panelSet.flip_v or panelSet.flip_h then
		local ULx,ULy,LLx,LLy,URx,URy,LRx,LRy = frame.bg:GetTexCoord()
		if panelSet.flip_v then frame.bg:SetTexCoord(LLx,LLy,ULx,ULy,LRx,LRy,URx,URy) end
		if panelSet.flip_h then frame.bg:SetTexCoord(URx,URy,LRx,LRy,ULx,ULy,LLx,LLy) end
	end
	
	if panelSet.fontstring then
		frame.text = frame:CreateFontString(nil)
		if not panelSet.width or not panelSet.height or panelSet.width == 0 or panelSet.height == 0 then
			local function settext()
				frame:SetWidth(frame.text:GetStringWidth())
				frame:SetHeight(frame.text:GetStringHeight())
			end
			hooksecurefunc(frame.text, "SetText", settext)
		end
		frame.text:SetFont(panelSet.fontstring.font or deffontstring.font,
			panelSet.fontstring.size or deffontstring.size,
			panelSet.fontstring.outline or deffontstring.outline)
		frame.text:SetPoint(panelSet.fontstring.anchor,panelSet.fontstring.x_off,panelSet.fontstring.y_off)
        if (panelSet.fontstring.align) then frame.text:SetJustifyH(panelSet.fontstring.align) end
		frame.text:SetText(panelSet.text or nil)
		
		if panelSet.fontstring.textcolor then frame.text:SetTextColor(unpack(panelSet.fontstring.textcolor)) end
		if type(panelSet.text) == "function" then
			frame.text:SetText(panelSet.text())
			frame.text.elapsed = 0
			local textfunc = function(self,elapsed)
				frame.text.elapsed = frame.text.elapsed + elapsed
				if frame.text.elapsed > (frame.ref or 3) then frame.text:SetText(panelSet.text()) frame.text.elapsed = 0 end
			end
			if not panelSet.script or not panelSet.script.OnUpdate then
				frame:SetScript("OnUpdate",textfunc)
			else hooksecurefunc(panelSet.script,"OnUpdate",textfunc) end
		end
	end
	if panelSet.event then 
		for k,v in pairs(panelSet.event) do 
			frame:RegisterEvent(v) 
            if v == "PLAYER_LOGIN" then panelSet.script.OnEvent(frame, v) end
		end
	end
	if panelSet.script then
		for k, v in pairs(panelSet.script) do 
            if k == "OnLoad" then v(frame) 
            else frame:SetScript(k, v) end
        end
	end
	if panelSet.hide then frame:Hide() end
	
	panelList[panelSet.name] = frame
	return frame
end
Lib.GetPanel = function(panelName)
	if panelList[panelName] then return panelList[panelName] 
	else return nil end
end
Lib.CreateIcon = function(parent, sets)
    local Frame = CreateFrame("Frame", nil, parent)
    Frame:SetWidth(sets.size)
    Frame:SetHeight(sets.size)
    
    Frame.Icon = Frame:CreateTexture(nil, "ARTWORK") 
    Frame.Icon:SetAllPoints()
    Frame.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92) 
    
    Lib.CreateBorder(Frame, 1, {1,1,1,1}, {1,1,1,.8})

    Frame.Count = Frame:CreateFontString(nil, "OVERLAY") 
    Frame.Count:SetFont(Media.Fonts.Default, 10, "THINOUTLINE") 
    Frame.Count:SetPoint("BOTTOMRIGHT", 3, -1)
    
    Frame.Cooldown = CreateFrame("Cooldown", nil, Frame, "CooldownFrameTemplate") 
    Frame.Cooldown:SetAllPoints() 
    Frame.Cooldown:SetReverse(false)
    
    return Frame
end

Lib.NewTrigger = function(name, triggerSets)
	local trigger = CreateFrame("Frame", name and "MoeTrigger_"..name or nil)
	if (triggerSets.Events) then
		for _,v in pairs(triggerSets.Events) do trigger:RegisterEvent(v) end
	end
	if (triggerSets.Script) then
		trigger:SetScript("OnEvent", triggerSets.Script)
	end
	trigger.Destroy = function(self) 
		Lib.Destroy(self)
	end
	trigger.ResetEvents = function(self, eventsSet)
		self:UnregisterAllEvents()
		for _,v in pairs(eventsSet) do trigger:RegisterEvent(v) end
	end
	trigger.ResetScript = function(self, scriptFunc)
		trigger:SetScript("OnEvent", scriptFunc)
	end
	return trigger
end
Lib.Destroy = function(obj)
	if obj.UnregisterAllEvents then obj:UnregisterAllEvents() end
	obj.Show = Lib.GetDummy()
	obj:Hide()
end

local dummy = function() end
Lib.GetDummy = function()
	return dummy
end
Lib.DummyFunc = function(func)
	func = dummy
end
Lib.Error = function(...)
    --local err = "|cffefea33MoeUI:|r|cffff0000Error:|r "..string.format(...)
    print("|cffefea33MoeUI:|r|cffff0000Error:|r ", ...)
end

local hiderframe
local function CreateHider() 
	if not hiderframe then hiderframe = CreateFrame("Frame","Moe_Hider") end
	hiderframe:Hide()
	hiderframe.Show = Lib.GetDummy()
end
Lib.GetHider = function()
	if not hiderframe then CreateHider() end
	return hiderframe
end
Lib.BindHider = function(...)
	if not hiderframe then CreateHider() end
	local hidelist = {...}
	for i = 1, #hidelist do
		hidelist[i].lastParent = hidelist[i]:GetParent()
		hidelist[i]:SetParent(hiderframe)
	end
end
Lib.UnbindHider = function(...)
	local unbindlist = {...}
	for i = 1, #unbindlist do
		if unbindlist[i].lastParent then 
			unbindlist[i]:SetParent(unbindlist[i].lastParent)
			unbindlist[i].lastParent = nil
		else
			unbindlist[i]:SetParent(UIParent)
		end
	end
end
Lib.IsHide = function(f)
	if hiderframe and f:GetParent() == hiderframe then return true 
	else return false end
end

Lib.IsSpellLearned = function(spellID)
    local isknown = IsPlayerSpell(spellID)
    local spellname, spellicon, slot
    
    if (isknown) then
        local name, _, icon, _, _, _, sid = GetSpellInfo(spellID)
        spellname = name
        spellicon = icon
        
        local _, _, offset, numSlots, _, _ = GetSpellTabInfo(2)
        local tempslot
        for i = 1, numSlots do
            tempslot = offset + i
            local slottype, soltid = GetSpellBookItemInfo(tempslot, "spell")
            local _, _, _, _, _, _, sid = GetSpellInfo(tempslot, "spell")
            if soltid and sid == spellID and slottype ~= "FUTURESPELL" then
                slot = tempslot
                break
            end
        end
    end
    
    return isknown, spellname, slot, spellicon
end
Lib.RandNum = function(maxNum, oldNum)
    local newNum = math.random(maxNum)
    if newNum == oldNum then
        if newNum >= maxNum then newNum = newNum - 1
        else newNum = newNum + 1 end
    end
	return newNum
end












