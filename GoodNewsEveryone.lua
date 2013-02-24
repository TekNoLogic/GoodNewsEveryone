
local myname, ns = ...


----------------------
--      Locals      --
----------------------

local defaults = {point = "CENTER", x = 0, y = 300, showanchor = true, font = "GameFontNormalLarge", playsound = true}
local my_power_type, my_power_max, my_power_value, my_power_name, my_power_icon
local anchor = ns.anchor


-----------------------------
--      Event Handler      --
-----------------------------

anchor:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, event, ...) end end)
anchor:RegisterEvent("ADDON_LOADED")


function anchor:ADDON_LOADED(event, addon)
	if addon:lower() ~= "goodnewseveryone" then return end

	GoodNewsEveryoneDB = setmetatable(GoodNewsEveryoneDB or {}, {__index = defaults})
	ns.db = GoodNewsEveryoneDB

	LibStub("tekKonfig-AboutPanel").new("GoodNewsEveryone", "GoodNewsEveryone")

	anchor:SetPoint(ns.db.point, ns.db.x, ns.db.y)
	if not ns.db.showanchor then anchor:Hide() end

	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("COMBAT_TEXT_UPDATE")

	local _, myclass = UnitClass("player")
	if myclass == "PALADIN" then
		self:RegisterEvent("UNIT_POWER")
		self:RegisterEvent("UNIT_MAXPOWER")
		my_power_type, my_power_value, my_power_max = "HOLY_POWER", SPELL_POWER_HOLY_POWER, UnitPowerMax("player", SPELL_POWER_HOLY_POWER)
		my_power_name, _, my_power_icon = GetSpellInfo(85705)
	end

	self:UNIT_AURA('UNIT_AURA', 'player')

	self:UnregisterEvent("ADDON_LOADED")
	self.ADDON_LOADED = nil

	self:RegisterEvent("PLAYER_LOGOUT")
end


function anchor:PLAYER_LOGOUT()
	for i,v in pairs(defaults) do if ns.db[i] == v then ns.db[i] = nil end end
end


function anchor:UNIT_AURA(event, unit)
	if unit ~= "player" then return end

	for spellname in pairs(ns.spells) do
		local filter = ns.debuffs[spellname] and 'HARMFUL' or 'HELPFUL'
		local name, _, icon, count, _, duration, expires = UnitAura("player", spellname, nil, filter)
		if name and not ns.exclude[spellname..icon] then
			local f = ns.active[spellname] or ns.GetFrame()
			f.spell, f.stacks, f.not_usable = spellname, count, ns.unusable[name]
			f.msg = "|T"..icon..":0|t ".. (ns.custom_names[spellname..icon] or spellname)
			f.duration = duration > 0 and duration or nil
			f.expires  =  expires > 0 and  expires or nil
			f:Show()
		elseif ns.active[spellname] then ns.active[spellname]:Hide() end
	end
end


function anchor:COMBAT_TEXT_UPDATE(event, action, name, ...)
	if action ~= "SPELL_ACTIVE" then return end

	name = ns.active_spell_names[name]

	local f = ns.active[name] or ns.GetFrame()
	local _, _, icon = GetSpellInfo(name)
	f.msg, f.spell, f.stacks, f.duration, f.expires, f.not_usable = "|T"..icon..":0|t "..name, name, 1
	f:Show()
end


function anchor:UNIT_MAXPOWER()
	my_power_max = UnitPowerMax("player", SPELL_POWER_HOLY_POWER)
end


function anchor:UNIT_POWER(event, unit, power_type, ...)
	if unit ~= "player" or power_type ~= my_power_type then return end
	local charges = UnitPower("player", my_power_value)
	if charges == my_power_max then
		local f = ns.active[my_power_name] or ns.GetFrame()
		f.msg, f.spell, f.stacks, f.not_usable, f.duration, f.expires = "|T"..my_power_icon..":0|t "..my_power_name, my_power_name, 1, true
		f:Show()
	elseif ns.active[my_power_name] then ns.active[my_power_name]:Hide() end
end
