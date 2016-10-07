
local myname, ns = ...


local anchor = CreateFrame("Button", nil, UIParent)
ns.anchor = anchor

local text = anchor:CreateFontString(nil, nil, "GameFontNormalSmall")
text:SetPoint("CENTER")
text:SetText("Good News Everyone!")

anchor:SetWidth(text:GetStringWidth() + 16)
anchor:SetHeight(24)

anchor:SetBackdrop({
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16,
	insets = {left = 5, right = 5, top = 5, bottom = 5},
	tile = true, tileSize = 16
})
anchor:SetBackdropColor(0.09, 0.09, 0.19, 0.5)
anchor:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)

anchor:SetMovable(true)
anchor:RegisterForDrag("LeftButton")
anchor:SetScript("OnDragStart", anchor.StartMoving)
anchor:SetScript("OnDragStop", function(self, button)
	self:StopMovingOrSizing()
	ns.db.point, ns.db.x, ns.db.y = "BOTTOMLEFT", self:GetLeft(), self:GetBottom()
end)


function ns.OnLoadAnchor()
	ns.anchor:SetPoint(ns.db.point, ns.db.x, ns.db.y)
	if not ns.db.showanchor then ns.anchor:Hide() end
end
