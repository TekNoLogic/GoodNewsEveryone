
local myname, ns = ...


local DEBUFFS = {}


local function GetMsg(spellname, icon)
	return "|T"..icon..":0|t ".. spellname
end


local function OnEvent(self, event, unit)
	if unit ~= "target" then return end

	for spellname in pairs(DEBUFFS) do
		local name, _, icon, count, _, duration, expires =
			UnitAura("target", spellname, nil, "HARMFUL")

		if name then
			local f = ns.active[spellname] or ns.GetFrame()
			f.spell, f.stacks = spellname, count
			f.msg = GetMsg(spellname, icon)
			f.duration = duration > 0 and duration or nil
			f.expires  =  expires > 0 and  expires or nil
			f:Show()
		elseif
			ns.active[spellname] then ns.active[spellname]:Hide()
		end
	end
end


function ns.OnLoadDebuffs()
	if not ns.DEBUFF_IDS then return end

	for k,v in pairs(ns.DEBUFF_IDS) do
		local i, _, icon = GetSpellInfo(v)
		if i then
			DEBUFFS[i] = icon
		else
			ns.Print("Unknown spell:", v)
		end
	end

	ns.DEBUFF_IDS = nil

	local frame = CreateFrame("Frame")
	frame:RegisterEvent("UNIT_AURA")
	frame:SetScript("OnEvent", OnEvent)
end
