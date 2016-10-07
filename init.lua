
local myname, ns = ...


ns.dbname, ns.dbdefaults = "GoodNewsEveryoneDB", {
	font = "GameFontNormalLarge",
	playsound = true,
	point = "CENTER",
	showanchor = true,
	x = 0,
	y = 300,
}


function ns.OnLoad()
	-- Do this here because we know it'll happen after all modules have init'd
	ns.BUFF_IDS = nil
end
