
local myname, ns = ...


local SCALETIME = 0.05 -- duration of the scale up from 1 to 1.5
local SHRINKTIME = 0.2 -- duration of the scale down from 1.5 to 1
local parents = {}
local elapsed = {}


local function OnShow(self)
	elapsed[self] = 0
	parents[self]:SetScale(1)
end


local function GetScale(time)
	local percent = 0

	if time < SCALETIME then
		percent = time / SCALETIME
	elseif time <= (SHRINKTIME + SCALETIME) then
		percent = (SHRINKTIME + SCALETIME - time) / SHRINKTIME
	end

	return 1 + percent * 0.5
end


local function OnUpdate(self, tick)
	elapsed[self] = elapsed[self] + tick

	if elapsed[self] >= (SHRINKTIME + SCALETIME) then
		parents[self]:SetScale(1)
		return self:Hide()
	end

	parents[self]:SetScale(GetScale(elapsed[self]))
end


function ns.CreateAlertScaler(parent)
	local frame = CreateFrame("Frame", nil, parent)
	frame:Hide()
	frame:SetScript("OnShow", OnShow)
	frame:SetScript("OnUpdate", OnUpdate)
	parents[frame] = parent
	return frame
end
