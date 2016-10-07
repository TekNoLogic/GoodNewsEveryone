
local myname, ns = ...


local _, myclass = UnitClass("player")
if myclass ~= "WARLOCK" then return end


ns.BUFF_IDS = {
	17941, -- Nightfall (buff name "Shadow Trance")
}
