
local myname, ns = ...


local GAP = 8
local rows = {}


local function OnClick(self)
	ns.db.font = rows[self]
	for row in pairs(rows) do row:SetChecked(row == self) end
end


function ns.NewConfigFontRow(parent, name)
	local row = CreateFrame("CheckButton", nil, parent)

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
	row:SetChecked(name == ns.db.font)
	row:SetScript("OnClick", OnClick)

	rows[row] = name

	return row
end
