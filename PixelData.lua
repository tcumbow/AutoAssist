local ADDON_NAME = "PixelData"
local ADDON_VERSION = "1.0"
local ADDON_AUTHOR = "Tom Cumbow"

local Mounted = false
local MajorSorcery, MajorProphecy, MinorSorcery, MajorResolve, MinorMending, MeditationActive, ImbueWeaponActive, DamageShield, MajorGallop, MajorExpedition = false, false, false, false, false, false, false, false, false, false
local InputReady = true
local InCombat = false
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
local TargetIsNotPlayer = false
local TargetIsEnemy = false
local TargetIsBoss
local TargetNotVampBane = false

local FrontBar, BackBar = false, false
local InBossBattle = false
local ReelInFish = false

local BurstHealSlotted = false
local HealOverTimeSlotted = false
local DegenerationSlotted = false
local RitualSlotted = false
local RemoteInterruptSlotted = false
local TauntSlotted = false
local SunFireSlotted = false
local FocusSlotted = false
local MeditationSlotted = false
local ImbueWeaponSlotted = false
local RapidManeuverSlotted = false
local AccelerateSlotted = false

local DoNothing = 0
-- 1 thru 5 are used for doing abilities 1 thru 5, based on the number assigned in UpdateAbilitySlotInfo()
local DoHeavyAttack = 6
local DoRollDodge = 7
local DoBreakFreeInterrupt = 8
local DoBlock = 9
local DoReelInFish = 10
local DoLightAttack = 11




local RawPlayerName = GetRawUnitName("player")


local function SetPixel(x)
	PDL:SetColor(0,0,(x/255))
end








local function BigLogicRoutine()
	if InputReady == false or IsUnitDead("player") then
		SetPixel(DoNothing)
	elseif RapidManeuverSlotted and Mounted and not MajorGallop and StaminaPercent > 0.80 then
		SetPixel(RapidManeuverSlotted)
	elseif Mounted then
		SetPixel(DoNothing)
	elseif Stunned or Feared and StaminaPercent > 0.49 then
		SetPixel(DoBreakFreeInterrupt)
	elseif BurstHealSlotted and LowestGroupHealthPercentWithRegen < 0.40 then
		SetPixel(BurstHealSlotted)
	elseif BurstHealSlotted and LowestGroupHealthPercentWithoutRegen < 0.40 then
		SetPixel(BurstHealSlotted)
	elseif HealOverTimeSlotted and LowestGroupHealthPercentWithoutRegen < 0.90 then
		SetPixel(HealOverTimeSlotted)
	elseif RemoteInterruptSlotted and MustInterrupt and MagickaPercent > 0.49 then
		SetPixel(RemoteInterruptSlotted)
	elseif MustInterrupt and StaminaPercent > 0.49 then
		SetPixel(DoBreakFreeInterrupt)
	elseif TauntSlotted and TargetIsBoss and TargetNotTaunted and MagickaPercent > 0.30 and TargetIsEnemy and TargetIsNotPlayer and InCombat then
		SetPixel(TauntSlotted)
	elseif MustBlock and StaminaPercent > 0.99 then
		SetPixel(DoBlock)
	elseif MustDodge and FrontBar and StaminaPercent > 0.99 then
		SetPixel(DoRollDodge)
	elseif RitualSlotted and not MinorMending and InCombat and MagickaPercent > 0.55 then
		SetPixel(RitualSlotted)
	elseif DegenerationSlotted and not MajorSorcery and MagickaPercent > 0.60 and InCombat and TargetIsEnemy then
		SetPixel(DegenerationSlotted)
	elseif ImbueWeaponActive == true and InCombat and TargetIsEnemy then
		SetPixel(DoLightAttack)
	elseif FocusSlotted and MajorResolve == false and MagickaPercent > 0.50 and InCombat then
		SetPixel(FocusSlotted)
	elseif ImbueWeaponSlotted and InCombat == true and ImbueWeaponActive == false and MagickaPercent > 0.70 then
		SetPixel(ImbueWeaponSlotted)
	elseif DamageShieldSlotted and InCombat == true and DamageShield == false and MagickaPercent > 0.50 then
		SetPixel(DamageShieldSlotted)
	elseif SunFireSlotted and (MajorProphecy == false or MinorSorcery == false) and MagickaPercent > 0.60 and TargetIsEnemy and InCombat then
		SetPixel(SunFireSlotted)
	elseif MeditationActive == true and InCombat and (MagickaPercent < 0.98 or StaminaPercent < 0.98) then
		SetPixel(DoNothing)
	elseif MeditationSlotted and (MagickaPercent < 0.80 or StaminaPercent < 0.80) and MeditationActive == false and InCombat then
		SetPixel(MeditationSlotted)
	elseif RapidManeuverSlotted and not MajorExpedition and StaminaPercent > 0.90 then
		SetPixel(RapidManeuverSlotted)
	elseif AccelerateSlotted and not MajorExpedition and MagickaPercent > 0.90 then
		SetPixel(AccelerateSlotted)
	elseif RapidManeuverSlotted and not MajorExpedition and StaminaPercent > 0.90 then
		SetPixel(RapidManeuverSlotted)
	elseif InCombat == true and not ImbueWeaponActive then
		SetPixel(DoHeavyAttack)
	elseif ReelInFish and not InCombat then
		SetPixel(DoReelInFish)
		zo_callLater(PD_StopReelInFish, 2000)
	else
		SetPixel(DoNothing)
	end
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
			local IsPlayer = GetUnitType(unitTag) == 1
			if HpPercent < LowestGroupHealthPercentWithoutRegen and HasRegen == false and InHealingRange and IsAlive and IsPlayer then
				LowestGroupHealthPercentWithoutRegen = HpPercent
			elseif HpPercent < LowestGroupHealthPercentWithRegen and HasRegen and InHealingRange and IsAlive and IsPlayer then
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

		if GetUnitType('reticleover') == 1 then
			TargetIsNotPlayer = false
		else
			TargetIsNotPlayer = true
		end

		if GetUnitReaction('reticleover') == 1 then
			TargetIsEnemy = true
		else
			TargetIsEnemy = false
		end

		if GetUnitDifficulty("reticleover") == MONSTER_DIFFICULTY_DEADLY then
			TargetIsBoss = true
			InBossBattle = true
		else
			TargetIsBoss = false
		end

		local _, maxHp, _ = GetUnitPower('reticleover', POWERTYPE_HEALTH)
		TargetMaxHealth = maxHp
		
		numAuras = GetNumBuffs('reticleover')

		TargetNotVampBane = true
		TargetNotTaunted = true
		if (numAuras > 0) then
			for i = 1, numAuras do
				local name, _, _, _, _, _, _, _, _, _, _, _ = GetUnitBuffInfo('reticleover', i)
				if name=="Taunt" then
					TargetNotTaunted = false
				end
				if name=="Vampire's Bane" then
					TargetNotVampBane = false
				end
			end
		end
	else
		TargetNotTaunted = false
		TargetIsEnemy = false
		TargetIsNotPlayer = false
		TargetNotVampBane = false
		TargetIsBoss = false
	end
end





local function UpdateAbilitySlotInfo()

	BurstHealSlotted = false
	HealOverTimeSlotted = false
	DegenerationSlotted = false
	RitualSlotted = false
	RemoteInterruptSlotted = false
	TauntSlotted = false
	SunFireSlotted = false
	FocusSlotted = false
	MeditationSlotted = false
	ImbueWeaponSlotted = false
	DamageShieldSlotted = false
	RapidManeuverSlotted = false
	AccelerateSlotted = false

	for i = 3, 7 do
		local AbilityName = GetAbilityName(GetSlotBoundId(i))
		if AbilityName == "Ritual of Rebirth" then
			BurstHealSlotted = i-2
		elseif AbilityName == "Rapid Regeneration" then
			HealOverTimeSlotted = i-2
		elseif AbilityName == "Inner Rage" then
			TauntSlotted = i-2
		elseif AbilityName == "Deep Thoughts" then
			MeditationSlotted = i-2
		elseif AbilityName == "Elemental Weapon" then
			ImbueWeaponSlotted = i-2
		elseif AbilityName == "Channeled Focus" then
			FocusSlotted = i-2
		elseif AbilityName == "Extended Ritual" then
			RitualSlotted = i-2
		elseif AbilityName == "Degeneration" then
			DegenerationSlotted = i-2
		elseif AbilityName == "Vampire's Bane" then
			SunFireSlotted = i-2
		elseif AbilityName == "Radiant Ward" or AbilityName == "Blazing Shield" then
			DamageShieldSlotted = i-2
		elseif AbilityName == "Explosive Charge" then
			RemoteInterruptSlotted = i-2
		elseif AbilityName == "Rapid Maneuver" or AbilityName == "Charging Maneuver" then
			RapidManeuverSlotted = i-2
		elseif AbilityName == "Accelerate" or AbilityName == "Race Against Time" then
			AccelerateSlotted = i-2
		elseif AbilityName == "Inner Light" or AbilityName == "Radiant Aura" or AbilityName == "Puncturing Sweep" or AbilityName == "" then -- do nothing, cuz we don't care about these abilities
		else 
			d("Unrecognized ability:"..AbilityName)
		end
	end

end





local function UpdateBarState()
	local BarNum = GetActiveWeaponPairInfo()
	if BarNum == 1 then
		FrontBar = true
		BackBar = false
	elseif BarNum == 2 then
		BackBar = true
		FrontBar = false
	end
end



function InitialInfoGathering()
	InCombat = IsUnitInCombat("player")
	UpdateBarState()
	UpdateAbilitySlotInfo()

end




local function UpdateBuffs()
	MajorSorcery, MajorProphecy, MinorSorcery, MajorResolve, MinorMending, MeditationActive, ImbueWeaponActive, DamageShield, MajorGallop, MajorExpedition = false, false, false, false, false, false, false, false, false, false
	-- MustBreakFree = false
	local numBuffs = GetNumBuffs("player")
	if numBuffs > 0 then
		optimalBuffOverlap = 200 -- constant
		msUntilBuffRecheckNeeded = 999999 -- if this value isn't replaced, then a buff recheck won't be scheduled
		for i = 1, numBuffs do
			local name, _, endTime, _, _, _, _, _, _, _, _, _ = GetUnitBuffInfo("player", i)
			local now = GetGameTimeMilliseconds()
			local timeLeft = (math.floor(endTime * 1000)) - now
			if name=="Major Sorcery" then
				MajorSorcery = true
			elseif name=="Major Prophecy" then
				MajorProphecy = true
			elseif name=="Minor Sorcery" then
				MinorSorcery = true
			elseif name=="Major Resolve" and timeLeft>optimalBuffOverlap then
				MajorResolve = true
				if timeLeft < msUntilBuffRecheckNeeded then msUntilBuffRecheckNeeded = timeLeft; d("blarg") end
			elseif name=="Minor Mending" then
				MinorMending = true
			elseif name=="Deep Thoughts" then
				MeditationActive = true
			elseif name=="Elemental Weapon" then
				ImbueWeaponActive = true
			elseif name=="Blazing Shield" or name=="Radiant Ward" then
				DamageShield = true
			elseif name=="Dampen Magic" then
				DamageShield = true
			elseif name=="Major Expedition" and timeLeft>optimalBuffOverlap then
				MajorExpedition = true
				if timeLeft < msUntilBuffRecheckNeeded then msUntilBuffRecheckNeeded = timeLeft end
			elseif name=="Major Gallop" and timeLeft>optimalBuffOverlap then
				MajorGallop = true
				if timeLeft < msUntilBuffRecheckNeeded then msUntilBuffRecheckNeeded = timeLeft end
			-- elseif name=="Rending Leap Ranged" or name=="Uppercut" or name=="Skeletal Smash" or name=="Stunning Shock" or name=="Discharge" or name=="Constricting Strike" or name=="Stun" then
			-- 	MustBreakFree = true
			end
		end
		if msUntilBuffRecheckNeeded < 999999 then
			zo_callLater(UpdateBuffs, msUntilBuffRecheckNeeded-optimalBuffOverlap)
		end
	end
	BigLogicRoutine()
end





local function OnEventMountedStateChanged(eventCode,mounted)
	Mounted = mounted
	BigLogicRoutine()
end





local function OnEventEffectChanged(e, change, slot, auraName, unitTag, start, finish, stack, icon, buffType, effectType, abilityType, statusType, unitName, unitId, abilityId, sourceType)
	UpdateLowestGroupHealth()
	UpdateTargetInfo()
	if unitTag=="player" then
		UpdateBuffs()
	else
		BigLogicRoutine()
	end
end

local function OnEventPowerUpdate(eventCode, unitTag, powerIndex, powerType, powerValue, powerMax, powerEffectiveMax)
	if unitTag=="player" and powerType==POWERTYPE_STAMINA then
		StaminaPercent = powerValue / powerMax
		BigLogicRoutine()
		return
	end
	if powerType==POWERTYPE_HEALTH then
		UpdateLowestGroupHealth()
		BigLogicRoutine()
		return
	end
end

local function OnEventGroupSupportRangeUpdate()
	UpdateLowestGroupHealth()
	BigLogicRoutine()
end

local function OnEventCombatTipDisplay(_, tipId)
	if tipId == 2 then
		return
	elseif tipId == 4 or tipId == 19 then
		MustDodge = true
		BigLogicRoutine()
	elseif tipId == 3 then
		MustInterrupt = true
		BigLogicRoutine()
	elseif tipId == 1 then
		MustBlock = true
		BigLogicRoutine()
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
	BigLogicRoutine()
end

local function OnEventCombatEvent(_,result,_,_,_,_,_,_,targetName)
	if targetName == RawPlayerName then 
		if result == ACTION_RESULT_FEARED then
			Feared = true
		end
	end
end

local function OnEventStunStateChanged(_,StunState)
	Stunned = StunState
	BigLogicRoutine()
end




local function OnEventReticleChanged()
	UpdateTargetInfo()
	BigLogicRoutine()
end




local function OnEventBarSwap()
	UpdateBarState()
	UpdateAbilitySlotInfo()
	BigLogicRoutine()
end

local function OnEventAbilityChange()
	UpdateAbilitySlotInfo()
end




function PD_InputReady()
	InputReady = true
	BigLogicRoutine()
end

function PD_InputNotReady()
	InputReady = false
	BigLogicRoutine()
end

function PD_NotInCombat()
	InCombat = false
	InBossBattle = false
	BigLogicRoutine()
end

function PD_InCombat()
	InCombat = true
	UpdateAbilitySlotInfo()
	BigLogicRoutine()
end

function PD_NotMounted()
	Mounted = false
	BigLogicRoutine()
end

function PD_Mounted()
	Mounted = true
	BigLogicRoutine()
end

function PD_MagickaPercent(x)
	MagickaPercent = x
	BigLogicRoutine()
end

function PD_ReelInFish()
	ReelInFish = true
	BigLogicRoutine()
end

function PD_StopReelInFish()
	ReelInFish = false
	BigLogicRoutine()
end







local function OnAddonLoaded(event, name)
	if name == ADDON_NAME then
		EVENT_MANAGER:UnregisterForEvent(ADDON_NAME, event)
		PixelDataWindow = WINDOW_MANAGER:CreateTopLevelWindow("PixelData")
		PixelDataWindow:SetDimensions(100,100)

		PDL = CreateControl(nil, PixelDataWindow,  CT_LINE)
		PDL:SetAnchor(TOPLEFT, PixelDataWindow, TOPLEFT, 0, 0)
		PDL:SetAnchor(TOPRIGHT, PixelDataWindow, TOPLEFT, 1, 1)
		SetPixel(DoNothing)

		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_MOUNTED_STATE_CHANGED, OnEventMountedStateChanged)
		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_EFFECT_CHANGED, OnEventEffectChanged)
		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_POWER_UPDATE, OnEventPowerUpdate)
		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_GROUP_SUPPORT_RANGE_UPDATE, OnEventGroupSupportRangeUpdate)
		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_DISPLAY_ACTIVE_COMBAT_TIP, OnEventCombatTipDisplay)
		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_REMOVE_ACTIVE_COMBAT_TIP, OnEventCombatTipRemove)
		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_PLAYER_STUNNED_STATE_CHANGED, OnEventStunStateChanged)
		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_COMBAT_EVENT, OnEventCombatEvent)
		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_RETICLE_TARGET_CHANGED, OnEventReticleChanged)
		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_WEAPON_PAIR_LOCK_CHANGED, OnEventBarSwap)
		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ACTION_SLOT_UPDATED, OnEventBarSwap)
		-- EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_SKILL_BUILD_SELECTION_UPDATED, OnEventAbilityChange) -- Turns out this isn't the right event, I'm just going to update abilities when combat begins
		-- EVENT_MANAGER:AddFilterForEvent(ADDON_NAME, EVENT_COMBAT_EVENT, REGISTER_FILTER_TARGET_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_PLAYER)

		
		zo_callLater(InitialInfoGathering, 1000)
		
	end
end

EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED, OnAddonLoaded)
