--[[
LibExtraTip (Main)

LibExtraTip is a library of API functions for manipulating additional information into GameTooltips by either adding information to the bottom of existing tooltips (embedded mode) or by adding information to an extra "attached" tooltip construct which is placed to the bottom of the existing tooltip.

LibExtraTip is composed of multiple files:
LibExtraTipStartup.lua - startup checks and lib setup
LibExtraTipHandler_DataProc.lua - only one of the Handler files will load, depending on available Client APIs
LibExtraTipHandler_HookSet.lua
LibExtraTip.lua - main code file
LibMoneyFrame.lua - routines for handling display of money values
Load.xml - loads the lua files in the above order

Copyright (C) 2008-2024, by the respective below authors.

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

@author Matt Richard (Tem)
@author Ken Allan <ken@norganna.org>
@author brykrys
@libname LibExtraTip
@version 1. see LibExtraTipStartup.lua for minor version
--]]

local lib = LibStub("LibExtraTip-1")
if not lib then return end
local private = lib.private
if not private then return end
local status, versions = private.status, private.versions
if not (status and versions) then return end

local LOAD_NEW, LOAD_START, LOAD_COMPLETE = 5, 10, 20
local ACTIVATE_START, ACTIVATE_COMPLETE = 45, 55
local DEACTIVATED = 99

if status.filetrackerMain ~= LOAD_NEW then return end
status.filetrackerMain = LOAD_START

local LIBSTRING = versions.LIBNAME.."_"..versions.MAJOR.."_"..versions.MINOR
local ExtraTipClass

local defaultEnable = {
	SetAuctionItem = true, SetAuctionSellItem = true, SetBagItem = true, SetBuybackItem = true,
	SetGuildBankItem = true, SetInboxItem = true, SetInventoryItem = true, SetLootItem = true,
	SetLootRollItem = true, SetMerchantItem = true, SetQuestItem = true, SetQuestLogItem = true,
	SetSendMailItem = true, SetTradePlayerItem = true, SetTradeTargetItem = true,
	SetRecipeReagentItem = true, SetRecipeResultItem = true, SetTradeSkillItem = true,
	SetCraftItem = true, SetHyperlink = true, SetHyperlinkAndCount = true,
	SetBattlePet = true, SetBattlePetAndCount = true, SetItemKey = true,
}

local alwaysEnable = { extrashow = true, extrahide = true }

local iconpath = "Interface\\MoneyFrame\\UI-"
local goldicon = "%.0f|T"..iconpath.."GoldIcon:0|t"
local silvericon = "%s|T"..iconpath.."SilverIcon:0|t"
local coppericon = "%s|T"..iconpath.."CopperIcon:0|t"

local function ProcessCallbacks(reg, tiptype, tooltip, ...)
	if not reg then return end
	local event = reg.additional.event or "Unknown"
	local default = defaultEnable[event]
	if lib.sortedCallbacks and #lib.sortedCallbacks > 0 then
		for i,options in ipairs(lib.sortedCallbacks) do
			if options.type == tiptype then
				local enable = default
				if options.allevents or alwaysEnable[tiptype] then
					enable = true
				elseif options.enable and options.enable[event] ~= nil then
					enable = options.enable[event]
				end
				if enable then options.callback(tooltip, ...) end
			end
		end
	end
end

function private.GetRegistry(tooltip) return lib.tooltipRegistry[tooltip] end

function private.ProcessItem(tooltip, reg)
	if not tooltip and reg and reg.extraTip then
        tooltip = reg.extraTip:GetParent()
    	end
    	if not tooltip or not tooltip.AddLine then
        return
    	end
	local self = lib
	local additional = reg.additional
	local item, name, quantity, link, quality = additional.item, additional.name, additional.quantity, additional.link, additional.quality
	if not self.sortedCallbacks or #self.sortedCallbacks == 0 then return end
	reg.hasItem = true
	local extraTip = private.GetFreeExtraTipObject()
	reg.extraTip = extraTip
	extraTip:Attach(tooltip)
	local qcol = ITEM_QUALITY_COLORS[quality] or ITEM_QUALITY_COLORS[1]
	extraTip:AddLine(name, qcol.r, qcol.g, qcol.b)
	ProcessCallbacks(reg, "item", tooltip, item, quantity, name, link, quality)
	tooltip:Show()
	if reg.extraTipUsed then
		extraTip:Show()
		ProcessCallbacks(reg, "extrashow", tooltip, extraTip)
	end
	if tooltip:IsShown() and MerchantFrame and MerchantFrame:IsShown() then
        -- This forces the tooltip to recognize the manually added lines
        tooltip:Show() 
        
        -- Optional: Force a height update if the box looks too small
        local width, height = tooltip:GetSize()
        tooltip:SetSize(width, height + 20) 
    end
end

function private.ProcessSpell(tooltip, reg)
	local additional = reg.additional
	local name, spellID = additional.name, additional.spellID
	local category = additional.category
	local link = additional.link or additional.eventLink or additional.spellLink
	if not lib.sortedCallbacks or #lib.sortedCallbacks == 0 then return end
	reg.hasItem = true
	local extraTip = private.GetFreeExtraTipObject()
	reg.extraTip = extraTip
	extraTip:Attach(tooltip)
	extraTip:AddLine(name, 1, 0.8, 0)
	ProcessCallbacks(reg, "spell", tooltip, link, name, category, spellID)
	tooltip:Show()
	if reg.extraTipUsed then
		extraTip:Show()
		ProcessCallbacks(reg, "extrashow", tooltip, extraTip)
	end
end

function private.ProcessUnit(tooltip, reg)
	local additional = reg.additional
	local name, unitId = additional.name, additional.unitId
	if not lib.sortedCallbacks or #lib.sortedCallbacks == 0 then return end
	reg.hasItem = true
	local extraTip = private.GetFreeExtraTipObject()
	reg.extraTip = extraTip
	extraTip:Attach(tooltip)
	extraTip:AddLine(name, 0.8, 0.8, 0.8)
	ProcessCallbacks(reg, "unit", tooltip, name, unitId)
	tooltip:Show()
	if reg.extraTipUsed then
		extraTip:Show()
		ProcessCallbacks(reg, "extrashow", tooltip, extraTip)
	end
end

function private.OnCleared(tooltip)
	local reg = lib.tooltipRegistry[tooltip]
	if not reg or reg.ignoreOnCleared then return end
	tooltip:SetFrameLevel(1)
	reg.extraTipUsed, reg.hasItem = nil, nil
	wipe(reg.additional)
	local extraTip = reg.extraTip
	if extraTip then
		reg.extraTip = nil
		extraTip:Release()
		extraTip:ClearLines()
		extraTip:SetWidth(1) 
		extraTip:SetHeight(1)
		extraTip:ClearAllPoints() 
		extraTip:Hide()
		ProcessCallbacks(reg, "extrahide", tooltip, extraTip)
		tinsert(lib.extraTippool, extraTip)
	end
end

function private.OnSetBattlePet(tooltip, data)
	local reg = lib.tooltipRegistry[tooltip]
	if not reg then return end
	if reg.hasItem then private.OnCleared(tooltip) end
	if lib.sortedCallbacks and #lib.sortedCallbacks > 0 then
		local speciesID, level, breedQuality, maxHealth, power, speed = data.speciesID, data.level, data.breedQuality, data.maxHealth, data.power, data.speed
		local battlePetID, name, customName, petType = data.battlePetID or "0x0000000000000000", data.name, data.customName, data.petType
		local r, g, b = 1, 1, 1
		if breedQuality ~= -1 then
			local col = ITEM_QUALITY_COLORS[breedQuality] or ITEM_QUALITY_COLORS[0]
			r, g, b = col.r, col.g, col.b
		end
		reg.hasItem = true
		local extraTip = private.GetFreeExtraTipObject()
		reg.extraTip = extraTip
		extraTip:Attach(tooltip)
		extraTip:AddLine(name, r, g, b)
		local add = reg.additional
		add.name, add.speciesID, add.quality, add.level, add.customName, add.petType, add.maxHealth, add.power, add.speed, add.battlePetID = name, speciesID, breedQuality, level, customName, petType, maxHealth, power, speed, battlePetID
		add.event = add.event or "SetBattlePet"
		ProcessCallbacks(reg, "battlepet", tooltip, add.link or "battlepet", add.quantity or 1, name, speciesID, breedQuality, level)
		if reg.extraTipUsed then extraTip:Show() end
	end
end

function private.OnResize(tooltip,w,h)
	local reg = lib.tooltipRegistry[tooltip]
	if reg and reg.extraTip then reg.extraTip:MatchSize() end
end

function private.OnShowCalled(tooltip)
	local reg = lib.tooltipRegistry[tooltip]
	if reg and reg.extraTip then reg.extraTip:MatchSize() end
end

function private.GetFreeExtraTipObject()
	if not lib.extraTippool then lib.extraTippool = {} end
	return tremove(lib.extraTippool) or ExtraTipClass:new()
end

local HOOKSTORE_VERSION = "D"
if not lib.hookStore or lib.hookStore.version ~= HOOKSTORE_VERSION then lib.hookStore = {version = HOOKSTORE_VERSION} end

function private.HookMethod(tip, method, prehook, posthook)
	if not lib.hookStore[tip] then lib.hookStore[tip] = {} end
	local control = lib.hookStore[tip][method]
	if control then
		if prehook or posthook then control[1], control[2] = prehook or control[1] or false, posthook or control[2] or false
		else control[1], control[2] = false, false end
		return
	end
	local orig = tip[method]
	if not orig then return end
	control = {prehook or false, posthook or false}
	lib.hookStore[tip][method] = control
	tip[method] = function(...)
		if control[1] then control[1](...) end
		local a,b,c,d,e,f,g,h,i,j,k = orig(...)
		if control[2] then control[2](...) end
		return a,b,c,d,e,f,g,h,i,j,k
	end
end

function private.HookMethodSecure(tip, method, posthook)
	if not lib.hookStore[tip] then lib.hookStore[tip] = {} end
	local key = "#"..method
	local control = lib.hookStore[tip][key]
	if control then control[1] = posthook return end
	if not tip[method] then return end
	control = {posthook}
	lib.hookStore[tip][key] = control
	hooksecurefunc(tip, method, function(...) if control[1] then control[1](...) end end)
end

function private.HookScriptBasic(tip, script, prehook)
	if not lib.hookStore[tip] then lib.hookStore[tip] = {} end
	local control = lib.hookStore[tip][script]
	if control then control[1] = prehook return end
	local orig = tip:GetScript(script)
	control = {prehook}
	lib.hookStore[tip][script] = control
	tip:SetScript(script, function(...) if control[1] then control[1](...) end if orig then orig(...) end end)
end

function private.HookScriptSecure(tip, script, posthook)
	if not tip:HasScript(script) then return end
	if not lib.hookStore[tip] then lib.hookStore[tip] = {} end
	local key = "#"..script
	local control = lib.hookStore[tip][key]
	if control then control[1] = posthook return end
	control = {posthook}
	lib.hookStore[tip][key] = control
	tip:HookScript(script, function(...) if control[1] then control[1](...) end end)
end

function private.HookGlobalSecure(func, posthook)
	if type(_G[func]) ~= "function" then return end
	if not lib.hookStore.global then lib.hookStore.global = {} end
	local control = lib.hookStore.global[func]
	if control then control[1] = posthook return end
	control = {posthook}
	lib.hookStore.global[func] = control
	hooksecurefunc(func, function(...) if control[1] then control[1](...) end end)
end

function private.HookDataProcessor(datatype, posthook)
	if not lib.hookStore.tooltipdata then lib.hookStore.tooltipdata = {} end
	local control = lib.hookStore.tooltipdata[datatype]
	if control then control[1] = posthook return end
	control = {posthook}
	lib.hookStore.tooltipdata[datatype] = control
	TooltipDataProcessor.AddTooltipPostCall(datatype, function(...) if control[1] then control[1](...) end end)
end

function lib:RegisterTooltip(tooltip)
	if not lib:IsActive() then return nil, "Library Inactive" end
	if not tooltip or type(tooltip) ~= "table" then return nil, "Invalid Tooltip" end
	if not self.tooltipRegistry[tooltip] then
		local reg = {additional = {}}
		local success, text = private.RegisterTooltipHandler(tooltip, reg)
		if not success then return nil, text end
		self.tooltipRegistry[tooltip] = reg
		return true, true
	end
	return true, nil
end

function lib:IsRegistered(tooltip) return self.tooltipRegistry and self.tooltipRegistry[tooltip] and true or false end
function lib:GetExtraTip(tooltip) return self.tooltipRegistry and self.tooltipRegistry[tooltip] and self.tooltipRegistry[tooltip].extraTip end

function lib:AddCallback(options,priority)
	if type(options) == "function" then options = {type = "item", callback = options} end
	if not options or type(options.callback) ~= "function" then return end
	local copy = {type = options.type, callback = options.callback, allevents = options.allevents, enable = options.enable}
	if not self.callbacks then self.callbacks, self.sortedCallbacks = {}, {} end
	self.callbacks[copy] = priority or 200
	tinsert(self.sortedCallbacks, copy)
	sort(self.sortedCallbacks, function(a,b) return self.callbacks[a] < self.callbacks[b] end)
end

function lib:RemoveCallback(callback)
	if not (callback and self.callbacks) then return end
	for options in pairs(self.callbacks) do
		if options == callback or options.callback == callback then
			self.callbacks[options] = nil
			for i, v in ipairs(self.sortedCallbacks) do if v == options then tremove(self.sortedCallbacks, i) break end end
			return true
		end
	end
end

function lib:SetEmbedMode(flag) self.embedMode = flag and true or false end

function lib:AddLine(tooltip, text, r, g, b, embed, wrap)
	local reg = self.tooltipRegistry[tooltip]
	if not reg then return end
	if r and not g then embed, r = r, nil end
	if embed == nil then embed = self.embedMode end
	if not embed and not reg.NoColumns then reg.extraTip:AddLine(text, r, g, b, wrap) reg.extraTipUsed = true
	else tooltip:AddLine(text, r, g, b, wrap) end
end

function lib:AddDoubleLine(tooltip,textLeft,textRight,lr,lg,lb,rr,rg,rb,embed)
	local reg = self.tooltipRegistry[tooltip]
	if not reg then return end
	if lr and not lg and not rr then embed, lr = lr, nil end
	if embed == nil then embed = self.embedMode end
	if not embed and not reg.NoColumns then reg.extraTip:AddDoubleLine(textLeft,textRight,lr,lg,lb,rr,rg,rb) reg.extraTipUsed = true
	else tooltip:AddDoubleLine(textLeft,textRight,lr,lg,lb,rr,rg,rb) end
end

function lib:GetMoneyText(money, concise)
	local g, s, c = floor(money/10000), floor(money%10000/100), floor(money%100)
    if GetCVar("colorblindMode") == "1" then
		local res = ""
		if g > 0 then res = g..GOLD_AMOUNT_SYMBOL end
		if s > 0 or (money >= 10000 and not concise) then res = res.." "..s..SILVER_AMOUNT_SYMBOL end
		if not concise or c > 0 or money < 100 then res = res.." "..c..COPPER_AMOUNT_SYMBOL end
		return res
    end
	local res, sep, fmt = "", "", "%d"
	if g > 0 then res, sep, fmt = goldicon:format(g), " ", "%02d" end
	if s > 0 or (money >= 10000 and not concise) then res, sep, fmt = res..sep..silvericon:format(fmt):format(s), " ", "%02d" end
	if not concise or c > 0 or money < 100 then res = res..sep..coppericon:format(fmt):format(c) end
	return res
end

function lib:AddMoneyLine(tooltip,text,money,r,g,b,embed,concise)
	local reg = self.tooltipRegistry[tooltip]
	if not reg then return end
	if embed == nil then embed = self.embedMode end
	local moneyText = self:GetMoneyText(money, concise)
	if not embed and not reg.NoColumns then reg.extraTip:AddDoubleLine(text,moneyText,r,g,b,1,1,1) reg.extraTipUsed = true
	else tooltip:AddDoubleLine(text,moneyText,r,g,b,1,1,1) end
end

function lib:SetHyperlinkAndCount(tooltip, link, quantity, detail)
	local reg = self.tooltipRegistry[tooltip]
	if not reg or reg.NoColumns then return end
	private.OnCleared(tooltip)
	reg.additional.quantity, reg.additional.event, reg.additional.eventLink = quantity, "SetHyperlinkAndCount", link
	if detail then for k,v in pairs(detail) do reg.additional[k] = v end end
	reg.ignoreOnCleared, reg.ignoreSetHyperlink = true, true
	tooltip:SetHyperlink(link)
	reg.ignoreSetHyperlink, reg.ignoreOnCleared = nil, nil
	return true
end

function lib:SetBattlePetAndCount(tooltip, link, quantity, detail)
	local reg = self.tooltipRegistry[tooltip]
	if not reg or not reg.NoColumns then return end
	local h, s, l, q, m, p, sp, t = strsplit(":", link)
	s = tonumber(s)
	local name, icon, petType = C_PetJournal.GetPetInfoBySpeciesID(s)
	if not name then return end
	local pet = {speciesID=s, name=name, level=tonumber(l), breedQuality=tonumber(q), petType=petType, maxHealth=tonumber(m), power=tonumber(p), speed=tonumber(sp)}
	private.OnCleared(tooltip)
	reg.additional.quantity, reg.additional.event, reg.additional.eventLink = quantity, "SetBattlePetAndCount", link
	if detail then for k,v in pairs(detail) do reg.additional[k] = v end end
	reg.ignoreOnCleared = true
	BattlePetTooltipTemplate_SetBattlePet(tooltip, pet)
	tooltip:Show()
	reg.ignoreOnCleared = nil
	return true
end

function lib:GetTooltipAdditional(tooltip) return self.tooltipRegistry[tooltip] and self.tooltipRegistry[tooltip].additional end
function lib:IsActive() return status.filetrackerMain == ACTIVATE_COMPLETE and status.filetrackerHandler == ACTIVATE_COMPLETE end

function lib:Deactivate()
	status.filetrackerMain = DEACTIVATED
	for tip, tiptable in pairs(lib.hookStore) do if tip ~= "version" then for m, c in pairs(tiptable) do wipe(c) end end end
	if self.tooltipRegistry then
		for _, reg in pairs(self.tooltipRegistry) do
			if reg.extraTip then reg.extraTip:Hide() reg.extraTip:Release() end
			reg.extraTip, reg.extraTipUsed = nil, nil
		end
	end
	self.extraTippool = nil
	private.DeactivateHandler()
end

function lib:Activate()
	if private.startup then private.startup.ActivateMain() end
end

function private.startup.ActivateMain()
	local startup = private.startup
	private.startup = nil
	if status.filetrackerMain ~= LOAD_COMPLETE then return end
	status.filetrackerMain = ACTIVATE_START
	local oldreg = lib.tooltipRegistry
	lib.tooltipRegistry = {}
	if not startup.ActivateHandler or not startup.ActivateHandler(startup) then status.filetrackerMain = ACTIVATE_FAIL return end
	status.filetrackerMain = ACTIVATE_COMPLETE
	if oldreg then for tip in pairs(oldreg) do lib:RegisterTooltip(tip) end end
	if lib.callbacks then
		local old = lib.callbacks
		lib.callbacks, lib.sortedCallbacks = nil, nil
		for opt, prio in pairs(old) do lib:AddCallback(opt, prio) end
	end
end

do -- ExtraTip CLASS
	local methods = {"InitLines","Attach","Show","MatchSize","Release","SetParentClamp"}
	local scripts = {"OnShow","OnHide","OnSizeChanged"}
	local numTips = 0
	local class = {}
	ExtraTipClass = class

	local addLine, addDoubleLine, show = GameTooltip.AddLine, GameTooltip.AddDoubleLine, GameTooltip.Show
	local line_mt = { __index = function(t,k) local v = _G[t.name..k] rawset(t,k,v) return v end }

	function class:new()
		numTips = numTips + 1
		local o = CreateFrame("GameTooltip",LIBSTRING.."Tooltip"..numTips,UIParent,"GameTooltipTemplate")
		o:SetClampedToScreen(false) 
		for _,m in pairs(methods) do o[m] = self[m] end
		for _,s in pairs(scripts) do o:SetScript(s,self[s]) end
		o.LibExtraTipLeft = setmetatable({name = o:GetName().."TextLeft"},line_mt)
		o.LibExtraTipRight = setmetatable({name = o:GetName().."TextRight"},line_mt)
		return o
	end

	local function IsProtected(frame)
		if not frame then return false end
		if frame.IsProtected and frame:IsProtected() then return true end
		local name = frame.GetName and frame:GetName() or ""
		return name:find("ActionButton") or name:find("MultiBar") or name:find("PetBar") or name:find("Stance") or name:find("BT4") or name:find("Dominos")
	end

	local function fixRight(tooltip, width)
		if not tooltip or (InCombatLockdown() and (tooltip == GameTooltip or tooltip:IsProtected())) then return end
		local lefts, rights = tooltip.LibExtraTipLeft, tooltip.LibExtraTipRight
		if not lefts or not rights then return end
		local padding = tooltip:GetPadding() or 0
		local xofs = width - padding - 35
		for i = 1, tooltip:NumLines() do
			local l, r = lefts[i], rights[i]
			if l and r and l:IsShown() then
				pcall(function() r:ClearAllPoints() r:SetPoint("RIGHT", l, "LEFT", xofs, 0) end)
			end
		end
	end

	function class:Attach(tooltip)
		if not tooltip or self.embedMode then 
        		return 
    		end
		if IsProtected(tooltip:GetOwner()) then self:Release() return end
		if self.parent then pcall(function() self:SetParentClamp(0) end) end
		self.parent = tooltip
		self:SetParent(tooltip)
		self:SetOwner(tooltip, "ANCHOR_NONE")
		self:ClearAllPoints()
		pcall(function() self:SetPoint("TOPRIGHT", tooltip, "BOTTOMRIGHT") end)
	end

	function class:Release()
		local p = self.parent
		if p then 
			pcall(function() self:SetParentClamp(0) end)
			if not InCombatLockdown() then pcall(function() p:SetWidth(0) end) end
		end
		self.parent, self.inMatchSize = nil, nil
		self:SetWidth(1)
		self:Hide()
	end

	function class:InitLines()
		local nlines, changed = self:NumLines(), self.changedLines or 0
		if changed < nlines then
			for i = changed + 1, nlines do
				local l, r = self.LibExtraTipLeft[i], self.LibExtraTipRight[i]
				local f = (i == 1) and GameFontNormal or GameFontNormalSmall
				l:SetFontObject(f) r:SetFontObject(f)
			end
			self.changedLines = nlines
			return true
		end
	end

	function class:SetParentClamp(h)
		local p = self.parent
		if not p or not p:IsShown() or InCombatLockdown() or (p.IsProtected and p:IsProtected()) then return end
		pcall(function()
			if h and h > 0 then
				local l, r, t, b = p:GetClampRectInsets()
				p:SetClampRectInsets(l or 0, r or 0, t or 0, (b or 0) + (p:GetHeight() or 0) + h)
			else p:SetClampRectInsets(0, 0, 0, 0) end
		end)
	end

	function class:OnShow() 
		if InCombatLockdown() then return end
		self:SetParentClamp(self:GetHeight()) 
		self:MatchSize() 
	end

	function class:OnSizeChanged(w,h) 
		if InCombatLockdown() then return end
		self:SetParentClamp(h) 
		self:MatchSize() 
	end

	function class:OnHide() 
		if InCombatLockdown() then return end
		self:SetParentClamp(0) 
	end

	function class:MatchSize(force)
		if InCombatLockdown() then 
			return 
		end

		if self.inMatchSize then return end
		local p = self.parent
		
		-- 2. FORBIDDEN CHECK
		if not p or not p:IsShown() then return end
		if (p.IsForbidden and p:IsForbidden()) or (p.IsProtected and p:IsProtected()) then 
			return 
		end

		self.inMatchSize = true
		pcall(function()
			local pw, w = p:GetWidth() or 0, self:GetWidth() or 0
			
			if pw > 20 then
				-- One-way sync: ExtraTip follows Blizzard
				if force or abs(pw - w) > 0.5 then
					self:SetWidth(pw)
					fixRight(self, pw)
				end

				-- Two-way sync: Blizzard follows ExtraTip (Only if 100% safe)
				local target = math.max(pw, w)
				if force or abs(pw - target) > 0.5 then
					p:SetWidth(target)
					fixRight(p, target)
				end
			end
		end)
		self.inMatchSize = nil
	end

	function class:Show() show(self) if self:InitLines() then show(self) end self:MatchSize() end
end

-- Force Embedded tooltips
if status.filetrackerMain == LOAD_START then status.filetrackerMain = LOAD_COMPLETE end

lib.embedMode = true 
lib:SetEmbedMode(true)

lib:Activate()

local combatResetFrame = CreateFrame("Frame")
combatResetFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
combatResetFrame:SetScript("OnEvent", function()
    for i = 1, 20 do
        local tip = _G[LIBSTRING.."Tooltip"..i]
        if tip then
            tip.inMatchSize = nil 
            -- In embedded mode, we just ensure the extra tip is hidden
            -- so it doesn't accidentally show up as a ghost window.
            tip:SetWidth(1)
            tip:Hide()
        end
    end
end)