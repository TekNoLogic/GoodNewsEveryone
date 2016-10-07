
local myname, ns = ...


local _, myclass = UnitClass("player")
if myclass ~= "WARRIOR" then return end


ns.BUFF_IDS = {
	46953, -- Sword and Board
}
