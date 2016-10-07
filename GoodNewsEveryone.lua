
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

	-- Do this here because we know it'll happen after all modules have init'd
	ns.BUFF_IDS = nil
end


function ns.GetMsg(spellname, icon)
	return "|T"..icon..":0|t ".. spellname
end
