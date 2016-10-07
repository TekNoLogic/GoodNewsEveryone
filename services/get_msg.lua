
local myname, ns = ...


function ns.GetMsg(spellname, icon)
	return "|T"..icon..":0|t ".. spellname
end
