
local myname, ns = ...


local DEBUFFS = {}
local pending = {}


local function Show(debuff, icon, count, duration, expires)
	if ns.active[debuff] then return end

	local alert = ns.active[debuff] or ns.GetFrame()
	alert.spell = debuff
	alert.stacks = count
	alert.msg = ns.GetMsg(debuff, icon)
	alert.duration = duration > 0 and duration or nil
	alert.expires = expires
	alert:Show()
end


local function Scan()
	local now = GetTime()
	for key,time in pairs(pending) do
		if time >= now then pending[key] = nil end
	end

	for debuff in pairs(DEBUFFS) do
		local name, _, icon, count, _, duration, expires =
			UnitAura("target", debuff, nil, "HARMFUL")

		if name then
			if (expires - now) <= 5 then
				Show(debuff, icon, count, duration, expires)
			else
				local key = debuff.. expires
				if not pending[key] then
				 	pending[key] = expires
					C_Timer.After(duration - 5, Scan)
				end
			end
		elseif ns.active[debuff] then
			ns.active[debuff]:Hide()
		end
	end
end


local function OnEvent(self, event, unit, ...)
	if event == "PLAYER_TARGET_CHANGED" then Scan() end
	if event == "UNIT_AURA" and unit == "target" then Scan() end
end


function ns.OnLoadDebuffs()
	if not ns.EXPIRING_DEBUFF_IDS then return end

	for k,v in pairs(ns.EXPIRING_DEBUFF_IDS) do
		local i, _, icon = GetSpellInfo(v)
		if i then
			DEBUFFS[i] = icon
		else
			ns.Print("Unknown debuff:", v)
		end
	end

	ns.EXPIRING_DEBUFF_IDS = nil

	local frame = CreateFrame("Frame")
	frame:RegisterEvent("UNIT_AURA")
	frame:RegisterEvent("PLAYER_TARGET_CHANGED")
	frame:SetScript("OnEvent", OnEvent)
end
