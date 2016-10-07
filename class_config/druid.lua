
local myname, ns = ...


local _, myclass = UnitClass("player")
if myclass ~= "DRUID" then return end


ns.BUFF_IDS = {
	16864, -- Omen of Clarity
	69369, -- Predator's Swiftness
	16870, -- Clearcasting
}
