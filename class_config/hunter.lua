
local myname, ns = ...


local _, myclass = UnitClass("player")
if myclass ~= "HUNTER" then return end


ns.BUFF_IDS = {
	-- 199522, -- Trick Shot
	223138, -- Marking Targets
	194595, -- Lock and Load
}


ns.DEBUFF_IDS = {
	187131, -- Vulnerable
	185987, -- Hunter's Mark
}
