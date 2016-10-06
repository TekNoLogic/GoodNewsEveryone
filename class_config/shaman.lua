
local myname, ns = ...


local _, myclass = UnitClass("player")
if myclass ~= "SHAMAN" then return end


ns.BUFF_IDS = {
  77756, -- Lava surge
}


ns.EXPIRING_DEBUFF_IDS = {
  188389, -- Flame Shock
}
