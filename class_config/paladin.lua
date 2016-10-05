
local myname, ns = ...


local _, myclass = UnitClass("player")
if myclass ~= "PALADIN" then return end


ns.NewPowerModule(85705, "HOLY_POWER", SPELL_POWER_HOLY_POWER)
