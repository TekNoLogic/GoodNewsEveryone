
local myname, ns = ...


if not ns.BaseConfig and AddonLoader and AddonLoader.RemoveInterfaceOptions then
	AddonLoader:RemoveInterfaceOptions(myname)
end


local frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
frame.name = ns.BaseConfig and "About" or myname
frame.parent = ns.BaseConfig
frame:Hide()
frame:SetScript("OnShow", function(frame)
	local fields = {"Version", "Author", "X-Category", "X-License", "X-Email", "X-Website", "X-Credits"}
	local haseditbox = {["Version"] = true, ["X-Website"] = true, ["X-Email"] = true}
	local function HideTooltip() GameTooltip:Hide() end
	local function ShowTooltip(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
		GameTooltip:SetText("Click and press Ctrl-C to copy")
	end

	local editbox = CreateFrame('EditBox', nil, UIParent)
	editbox:Hide()
	editbox:SetAutoFocus(true)
	editbox:SetHeight(32)
	editbox:SetFontObject('GameFontHighlightSmall')

	local left = editbox:CreateTexture(nil, "BACKGROUND")
	left:SetWidth(8) left:SetHeight(20)
	left:SetPoint("LEFT", -5, 0)
	left:SetTexture("Interface\\Common\\Common-Input-Border")
	left:SetTexCoord(0, 0.0625, 0, 0.625)

	local right = editbox:CreateTexture(nil, "BACKGROUND")
	right:SetWidth(8) right:SetHeight(20)
	right:SetPoint("RIGHT", 0, 0)
	right:SetTexture("Interface\\Common\\Common-Input-Border")
	right:SetTexCoord(0.9375, 1, 0, 0.625)

	local center = editbox:CreateTexture(nil, "BACKGROUND")
	center:SetHeight(20)
	center:SetPoint("RIGHT", right, "LEFT", 0, 0)
	center:SetPoint("LEFT", left, "RIGHT", 0, 0)
	center:SetTexture("Interface\\Common\\Common-Input-Border")
	center:SetTexCoord(0.0625, 0.9375, 0, 0.625)

	editbox:SetScript("OnEscapePressed", editbox.ClearFocus)
	editbox:SetScript("OnEnterPressed", editbox.ClearFocus)
	editbox:SetScript("OnEditFocusLost", editbox.Hide)
	editbox:SetScript("OnEditFocusGained", editbox.HighlightText)
	editbox:SetScript("OnTextChanged", function(self)
		self:SetText(self:GetParent().val)
		self:HighlightText()
	end)

	local function OpenEditbox(self)
		editbox:SetText(self.val)
		editbox:SetParent(self)
		editbox:SetPoint("LEFT", self)
		editbox:SetPoint("RIGHT", self)
		editbox:Show()
	end


	local notes = GetAddOnMetadata(myname, "Notes")

	local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText((ns.BaseConfig or myname).." - About")

	local subtitle = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	subtitle:SetHeight(32)
	subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
	subtitle:SetPoint("RIGHT", parent, -32, 0)
	subtitle:SetNonSpaceWrap(true)
	subtitle:SetJustifyH("LEFT")
	subtitle:SetJustifyV("TOP")
	subtitle:SetText(notes)

	local anchor
	for _,field in pairs(fields) do
		local val = GetAddOnMetadata(myname, field)
		if val then
			local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
			title:SetWidth(75)
			if not anchor then title:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", -2, -8)
			else title:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -6) end
			title:SetJustifyH("RIGHT")
			title:SetText(field:gsub("X%-", ""))

			local detail = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
			detail:SetPoint("LEFT", title, "RIGHT", 4, 0)
			detail:SetPoint("RIGHT", -16, 0)
			detail:SetJustifyH("LEFT")
			detail:SetText((haseditbox[field] and "|cff9999ff" or "").. val)

			if haseditbox[field] then
				local button = CreateFrame("Button", nil, frame)
				button:SetAllPoints(detail)
				button.val = val
				button:SetScript("OnClick", OpenEditbox)
				button:SetScript("OnEnter", ShowTooltip)
				button:SetScript("OnLeave", HideTooltip)
			end

			anchor = title
		end
	end

	frame:SetScript("OnShow", nil)
end)

InterfaceOptions_AddCategory(frame)
