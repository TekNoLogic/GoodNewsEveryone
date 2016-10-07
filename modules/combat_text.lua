
local myname, ns = ...


local EXCLUDE = {}
local frame = CreateFrame("Frame")
frame:SetScript("OnEvent", function(self, event, action, name, ...)
	if action ~= "SPELL_ACTIVE" then return end

	name = name:gsub("!$", "")
	if EXCLUDE[name] then return end

	local _, _, icon = GetSpellInfo(name)
	if not icon then return ns.Print("Unknown spell activation:", name, ...) end

	local f = ns.active[name] or ns.GetFrame()
	f.msg, f.spell, f.stacks = ns.GetMsg(name, icon), name, 1
	f.duration, f.expires, f.not_usable = nil
	f:Show()
end)
frame:RegisterEvent("COMBAT_TEXT_UPDATE")


function ns.OnLoadCombatText()
	if ns.BUFF_IDS then
		for k,v in pairs(ns.BUFF_IDS) do
			local i, _, icon = GetSpellInfo(v)
			if i then
				EXCLUDE[i] = icon
			end
		end
	end
end
