--[[
	Development File. Based on Informant's locale file

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

--[[ Create the Auctioneer table as the first thing. Install empty module tables. ]]
local Auctioneer = {
	Manifest = {},
	Locale = {},
	Settings = {},
	Commands = {},
	Version = '',
	MajorVersion = '',
	MinorVersion = '',
	RelVersion = '',
	Revision = '',
}
local AuctioneerConfig = {} -- blank starter we fill in and override with user settings later

_G.Auctioneer = Auctioneer
_G.AuctioneerConfig = AuctioneerConfig
