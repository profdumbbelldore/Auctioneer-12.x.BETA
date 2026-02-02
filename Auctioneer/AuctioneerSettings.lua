--[[
	Development File. Based on Informant's GUI

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
local Auctioneer = Auctioneer
local addonName, _ = ... -- return addon name dynamically
local lib = Auctioneer.Settings -- how to refer to this library; using 'lib' currently throws an error on lines 285+
local gui
local debugPrint -- used in debugging
local _TRANS = Auctioneer.Locale.Translate -- how to access strings for location adjustment
local UserSig = format("users.%s.%s", GetRealmName(), UnitName("player")) -- for profile naming

local settingDefaults = { -- Default setting values
	--[[ access methods: addons compartment & minimap ]]--
	['addoncompartment']     = true,
	['aucminiicon.angle']    = 120,
	['aucminiicon.distance'] = 12,
	['aucminiicon.enable']   = true,

	--[[ general options: dealfinder, integrations, etc ]]--
	['auctioneertooltips']   = true,
	['dealfinder']           = 5,
	['enchantrixinteract']   = true,
	['fakepricechecks']      = true,
	['fakepricedisparity']   = 5,
	['informantinteract']    = true,
	['statskeeptime']        = 7,
	['undervendorpriceshow'] = true,
	['undervendorpricewarn'] = true,
}

--[[ local functions :: these are used in the settings actions ]]--
local function getUserProfileName()
	if (not AuctioneerConfig) then AuctioneerConfig = {} end
	return AuctioneerConfig[UserSig] or "Default"
end

local function getUserProfile()
	local profileName = getUserProfileName()
	if (not AuctioneerConfig["profile."..profileName]) then
		if profileName ~= "Default" then
			profileName = "Default"
			AuctioneerConfig[UserSig] = "Default"
		end
		if profileName == "Default" then
			AuctioneerConfig["profile."..profileName] = {}
		end
	end
	return AuctioneerConfig["profile."..profileName]
end

local function cleanse( profile )
	if type(profile) == "table" then
		wipe(profile)
	end
end

local function getDefault(setting)
	local result = settingDefaults[setting]; -- lookup the simple settings

	if (result == nil) then -- if the setting doesn't exit, send a debug message (slash command and other input testing)
		-- debugPrint("Function GetDefault, requested key is unknown: " .. tostring(setting), "GetDefault: Unknown key", nil, "Info")
	end

	return result
end

local function setter(setting, value)
	if (not AuctioneerConfig) then AuctioneerConfig = {} end

	-- turn value into a canonical true or false
	if value == 'on' then
		value = true
	elseif value == 'off' then
		value = false
	end

	-- for defaults, just remove the value and it'll fall through
	if (value == 'default') or (value == getDefault(setting)) then
		value = nil -- Don't save default values
	end

	local a,b,c = strsplit(".", setting)
	if (a == "profile") then -- if we're acting on a profile
		if (setting == "profile.save") then -- if saving one
			value = gui.elements["profile.name"]:GetText() -- get the desired name
			AuctioneerConfig["profile."..value] = {} -- Create the new profile
			AuctioneerConfig[UserSig] = value -- Set the current profile to the new profile
			local newProfile = getUserProfile() -- Get the new current profile
			cleanse(newProfile)-- Clean it out and then resave all data
			gui:Resave()

			-- Add the new profile to the profiles list
			local profiles = AuctioneerConfig["profiles"]
			if (not profiles) then
				profiles = { "Default" }
				AuctioneerConfig["profiles"] = profiles
			end

			-- Check to see if it already exists
			local found = false
			for pos, name in ipairs(profiles) do
				if (name == value) then found = true end
			end

			-- If not, add it and then sort it
			if (not found) then
				table.insert(profiles, value)
				table.sort(profiles)
			end

			DEFAULT_CHAT_FRAME:AddMessage(_TRANS("ProfileSaved")..value) -- report to player
		elseif (setting == "profile.delete") then -- if deleting one
			value = gui.elements["profile"].value -- User clicked the Delete button, see what the select box's value is.

			if (value) then -- If there's a profile name supplied
				cleanse(AuctioneerConfig["profile."..value]) -- Clean it's profile container of values
				AuctioneerConfig["profile."..value] = nil -- Delete it's profile container
				local profiles = AuctioneerConfig["profiles"] -- Find it's entry in the profiles list

				if (profiles) then -- if we have profiles
					for pos, name in ipairs(profiles) do -- check each profile
						if (name == value and name ~= "Default") then -- If this is it, then extract it
							table.remove(profiles, pos)
						end
					end
				end

				-- If the user was using this one, then move them to Default
				if (getUserProfileName() == value) then AuctioneerConfig[UserSig] = 'Default' end

				DEFAULT_CHAT_FRAME:AddMessage(_TRANS("ProfileDeleted")..value) -- report to player
			end
		elseif (setting == "profile.default") then -- User clicked the reset settings button
			value = gui.elements["profile"].value -- Get the current profile from the select box
			AuctioneerConfig["profile."..value] = {} -- Clean it's profile container of values
			DEFAULT_CHAT_FRAME:AddMessage(_TRANS("ProfileReset")..value) -- report to player
		elseif (setting == "profile") then -- if the player updated the profile
			value = gui.elements["profile"].value -- get the player's new profile name
			AuctioneerConfig[UserSig] = value -- change the player's profile options
			DEFAULT_CHAT_FRAME:AddMessage(_TRANS("ProfileUsing")..value)
		end

		gui:Refresh() -- Refresh all values to reflect current data
	elseif a == "locale" then -- player chose a locale (language)
		local success = Auctioneer.Locale.SetLocale(value) -- set the language
		if success then gui:Refresh() end -- refresh to language
	else
		local db = getUserProfile() -- get the user's profile
		db[setting] = value -- set the updated value
	end

	if a == "aucminiicon" then -- if updating the minimap icon settings
		if b =="enable" then -- if enable was toggled; act on the newly saved setting
			if not Auctioneer.Settings.GetSetting("aucminiicon.enable") then
				AucMiniIcon:Hide() 
				return
			end
			AucMiniIcon:Show()
		elseif b == "angle" then -- if updating the angle
			AucMiniIcon.Reposition(angle) -- reposition the icon
		end
	end
end

local function getter(setting)
	if (not AuctioneerConfig) then AuctioneerConfig = {} end -- if we dont have a config; make one
	if not setting then return end -- verify the setting
	
	local a,b,c = strsplit(".", setting)
	if (a == 'profile') then -- if we're  touching profiles
		if not b then
			return getUserProfileName()
		elseif b == 'profiles' then
			local pList = AuctioneerConfig["profiles"]
			if (not pList) then pList = { "Default" } end
			return pList
		else
			return
		end
	elseif a == "locale" then
		local _, future = Auctioneer.Locale.GetLocale()
		return future
	end

	local db = getUserProfile()
	if ( db[setting] ~= nil ) then
		return db[setting]
	else
		return getDefault(setting)
	end
end

local function makeGuiConfig() -- create our GUI Options
	local id, last, cont
	local Configator = LibStub:GetLibrary("Configator")
	gui = Configator:Create(setter, getter)
	lib.Gui = gui

	local localelist = Auctioneer.Locale.GetLocaleList()
	local localedropdown = {}
	for index = 1, #localelist do
		tinsert(localedropdown, {localelist[index], localelist[index]})
	end
	local function selectorLocales()
		return localedropdown
	end

  	gui:AddCat("Auctioneer") -- TODO: localize me!

	id = gui:AddTab("General")
	gui:AddControl(id, "Header", 0, _TRANS('GeneralOptions'))
	--[[ Comment out future planned things ::: issue 31: interaction with tool tip
		They probably only means the first, but i added scaffolding for two others --]  ]
	gui:AddControl(id, "Subhead", 0, _TRANS('DispModInter'))
	gui:AddControl(id, "Checkbox", 0, 1, "auctioneertooltips", _TRANS('AuctioneerToToolTip') )
	gui:AddTip(id, _TRANS('Tooltip_AuctioneerToToolTip'))  --]]
	--[[gui:AddControl(id, "Checkbox", 0, 1, "enchantrixinteract", _TRANS('InteractEnchantrix') )
	gui:AddTip(id, _TRANS('Tooltip_InteractEnchantrix')) --]]
	--[[gui:AddControl(id, "Checkbox", 0, 1, "informantinteract", _TRANS('InteractInformant') )
	gui:AddTip(id, _TRANS('Tooltip_InteractInformant')) --]]

	gui:AddControl(id, "Subhead", 0, _TRANS('ValueControls'))
	gui:AddControl(id, "Checkbox", 0, 1, "undervendorpriceshow", _TRANS('UnderVendorPriceShow') )
	gui:AddTip(id, _TRANS('Tooltip_UnderVendorPriceShow'))
	--[[    comment out stuff in development (need better understanding to implement)
	gui:AddControl(id, "Checkbox", 0, 1, "undervendorpricewarn", _TRANS('UnderVendorPriceWarn') ) -- emailed WoWUI@blizzard.com for verification this is kosher: 2025 03 02
	gui:AddControl(id, "Checkbox", 0, 1, "fakepricechecks", _TRANS('FakePriceChecks') )
	gui:AddControl(id, "Slider", 0, 1, "fakepricedisparity", 0, 500, 1, _TRANS("FakePriceDisparity")) -- create the fake price determination
	gui:AddTip(id, _TRANS('Tooltip_FakePriceDisparity')) --]]
	gui:AddControl(id, "Slider", 0, 1, "dealfinder", 0, 500, 1, _TRANS("DealFinder")) -- create the deal finder % slider
	gui:AddTip(id, _TRANS('Tooltip_DealFinder'))
	--[[    comment out stuff in development
	gui:AddControl(id, "Slider", 0, 1, "statskeeptime", 0, 500, 1, _TRANS("StatsKeepTime")) -- create the window for stats
	gui:AddTip(id, _TRANS('Tooltip_StatsKeepTime')) --]]
	-- TODO: Add text box of the number for those who do not like sliders

	id = gui:AddTab("Access") -- section for options access methods
	gui:AddControl(id, "Header", 0, _TRANS('Access_Config_Options')) -- "How would you like to access these options?"
	gui:AddControl(id, "Subhead", 0, _TRANS("MinimapOptions")) -- show in the minimap
	gui:AddControl(id, "Checkbox", 0, 1, "aucminiicon.enable", _TRANS("MinimapShowButton")) -- give a checkbox window for this (start enabled as it's new)
	gui:AddControl(id, "Slider", 0, 1, "aucminiicon.angle", 0, 360, 1, _TRANS("MinimapButtonAngle")) -- create the angle slider

	if AddonCompartmentFrame then -- checks for a wow built in
		gui:AddControl(id, "Subhead", 0, _TRANS('AddOnsCompartment')) -- "Show in Blizzard's AddOnCompatment:"
		gui:AddControl(id, "Checkbox", 0, 1, "addoncompartment", _TRANS('AddOnsCompartmentEnable')) -- give a checkbox window for this (start enabled as it's new)
		gui:AddTip(id, _TRANS("AddOnsCompartmentWarning"))
	end

	id = gui:AddTab("Profiles") -- section for profiles
	gui:AddControl(id, "Header", 0, _TRANS('SetupProfiles')) --"Setup, Configure and Edit Profiles"
	gui:AddControl(id, "Subhead", 0, _TRANS('ActivateProfile')) --"Activate a current profile"
	gui:AddControl(id, "Selectbox", 0, 1, "profile.profiles", "profile")
	gui:AddTip(id, _TRANS('Tooltip_ActivateProfile')) --"Select the profile that you wish to use for this character"
	gui:AddControl(id, "Button", 0, 1, "profile.delete", _TRANS('DeleteProfile')) --"Delete"
	gui:AddTip(id, _TRANS('Tooltip_DeleteProfile')) --"Deletes the currently selected profile"
	gui:AddControl(id, "Button", 0, 1, "profile.default", _TRANS('DefaultProfile'))
	gui:AddTip(id, _TRANS('Tooltip_DefaultProfile')) -- Reset all settings for the current profile"

	gui:AddControl(id, "Subhead", 0, _TRANS('CreateProfile')) --"Create or replace a profile"
	gui:AddControl(id, "Text", 0, 1, "profile.name", _TRANS('ProfileName')) --"New profile name:"
	gui:AddTip(id, _TRANS('Tooltip_ProfileName')) --"Enter the name of the profile that you wish to create"
	gui:AddControl(id, "Button", 0, 1, "profile.save", _TRANS('SaveProfile')) --"Save"
	gui:AddTip(id, _TRANS('Tooltip_ProfileSave')) --"Click this button to create or overwrite the specified profile name")

	-- TODO - localize me!
	gui:AddHelp(id, "what is",
		"What is a profile?",
		"A profile is used to contain a group of settings, you can use different profiles for different characters, or switch between profiles for the same character when doing different tasks."
	)
	gui:AddHelp(id, "how to create",
		"How do I create a new profile?",
		"You enter the name of the new profile that you wish to create into the text box labelled \"New profile name\", and then click the \"Save\" button. A profile may be called whatever you wish, but it should reflect the purpose of the profile so that you may more easily recall that purpose at a later date."
	)
	gui:AddHelp(id, "how to delete",
		"How do I delete a profile?",
		"To delete a profile, simply select the profile you wish to delete with the drop-down selection box and then click the Delete button."
	)
	gui:AddHelp(id, "why delete",
		"Why would I want to delete a profile?",
		"You can delete a profile when you don't want to use it anymore, or you want to create it from scratch again with default values. Deleting a profile will also affect any other characters who are using the profile."
	)

	-- TODO: sense  updates and save to file upon closure for dealfinder component
	makeGuiConfig = nil
end

--[[ global functions :: these are used by other files ]]--
function lib.RestoreDefaults() -- reset all settings for the current user
	local profile = getUserProfile()
	cleanse(profile)
end

function lib.GetDefault(setting)
	local val = getDefault(setting);
	return val;
end

function lib.SetSetting(...)
	setter(...)
	if (gui) then
		gui:Refresh()
	end
end

function lib.GetSetting(setting, default)
	local option = getter(setting)
	if ( option ~= nil ) then
		return option
	else
		return default
	end
end

function lib.MakeGuiConfig()
	if makeGuiConfig then
		makeGuiConfig()
	end
end

--[[ the main function isnt ported from informant... line 79 errors
	Debugging function :: Prints the specified message to nLog.
	syntax:
		errorCode, message = debugPrint([message][, title][, errorCode][, level])
	parameters:
		message   - (string) the error message; nil, no error message specified
		title     - (string) the title for the debug message; nil, no title specified
		errorCode - (number) the error code; nil, no error code specified
		level     - (string) nLog message level; Any nLog.levels string is valid; nil, no level specified
	returns:
		errorCode - (number) errorCode, if one is specified; nil, otherwise
		message   - (string) message, if one is specified; nil, otherwise
] ]--
function debugPrint(message, title, errorCode, level)
	return Auctioneer.DebugPrint(message, "AuctioneerSettings", title, errorCode, level)
end
]]--