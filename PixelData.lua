local ADDON_NAME = "PixelData"
local ADDON_VERSION = "1.0"
local ADDON_AUTHOR = "Tom Cumbow"

local Mounted = false
local MajorSorcery, MajorProphesy, MinorSorcery, MajorResolve, MinorMending = false, false, false, false, false
local InputReady = true
local InCombat = false
local InputReady = true
local HealingNeeded = false
local MagickaPercent = 1.00


local function PD_SetPixel(x)
	PDL:SetColor(0,0,(x/255))
end







local function DoNothing()
	PD_SetPixel(0)
end

local function Heal()
	PD_SetPixel(1)
end

local function Channel()
	PD_SetPixel(2)
end

local function Entropy()
	PD_SetPixel(3)
end

local function Staff()
	PD_SetPixel(4)
end

local function Pokes()
	PD_SetPixel(5)
end










local function UpdatePixel()
	if InputReady == false or Mounted == true then
		DoNothing()
		return
	end
	if HealingNeeded == true then
		Heal()
		return
	end
	if InCombat == true and MajorSorcery == false and MagickaPercent > 0.50 then
		Entropy()
		return
	end
	if InCombat == true and MajorResolve == false then
		Channel()
		return
	end
	if InCombat == true and MagickaPercent > 0.75 then
		Pokes()
		return
	end
	if InCombat == true then
		Staff()
		return
	end
	DoNothing()
end









local function OnEventMountedStateChanged(eventCode,mounted)
	Mounted = mounted
	UpdatePixel()
end

local function OnEventEffectChanged(e, change, slot, auraName, unitTag, start, finish, stack, icon, buffType, effectType, abilityType, statusType, unitName, unitId, abilityId, sourceType)
	if unitTag=="player" then
		MajorSorcery, MajorProphesy, MinorSorcery, MajorResolve, MinorMending = false, false, false, false, false
		local numBuffs = GetNumBuffs("player")
		if numBuffs > 0 then
			for i = 1, numBuffs do
				local name, _, _, _, _, _, _, _, _, _, _, _ = GetUnitBuffInfo("player", i)
				if name=="Major Sorcery" then
					MajorSorcery = true
				elseif name=="Major Prophesy" then
					MajorProphesy = true
				elseif name=="Minor Sorcery" then
					MinorSorcery = true
				elseif name=="Major Resolve" then
					MajorResolve = true
				elseif name=="Minor Mending" then
					MinorMending = true
				end
			end
		end
	end
end

local function OnEventPowerUpdate(eventCode, unitTag, powerIndex, powerType, powerValue, powerMax, powerEffectiveMax)
	-- local UnitType = GetUnitType(unitTag)
	-- local UnitName = GetUnitName(unitTag)
	-- if unitTag ~= "worldevent7" and unitTag ~= "worldevent8" and unitTag ~= "reticleover" and unitTag ~= "player" then
	-- 	d(unitTag)
	-- 	d(UnitName)
	-- 	d(UnitType)
	-- end
end








function PD_InputReady()
	InputReady = true
	UpdatePixel()
end

function PD_InputNotReady()
	InputReady = false
	UpdatePixel()
end

function PD_NotInCombat()
	InCombat = false
	UpdatePixel()
end

function PD_InCombat()
	InCombat = true
	UpdatePixel()
end

function PD_NotMounted()
	Mounted = false
	UpdatePixel()
end

function PD_Mounted()
	Mounted = true
	UpdatePixel()
end

function PD_HealingNotNeeded()
	HealingNeeded = false
	UpdatePixel()
end

function PD_HealingNeeded()
	HealingNeeded = true
	UpdatePixel()
end

function PD_MagickaPercent(x)
	MagickaPercent = x
	UpdatePixel()
end







local function OnAddonLoaded(event, name)
	if name == ADDON_NAME then
		EVENT_MANAGER:UnregisterForEvent(ADDON_NAME, event)
		PixelDataWindow = WINDOW_MANAGER:CreateTopLevelWindow("PixelData")
		PixelDataWindow:SetDimensions(100,100)

		PDL = CreateControl(nil, PixelDataWindow,  CT_LINE)
		PDL:SetAnchor(TOPLEFT, PixelDataWindow, TOPLEFT, 0, 0)
		PDL:SetAnchor(TOPRIGHT, PixelDataWindow, TOPLEFT, 1, 1)
		PD_SetPixel(5)

		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_MOUNTED_STATE_CHANGED, OnEventMountedStateChanged)
		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_EFFECT_CHANGED, OnEventEffectChanged)
		-- EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_POWER_UPDATE, OnEventPowerUpdate)
	
	end
end

EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED, OnAddonLoaded)
