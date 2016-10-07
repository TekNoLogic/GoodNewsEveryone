
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

	-- Druid
	16864, -- Omen of Clarity
	69369, -- Predator's Swiftness
	16870, -- Clearcasting

	-- Mage
	79683, -- Arcane Missiles!
	112965, -- Fingers of Frost
	48107, -- Heating Up
	48108, -- Pyroblast!

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
