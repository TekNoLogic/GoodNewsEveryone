
local myname, ns = ...


ns.dbname, ns.dbdefaults = 'GoodNewsEveryoneDB', {
	point = "CENTER", x = 0, y = 300,
	showanchor = true,
	font = "GameFontNormalLarge",
	playsound = true,
}


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

	local icon = select(3, GetSpellInfo(name)) or ns.spells[name]
	if not icon then return ns.Print('Unknown spell:', name, ...) end

	local f = ns.active[name] or ns.GetFrame()
	f.msg, f.spell, f.stacks = ns.GetMsg(name, icon), name, 1
	f.duration, f.expires, f.not_usable = nil
	f:Show()
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
