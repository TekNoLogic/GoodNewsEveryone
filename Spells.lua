
local myname, ns = ...


ns.spells, ns.debuffs = {}, {}
local spells = {
	-- Death Knight
	59052, -- Freezing Fog
	51124, -- Killing Machine

	-- Priest
	60062, -- Essence of Life
	124430, -- Divine Insight
	87160, -- Surge of Darkness

	-- Paladin
	53576, -- Infusion of Light
	85804, -- Selfless Healer

	-- Shaman
	51564, -- Tidal waves

	-- Druid
	16864, -- Omen of Clarity
	69369, -- Predator's Swiftness
	16870, -- Clearcasting

	-- Hunter

	-- Mage
	79683, -- Arcane Missiles!
	112965, -- Fingers of Frost
	48107, -- Heating Up
	48108, -- Pyroblast!

	-- Monk
	116768, -- Combo Breaker: Blackout Kick

	-- Rogue

	-- Warlock
	17941, -- Nightfall (buff name "Shadow Trance")

	-- Warrior
	46953, -- Sword and Board
}
local debuffs = {
}
for k,v in pairs(spells) do
	local i, _, icon = GetSpellInfo(v)
	if i then ns.spells[i] = icon
	else ns.Print("Unknown spell:", v) end
end
for k,v in pairs(debuffs) do
	local i, _, icon = GetSpellInfo(v)
	if i then
		ns.spells[i] = icon
		ns.debuffs[i] = true
	else ns.Print("Unknown spell:", v) end
end

local MAELSTROM_READY = GetLocale() == "zhTW" and "氣漩準備完畢!"
                        or "Maelstrom Ready!"
ns.active_spell_names = setmetatable({
	[MAELSTROM_READY] = GetSpellInfo(51530),
}, {__index = function(t,i) return i end})


local tigerseyebuff, _, tebufficon = GetSpellInfo(116740)
ns.exclude = {
	[tigerseyebuff..tebufficon] = true,
	['+1 Tigereye Brew'] = true,
}
