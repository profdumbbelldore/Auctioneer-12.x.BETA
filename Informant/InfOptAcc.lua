--[[
	Informant - An addon for World of Warcraft that shows pertinent information about
	an item in a tooltip when you hover over the item in the game.
	Version: <%version%> (<%codename%>)
	Revision: $Id$
	URL: http://auctioneeraddon.com/dl/Informant/

	Tooltip handler. Assumes the responsibility of filling the tooltip
	with the user-selected information

	License:
		This program is free software; you can redistribute it and/or
		modify it under the terms of the GNU General Public License
		as published by the Free Software Foundation; either version 2
		of the License, or (at your option) any later version.

		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.

		You should have received a copy of the GNU General Public License
		along with this program(see GPL.txt); if not, write to the Free Software
		Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
]]

local addonName, _ = ... -- return addon name dynamically

--[[
	This section is for loading Informant Options Access (InfOptAcc) Methods
	If the main is moved to be the last loaded lua file this would be logical to move to its own lua file to make things clearer
	InfMain.lua would need to be placed after the file this goes into in the TOC
	This may require settings & such to be before it.
]]

--[[ first slidebar
-- slidebar click handler
local function slidebarclickhandler(_, button)
	--if we rightclick open the configuration window for the whole addon
	Informant.Settings.MakeGuiConfig()
	local gui = Informant.Settings.Gui
	if (gui:IsVisible()) then
		gui:Hide()
	else
		gui:Show()
	end
end

-- slidebar setup
local function setupSlidebar()
	if LibStub then
		local LibDataBroker = LibStub:GetLibrary("LibDataBroker-1.1", true)
		if LibDataBroker then
			local LDBButton = LibDataBroker:NewDataObject("Informant", {
						type = "launcher",
						icon = "Interface\\AddOns\\Informant\\inficon",
						OnClick = function(self, button) slidebarclickhandler(self, button) end,
						})

			function LDBButton:OnTooltipShow()
				self:AddLine("Informant Configuration",  1,1,0.5, 1)
			end
			function LDBButton:OnEnter()
				GameTooltip:SetOwner(self, "ANCHOR_NONE")
				GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT")
				GameTooltip:ClearLines()
				LDBButton.OnTooltipShow(GameTooltip)
				GameTooltip:Show()
			end
			function LDBButton:OnLeave()
				GameTooltip:Hide()
			end
		end
	end
end
]]

-- second the classic minimap button
miniIcon = CreateFrame("Button", "InfMiniMapIcon", Minimap);
Informant.MiniIcon = miniIcon
miniIcon.infMoving = false

local function mouseDown()
	miniIcon.icon:SetTexCoord(0, 1, 0, 1)
end

local function mouseUp()
	miniIcon.icon:SetTexCoord(0.075, 0.925, 0.075, 0.925)
end

local function dragStart()
	miniIcon.infMoving = true
end

local function dragStop()
	miniIcon.icon:SetTexCoord(0.075, 0.925, 0.075, 0.925)
	miniIcon.infMoving = false
end

function miniIcon.Reposition(angle)
	if not Informant.Settings.GetSetting("miniicon.enable") then
		miniIcon:Hide()
		return
	end
	miniIcon:Show()
	if not angle then angle = Informant.Settings.GetSetting("miniicon.angle")
	else Informant.Settings.SetSetting("miniicon.angle", angle) end
	angle = angle
	local distance = Informant.Settings.GetSetting("miniicon.distance")

	local width,height = Minimap:GetWidth()/2, Minimap:GetHeight()/2
	width = width+distance
	height = height+distance

	local iconX, iconY
	iconX = width * cos(angle)
	iconY = height * sin(angle)

	miniIcon:ClearAllPoints()
	miniIcon:SetPoint("CENTER", Minimap, "CENTER", iconX, iconY)
end

local function update()
	if miniIcon.infMoving then
		local curX, curY = GetCursorPosition()
		local miniX, miniY = Minimap:GetCenter()
		miniX = miniX * Minimap:GetEffectiveScale()
		miniY = miniY * Minimap:GetEffectiveScale()

		local relX = miniX - curX
		local relY = miniY - curY
		local angle = math.deg(math.atan2(relY, relX)) + 180

		miniIcon.Reposition(angle)
	end
end

local function mmButton_OnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT")
	GameTooltip:ClearLines()
	GameTooltip:AddLine("Informant Configuration",  1,1,0.5, 1)
	GameTooltip:Show()
end

local function mmButton_OnLeave(self)
	GameTooltip:Hide()
end

local function click(obj, button)
	Informant.Settings.MakeGuiConfig()
	local gui = Informant.Settings.Gui
	if (gui:IsVisible()) then
		gui:Hide()
	else
		gui:Show()
	end
end

miniIcon:SetToplevel(true)
miniIcon:SetMovable(true)
miniIcon:SetFrameStrata("LOW")
miniIcon:SetWidth(20)
miniIcon:SetHeight(20)
miniIcon:SetPoint("RIGHT", Minimap, "LEFT", 0,0)
miniIcon:Hide()
miniIcon.icon = miniIcon:CreateTexture("", "BACKGROUND")
miniIcon.icon:SetTexture("Interface\\AddOns\\Informant\\inficon")
miniIcon.icon:SetTexCoord(0.075, 0.925, 0.075, 0.925)
miniIcon.icon:SetWidth(20)
miniIcon.icon:SetHeight(20)
miniIcon.icon:SetPoint("TOPLEFT", miniIcon, "TOPLEFT", 0,0)
miniIcon.mask = miniIcon:CreateTexture("", "OVERLAY")
miniIcon.mask:SetTexCoord(0.0, 0.6, 0.0, 0.6)
miniIcon.mask:SetTexture("Interface\\Minimap\\Minimap-TrackingBorder")
miniIcon.mask:SetWidth(36)
miniIcon.mask:SetHeight(36)
miniIcon.mask:SetPoint("TOPLEFT", miniIcon, "TOPLEFT", -8,8)
miniIcon:RegisterForClicks("LeftButtonUp","RightButtonUp")
miniIcon:RegisterForDrag("LeftButton")
miniIcon:SetScript("OnMouseDown", mouseDown)
miniIcon:SetScript("OnMouseUp", mouseUp)
miniIcon:SetScript("OnDragStart", dragStart)
miniIcon:SetScript("OnDragStop", dragStop)
miniIcon:SetScript("OnClick", click)
miniIcon:SetScript("OnUpdate", update)
miniIcon:SetScript("OnEnter", mmButton_OnEnter)
miniIcon:SetScript("OnLeave", mmButton_OnLeave)

-- third the addons compartment
local function doAddonCompartment()
	if AddonCompartmentFrame then
		local mouseButtonNote = "\nDisplays detailed item information in tooltips, such as use, vendor sales information, and more.";
		AddonCompartmentFrame:RegisterAddon({
			text = addonName,
			icon = "Interface/AddOns/Informant/inficon.blp",
			notCheckable = true,
			func = function(button, menuInputData, menu)
				Informant.Settings.MakeGuiConfig()
				local gui = Informant.Settings.Gui
				if (gui:IsVisible()) then
					gui:Hide()
				else
					gui:Show()
				end
			end,
			funcOnEnter = function(button)
				MenuUtil.ShowTooltip(button, function(tooltip)
					tooltip:SetText(addonName .. mouseButtonNote)
				end)
			end,
			funcOnLeave = function(button)
				MenuUtil.HideTooltip(button)
			end,
		})
	end
end

-- fourth a trigger function for our methods
function AddonLoaded()
	-- setupSlidebar()  -- if slidebar is moved here ...
	
	-- if enabled, kick off the minimap icon
	if Informant.Settings.GetSetting("miniicon.enable") then
		miniIcon.Reposition()
	end

	if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then  -- if the addons compartment exists
		if Informant.Settings.GetSetting("addoncompartment") then -- do we want to display?
			if doAddonCompartment then
				doAddonCompartment()
				-- only call this function once
				doAddonCompartment = nil
			end
		end
	end
end

-- fifth sense the add on is loading and set off our loaded function
local frame = CreateFrame("Frame") -- used to sense events
local function onEvent(self, event, name) -- used to trigger AFTER saved variables are in play
  if name ~= addonName then return end -- don't process event if it wasn't our addon that loaded
  AddonLoaded() -- load options access methods
  self:UnregisterEvent("ADDON_LOADED") -- don't process further loaded events
end
frame:SetScript("OnEvent", onEvent) -- watch events
frame:RegisterEvent("ADDON_LOADED") -- when an add on is fully loaded...
