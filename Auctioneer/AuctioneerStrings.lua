--[[
	Development File. Based on Informant Strings.
	Needs to be brought to localizer.
	Localizer URL: http://localizer.norganna.org/

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

AuctioneerLocalizations = {
	enUS = {
		-- Section: Access Options
		["AccessMouseOverNote"]      = "Auctioneer: The original Auction House Mod!";
		["Access_Config_Options"]    = "How would you like to access these options?";
		["AddOnsCompartment"]        = "Show in Blizzard's AddOns Compartment";
		["AddOnsCompartmentEnable"]  = "Display button in AddOns Compartment";
		["AddOnsCompartmentWarning"] = "This setting requires a UI reload to take effect";
		["MinimapButtonAngle"]       = "Button angle: %d";
		["MinimapOptions"]           = "Minimap display options";
		["MinimapShowButton"]        = "Display Minimap button";

		-- Section: General Options
		["AuctioneerToToolTip"]          = "Enable Auctioneer Tool Tips";
		["BelowVendorFinder"]            = "Show Items with Buyout under Sell-to-Vendor Price";
		["BelowVendorWarning"]           = "Warn when setting Buyout under Sell-to-Vendor Price";
		["DealFinder"]                   = "Deal Finder minimum percent: %d";
		["FakePriceChecks"]              = "Determine & Ignore auctions meant to invalidate statistics [Future Planned Feature]";
		["FakePriceDisparity"]           = "Sensitivity/Variance for Problem Auctions: %d";
		["GeneralOptions"]               = "General Options";
		["DispModInter"]                 = "Display & Module Interaction";
		["InteractEnchantrix"]           = "Enable Enchantrix Interactions";
		["InteractInformant"]            = "Enable Informant Interactions";
		["StatsKeepTime"]                = "Remember statistics for %d days [Future Planned Feature]";
		["Tooltip_AuctioneerToToolTip"]  = "Enables Auctioneer details to ToolTips (like Enchantrix & Informant) [Future Planned Feature]";
		["Tooltip_BelowVendorFinder"]    = "Show Items with Buyout under Sell-to-Vendor Price";
		["Tooltip_BelowVendorWarning"]   = "Warn when setting Buyout under Sell-to-Vendor Price";
		["Tooltip_DealFinder"]           = "A whole number representing the minimum percent the deal must be to show in the Deal Finder window";
		["Tooltip_FakePriceDisparity"]   = "A whole number representing the maximum differential for fake sensing [Future Planned Feature]";
		["Tooltip_InteractEnchantrix"]   = "Enables Auctioneer/Enchantrix Data Sharing [Future Planned Feature]";
		["Tooltip_InteractInformant"]    = "Enables Auctioneer/Informant Data Sharing [Future Planned Feature]";
		["Tooltip_StatsKeepTime"]        = "How long, in days, to remember stats for [Future Planned Feature]";
		["Tooltip_UnderVendorPriceShow"] = "Changing this takes effect on the first scan post reload";
		["UnderVendorPriceShow"]         = "Show Items under Vendor Price in dealfinder frame (caveat in tool tip)";
		["UnderVendorPriceWarn"]         = "Warn when putting items up for auction under vendor price [Future Planned Feature]";
		["ValueControls"]                = "Value Checks & Controls";

		-- Section: Profiles
		["ActivateProfile"]         = "Select the profile that you wish to use for this character";
		["CreateProfile"]           = "Create or replace a profile";
		["DefaultProfile"]          = "Reset all settings for the current profile";
		["DeleteProfile"]           = "Delete";
		["ProfileDeleted"]          = "Deleted profile:";
		["ProfileName"]             = "Enter the name of the profile that you wish to create";
		["ProfileReset"]            = "Reset profile:";
		["ProfileSaved"]            = "Saved profile:";
		["ProfileUsing"]            = "Using profile:";
		["SaveProfile"]             = "Save";
		["SetupProfiles"]           = "Setup, Configure and Edit Profiles";
		["Tooltip_ActivateProfile"] = "Select the profile that you wish to use for this character";
		["Tooltip_DefaultProfile"]	= "Reset all settings for the current profile";
		["Tooltip_DeleteProfile"]   = "Deletes the currently selected profile";
		["Tooltip_ProfileName"]     = "Enter the name of the profile that you wish to create";
		["Tooltip_ProfileSave"]     = "Click this button to create or overwrite the specified profile name";
	};
}