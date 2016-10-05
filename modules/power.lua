
local myname, ns = ...


local my_power_type, my_power_max, my_power_value, my_power_name, my_power_icon


local function UNIT_MAXPOWER()
	my_power_max = UnitPowerMax("player", my_power_value)
end


local function UNIT_POWER(event, unit, power_type, ...)
	if unit ~= "player" or power_type ~= my_power_type then return end

	if UnitPower("player", my_power_value) == my_power_max then
		local alert = ns.active[my_power_name] or ns.GetFrame()
		alert.msg = ns.GetMsg(my_power_name, my_power_icon)
		alert.spell = my_power_name
		alert.stacks = 1
		alert.not_usable = true
		alert.duration = nil
		alert.expires = nil
		alert:Show()
		print(alert)
		TEKALERT = alert
	elseif ns.active[my_power_name] then
		ns.active[my_power_name]:Hide()
	end
end


function ns.NewPowerModule(spell_id, power_type, power_value)
	ns.RegisterEvent("UNIT_POWER", UNIT_POWER)
	ns.RegisterEvent("UNIT_MAXPOWER", UNIT_MAXPOWER)
	my_power_type = power_type
	my_power_value = power_value
	my_power_max = UnitPowerMax("player", power_value)
	my_power_name, _, my_power_icon = GetSpellInfo(spell_id)
end
