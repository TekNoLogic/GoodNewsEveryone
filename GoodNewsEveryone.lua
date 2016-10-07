
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
	ns.UNIT_AURA("UNIT_AURA", "player")

	-- Do this here because we know it'll happen after all modules have init'd
	ns.BUFF_IDS = nil
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
end
