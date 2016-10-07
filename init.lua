
local myname, ns = ...


ns.dbname, ns.dbdefaults = 'GoodNewsEveryoneDB', {
	point = "CENTER", x = 0, y = 300,
	showanchor = true,
	font = "GameFontNormalLarge",
	playsound = true,
}


function ns.OnLoad()
	-- Do this here because we know it'll happen after all modules have init'd
	ns.BUFF_IDS = nil
end
