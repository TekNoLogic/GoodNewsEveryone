
local myname, ns = ...


if AddonLoader and AddonLoader.RemoveInterfaceOptions then
	AddonLoader:RemoveInterfaceOptions("GoodNewsEveryone")
end


local frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
ns.BaseConfig = "GoodNewsEveryone"
ns.config_frame = frame
frame.name = "GoodNewsEveryone"
frame:Hide()


function ns.OnLoadConfig()
	ns.anchor:SetScript("OnClick", function(self)
		InterfaceOptionsFrame_OpenToCategory(frame)
	end)
end


frame:SetScript("OnShow", function(self)
	local GAP, EDGEGAP = 8, 16
	local tekcheck = LibStub("tekKonfig-Checkbox")

	local title, subtitle = LibStub("tekKonfig-Heading").new(self, "Good News Everyone!", "I've created a panel that lets you configure this addon!")

	local showanchor = tekcheck.new(self, nil, "Show anchor", "TOPLEFT", subtitle, "BOTTOMLEFT", -2, -GAP)
	showanchor.tiptext = "Toggle the text anchor."
	showanchor:SetChecked(ns.db.showanchor)
	local checksound = showanchor:GetScript("OnClick")
	showanchor:SetScript("OnClick", function(self)
		checksound(self)
		ns.db.showanchor = not ns.db.showanchor
		if ns.db.showanchor then ns.anchor:Show()
		else ns.anchor:Hide() end
	end)

	local resetanchor = LibStub("tekKonfig-Button").new_small(self, "LEFT", showanchor, "RIGHT", 105, 0)
	resetanchor:SetWidth(60) resetanchor:SetHeight(18)
	resetanchor.tiptext = "Click to reset the anchor to it's default position."
	resetanchor:SetText("Reset")
	resetanchor:SetScript("OnClick", function()
		ns.db.point, ns.db.x, ns.db.y = nil
		ns.anchor:ClearAllPoints()
		ns.anchor:SetPoint(ns.db.point, ns.db.x, ns.db.y)
	end)


	local playsound = tekcheck.new(self, nil, "Play sound", "TOPLEFT", showanchor, "BOTTOMLEFT", 0, -GAP)
	playsound.tiptext = "Play sound when new events trigger."
	playsound:SetChecked(ns.db.playsound)
	local checksound = playsound:GetScript("OnClick")
	playsound:SetScript("OnClick", function(self)
		checksound(self)
		ns.db.playsound = not ns.db.playsound
	end)


	local group = LibStub("tekKonfig-Group").new(self, "Font")
	group:SetPoint("TOP", playsound, "BOTTOM", 0, -16)
	group:SetPoint("LEFT", 16, 0)
	group:SetPoint("RIGHT", self, "CENTER", -16, 0)


	local anchor
	local height = 0
	local FONTS = {
		"GameFontNormal",
		"GameFontNormalLarge",
		"GameFontNormalHuge",
		"CombatTextFont",
		"BossEmoteNormalHuge",
	}
	for i,name in ipairs(FONTS) do
		local row = ns.NewConfigFontRow(group, name)
		if i == 1 then
			row:SetPoint("TOP", group, 0, -GAP)
		else
			row:SetPoint("TOP", anchor, "BOTTOM")
		end
		row:SetPoint("LEFT", GAP, 0)
		row:SetPoint("RIGHT", -GAP, 0)

		height = height + row:GetHeight()
		anchor = row
	end

	group:SetHeight(height + GAP*2)

	self:SetScript("OnShow", nil)
	ns.NewConfigFontRow = nil
end)


InterfaceOptions_AddCategory(frame)
