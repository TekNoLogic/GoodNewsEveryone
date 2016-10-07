
local myname, ns = ...


function ns.OnLoadLDBLauncher()
	local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
	local dataobj = ldb:GetDataObjectByName("GoodNewsEveryone")
	dataobj = dataobj or ldb:NewDataObject("GoodNewsEveryone", {
		type = "launcher",
		icon = "Interface\\AddOns\\GoodNewsEveryone\\icon",
		tocname = "GoodNewsEveryone"
	})

	function dataobj.OnClick()
		InterfaceOptionsFrame_OpenToCategory(ns.config_frame)
	end
end
