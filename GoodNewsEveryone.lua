
----------------------
--      Locals      --
----------------------

local L = setmetatable({}, {__index=function(t,i) return i end})
local defaults, db = {point = "CENTER", x = 0, y = 300}

local spells = {
	-- Death Knight
	59052, -- Freezing Fog
	51124, -- Killing Machine

	-- Priest
	33151, -- Surge of Light
	63734, -- Serendipity
	60062, -- Essence of Life

	-- Paladin
	31833, -- Light's Grace
	53569, -- Infusion of Light
	53486, -- The Art of War

	-- Shaman
	51562, -- Tidal waves
	51528, -- Maelstrom Weapon
	16246, -- Clearcasting

	-- Druid
	16864, -- Omen of Clarity
	48516, -- Eclipse

	-- Hunter
	56342, -- Lock and Load

	-- Mage
	44404, -- Missle Barrage
	11103, -- Impact
	44445, -- Hot Streak
	44543, -- Finger of Frost
	44546, -- Brain Freeze
}

local colors = setmetatable({}, {__index = function(t,i)
	local r,g,b = i > 0.5 and 2 * (1 - i) or 1, i > 0.5 and 1 or 2 * i, 0
	local color = string.format("|cff%02x%02x%02x", r*255, g*255, b*255)
	t[i] = color
	return color
end})


----------------------
--      Anchor      --
----------------------

local anchor = CreateFrame("Frame", nil, UIParent)

local text = anchor:CreateFontString(nil, nil, "GameFontNormalSmall")
text:SetPoint("CENTER")
text:SetText("GoodNewsEveryone")

anchor:SetWidth(text:GetStringWidth() + 8)
anchor:SetHeight(24)

anchor:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16, insets = {left = 5, right = 5, top = 5, bottom = 5}, tile = true, tileSize = 16})
anchor:SetBackdropColor(0.09, 0.09, 0.19, 0.5)
anchor:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)

anchor:EnableMouse(true)
anchor:SetMovable(true)
anchor:SetScript("OnMouseDown", anchor.StartMoving)
anchor:SetScript("OnMouseUp", function(self, button)
	self:StopMovingOrSizing()
	db.point, db.x, db.y = "BOTTOMLEFT", self:GetLeft(), self:GetBottom()
end)

local active, frames, lastframe = {}, {}, anchor
local function OnShow(self) active[self.spell] = self end
local function OnHide(self) active[self.spell] = nil end
local function OnUpdate(self, elap)
	local now = GetTime()
	if now >= self.expires then return self:Hide() end

	local left = math.ceil(self.expires - now)
	local message = self.msg.. (self.stacks > 1 and (" x"..self.stacks) or "").. ((left and left >= 0) and " ("..colors[left / self.duration]..left.."|rs)" or "")
	self.text:SetText(message)
end


-----------------------------
--      Frame factory      --
-----------------------------

local function GetFrame()
	for i,f in pairs(frames) do if not f:IsVisible() then return f end end

	local f = CreateFrame("Frame", nil, UIParent)
	f:SetFrameStrata("HIGH")
	f:SetPoint("TOP", lastframe, "BOTTOM")
	f:SetHeight(20)
	f:SetWidth(250)
	f:Hide()
	f:SetScript("OnShow", OnShow)
	f:SetScript("OnHide", OnHide)
	f:SetScript("OnUpdate", OnUpdate)

	f.text = f:CreateFontString(nil, "OVERLAY")
	f.text:SetFontObject("GameFontNormalLarge")
	f.text:SetPoint("CENTER")
	f.text:SetJustifyH("CENTER")

	table.insert(frames, f)
	lastframe = f
	return f
end


-----------------------------
--      Event Handler      --
-----------------------------

anchor:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, event, ...) end end)
anchor:RegisterEvent("ADDON_LOADED")


function anchor:ADDON_LOADED(event, addon)
	if addon:lower() ~= "goodnewseveryone" then return end

	GoodNewsEveryoneDB = setmetatable(GoodNewsEveryoneDB or {}, {__index = defaults})
	db = GoodNewsEveryoneDB

	anchor:SetPoint(db.point, db.x, db.y)

	local t = {}
	for k,v in pairs(spells) do t[GetSpellInfo(v)] = true end
	spells = t

	self:RegisterEvent("UNIT_AURA")

	self:UnregisterEvent("ADDON_LOADED")
	self.ADDON_LOADED = nil

	self:RegisterEvent("PLAYER_LOGOUT")
end


function anchor:PLAYER_LOGOUT()
	for i,v in pairs(defaults) do if db[i] == v then db[i] = nil end end
end


function anchor:UNIT_AURA(event, unit)
	if unit ~= "player" then return end

	for spellname in pairs(spells) do
		local name, _, icon, count, _, duration, expires = UnitAura("player", spellname)
		if name then
			local f = active[spellname] or GetFrame()
			f.msg, f.spell, f.stacks, f.duration, f.expires = "|T"..icon..":0|t "..spellname, spellname, count, duration, expires
			f:Show()
		elseif active[spellname] then active[spellname]:Hide() end
	end
end
