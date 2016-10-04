
local myname, ns = ...


ns.dbname, ns.dbdefaults = 'GoodNewsEveryoneDB', {
	point = "CENTER", x = 0, y = 300,
	showanchor = true,
	font = "GameFontNormalLarge",
	playsound = true,
}


local my_power_type, my_power_max, my_power_value, my_power_name, my_power_icon
function ns.OnLoad()
	ns.anchor:SetPoint(ns.db.point, ns.db.x, ns.db.y)
	if not ns.db.showanchor then ns.anchor:Hide() end

	ns.RegisterEvent("UNIT_AURA")
	ns.RegisterEvent("COMBAT_TEXT_UPDATE")

	local _, myclass = UnitClass("player")
	if myclass == "MAGE" then
		ns.RegisterEvent("PLAYER_TARGET_CHANGED")
	else
		ns.PLAYER_TARGET_CHANGED = function() end
	end

	if myclass == "PALADIN" then
		ns.RegisterEvent("UNIT_POWER")
		ns.RegisterEvent("UNIT_MAXPOWER")
		my_power_type = "HOLY_POWER"
		my_power_value = SPELL_POWER_HOLY_POWER
		my_power_max = UnitPowerMax("player", SPELL_POWER_HOLY_POWER)
		my_power_name, _, my_power_icon = GetSpellInfo(85705)
	end

	ns.UNIT_AURA('UNIT_AURA', 'player')
end


function ns.GetMsg(spellname, icon)
	return "|T"..icon..":0|t ".. spellname
end


function ns.UNIT_AURA(event, unit)
	if unit == "target" then return ns.PLAYER_TARGET_CHANGED() end
	if unit ~= "player" then return end

	for spellname in pairs(ns.spells) do
		local filter = ns.debuffs[spellname] and 'HARMFUL' or 'HELPFUL'
		local name, _, icon, count, _, duration, expires =
			UnitAura("player", spellname, nil, filter)

		if name and not ns.exclude[spellname..icon] then
			local f = ns.active[spellname] or ns.GetFrame()
			f.spell, f.stacks = spellname, count
			f.msg = ns.GetMsg(spellname, icon)
			f.duration = duration > 0 and duration or nil
			f.expires  =  expires > 0 and  expires or nil
			f:Show()
		elseif ns.active[spellname] then ns.active[spellname]:Hide() end
	end
end


function ns.COMBAT_TEXT_UPDATE(event, action, name, ...)
	if action ~= "SPELL_ACTIVE" or ns.exclude[name] then return end

	name = name:gsub("!$", "")
	name = ns.active_spell_names[name]

	local icon = select(3, GetSpellInfo(name)) or ns.spells[name]
	if not icon then return ns.Print('Unknown spell:', name, ...) end

	local f = ns.active[name] or ns.GetFrame()
	f.msg, f.spell, f.stacks = ns.GetMsg(name, icon), name, 1
	f.duration, f.expires, f.not_usable = nil
	f:Show()
end


function ns.UNIT_MAXPOWER()
	my_power_max = UnitPowerMax("player", SPELL_POWER_HOLY_POWER)
end


function ns.UNIT_POWER(event, unit, power_type, ...)
	if unit ~= "player" or power_type ~= my_power_type then return end
	local charges = UnitPower("player", my_power_value)
	if charges == my_power_max then
		local f = ns.active[my_power_name] or ns.GetFrame()
		f.msg, f.spell = ns.GetMsg(my_power_name, my_power_icon), my_power_name
		f.stacks, f.not_usable = 1, true
		f.duration, f.expires = nil
		f:Show()
	elseif ns.active[my_power_name] then ns.active[my_power_name]:Hide() end
end


local function HasStealableBuff()
	for i=1,50 do
		local name, _, _, _, _, _, _, _, stealable = UnitAura("target", i, "HELPFUL")
		if not name then return false end
		if stealable then return true end
	end
end


-- Spellsteal
local name, _, icon = GetSpellInfo(30449)
function ns.PLAYER_TARGET_CHANGED()
	if HasStealableBuff() then
		local f = ns.active[name] or ns.GetFrame()
		f.msg, f.spell, f.stacks = ns.GetMsg(name, icon), name, 1
		f.duration, f.expires, f.not_usable = nil
		f:Show()
	elseif ns.active[name] then
		ns.active[name]:Hide()
	end
end
