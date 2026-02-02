--[[
	Enchantrix Addon for World of Warcraft(tm).
	Version: <%version%> (<%codename%>)
	Revision: $Id: EnxConstants.lua 4632 2010-01-24 02:33:54Z ccox $
	URL: http://enchantrix.org/

	Enchantrix Constants for Inscription / Milling

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
		You have an implicit license to use this AddOn with these facilities
		since that is its designated purpose as per:
		http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat
]]
Enchantrix_RegisterRevision("$URL: http://dev.norganna.org/auctioneer/trunk/Enchantrix/EnxConstantsInscription.lua $", "$Rev: 4632 $")

local const = Enchantrix.Constants

-- DragonFlight (DF) Locals
local R1_HERB_Bubble_Poppy = 191467
local R2_HERB_Bubble_Poppy = 191468
local R3_HERB_Bubble_Poppy = 191469
local R1_HERB_Hochenblume  = 191460
local R2_HERB_Hochenblume  = 191461
local R3_HERB_Hochenblume  = 191462
local Prismatic_Leaper     = 200061
local R1_HERB_Saxifrage    = 191464
local R2_HERB_Saxifrage    = 191465
local R3_HERB_Saxifrage    = 191466
local R1_HERB_Writhebark   = 191470
local R2_HERB_Writhebark   = 191471
local R3_HERB_Writhebark   = 191472

local R1_Blazing_Pigment     = 198418
local R2_Blazing_Pigment     = 198419
local R3_Blazing_Pigment     = 198420
local R1_Flourishing_Pigment = 198415
local R2_Flourishing_Pigment = 198416
local R3_Flourishing_Pigment = 198417
local R1_Serene_Pigment      = 198412
local R2_Serene_Pigment      = 198413
local R3_Serene_Pigment      = 198414
local R1_Shimmering_Pigment  = 198421
local R2_Shimmering_Pigment  = 198422
local R3_Shimmering_Pigment  = 198423

local R1_Blazing_Ink     = 194751
local R2_Blazing_Ink     = 194752
local R3_Blazing_Ink     = 194846
local R1_Burnished_Ink   = 194760
local R2_Burnished_Ink   = 194761
local R3_Burnished_Ink   = 194855
local R1_Cosmic_Ink      = 194754
local R2_Cosmic_Ink      = 194755
local R3_Cosmic_Ink      = 194756
local R1_Flourishing_Ink = 194850
local R2_Flourishing_Ink = 194758
local R3_Flourishing_Ink = 194852
local R1_Serene_Ink      = 194856
local R2_Serene_Ink      = 194857
local R3_Serene_Ink      = 194858

local Blazing_Pigment_LOW     = "Blazing_Pigment_LOW"
local Blazing_Pigment_MED     = "Blazing_Pigment_MED"
local Blazing_Pigment_HGH     = "Blazing_Pigment_HGH"
local Flourishing_Pigment_LOW = "Flourishing_Pigment_LOW"
local Flourishing_Pigment_MED = "Flourishing_Pigment_MED"
local Flourishing_Pigment_HGH = "Flourishing_Pigment_HGH"
local Prismatic_Leaper_MILL   = "Prismatic_Leaper_MILL"
local Serene_Pigment_LOW      = "Serene_Pigment_LOW"
local Serene_Pigment_MED      = "Serene_Pigment_MED"
local Serene_Pigment_HGH      = "Serene_Pigment_HGH"
local Shimmering_Pigment_LOW  = "Shimmering_Pigment_LOW"
local Shimmering_Pigment_MED  = "Shimmering_Pigment_MED"
local Shimmering_Pigment_HGH  = "Shimmering_Pigment_HGH"

-- The War Within (TWW) Locals
local R1_HERB_Arathors_Spear   = 210808
local R2_HERB_Arathors_Spear   = 210809
local R3_HERB_Arathors_Spear   = 210810
local R1_HERB_Blessing_Blossom = 210805
local R2_HERB_Blessing_Blossom = 210806
local R3_HERB_Blessing_Blossom = 210807
local R1_HERB_Luredrop         = 210799
local R2_HERB_Luredrop         = 210800
local R3_HERB_Luredrop         = 210801
local R1_HERB_Mycobloom        = 210796
local R2_HERB_Mycobloom        = 210797
local R3_HERB_Mycobloom        = 210798
local R1_HERB_Orbinid          = 210802
local R2_HERB_Orbinid          = 210803
local R3_HERB_Orbinid          = 210804
local Specular_RainbowFish     = 220141

local R1_Blossom_Pigment  = 224805
local R2_Blossom_Pigment  = 224804
local R3_Blossom_Pigment  = 224803
local R1_Luredrop_Pigment = 222612
local R2_Luredrop_Pigment = 222613
local R3_Luredrop_Pigment = 222614
local R1_Nacreous_Pigment = 222618
local R2_Nacreous_Pigment = 222619
local R3_Nacreous_Pigment = 222620
local R1_Orbinid_Pigment  = 224802
local R2_Orbinid_Pigment  = 224801
local R3_Orbinid_Pigment  = 224800

local R1_Apricate_Ink = 222615
local R2_Apricate_Ink = 222616
local R3_Apricate_Ink = 222617
local R1_Shadow_Ink   = 222609
local R2_Shadow_Ink   = 222610
local R3_Shadow_Ink   = 222611

local Blossom_Pigment_LOW       = "Blossom_Pigment_LOW"
local Blossom_Pigment_MED       = "Blossom_Pigment_MED"
local Blossom_Pigment_HGH       = "Blossom_Pigment_HGH"
local Luredrop_Pigment_LOW      = "Luredrop_Pigment_LOW"
local Luredrop_Pigment_MED      = "Luredrop_Pigment_MED"
local Luredrop_Pigment_HGH      = "Luredrop_Pigment_HGH"
local Nacreous_Pigment_LOW      = "Nacreous_Pigment_LOW"
local Nacreous_Pigment_MED      = "Nacreous_Pigment_MED"
local Nacreous_Pigment_HGH      = "Nacreous_Pigment_HGH"
local Orbinid_Pigment_LOW       = "Orbinid_Pigment_LOW"
local Orbinid_Pigment_MED       = "Orbinid_Pigment_MED"
local Orbinid_Pigment_HGH       = "Orbinid_Pigment_HGH"
local Specular_RainbowFish_MILL = "Specular_RainbowFish_MILL"

-- only currently used for autoloot in EnxAutoDisenchant.lua
-- Blizz normally provides the reverse data in the pigment tooltip
const.DFPReversePigmentList = {
	-- DF Reverse Listing
	[R1_Blazing_Pigment]     = 1,
	[R2_Blazing_Pigment]     = 1,
	[R3_Blazing_Pigment]     = 1,
	[R1_Flourishing_Pigment] = 1,
	[R2_Flourishing_Pigment] = 1,
	[R3_Flourishing_Pigment] = 1,
	[Prismatic_Leaper]       = 1,
	[R1_Serene_Pigment]      = 1,
	[R2_Serene_Pigment]      = 1,
	[R3_Serene_Pigment]      = 1,
	[R1_Shimmering_Pigment]  = 1,
	[R2_Shimmering_Pigment]  = 1,
	[R3_Shimmering_Pigment]  = 1,

	-- TWW Reverse Listing
	[R1_Blossom_Pigment]   = 1,
	[R2_Blossom_Pigment]   = 1,
	[R3_Blossom_Pigment]   = 1,
	[R1_Luredrop_Pigment]  = 1,
	[R2_Luredrop_Pigment]  = 1,
	[R3_Luredrop_Pigment]  = 1,
	[R1_Nacreous_Pigment]  = 1,
	[R2_Nacreous_Pigment]  = 1,
	[R3_Nacreous_Pigment]  = 1,
	[R1_Orbinid_Pigment]   = 1,
	[R2_Orbinid_Pigment]   = 1,
	[R3_Orbinid_Pigment]   = 1,
	[Specular_RainbowFish] = 1,
}

-- Inks Reverse Table
const.DFPReverseInkList = {
	-- DF Reverse Listing
	[R1_Blazing_Ink]   = {R1_Blazing_Pigment, R2_Blazing_Pigment, R3_Blazing_Pigment, R1_Shimmering_Pigment, R2_Shimmering_Pigment, R3_Shimmering_Pigment},
	[R2_Blazing_Ink]   = {R1_Blazing_Pigment, R2_Blazing_Pigment, R3_Blazing_Pigment, R1_Shimmering_Pigment, R2_Shimmering_Pigment, R3_Shimmering_Pigment},
	[R3_Blazing_Ink]   = {R1_Blazing_Pigment, R2_Blazing_Pigment, R3_Blazing_Pigment, R1_Shimmering_Pigment, R2_Shimmering_Pigment, R3_Shimmering_Pigment},
	[R1_Burnished_Ink] = {R1_Blazing_Pigment, R2_Blazing_Pigment, R3_Blazing_Pigment, R1_Flourishing_Pigment, R2_Flourishing_Pigment, R3_Flourishing_Pigment, R1_Serene_Pigment, R2_Serene_Pigment, R3_Serene_Pigment},
	[R2_Burnished_Ink] = {R1_Blazing_Pigment, R2_Blazing_Pigment, R3_Blazing_Pigment, R1_Flourishing_Pigment, R2_Flourishing_Pigment, R3_Flourishing_Pigment, R1_Serene_Pigment, R2_Serene_Pigment, R3_Serene_Pigment},
	[R3_Burnished_Ink] = {R1_Blazing_Pigment, R2_Blazing_Pigment, R3_Blazing_Pigment, R1_Flourishing_Pigment, R2_Flourishing_Pigment, R3_Flourishing_Pigment, R1_Serene_Pigment, R2_Serene_Pigment, R3_Serene_Pigment},
	-- [Cosmic_Ink] = {},  -- this is actually from other inks!!!
	[R1_Flourishing_Ink] = {R1_Flourishing_Pigment, R2_Flourishing_Pigment, R3_Flourishing_Pigment, R1_Shimmering_Pigment, R2_Shimmering_Pigment, R3_Shimmering_Pigment},
	[R2_Flourishing_Ink] = {R1_Flourishing_Pigment, R2_Flourishing_Pigment, R3_Flourishing_Pigment, R1_Shimmering_Pigment, R2_Shimmering_Pigment, R3_Shimmering_Pigment},
	[R3_Flourishing_Ink] = {R1_Flourishing_Pigment, R2_Flourishing_Pigment, R3_Flourishing_Pigment, R1_Shimmering_Pigment, R2_Shimmering_Pigment, R3_Shimmering_Pigment},
	[R1_Serene_Ink] = {R1_Serene_Pigment, R2_Serene_Pigment, R3_Serene_Pigment, R1_Shimmering_Pigment, R2_Shimmering_Pigment, R3_Shimmering_Pigment},
	[R2_Serene_Ink] = {R1_Serene_Pigment, R2_Serene_Pigment, R3_Serene_Pigment, R1_Shimmering_Pigment, R2_Shimmering_Pigment, R3_Shimmering_Pigment},
	[R3_Serene_Ink] = {R1_Serene_Pigment, R2_Serene_Pigment, R3_Serene_Pigment, R1_Shimmering_Pigment, R2_Shimmering_Pigment, R3_Shimmering_Pigment},

	-- TWW Reverse Listing
	[R1_Apricate_Ink] = {R1_Luredrop_Pigment, R2_Luredrop_Pigment, R3_Luredrop_Pigment, R1_Nacreous_Pigment, R2_Nacreous_Pigment, R3_Nacreous_Pigment},
	[R2_Apricate_Ink] = {R1_Luredrop_Pigment, R2_Luredrop_Pigment, R3_Luredrop_Pigment, R1_Nacreous_Pigment, R2_Nacreous_Pigment, R3_Nacreous_Pigment},
	[R3_Apricate_Ink] = {R1_Luredrop_Pigment, R2_Luredrop_Pigment, R3_Luredrop_Pigment, R1_Nacreous_Pigment, R2_Nacreous_Pigment, R3_Nacreous_Pigment},
	[R1_Shadow_Ink]   = {R1_Blossom_Pigment, R2_Blossom_Pigment, R3_Blossom_Pigment, R1_Orbinid_Pigment, R2_Orbinid_Pigment, R3_Orbinid_Pigment},
	[R2_Shadow_Ink]   = {R1_Blossom_Pigment, R2_Blossom_Pigment, R3_Blossom_Pigment, R1_Orbinid_Pigment, R2_Orbinid_Pigment, R3_Orbinid_Pigment},
	[R3_Shadow_Ink]   = {R1_Blossom_Pigment, R2_Blossom_Pigment, R3_Blossom_Pigment, R1_Orbinid_Pigment, R2_Orbinid_Pigment, R3_Orbinid_Pigment},
}

-- skill required, by bracket/result
const.DFPMillingSkillRequired = {
	-- DF Skills
	[Blazing_Pigment_LOW]     = 1,
	[Blazing_Pigment_MED]     = 1,
	[Blazing_Pigment_HGH]     = 1,
	[Flourishing_Pigment_LOW] = 1,
	[Flourishing_Pigment_MED] = 1,
	[Flourishing_Pigment_HGH] = 1,
	[Serene_Pigment_LOW]      = 1,
	[Serene_Pigment_MED]      = 1,
	[Serene_Pigment_HGH]      = 1,
	[Shimmering_Pigment_LOW]  = 1,
	[Shimmering_Pigment_MED]  = 1,
	[Shimmering_Pigment_HGH]  = 1,

	-- TWW Skills
	[Blossom_Pigment_LOW]  = 1,
	[Blossom_Pigment_MED]  = 1,
	[Blossom_Pigment_HGH]  = 1,
	[Luredrop_Pigment_LOW] = 1,
	[Luredrop_Pigment_MED] = 1,
	[Luredrop_Pigment_HGH] = 1,
	[Nacreous_Pigment_LOW] = 1,
	[Nacreous_Pigment_MED] = 1,
	[Nacreous_Pigment_HGH] = 1,
	[Orbinid_Pigment_LOW]  = 1,
	[Orbinid_Pigment_MED]  = 1,
	[Orbinid_Pigment_HGH]  = 1,
	[Specular_RainbowFish] = 1,
}

-- maps millable items to what they yield
const.DFPMillableItems = {
	-- DF Millable ||| Mapping Source: FAdraven's comments here: https://www.wowhead.com/item=198420/blazing-pigment#comments
	[R1_HERB_Bubble_Poppy] = Serene_Pigment_LOW,
	[R2_HERB_Bubble_Poppy] = Serene_Pigment_MED,
	[R3_HERB_Bubble_Poppy] = Serene_Pigment_HGH,
	[R1_HERB_Hochenblume] = Shimmering_Pigment_LOW,
	[R2_HERB_Hochenblume] = Shimmering_Pigment_MED,
	[R3_HERB_Hochenblume] = Shimmering_Pigment_HGH,
	[Prismatic_Leaper] = Prismatic_Leaper_MILL,
	[R1_HERB_Saxifrage] = Blazing_Pigment_LOW,
	[R2_HERB_Saxifrage] = Blazing_Pigment_MED,
	[R3_HERB_Saxifrage] = Blazing_Pigment_HGH,
	[R1_HERB_Writhebark] = Flourishing_Pigment_LOW,
	[R2_HERB_Writhebark] = Flourishing_Pigment_MED,
	[R3_HERB_Writhebark] = Flourishing_Pigment_HGH,

	-- TWW Millable ||| Mapping Source: LotzBoi's comments here: https://www.wowhead.com/item=224805/blossom-pigment#comments
	--[[ As per my Scribe's Inscription Interface, Arathor's is not currently millable 2025 03 01
	[R1_HERB_Arathors_Spear] = xx,
	[R2_HERB_Arathors_Spear] = xx,
	[R3_HERB_Arathors_Spear] = xx, ]]--
	[R1_HERB_Blessing_Blossom] = Blossom_Pigment_LOW,
	[R2_HERB_Blessing_Blossom] = Blossom_Pigment_MED,
	[R3_HERB_Blessing_Blossom] = Blossom_Pigment_HGH,
	[R1_HERB_Luredrop] = Luredrop_Pigment_LOW,
	[R2_HERB_Luredrop] = Luredrop_Pigment_MED,
	[R3_HERB_Luredrop] = Luredrop_Pigment_HGH,
	[R1_HERB_Mycobloom] = Nacreous_Pigment_LOW,
	[R2_HERB_Mycobloom] = Nacreous_Pigment_MED,
	[R3_HERB_Mycobloom] = Nacreous_Pigment_HGH,
	[R1_HERB_Orbinid] = Orbinid_Pigment_LOW,
	[R2_HERB_Orbinid] = Orbinid_Pigment_MED,
	[R3_HERB_Orbinid] = Orbinid_Pigment_HGH,
	[Specular_RainbowFish] = Specular_RainbowFish_MILL,
}

-- the numbers need to be adjusted to be real. 0.1 was used for loading to test.
const.DFPMillGroupYields = {
	-- DF Millable Group Yeilds
	[Blazing_Pigment_LOW]     = {[R1_Blazing_Pigment] = 0.1, [R2_Blazing_Pigment] = 0.1, [R3_Blazing_Pigment] = 0.1,},
	[Blazing_Pigment_MED]     = {[R1_Blazing_Pigment] = 0.1, [R2_Blazing_Pigment] = 0.1, [R3_Blazing_Pigment] = 0.1,},
	[Blazing_Pigment_HGH]     = {[R1_Blazing_Pigment] = 0.1, [R2_Blazing_Pigment] = 0.1, [R3_Blazing_Pigment] = 0.1,},
	[Flourishing_Pigment_LOW] = {[R1_Flourishing_Pigment] = 0.1, [R2_Flourishing_Pigment] = 0.1, [R3_Flourishing_Pigment] = 0.1,},
	[Flourishing_Pigment_MED] = {[R1_Flourishing_Pigment] = 0.1, [R2_Flourishing_Pigment] = 0.1, [R3_Flourishing_Pigment] = 0.1,},
	[Flourishing_Pigment_HGH] = {[R1_Flourishing_Pigment] = 0.1, [R2_Flourishing_Pigment] = 0.1, [R3_Flourishing_Pigment] = 0.1,},
	[Prismatic_Leaper_MILL]   = {[R2_Flourishing_Pigment] = 0.1, [R3_Flourishing_Pigment] = 0.1, [R2_Serene_Pigment] = 0.1,},
	[Serene_Pigment_LOW]      = {[R1_Serene_Pigment] = 0.1, [R2_Serene_Pigment] = 0.1, [R3_Serene_Pigment] = 0.1,},
	[Serene_Pigment_MED]      = {[R1_Serene_Pigment] = 0.1, [R2_Serene_Pigment] = 0.1, [R3_Serene_Pigment] = 0.1,},
	[Serene_Pigment_HGH]      = {[R1_Serene_Pigment] = 0.1, [R2_Serene_Pigment] = 0.1, [R3_Serene_Pigment] = 0.1,},
	[Shimmering_Pigment_LOW]  = {[R1_Shimmering_Pigment] = 0.1, [R2_Shimmering_Pigment] = 0.1, [R3_Shimmering_Pigment] = 0.1,},
	[Shimmering_Pigment_MED]  = {[R1_Shimmering_Pigment] = 0.1, [R2_Shimmering_Pigment] = 0.1, [R3_Shimmering_Pigment] = 0.1,},
	[Shimmering_Pigment_HGH]  = {[R1_Shimmering_Pigment] = 0.1, [R2_Shimmering_Pigment] = 0.1, [R3_Shimmering_Pigment] = 0.1,},

	-- TWW Millable Group Yeilds
	[Blossom_Pigment_LOW]       = {[R1_Blossom_Pigment] = 0.1, [R2_Blossom_Pigment] = 0.1, [R3_Blossom_Pigment] = 0.1,},
	[Blossom_Pigment_MED]       = {[R1_Blossom_Pigment] = 0.1, [R2_Blossom_Pigment] = 0.1, [R3_Blossom_Pigment] = 0.1,},
	[Blossom_Pigment_HGH]       = {[R1_Blossom_Pigment] = 0.1, [R2_Blossom_Pigment] = 0.1, [R3_Blossom_Pigment] = 0.1,},
	[Luredrop_Pigment_LOW]      = {[R1_Luredrop_Pigment] = 0.1, [R2_Luredrop_Pigment] = 0.1, [R3_Luredrop_Pigment] = 0.1,},
	[Luredrop_Pigment_MED]      = {[R1_Luredrop_Pigment] = 0.1, [R2_Luredrop_Pigment] = 0.1, [R3_Luredrop_Pigment] = 0.1,},
	[Luredrop_Pigment_HGH]      = {[R1_Luredrop_Pigment] = 0.1, [R2_Luredrop_Pigment] = 0.1, [R3_Luredrop_Pigment] = 0.1,},
	[Nacreous_Pigment_LOW]      = {[R1_Nacreous_Pigment] = 0.1, [R2_Nacreous_Pigment] = 0.1, [R3_Nacreous_Pigment] = 0.1,},
	[Nacreous_Pigment_MED]      = {[R1_Nacreous_Pigment] = 0.1, [R2_Nacreous_Pigment] = 0.1, [R3_Nacreous_Pigment] = 0.1,},
	[Nacreous_Pigment_HGH]      = {[R1_Nacreous_Pigment] = 0.1, [R2_Nacreous_Pigment] = 0.1, [R3_Nacreous_Pigment] = 0.1,},
	[Orbinid_Pigment_LOW]       = {[R1_Orbinid_Pigment] = 0.1, [R2_Orbinid_Pigment] = 0.1, [R3_Orbinid_Pigment] = 0.1,},
	[Orbinid_Pigment_MED]       = {[R1_Orbinid_Pigment] = 0.1, [R2_Orbinid_Pigment] = 0.1, [R3_Orbinid_Pigment] = 0.1,},
	[Orbinid_Pigment_HGH]       = {[R1_Orbinid_Pigment] = 0.1, [R2_Orbinid_Pigment] = 0.1, [R3_Orbinid_Pigment] = 0.1,},
	[Specular_RainbowFish_MILL] = {[R1_Nacreous_Pigment] = 0.1,}
}
