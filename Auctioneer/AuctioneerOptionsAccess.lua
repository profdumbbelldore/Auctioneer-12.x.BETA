--[[
	Development File. Based on Informant's Options Access

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

	Note:
		This AddOn's source code is specifically designed to work with
		World of Warcraft's interpreted AddOn system.
		You have an implicit licence to use this AddOn with these facilities
		since that is its designated purpose as per:
		http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat
]]--

--[[ local & global variables :: local are used throught the file :: global are used between files ]]--
local addonName, _ = ... -- return addon name dynamically
local _TRANS = Auctioneer.Locale.Translate -- how to access strings for location adjustment (future improvement)

-- the classic minimap button
AucMiniIcon = CreateFrame("Button", "miniMapIcon", Minimap);
Auctioneer.AucMiniIcon = AucMiniIcon
AucMiniIcon.Moving = false

local function mouseDown()
	AucMiniIcon.icon:SetTexCoord(0, 1, 0, 1)
end

local function mouseUp()
	AucMiniIcon.icon:SetTexCoord(0.075, 0.925, 0.075, 0.925)
end

local function dragStart()
	AucMiniIcon.Moving = true
end

local function dragStop()
	AucMiniIcon.icon:SetTexCoord(0.075, 0.925, 0.075, 0.925)
	AucMiniIcon.Moving = false
end

function AucMiniIcon.Reposition(angle)
	if not Auctioneer.Settings.GetSetting("aucminiicon.enable") then
		AucMiniIcon:Hide()
		return
	end
	AucMiniIcon:Show()
	if not angle then angle = Auctioneer.Settings.GetSetting("aucminiicon.angle")
	else Auctioneer.Settings.SetSetting("aucminiicon.angle", angle) end
	angle = angle
	local distance = Auctioneer.Settings.GetSetting("aucminiicon.distance")

	local width,height = Minimap:GetWidth()/2, Minimap:GetHeight()/2
	width = width+distance
	height = height+distance

	local iconX, iconY
	iconX = width * cos(angle)
	iconY = height * sin(angle)

	AucMiniIcon:ClearAllPoints()
	AucMiniIcon:SetPoint("CENTER", Minimap, "CENTER", iconX, iconY)
end

local function update()
	if AucMiniIcon.Moving then
		local curX, curY = GetCursorPosition()
		local miniX, miniY = Minimap:GetCenter()
		miniX = miniX * Minimap:GetEffectiveScale()
		miniY = miniY * Minimap:GetEffectiveScale()

		local relX = miniX - curX
		local relY = miniY - curY
		local angle = math.deg(math.atan2(relY, relX)) + 180

		AucMiniIcon.Reposition(angle)
	end
end

local function mmButton_OnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT")
	GameTooltip:ClearLines()
	GameTooltip:AddLine("Auctioneer Configuration",  1,1,0.5, 1)
	GameTooltip:Show()
end

local function mmButton_OnLeave(self)
	GameTooltip:Hide()
end

local function click(obj, button)
	Auctioneer.Settings.MakeGuiConfig()
	local gui = Auctioneer.Settings.Gui
	if (gui:IsVisible()) then
		gui:Hide()
	else
		gui:Show()
	end
end

AucMiniIcon:SetToplevel(true)
AucMiniIcon:SetMovable(true)
AucMiniIcon:SetFrameStrata("LOW")
AucMiniIcon:SetWidth(20)
AucMiniIcon:SetHeight(20)
AucMiniIcon:SetPoint("RIGHT", Minimap, "LEFT", 0,0)
AucMiniIcon:Hide()
AucMiniIcon.icon = AucMiniIcon:CreateTexture("", "BACKGROUND")
AucMiniIcon.icon:SetTexture("Interface\\AddOns\\Auctioneer\\AuctioneerIcon")
AucMiniIcon.icon:SetTexCoord(0.075, 0.925, 0.075, 0.925)
AucMiniIcon.icon:SetWidth(20)
AucMiniIcon.icon:SetHeight(20)
AucMiniIcon.icon:SetPoint("TOPLEFT", AucMiniIcon, "TOPLEFT", 0,0)
AucMiniIcon.mask = AucMiniIcon:CreateTexture("", "OVERLAY")
AucMiniIcon.mask:SetTexCoord(0.0, 0.6, 0.0, 0.6)
AucMiniIcon.mask:SetTexture("Interface\\Minimap\\Minimap-TrackingBorder")
AucMiniIcon.mask:SetWidth(36)
AucMiniIcon.mask:SetHeight(36)
AucMiniIcon.mask:SetPoint("TOPLEFT", AucMiniIcon, "TOPLEFT", -8,8)
AucMiniIcon:RegisterForClicks("LeftButtonUp","RightButtonUp")
AucMiniIcon:RegisterForDrag("LeftButton")
AucMiniIcon:SetScript("OnMouseDown", mouseDown)
AucMiniIcon:SetScript("OnMouseUp", mouseUp)
AucMiniIcon:SetScript("OnDragStart", dragStart)
AucMiniIcon:SetScript("OnDragStop", dragStop)
AucMiniIcon:SetScript("OnClick", click)
AucMiniIcon:SetScript("OnUpdate", update)
AucMiniIcon:SetScript("OnEnter", mmButton_OnEnter)
AucMiniIcon:SetScript("OnLeave", mmButton_OnLeave)

-- the addons compartment
local function doAddonCompartment()
	if AddonCompartmentFrame then
		local mouseButtonNote = "\nThe original Auction House Mod!"; -- TODO: change to use strings
		AddonCompartmentFrame:RegisterAddon({
			text = addonName,
			icon = "Interface/AddOns/Auctioneer/AuctioneerIcon.blp",
			notCheckable = true,
			func = function(button, menuInputData, menu)
				Auctioneer.Settings.MakeGuiConfig()
				local gui = Auctioneer.Settings.Gui
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

-- a trigger function for our methods
function AddonLoaded()
	-- setupSlidebar()  -- if slidebar is moved here ...
	
	-- if enabled, kick off the minimap icon
	if Auctioneer.Settings.GetSetting("aucminiicon.enable") then
		AucMiniIcon.Reposition()
	end

	if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then  -- if the addons compartment exists
		if Auctioneer.Settings.GetSetting("addoncompartment") then -- do we want to display?
			if doAddonCompartment then
				doAddonCompartment()
				-- only call this function once
				doAddonCompartment = nil
			end
		end
	end
end

-- sense the add on is loading and set off our loaded function
local frame = CreateFrame("Frame") -- used to sense events
local function onEvent(self, event, name) -- used to trigger AFTER saved variables are in play
  if name ~= addonName then return end -- don't process event if it wasn't our addon that loaded
  AddonLoaded() -- load options access methods
  self:UnregisterEvent("ADDON_LOADED") -- don't process further loaded events
end
frame:SetScript("OnEvent", onEvent) -- watch events
frame:RegisterEvent("ADDON_LOADED") -- when an add on is fully loaded...
