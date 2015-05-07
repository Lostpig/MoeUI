local addon, namespace = ...
local ActBar = namespace.Moe.Modules:Get("ActionBar")



local function SetButtonBG(button, theme)
    if not button or (button and button.bg) then return end
    --shadows+background
    if button:GetFrameLevel() < 1 then button:SetFrameLevel(1) end
    if theme.background.showbg or theme.background.showshadow then
		button.bg = CreateFrame("Frame", nil, button)
		button.bg:SetAllPoints(button)
		button.bg:SetPoint("TOPLEFT", button, "TOPLEFT", -2, 2)
		button.bg:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, -2)
		button.bg:SetFrameLevel(button:GetFrameLevel()-1)

		if theme.background.showbg and not theme.background.useflatbackground then
			local t = button.bg:CreateTexture(nil,"BACKGROUND",-8)
			t:SetTexture(theme.textures.buttonback)
			t:SetAllPoints(button)
			t:SetVertexColor(unpack(theme.background.backgroundcolor))
		end
		button.bg:SetBackdrop(theme.backdrop)
		if theme.background.useflatbackground then
			button.bg:SetBackdropColor(unpack(theme.background.backgroundcolor))
			button.bg:SetBackdropBorderColor(unpack(theme.background.shadowcolor))
		end
		if theme.background.showshadow then
			button.bg:SetBackdropColor(unpack(theme.background.backgroundcolor))
			button.bg:SetBackdropBorderColor(unpack(theme.background.shadowcolor))
		end
    end
end

--action button
local function SetButtonStyle(button, theme)
	if not button or (button and button.isStyled) then return end
	local action = button.action
    local name = button:GetName()
    local icon  = _G[name.."Icon"]
    local count  = _G[name.."Count"]
    local border  = _G[name.."Border"]
    local hotkey  = _G[name.."HotKey"]
    local cooldown  = _G[name.."Cooldown"]
    local macroname  = _G[name.."Name"]
    local flash  = _G[name.."Flash"]
    local normaltex  = _G[name.."NormalTexture"]
    local fbg  = _G[name.."FloatingBG"]
    local fborder = _G[name.."FlyoutBorder"]
    local fshadow = _G[name.."FlyoutBorderShadow"]
    local id = button:GetID();
    local btype = button.buttonType
	
	if fbg then fbg:Hide() end
	if fborder then fborder:SetTexture(nil) end
    if fshadow then fshadow:SetTexture(nil) end
    border:SetTexture(nil)
	--hotkey
	hotkey:SetFont(theme.hotkeys.font, theme.hotkeys.fontsize, theme.hotkeys.fontflags)
	hotkey:ClearAllPoints()
	hotkey:SetPoint(unpack(theme.hotkeys.point))
    if(btype) then 
        local key = GetBindingKey(btype..id)
        if (key and (key == "BUTTON4" or key == "BUTTON5")) then
            hotkey:SetText(key == "BUTTON4" and "M4" or "M5")
        end
    end
	--macroname
	macroname:SetFont(theme.macroname.font, theme.macroname.fontsize, theme.macroname.fontflags)
	macroname:ClearAllPoints()
	macroname:SetPoint(unpack(theme.macroname.point))
	--itemcount
	count:SetFont(theme.itemcount.font, theme.itemcount.fontsize, theme.itemcount.fontflags)
	count:ClearAllPoints()
	count:SetPoint(unpack(theme.itemcount.point))
	--texture
	flash:SetTexture(theme.textures.flash)
    button:SetHighlightTexture(theme.textures.hover)
    button:SetPushedTexture(theme.textures.pushed)
    button:SetCheckedTexture(theme.textures.checked)
    button:SetNormalTexture(theme.textures.normal)
	if not normaltex then
      --fix the non existent texture problem (no clue what is causing this)
      normaltex = button:GetNormalTexture()
    end
	--cut the default border of the icons and make them shiny
    icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    icon:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
    icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
    --adjust the cooldown frame
    cooldown:SetPoint("TOPLEFT", button, "TOPLEFT", theme.cooldown.spacing, -theme.cooldown.spacing)
    cooldown:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -theme.cooldown.spacing, theme.cooldown.spacing)
    --apply the normaltexture
    if action and  IsEquippedAction(action) then
		button:SetNormalTexture(theme.textures.equipped)
		normaltex:SetVertexColor(unpack(theme.color.equipped))
    else
		button:SetNormalTexture(theme.textures.normal)
		normaltex:SetVertexColor(unpack(theme.color.normal))
    end
    --make the normaltexture match the buttonsize
    normaltex:SetAllPoints(button)
    --hook to prevent Blizzard from reseting our colors
    hooksecurefunc(normaltex, "SetVertexColor", function(nt, r, g, b, a)
		local button = nt:GetParent()
		local action = button.action
		local nr,ng,nb,na = unpack(theme.color.normal)
		local er,eg,eb,ea = unpack(theme.color.equipped)
		
		if r==1 and g==1 and b==1 and action and (IsEquippedAction(action)) then
			if er == 1 and eg == 1 and eb == 1 then
				nt:SetVertexColor(0.999,0.999,0.999,1)
			else
				nt:SetVertexColor(er,eg,eb,ea)
			end
		elseif r==0.5 and g==0.5 and b==1 then
			--blizzard oom color
			if nr == 0.5 and ng == 0.5 and nb == 1 then
				nt:SetVertexColor(0.499,0.499,0.999,1)
			else
				nt:SetVertexColor(nr,ng,nb,na)
			end
		elseif r == 1 and g == 1 and b == 1 then
			if nr == 1 and ng == 1 and nb == 1 then
				nt:SetVertexColor(0.999,0.999,0.999,1)
			else
				nt:SetVertexColor(nr,ng,nb,na)
			end
		end
    end)
    --shadows+background
    if not button.bg then SetButtonBG(button, theme) end
    button.isStyled = true
end
--extra button
local function SetExtraButtonStyle(button, theme)
    if not button or (button and button.isStyled) then return end
    local name = button:GetName()
    local hotkey = _G[name.."HotKey"]
    --remove the style background theme
    button.style:SetTexture(nil)
    hooksecurefunc(button.style, "SetTexture", function(self, texture)
		if texture then
			--print("reseting texture: "..texture)
			self:SetTexture(nil)
		end
    end)
    --icon
    button.icon:SetTexCoord(0.1,0.9,0.1,0.9)
    button.icon:SetAllPoints(button)
    --cooldown
    button.cooldown:SetAllPoints(button.icon)
    --hotkey
    hotkey:Hide()
    --add button normaltexture
    button:SetNormalTexture(theme.textures.normal)
    local nt = button:GetNormalTexture()
    nt:SetVertexColor(unpack(theme.color.normal))
    nt:SetAllPoints(button)
    --apply background
    if not button.bg then SetButtonBG(button, theme) end
    button.isStyled = true
end
--pet button
local function SetPetButtonStyle(button, theme)
    if not button or (button and button.isStyled) then return end
    local name = button:GetName()
    local ic = _G[name.."Icon"]
    local fl = _G[name.."Flash"]
    local nt = _G[name.."NormalTexture2"]
	local auto = _G[name.."AutoCastable"]
	local shine = _G[name.."Shine"]
	local hotkey  = _G[name.."HotKey"]
    nt:SetAllPoints(button)
    --applying color
    nt:SetVertexColor(unpack(theme.color.normal))
    --setting the textures
    fl:SetTexture(theme.textures.flash)
    button:SetHighlightTexture(theme.textures.hover)
    button:SetPushedTexture(theme.textures.pushed)
    button:SetCheckedTexture(theme.textures.checked)
    button:SetNormalTexture(theme.textures.normal)
	
	hotkey:SetFont(theme.hotkeys.font, theme.hotkeys.fontsize, theme.hotkeys.fontflags)
	hotkey:ClearAllPoints()
	hotkey:SetPoint(unpack(theme.hotkeys.point))
	
	auto:SetWidth(button:GetWidth()*2)
	auto:SetHeight(button:GetHeight()*2)
	shine:SetWidth(button:GetWidth()+2)
	shine:SetHeight(button:GetHeight()+2)
	
    hooksecurefunc(button, "SetNormalTexture", function(self, texture)
		--make sure the normaltexture stays the way we want it
		if texture and texture ~= theme.textures.normal then
			self:SetNormalTexture(theme.textures.normal)
		end
    end)
    --cut the default border of the icons and make them shiny
    ic:SetTexCoord(0.1,0.9,0.1,0.9)
    ic:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
    ic:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
    --shadows+background
    if not button.bg then SetButtonBG(button, theme) end
    button.isStyled = true
end
--stance button
local function SetStanceButtonStyle(button, theme)
    if not button or (button and button.isStyled) then return end
    local name = button:GetName()
    local ic = _G[name.."Icon"]
    local fl = _G[name.."Flash"]
    local nt = _G[name.."NormalTexture2"]
    nt:SetAllPoints(button)
    --applying color
    nt:SetVertexColor(unpack(theme.color.normal))
    --setting the textures
    fl:SetTexture(theme.textures.flash)
    button:SetHighlightTexture(theme.textures.hover)
    button:SetPushedTexture(theme.textures.pushed)
    button:SetCheckedTexture(theme.textures.checked)
    button:SetNormalTexture(theme.textures.normal)
    --cut the default border of the icons and make them shiny
    ic:SetTexCoord(0.1,0.9,0.1,0.9)
    ic:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
    ic:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
    --shadows+background
    if not button.bg then SetButtonBG(button, theme) end
    button.isStyled = true
end
--possess button
local function SetPossessButtonStyle(button, theme)
    if not button or (button and button.isStyled) then return end
    local name = button:GetName()
    local ic = _G[name.."Icon"]
    local fl = _G[name.."Flash"]
    local nt = _G[name.."NormalTexture"]
    nt:SetAllPoints(button)
    --applying color
    nt:SetVertexColor(unpack(theme.color.normal))
    --setting the textures
    fl:SetTexture(theme.textures.flash)
    button:SetHighlightTexture(theme.textures.hover)
    button:SetPushedTexture(theme.textures.pushed)
    button:SetCheckedTexture(theme.textures.checked)
    button:SetNormalTexture(theme.textures.normal)
    --cut the default border of the icons and make them shiny
    ic:SetTexCoord(0.1,0.9,0.1,0.9)
    ic:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
    ic:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
    --shadows+background
    if not button.bg then SetButtonBG(button, theme) end
    button.isStyled = true
end
--leave button
local function SetLeaveButtonStyle(button, theme)
	if not button or (button and button.isStyled) then return end
	--shadows+background
	if not button.bg then SetButtonBG(button, theme) end
	button.isStyled = true
end

ActBar.ButtonStyle = SetButtonStyle
ActBar.ExtraButtonStyle = SetExtraButtonStyle
ActBar.PetButtonStyle = SetPetButtonStyle
ActBar.StanceButtonStyle = SetStanceButtonStyle
ActBar.PossessButtonStyle = SetPossessButtonStyle
ActBar.LeaveButtonStyle = SetLeaveButtonStyle
