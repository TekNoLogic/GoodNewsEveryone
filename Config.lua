

local anchor = GOODNEWS_ANCHOR
GOODNEWS_ANCHOR = nil


local frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
anchor:SetScript("OnClick", function(self) InterfaceOptionsFrame_OpenToCategory(frame) end)
frame.name = "GoodNewsEveryone"
frame:Hide()

frame:SetScript("OnShow", function()
	local GAP = 8
	local tekcheck = LibStub("tekKonfig-Checkbox")

	local title, subtitle = LibStub("tekKonfig-Heading").new(frame, "Good News Everyone!", "I've created a panel that lets you configure this addon!")

	local showanchor = tekcheck.new(frame, nil, "Show anchor", "TOPLEFT", subtitle, "BOTTOMLEFT", -2, -GAP)
	showanchor.tiptext = "Toggle the text anchor."
	showanchor:SetChecked(GoodNewsEveryoneDB.showanchor)
	local checksound = showanchor:GetScript("OnClick")
	showanchor:SetScript("OnClick", function(self)
		checksound(self)
		GoodNewsEveryoneDB.showanchor = not GoodNewsEveryoneDB.showanchor
		if GoodNewsEveryoneDB.showanchor then anchor:Show() else anchor:Hide() end
	end)


	local resetanchor = LibStub("tekKonfig-Button").new_small(frame, "LEFT", showanchor, "RIGHT", 105, 0)
	resetanchor:SetWidth(60) resetanchor:SetHeight(18)
	resetanchor.tiptext = "Click to reset the anchor to it's default position."
	resetanchor:SetText("Reset")
	resetanchor:SetScript("OnClick", function()
		GoodNewsEveryoneDB.point, GoodNewsEveryoneDB.x, GoodNewsEveryoneDB.y = nil
		anchor:ClearAllPoints()
		anchor:SetPoint(GoodNewsEveryoneDB.point, GoodNewsEveryoneDB.x, GoodNewsEveryoneDB.y)
	end)


	local reacttime, reacttimetext, rtcontainer = LibStub("tekKonfig-Slider").new(frame, "Reactive timeout: " .. GoodNewsEveryoneDB.reacttime.. "s", 0, 15, "TOPLEFT", showanchor, "BOTTOMLEFT", GAP, -GAP)
	reacttime.tiptext = "The number of seconds to show 'reactive' abilities."
	reacttime:SetValueStep(1)
	reacttime:SetValue(GoodNewsEveryoneDB.reacttime)
	reacttime:SetScript("OnValueChanged", function(self, newvalue)
		GoodNewsEveryoneDB.reacttime = newvalue
		reacttimetext:SetText("Reactive spell time: " .. newvalue.. "s")
	end)


	frame:SetScript("OnShow", nil)
end)

InterfaceOptions_AddCategory(frame)


----------------------------
--      LDB Launcher      --
----------------------------
--[[
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local dataobj = ldb:GetDataObjectByName("CorkLauncher") or ldb:NewDataObject("CorkLauncher", {type = "launcher", icon = "Interface\\Icons\\INV_Drink_11", tocname = "Cork"})
dataobj.OnClick = function() InterfaceOptionsFrame_OpenToCategory(frame) end
]]
