
local myname, ns = ...


local _, myclass = UnitClass("player")
if myclass ~= "SHAMAN" then return end


ns.EXPIRING_DEBUFF_IDS = {
  188389, -- Flame Shock
}
