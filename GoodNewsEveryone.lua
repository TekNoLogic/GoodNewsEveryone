
----------------------
--      Locals      --
----------------------

local L = setmetatable(GetLocale() == "zhTW" and {["Maelstrom Ready!"] = "氣漩準備完畢!"} or {}, {__index=function(t,i) return i end})
local defaults, db = {point = "CENTER", x = 0, y = 300, showanchor = true, font = "GameFontNormalLarge", playsound = true}

local spells = {
	-- Death Knight
	59052, -- Freezing Fog
	51124, -- Killing Machine

	-- Priest
	33151, -- Surge of Light
	60062, -- Essence of Life
	77487, -- Shadow Bollocks

	-- Paladin
	53569, -- Infusion of Light
	53486, -- The Art of War
	90174, -- Hand of Light

	-- Shaman
	51562, -- Tidal waves
	51528, -- Maelstrom Weapon
	16246, -- Clearcasting

	-- Druid
	16864, -- Omen of Clarity
	48516, -- Eclipse
	48517, -- Eclipse (Solar)
	48518, -- Eclipse (Lunar)
	69369, -- Predator's Swiftness

	-- Hunter
	56342, -- Lock and Load
	53220, -- Improved Steady Shot

	-- Mage
	79683, -- Arcane Missiles!
	11103, -- Impact
	44445, -- Hot Streak
	44543, -- Fingers of Frost
	57761, -- Brain Freeze (buff named "Fireball!")

	-- Warlock
	47258, -- Backdraft
	34935, -- Backlash
	63156, -- Decimation
	47195, -- Eradication
	47245, -- Molten Core
	17941, -- Nightfall (buff name "Shadow Trance")

	-- Warrior
	46916, -- Bloodsurge (buff named "Slam!")
	29723, -- Sudden Death
	46953, -- Sword and Board
}
local active_spell_names = setmetatable({
	[L["Maelstrom Ready!"]] = GetSpellInfo(51528),
}, {__index = function(t,i) return i end})


local eclipse = GetSpellInfo(48516)
local eclipse_wrath, _, ewicon = GetSpellInfo(48517)
local eclipse_sf, _, esficon = GetSpellInfo(48518)
local custom_names = {
	[eclipse_wrath..ewicon] = eclipse.. " (".. GetSpellInfo(5176).. ")",
	[eclipse_sf..esficon] = eclipse.. " (".. GetSpellInfo(2912).. ")",
}

local colors = setmetatable({}, {__index = function(t,i)
	local r,g,b = i > 0.5 and 2 * (1 - i) or 1, i > 0.5 and 1 or 2 * i, 0
	local color = string.format("|cff%02x%02x%02x", r*255, g*255, b*255)
	t[i] = color
	return color
end})

local my_power_type, my_power_max, my_power_value, my_power_name, my_power_icon

----------------------
--      Anchor      --
----------------------

local anchor = CreateFrame("Button", nil, UIParent)

local text = anchor:CreateFontString(nil, nil, "GameFontNormalSmall")
text:SetPoint("CENTER")
text:SetText("Good News Everyone!")

anchor:SetWidth(text:GetStringWidth() + 16)
anchor:SetHeight(24)

anchor:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16, insets = {left = 5, right = 5, top = 5, bottom = 5}, tile = true, tileSize = 16})
anchor:SetBackdropColor(0.09, 0.09, 0.19, 0.5)
anchor:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)

anchor:SetMovable(true)
anchor:RegisterForDrag("LeftButton")
anchor:SetScript("OnDragStart", anchor.StartMoving)
anchor:SetScript("OnDragStop", function(self, button)
	self:StopMovingOrSizing()
	db.point, db.x, db.y = "BOTTOMLEFT", self:GetLeft(), self:GetBottom()
end)

local active, frames, lastframe = {}, {}, anchor
local PULSESCALE, SCALETIME, SHRINKTIME = 1.5, 0.05, 0.2
local function OnShow(self)
	local now = GetTime()
	active[self.spell] = self
	self:SetScale(1)
	self.scaletime, self.shrinktime = now + SCALETIME, now + SCALETIME + SHRINKTIME
	self.text:SetFontObject(db.font)
	self.text:SetText(" ")
	self:SetHeight(self.text:GetStringHeight())
	if db.playsound then PlaySound("RaidBossEmoteWarning") end
end
local function OnHide(self) active[self.spell] = nil end
local function OnUpdate(self, elap)
	local now = GetTime()
	if self.expires and now >= self.expires then return self:Hide() end
	if not self.expires and not self.not_usable and not IsUsableSpell(self.spell) then return self:Hide() end

	local scale = (now <= self.scaletime) and (PULSESCALE - (PULSESCALE-1)*(self.scaletime - now)/SCALETIME) or (now <= self.shrinktime) and (1 + (PULSESCALE-1)*(self.shrinktime - now)/SHRINKTIME) or 1
	self:SetScale(scale)

	if self.expires then
		local left = math.floor(self.expires - now)
		self.text:SetText(self.msg.. (self.stacks > 1 and (" x"..self.stacks) or "").. " ("..colors[left / self.duration]..left.."|rs)")
	else
		self.text:SetText(self.msg.. (self.stacks > 1 and (" x"..self.stacks) or ""))
	end
end


-----------------------------
--      Frame factory      --
-----------------------------

local function GetFrame()
	for i,f in pairs(frames) do if not f:IsVisible() then return f end end

	local f = CreateFrame("Frame", nil, UIParent)
	f:SetFrameStrata("HIGH")
	f:SetPoint("TOP", lastframe, "BOTTOM")
	f:SetWidth(250)
	f:Hide()
	f:SetScript("OnShow", OnShow)
	f:SetScript("OnHide", OnHide)
	f:SetScript("OnUpdate", OnUpdate)

	f.text = f:CreateFontString(nil, nil, db.font)
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

	LibStub("tekKonfig-AboutPanel").new("GoodNewsEveryone", "GoodNewsEveryone")

	anchor:SetPoint(db.point, db.x, db.y)
	if not db.showanchor then anchor:Hide() end

	local t = {}
	for k,v in pairs(spells) do
		local i = GetSpellInfo(v)
		if i then t[i] = true
		else print("Good New Everyone doesn't know spell", v) end
	end
	spells = t

	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("COMBAT_TEXT_UPDATE")

	local _, myclass = UnitClass("player")
	if myclass == "PALADIN" then
		self:RegisterEvent("UNIT_POWER")
		my_power_type, my_power_value, my_power_max = "HOLY_POWER", SPELL_POWER_HOLY_POWER, UnitPowerMax("player", SPELL_POWER_HOLY_POWER)
		my_power_name, _, my_power_icon = GetSpellInfo(85705)
	end

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
			f.msg, f.spell, f.stacks, f.duration, f.expires, f.not_usable = "|T"..icon..":0|t ".. (custom_names[spellname..icon] or spellname), spellname, count, duration, expires
			f:Show()
		elseif active[spellname] then active[spellname]:Hide() end
	end
end


function anchor:COMBAT_TEXT_UPDATE(event, action, name, ...)
	if action ~= "SPELL_ACTIVE" then return end

	name = active_spell_names[name]

	local f = active[name] or GetFrame()
	local _, _, icon = GetSpellInfo(name)
	f.msg, f.spell, f.stacks, f.duration, f.expires, f.not_usable = "|T"..icon..":0|t "..name, name, 1
	f:Show()
end


function anchor:UNIT_POWER(event, unit, power_type, ...)
	if unit ~= "player" or power_type ~= my_power_type then return end
	local charges = UnitPower("player", my_power_value)
	if charges == my_power_max then
		local f = active[my_power_name] or GetFrame()
		f.msg, f.spell, f.stacks, f.not_usable, f.duration, f.expires = "|T"..my_power_icon..":0|t "..my_power_name, my_power_name, 1, true
		f:Show()
	elseif active[my_power_name] then active[my_power_name]:Hide() end
end


GOODNEWS_ANCHOR = anchor
