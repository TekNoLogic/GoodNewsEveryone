
local myname, ns = ...


local COLORS = setmetatable({}, {__index = function(t,i)
	local r,g,b = i > 0.5 and 2 * (1 - i) or 1, i > 0.5 and 1 or 2 * i, 0
	local color = string.format("|cff%02x%02x%02x", r*255, g*255, b*255)
	t[i] = color
	return color
end})


local frames, lastframe = {}
ns.active = {}


local function OnShow(self)
	local now = GetTime()
	ns.active[self.spell] = self

	self.text:SetFontObject(ns.db.font)
	self.text:SetText(" ")
	self:SetHeight(self.text:GetStringHeight())

	self.scaler:Show()

	if ns.db.playsound then PlaySound(PlaySoundKitID and "RaidBossEmoteWarning" or 12197) end
end


local function OnHide(self)
	ns.active[self.spell] = nil
end


local passive = setmetatable({}, {
	__index = function(t,i)
		local v = not not IsPassiveSpell(i)
		t[i] = v
		return v
	end
})


local function ShouldHide(self)
	if self.not_usable then return false end
	if self.expires then return GetTime() >= self.expires end
	if passive[self.spell] then return true end
	return not IsUsableSpell(self.spell)
end


local function GetText(self, now)
	local stacks = self.stacks > 1 and (" x"..self.stacks) or ""

	if self.expires then
		local left = math.ceil(self.expires - now)
		local timer = " (".. COLORS[left / self.duration].. left.. "|rs)"
		return self.msg.. stacks.. timer
	else
		return self.msg.. stacks
	end
end


local function OnUpdate(self, elap)
	local now = GetTime()
	if ShouldHide(self) then return self:Hide() end

	self.text:SetText(GetText(self, now))
end


-----------------------------
--      Frame factory      --
-----------------------------

function ns.GetFrame()
	for i,frame in pairs(frames) do
		if not frame:IsVisible() then return frame end
	end

	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetFrameStrata("HIGH")
	frame:SetPoint("TOP", lastframe or ns.anchor, "BOTTOM")
	frame:SetWidth(250)
	frame:Hide()
	frame:SetScript("OnShow", OnShow)
	frame:SetScript("OnHide", OnHide)
	frame:SetScript("OnUpdate", OnUpdate)

	frame.text = frame:CreateFontString(nil, nil, ns.db.font)
	frame.text:SetPoint("CENTER")
	frame.text:SetJustifyH("CENTER")

	frame.scaler = ns.CreateAlertScaler(frame)

	table.insert(frames, frame)
	lastframe = frame
	return frame
end
