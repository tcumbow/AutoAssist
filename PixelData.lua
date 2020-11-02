local ADDON_NAME = "PixelData"
local ADDON_VERSION = "1.0"
local ADDON_AUTHOR = "Tom Cumbow"

local Mounted = false
local MajorSorcery, MajorProphesy, MinorSorcery, MajorResolve, MinorMending, DeepThoughts, ElementalWeapon, DamageShield = false, false, false, false, false, false, false, false
local InputReady = true
local InCombat = false
local InputReady = true
local HealingNeeded = false
local MagickaPercent = 1.00
local StaminaPercent = 1.00
local LowestGroupHealthPercentWithoutRegen = 1.00
local LowestGroupHealthPercentWithRegen = 1.00
local Feared = false
local Stunned = false
local MustDodge = false
local MustInterrupt = false
local MustBreakFree = false
local MustBlock = false
local TargetNotTaunted = false
local TargetMaxHealth = 0


local RawPlayerName = GetRawUnitName("player")


local function PD_SetPixel(x)
	PDL:SetColor(0,0,(x/255))
end








local function UpdatePixel()
	if InputReady == false or Mounted == true then
		PD_SetPixel(0)
		return
	end
	if Stunned or Feared and StaminaPercent > 0.49 then
		PD_SetPixel(8)
		return
	end
	if LowestGroupHealthPercentWithRegen < 0.40 then
		PD_SetPixel(1)
		return
	end
	if LowestGroupHealthPercentWithoutRegen < 0.40 then
		PD_SetPixel(1)
		return
	end
	if LowestGroupHealthPercentWithoutRegen < 0.90 then
		PD_SetPixel(2)
		return
	end
	if MustInterrupt and StaminaPercent > 0.49 then
		PD_SetPixel(8)
		return
	end
	if TargetNotTaunted and TargetMaxHealth > 100000 and MagickaPercent > 0.30 and InCombat then
		PD_SetPixel(3)
		return
	end
	if MustBlock and StaminaPercent > 0.99 then
		PD_SetPixel(9)
		return
	end
	if MustDodge and StaminaPercent > 0.99 then
		PD_SetPixel(9)
		return
	end
	if InCombat == true and ElementalWeapon == true then
		PD_SetPixel(6)
		return
	end
	if InCombat == true and MajorResolve == false and MagickaPercent > 0.50 then
		PD_SetPixel(5)
		return
	end
	-- if InCombat == true and ElementalWeapon == false and MagickaPercent > 0.70 then
	-- 	PD_SetPixel(5)
	-- 	return
	-- end
	-- if InCombat == true and DamageShield == false and MagickaPercent > 0.50 then
	-- 	PD_SetPixel(5)
	-- 	return
	-- end
	if TargetNotTaunted and TargetMaxHealth > 1 and MagickaPercent > 0.90 and InCombat then
		PD_SetPixel(3)
		return
	end
	-- if InCombat == true and MagickaPercent > 0.90 then
	-- 	PD_SetPixel(5)
	-- 	return
	-- end
	if (MagickaPercent < 0.98 or StaminaPercent < 0.98) and DeepThoughts == false and InCombat then
		PD_SetPixel(4)
		return
	end
	if InCombat == true then
		PD_SetPixel(6)
		return
	end
	-- if InCombat and (MagickaPercent < 0.95 or StaminaPercent < 0.95) and DeepThoughts == true then
	-- 	PD_SetPixel(0)
	-- 	return
	-- end
	PD_SetPixel(0)
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
			local IsAlive = not IsUnitDead(unitTag)
			if HpPercent < LowestGroupHealthPercentWithoutRegen and HasRegen == false and InHealingRange and IsAlive then
				LowestGroupHealthPercentWithoutRegen = HpPercent
			elseif HpPercent < LowestGroupHealthPercentWithRegen and HasRegen and InHealingRange and IsAlive then
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



local function UpdateTargetInfo()
	if (DoesUnitExist('reticleover') and not (IsUnitDead('reticleover'))) then -- have a target, scan for auras
		-- local unitName = zo_strformat("<<t:1>>",GetUnitName('reticleover'))

		numAuras = GetNumBuffs('reticleover')

		if (numAuras > 0) then -- target has auras, scan and send to handler
			for i = 1, numAuras do
				local name, _, _, _, _, _, _, _, _, _, _, _ = GetUnitBuffInfo('reticleover', i)
				if name=="Taunt" then
					TargetNotTaunted = false
					return
				end
			end
		end
		TargetNotTaunted = true
		local _, maxHp, _ = GetUnitPower('reticleover', POWERTYPE_HEALTH)
		TargetMaxHealth = maxHp
	else
		TargetNotTaunted = false
	end
end





local function OnEventMountedStateChanged(eventCode,mounted)
	Mounted = mounted
	UpdatePixel()
end

local function OnEventEffectChanged(e, change, slot, auraName, unitTag, start, finish, stack, icon, buffType, effectType, abilityType, statusType, unitName, unitId, abilityId, sourceType)
	if unitTag=="player" then
		MajorSorcery, MajorProphesy, MinorSorcery, MajorResolve, MinorMending, DeepThoughts, ElementalWeapon, DamageShield = false, false, false, false, false, false, false, false
		-- MustBreakFree = false
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
				elseif name=="Deep Thoughts" then
					DeepThoughts = true
				elseif name=="Elemental Weapon" then
					ElementalWeapon = true
				elseif name=="Blazing Shield" then
					DamageShield = true
				elseif name=="Dampen Magic" then
					DamageShield = true
				-- elseif name=="Rending Leap Ranged" or name=="Uppercut" or name=="Skeletal Smash" or name=="Stunning Shock" or name=="Discharge" or name=="Constricting Strike" or name=="Stun" then
				-- 	MustBreakFree = true
				end
			end
		end
	end
	UpdateLowestGroupHealth()
	UpdateTargetInfo()
	UpdatePixel()
end

local function OnEventPowerUpdate(eventCode, unitTag, powerIndex, powerType, powerValue, powerMax, powerEffectiveMax)
	if unitTag=="player" and powerType==POWERTYPE_STAMINA then
		StaminaPercent = powerValue / powerMax
		UpdatePixel()
		return
	end
	if powerType==POWERTYPE_HEALTH then
		UpdateLowestGroupHealth()
		UpdatePixel()
		return
	end
end

local function OnEventGroupSupportRangeUpdate()
	UpdateLowestGroupHealth()
	UpdatePixel()
end

local function OnEventCombatTipDisplay(_, tipId)
	if tipId == 2 then
		return
	elseif tipId == 4 or tipId == 19 then
		MustDodge = true
		UpdatePixel()
	elseif tipId == 3 then
		MustInterrupt = true
		UpdatePixel()
	elseif tipId == 1 then
		MustBlock = true
		UpdatePixel()
	elseif tipId == 18 then
	else
		local name, tipText, iconPath = GetActiveCombatTipInfo(tipId)
		d(name)
		d(tipText)
		d(tipId)
	end

end

local function OnEventCombatTipRemove()
	MustDodge = false
	MustInterrupt = false
	MustBlock = false
	Feared = false
	UpdatePixel()
end

function OnEventCombatEvent(_,result,_,_,_,_,_,_,targetName)
	if targetName == RawPlayerName then 
		if result == ACTION_RESULT_FEARED then
			Feared = true
		end
	end
end

function OnEventStunStateChanged(_,StunState)
	Stunned = StunState
	UpdatePixel()
end




function OnEventReticleChanged()
	UpdateTargetInfo()
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
		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_DISPLAY_ACTIVE_COMBAT_TIP, OnEventCombatTipDisplay)
		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_REMOVE_ACTIVE_COMBAT_TIP, OnEventCombatTipRemove)
		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_PLAYER_STUNNED_STATE_CHANGED, OnEventStunStateChanged)
		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_COMBAT_EVENT, OnEventCombatEvent)
		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_RETICLE_TARGET_CHANGED, OnEventReticleChanged)
		-- EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_COMBAT_EVENT, OnEventCombatEvent)
		-- EVENT_MANAGER:AddFilterForEvent(ADDON_NAME, EVENT_COMBAT_EVENT, REGISTER_FILTER_TARGET_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_PLAYER)
	end
end

EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED, OnAddonLoaded)
