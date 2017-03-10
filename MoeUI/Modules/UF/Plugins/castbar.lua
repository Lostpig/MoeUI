local addon, namespace = ...
local Lib = namespace.Moe.Lib
local MoeUF = namespace.Moe.Modules:Get("UnitFrame")
local oUF = namespace.oUF

local Cast = {}
MoeUF.Cast = Cast
	
local InterruptColor  = { 95/255, 182/255, 255/255, 1}
local NormalColor     = {244/255, 182/255, 96/255, 1}

local setInterruptible = function (self, unit, notinterrupt) 
	if (notinterrupt) then
		self:SetStatusBarColor(unpack(self.NotInterruptColor))
	else 
		self:SetStatusBarColor(unpack(self.CastingColor))
	end
end

Cast.ChannelTickList = {
	-- warlock
	[GetSpellInfo(689)] = 5, -- drain life
	[GetSpellInfo(5740)] = 4, -- rain of fire
	-- druid
	[GetSpellInfo(740)] = 4, -- Tranquility
	-- priest
	[GetSpellInfo(15407)] = 3, -- mind flay
	[GetSpellInfo(48045)] = 5, -- mind sear
	[GetSpellInfo(47540)] = 2, -- penance
	-- mage
	[GetSpellInfo(5143)] = 5, -- arcane missiles
	[GetSpellInfo(12051)] = 4, -- evocation
}
local ticks = {}
Cast.SetTicks = function(castBar, ticknum)
	if ticknum and ticknum > 0 then
		local delta = castBar:GetWidth() / ticknum
		for k = 1, ticknum do
			if not ticks[k] then
				ticks[k] = castBar:CreateTexture(nil, 'OVERLAY')
				ticks[k]:SetTexture(castBar.Spark:GetTexture())
				ticks[k]:SetAlpha(1)
				ticks[k]:SetVertexColor(1, 1, .5)
				ticks[k]:SetWidth(1)
				ticks[k]:SetHeight(castBar:GetHeight())
				Lib.Flip(ticks[k], "VERTICAL")
			end
			ticks[k]:ClearAllPoints()
			ticks[k]:SetPoint("CENTER", castBar, "LEFT", delta * k, 0 )
			ticks[k]:Show()
		end
	else
		for k, v in pairs(ticks) do
			v:Hide()
		end
	end
end
Cast.OnCastbarUpdate = function(self, elapsed)
	local currentTime = GetTime()
	if self.casting or self.channeling then
		local parent = self:GetParent()
		local duration = self.casting and self.duration + elapsed or self.duration - elapsed
		if (self.casting and duration >= self.max) or (self.channeling and duration <= 0) then
			self.casting = nil
			self.channeling = nil
			return
		end
		if parent.unit == 'player' then
			if self.delay ~= 0 then
				self.Time:SetFormattedText('%.1f | |cffff0000%.1f|r', duration, self.casting and self.max + self.delay or self.max - self.delay)
			else
				self.Time:SetFormattedText('%.1f | %.1f', duration, self.max)
				self.Lag:SetFormattedText("%d ms", self.SafeZone.timeDiff * 1000)
			end
		else
			self.Time:SetFormattedText('%.1f | %.1f', duration, self.casting and self.max + self.delay or self.max - self.delay)
		end
				
		self.duration = duration
		self:SetValue(duration)
		if self.mystyle == "target" then
			self.Spark:SetPoint('CENTER', self, 'RIGHT', (duration / self.max) * self:GetWidth() * -1, 0)
		else
			self.Spark:SetPoint('CENTER', self, 'LEFT', (duration / self.max) * self:GetWidth(), 0)
		end
	else
		self.Spark:Hide()
		local alpha = self:GetAlpha() - 0.02
		if alpha > 0 then
			self:SetAlpha(alpha)
		else
			self.fadeOut = nil
			self:Hide()
		end
	end
end
Cast.OnCastSent = function(self, event, unit, spell, rank)
	if self.unit ~= unit or not self.SafeZone then return end
	
	self.SafeZone.sendTime = GetTime()
	--print('sent:' .. self.SafeZone.sendTime)
end
Cast.PostCastStart = function(self, unit, name, rank, text)
	self:SetAlpha(1.0)
	self.Spark:Show()
	
	if unit == "player"then
        self:SetStatusBarColor(unpack(self.casting and self.CastingColor or self.ChannelingColor))
		self.SafeZone.timeDiff = GetTime() - self.SafeZone.sendTime
		self.SafeZone.timeDiff = self.SafeZone.timeDiff > self.max and self.max or self.SafeZone.timeDiff
		
		--print('start:' .. GetTime())
		
        if (self.SafeZone.timeDiff > 0) then
            self.SafeZone:SetWidth(self:GetWidth() * self.SafeZone.timeDiff / self.max)
            self.SafeZone:Show()
        else 
            self.SafeZone:Hide()
        end
		
		if self.casting then
			Cast.SetTicks(self, 0)
		else
			local spell = UnitChannelInfo(unit)
			self.channelingTicks = Cast.ChannelTickList[spell] or 0
			Cast.SetTicks(self, self.channelingTicks)
		end
	elseif (unit == "target" or unit == "focus") then
		if self.interrupt then
			setInterruptible(self, unit, self.interrupt)
		else
			self:SetStatusBarColor(unpack(self.CastingColor))
		end
	else
		self:SetStatusBarColor(unpack(self.CastingColor))
	end
end
Cast.PostCastStop = function(self, unit, name, rank, castid)
	if not self.fadeOut then 
		self:SetStatusBarColor(unpack(self.CompleteColor))
		self.fadeOut = true
	end
	self:SetValue(self.max)
	self:Show()
end
Cast.PostChannelStop = function(self, unit, name, rank)
	self.fadeOut = true
	self:SetValue(0)
	self:Show()
end
Cast.PostCastFailed = function(self, event, unit, name, rank, castid)
	self:SetStatusBarColor(unpack(self.FailColor))
	self:SetValue(self.max)
	if not self.fadeOut then
		self.fadeOut = true
	end
	self:Show()
end
Cast.PostCastInterruptible = function(self, unit)
	setInterruptible(self, unit, false)
end
Cast.PostCastNotInterruptible= function(self, unit)
    if UnitIsPlayer(unit) and UnitIsFriend(unit, "player") then
		--doNothing
    else
        setInterruptible(self, unit, true)
    end
end




