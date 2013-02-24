
local myname, ns = ...


ns.spells, ns.debuffs = {}, {}
local spells = {
	-- Death Knight
	59052, -- Freezing Fog
	51124, -- Killing Machine

	-- Priest
	60062, -- Essence of Life
	77487, -- Shadow Bollocks
	124430, -- Divine Insight

	-- Paladin
	53576, -- Infusion of Light
	87138, -- The Art of War
	90174, -- Hand of Light
	88819, -- Daybreak
	85804, -- Selfless Healer

	-- Shaman
	51564, -- Tidal waves
	51530, -- Maelstrom Weapon
	16246, -- Clearcasting

	-- Druid
	16864, -- Omen of Clarity
	48517, -- Eclipse (Solar)
	48518, -- Eclipse (Lunar)
	69369, -- Predator's Swiftness

	-- Hunter
	56343, -- Lock and Load
	53220, -- Improved Steady Shot

	-- Mage
	79683, -- Arcane Missiles!
	112965, -- Fingers of Frost
	57761, -- Brain Freeze (buff named "Fireball!")
	48107, -- Heating Up
	48108, -- Pyroblast!

	-- Monk
	125195, -- Tigereye Brew

	-- Warlock
	117896, -- Backdraft
	108563, -- Backlash
	108869, -- Decimation
	122351, -- Molten Core
	17941, -- Nightfall (buff name "Shadow Trance")

	-- Warrior
	46916, -- Bloodsurge (buff named "Slam!")
	29725, -- Sudden Death
	46953, -- Sword and Board
}
local debuffs = {
	-- Mage
	114664, -- Arcane Charge
}
for k,v in pairs(spells) do
	local i = GetSpellInfo(v)
	if i then ns.spells[i] = true
	else print("GoodNewsEveryone doesn't know spell", v) end
end
for k,v in pairs(debuffs) do
	local i = GetSpellInfo(v)
	if i then
		ns.spells[i] = true
		ns.debuffs[i] = true
	else print("GoodNewsEveryone doesn't know spell", v) end
end

local MAELSTROM_READY = GetLocale() == "zhTW" and "氣漩準備完畢!"
                        or "Maelstrom Ready!"
ns.active_spell_names = setmetatable({
	[MAELSTROM_READY] = GetSpellInfo(51530),
}, {__index = function(t,i) return i end})


local tigerseyebuff, _, tebufficon = GetSpellInfo(116740)
ns.exclude = {
	[tigerseyebuff..tebufficon] = true,
}


local eclipse = GetSpellInfo(80745)
local eclipse_wrath, _, ewicon = GetSpellInfo(48517)
local eclipse_sf, _, esficon = GetSpellInfo(48518)
ns.custom_names, ns.unusable = {
	[eclipse_wrath..ewicon] = eclipse.. " (".. GetSpellInfo(5176).. ")",
	[eclipse_sf..esficon] = eclipse.. " (".. GetSpellInfo(2912).. ")",
}, {
	[eclipse_wrath] = true,
	[eclipse_sf]    = true,
}

