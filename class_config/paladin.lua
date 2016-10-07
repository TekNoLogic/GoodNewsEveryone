
local myname, ns = ...


local _, myclass = UnitClass("player")
if myclass ~= "PALADIN" then return end


ns.NewPowerModule(85705, "HOLY_POWER", SPELL_POWER_HOLY_POWER)


ns.BUFF_IDS = {
	53576, -- Infusion of Light
	85804, -- Selfless Healer
}
