
local myname, ns = ...


local _, myclass = UnitClass("player")
if myclass ~= "HUNTER" then return end


ns.DEBUFF_IDS = {
	187131, -- Vulnerable
	185987, -- Hunter's Mark
}
