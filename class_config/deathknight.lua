
local myname, ns = ...


local _, myclass = UnitClass("player")
if myclass ~= "DEATHKNIGHT" then return end


ns.BUFF_IDS = {
	59052, -- Freezing Fog
	51124, -- Killing Machine
}
