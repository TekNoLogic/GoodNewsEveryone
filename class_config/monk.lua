
local myname, ns = ...


local _, myclass = UnitClass("player")
if myclass ~= "MONK" then return end


ns.BUFF_IDS = {
	116768, -- Combo Breaker: Blackout Kick
}
