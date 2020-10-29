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
local LowestGroupHealthPercentWithoutRegen = 1.00
local LowestGroupHealthPercentWithRegen = 1.00


local function PD_SetPixel(x)
	PDL:SetColor(0,0,(x/255))
end







local function DoNothing()
	PD_SetPixel(0)
end

local function Heal()
	PD_SetPixel(1)
end

local function Regen()
	PD_SetPixel(6)
end

local function RegenNow()
	PD_SetPixel(7)
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
	if LowestGroupHealthPercentWithRegen < 0.40 then
		Heal()
		return
	end
	if LowestGroupHealthPercentWithoutRegen < 0.80 then
		RegenNow()
		return
	end
	if LowestGroupHealthPercentWithoutRegen < 0.90 then
		Regen()
		return
	end
	if InCombat == true and MajorSorcery == false and MagickaPercent > 0.30 then
		Entropy()
		return
	end
	if InCombat == true and MajorResolve == false then
		Channel()
		return
	end
	if InCombat == true and MagickaPercent > 0.50 then
		Pokes()
		return
	end
	if InCombat == true then
		Staff()
		return
	end
	DoNothing()
end


local function UnitHasRegen(unitTag)
		local numBuffs = GetNumBuffs(unitTag)
		if numBuffs > 0 then
			for i = 1, numBuffs do
				local name, _, _, _, _, _, _, _, _, _, _, _ = GetUnitBuffInfo(unitTag, i)
				if name=="Rapid Regeneration" then
					return true
				end
			end
		end
		return false
end

local function UpdateLowestGroupHealth()
	GroupSize = GetGroupSize()
	LowestGroupHealthPercentWithoutRegen = 1.00
	LowestGroupHealthPercentWithRegen = 1.00

	if GroupSize > 0 then
		for i = 1, GroupSize do
			local unitTag = GetGroupUnitTagByIndex(i)
			local currentHp, maxHp, effectiveMaxHp = GetUnitPower(unitTag, POWERTYPE_HEALTH)
			local HpPercent = currentHp / maxHp
			local HasRegen = UnitHasRegen(unitTag)
			local InHealingRange = IsUnitInGroupSupportRange(unitTag)
			if HpPercent < LowestGroupHealthPercentWithoutRegen and HasRegen == false and InHealingRange then
				LowestGroupHealthPercentWithoutRegen = HpPercent
			elseif HpPercent < LowestGroupHealthPercentWithRegen and HasRegen and InHealingRange then
				LowestGroupHealthPercentWithRegen = HpPercent
			end
		end
	else
		local unitTag = "player"
		local currentHp, maxHp, effectiveMaxHp = GetUnitPower(unitTag, POWERTYPE_HEALTH)
		local HpPercent = currentHp / maxHp
		local HasRegen = UnitHasRegen(unitTag)
		if HasRegen == false then
			LowestGroupHealthPercentWithoutRegen = HpPercent
		elseif HasRegen then
			LowestGroupHealthPercentWithRegen = HpPercent
		end
	end
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
	UpdateLowestGroupHealth()
	UpdatePixel()
end

local function OnEventPowerUpdate()
	UpdateLowestGroupHealth()
	UpdatePixel()
end

local function OnEventGroupSupportRangeUpdate()
	UpdateLowestGroupHealth()
	UpdatePixel()
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

end

function PD_HealingNeeded()

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
		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_POWER_UPDATE, OnEventPowerUpdate)
		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_GROUP_SUPPORT_RANGE_UPDATE, OnEventGroupSupportRangeUpdate)
	
	end
end

EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED, OnAddonLoaded)
