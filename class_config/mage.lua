
local myname, ns = ...


local _, myclass = UnitClass("player")
if myclass ~= "MAGE" then return end


ns.BUFF_IDS = {
	79683, -- Arcane Missiles!
	112965, -- Fingers of Frost
	48107, -- Heating Up
	48108, -- Pyroblast!
}


-- Spellsteal
local function HasStealableBuff()
	for i=1,50 do
		local name, _, _, _, _, _, _, _, stealable = UnitAura("target", i, "HELPFUL")
		if not name then return false end
		if stealable then return true end
	end
end


local name, _, icon = GetSpellInfo(30449)
local MSG = ns.GetMsg(name, icon)
local function OnEvent(self, event, unit)
	if event == "UNIT_AURA" and unit ~= "target" then return end

	if HasStealableBuff() then
		local alert = ns.active[name] or ns.GetFrame()
		alert.msg = MSG
		alert.spell = name
		alert.stacks = 1
		alert.duration = nil
		alert.expires = nil
		alert.not_usable = nil
		alert:Show()
	elseif ns.active[name] then
		ns.active[name]:Hide()
	end
end


function ns.OnLoadMage()
	local frame = CreateFrame("Frame")
	frame:SetScript("OnEvent", OnEvent)
	frame:RegisterEvent("UNIT_AURA")
	frame:RegisterEvent("PLAYER_TARGET_CHANGED")
end
