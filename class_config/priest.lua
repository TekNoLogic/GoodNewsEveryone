
local myname, ns = ...


local _, myclass = UnitClass("player")
if myclass ~= "PRIEST" then return end


ns.BUFF_IDS = {
	60062, -- Essence of Life
	124430, -- Divine Insight
	87160, -- Surge of Darkness
}
