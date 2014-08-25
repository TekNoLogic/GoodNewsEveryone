
local myname, ns = ...


local colors = setmetatable({}, {__index = function(t,i)
	local r,g,b = i > 0.5 and 2 * (1 - i) or 1, i > 0.5 and 1 or 2 * i, 0
	local color = string.format("|cff%02x%02x%02x", r*255, g*255, b*255)
	t[i] = color
	return color
end})


local anchor = CreateFrame("Button", nil, UIParent)
ns.anchor = anchor

local text = anchor:CreateFontString(nil, nil, "GameFontNormalSmall")
text:SetPoint("CENTER")
text:SetText("Good News Everyone!")

anchor:SetWidth(text:GetStringWidth() + 16)
anchor:SetHeight(24)

anchor:SetBackdrop({
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16,
	insets = {left = 5, right = 5, top = 5, bottom = 5},
	tile = true, tileSize = 16
})
anchor:SetBackdropColor(0.09, 0.09, 0.19, 0.5)
anchor:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)

anchor:SetMovable(true)
anchor:RegisterForDrag("LeftButton")
anchor:SetScript("OnDragStart", anchor.StartMoving)
anchor:SetScript("OnDragStop", function(self, button)
	self:StopMovingOrSizing()
	ns.db.point, ns.db.x, ns.db.y = "BOTTOMLEFT", self:GetLeft(), self:GetBottom()
end)

local PULSESCALE, SCALETIME, SHRINKTIME = 1.5, 0.05, 0.2
local frames, lastframe = {}, anchor
ns.active = {}
local function OnShow(self)
	local now = GetTime()
	ns.active[self.spell] = self
	self:SetScale(1)
	self.scaletime = now + SCALETIME
	self.shrinktime = now + SCALETIME + SHRINKTIME
	self.text:SetFontObject(ns.db.font)
	self.text:SetText(" ")
	self:SetHeight(self.text:GetStringHeight())
	if ns.db.playsound then PlaySound("RaidBossEmoteWarning") end
end
local function OnHide(self) ns.active[self.spell] = nil end
local function OnUpdate(self, elap)
	local now = GetTime()
	if self.expires and now >= self.expires then return self:Hide() end
	if not self.expires and
		(IsPassiveSpell(self.spell) or not IsUsableSpell(self.spell)) then
		return self:Hide()
	end

	local scale = (now <= self.scaletime) and
	                (PULSESCALE - (PULSESCALE-1)*(self.scaletime - now)/SCALETIME)
	              or (now <= self.shrinktime) and
	                (1 + (PULSESCALE-1)*(self.shrinktime - now)/SHRINKTIME)
	              or 1
	self:SetScale(scale)

	if self.expires then
		local left = math.floor(self.expires - now)
		self.text:SetText(
			self.msg.. (self.stacks > 1 and (" x"..self.stacks) or "")..
			" ("..colors[left / self.duration]..left.."|rs)"
		)
	else
		self.text:SetText(self.msg.. (self.stacks > 1 and (" x"..self.stacks) or ""))
	end
end


-----------------------------
--      Frame factory      --
-----------------------------

function ns.GetFrame()
	for i,f in pairs(frames) do if not f:IsVisible() then return f end end

	local f = CreateFrame("Frame", nil, UIParent)
	f:SetFrameStrata("HIGH")
	f:SetPoint("TOP", lastframe, "BOTTOM")
	f:SetWidth(250)
	f:Hide()
	f:SetScript("OnShow", OnShow)
	f:SetScript("OnHide", OnHide)
	f:SetScript("OnUpdate", OnUpdate)

	f.text = f:CreateFontString(nil, nil, ns.db.font)
	f.text:SetPoint("CENTER")
	f.text:SetJustifyH("CENTER")

	table.insert(frames, f)
	lastframe = f
	return f
end
