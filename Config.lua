

local anchor = GOODNEWS_ANCHOR
GOODNEWS_ANCHOR = nil


local frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
anchor:SetScript("OnClick", function(self) InterfaceOptionsFrame_OpenToCategory(frame) end)
frame.name = "GoodNewsEveryone"
frame:Hide()

frame:SetScript("OnShow", function(self)
	local GAP, EDGEGAP = 8, 16
	local tekcheck = LibStub("tekKonfig-Checkbox")

	local title, subtitle = LibStub("tekKonfig-Heading").new(self, "Good News Everyone!", "I've created a panel that lets you configure this addon!")

	local showanchor = tekcheck.new(self, nil, "Show anchor", "TOPLEFT", subtitle, "BOTTOMLEFT", -2, -GAP)
	showanchor.tiptext = "Toggle the text anchor."
	showanchor:SetChecked(GoodNewsEveryoneDB.showanchor)
	local checksound = showanchor:GetScript("OnClick")
	showanchor:SetScript("OnClick", function(self)
		checksound(self)
		GoodNewsEveryoneDB.showanchor = not GoodNewsEveryoneDB.showanchor
		if GoodNewsEveryoneDB.showanchor then anchor:Show() else anchor:Hide() end
	end)

	local resetanchor = LibStub("tekKonfig-Button").new_small(self, "LEFT", showanchor, "RIGHT", 105, 0)
	resetanchor:SetWidth(60) resetanchor:SetHeight(18)
	resetanchor.tiptext = "Click to reset the anchor to it's default position."
	resetanchor:SetText("Reset")
	resetanchor:SetScript("OnClick", function()
		GoodNewsEveryoneDB.point, GoodNewsEveryoneDB.x, GoodNewsEveryoneDB.y = nil
		anchor:ClearAllPoints()
		anchor:SetPoint(GoodNewsEveryoneDB.point, GoodNewsEveryoneDB.x, GoodNewsEveryoneDB.y)
	end)


	local playsound = tekcheck.new(self, nil, "Play sound", "TOPLEFT", showanchor, "BOTTOMLEFT", 0, -GAP)
	playsound.tiptext = "Play sound when new events trigger."
	playsound:SetChecked(GoodNewsEveryoneDB.playsound)
	local checksound = playsound:GetScript("OnClick")
	playsound:SetScript("OnClick", function(self)
		checksound(self)
		GoodNewsEveryoneDB.playsound = not GoodNewsEveryoneDB.playsound
	end)


	local group = LibStub("tekKonfig-Group").new(self, "Font")
	group:SetPoint("TOP", playsound, "BOTTOM", 0, -16)
	group:SetPoint("LEFT", 16, 0)
	group:SetPoint("RIGHT", -16, 0)


	local anchor, rows, height = group, {}, 0
	local function OnClick(self)
		GoodNewsEveryoneDB.font = self.font
		for _,row in pairs(rows) do row:SetChecked(row == self) end
	end
	for i,name in ipairs{"GameFontNormal", "GameFontNormalLarge", "GameFontNormalHuge", "CombatTextFont", "BossEmoteNormalHuge"} do
		local row = CreateFrame("CheckButton", nil, group)
		row:SetPoint("TOP", anchor, i == 1 and "TOP" or "BOTTOM", 0, i == 1 and -GAP or 0)
		row:SetPoint("LEFT", GAP, 0)
		row:SetPoint("RIGHT", -GAP, 0)

		row:SetChecked(name == GoodNewsEveryoneDB.font)
		row:SetScript("OnClick", OnClick)

		local highlight = row:CreateTexture()
		highlight:SetTexture("Interface\\HelpFrame\\HelpFrameButton-Highlight")
		highlight:SetTexCoord(0, 1, 0, 0.578125)
		highlight:SetAllPoints()
		row:SetHighlightTexture(highlight)
		row:SetCheckedTexture(highlight)

		local text = row:CreateFontString(nil, nil, name)
		text:SetPoint("LEFT", row)
		text:SetPoint("RIGHT", row)
		text:SetText(name)

		row:SetHeight(text:GetStringHeight() + GAP)
		height = height + text:GetStringHeight() + GAP

		table.insert(rows, row)
		anchor = row
		row.font = name
	end

	group:SetHeight(height + GAP*2)

	self:SetScript("OnShow", nil)
end)

InterfaceOptions_AddCategory(frame)


----------------------------
--      LDB Launcher      --
----------------------------

local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local dataobj = ldb:GetDataObjectByName("GoodNewsEveryone") or ldb:NewDataObject("GoodNewsEveryone", {type = "launcher", icon = "Interface\\AddOns\\GoodNewsEveryone\\icon", tocname = "GoodNewsEveryone"})
dataobj.OnClick = function() InterfaceOptionsFrame_OpenToCategory(frame) end

