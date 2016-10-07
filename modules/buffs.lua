
local myname, ns = ...


local BUFFS = {}


local function OnEvent(self, event, unit)
	if unit ~= "player" then return end

	for buff in pairs(BUFFS) do
		local name, _, icon, count, _, duration, expires =
			UnitAura("player", buff, nil, "HELPFUL")

		if name then
			local f = ns.active[buff] or ns.GetFrame()
			f.spell, f.stacks = buff, count
			f.msg = ns.GetMsg(buff, icon)
			f.duration = duration > 0 and duration or nil
			f.expires  =  expires > 0 and  expires or nil
			f:Show()
		elseif ns.active[buff] then ns.active[buff]:Hide() end
	end
end


function ns.OnLoadBuffs()
	if not ns.BUFF_IDS then return end

	for k,v in pairs(ns.BUFF_IDS) do
		local i, _, icon = GetSpellInfo(v)
		if i then
			BUFFS[i] = icon
		else
			ns.Print("Unknown buff:", v)
		end
	end

	local frame = CreateFrame("Frame")
	frame:RegisterEvent("UNIT_AURA")
	frame:SetScript("OnEvent", OnEvent)

	OnEvent(frame, "UNIT_AURA", "player")
end
