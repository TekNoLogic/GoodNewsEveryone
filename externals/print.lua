
local myname, ns = ...


local title = "|cFF33FF99".. GetAddOnMetadata(myname, "Title").. "|r:"
function ns.Print(...) print(title, ...) end
