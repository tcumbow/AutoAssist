local ADDON_NAME = "PixelData"
local ADDON_VERSION = "1.0"
local ADDON_AUTHOR = "Tom Cumbow"

local SV

local function OnEventMountedStateChanged(eventCode,mounted)
	if mounted then
		PD_Mounted()
	else
		PD_NotMounted()
	end
end

local function OnEventEffectChanged(e, change, slot, auraName, unitTag, start, finish, stack, icon, buffType, effectType, abilityType, statusType, unitName, unitId, abilityId, sourceType)
	if unitTag=="player" then
		local MajorSorcery, MajorProphesy, MinorSorcery, MajorResolve, MinorMending = false, false, false, false, false
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
		if MajorResolve then
			PDL_MajorResolve:SetColor(255,255,255,255)
		else
			PDL_MajorResolve:SetColor(0,0,0,255)
		end
	end
end

function PD_InputReady()
	PDL_InputReady:SetColor(0,0,0,255)
end

function PD_InputNotReady()
	PDL_InputReady:SetColor(255,255,255,255)
end

function PD_NotInCombat()
	PDL_InCombat:SetColor(0,0,0,255)
end

function PD_InCombat()
	PDL_InCombat:SetColor(255,255,255,255)
end

function PD_NotMounted()
	PDL_Mounted:SetColor(0,0,0,255)
end

function PD_Mounted()
	PDL_Mounted:SetColor(255,255,255,255)
end

function PD_HealingNotNeeded()
	PDL_HealingNeeded:SetColor(0,0,0,255)
end

function PD_HealingNeeded()
	PDL_HealingNeeded:SetColor(255,255,255,255)
end

function PD_MagPlenty()
	PDL_MagPlenty:SetColor(0,0,0,255)
end

function PD_MagNotPlenty()
	PDL_MagPlenty:SetColor(255,255,255,255)
end



local function OnAddonLoaded(event, name)
	if name == ADDON_NAME then
		EVENT_MANAGER:UnregisterForEvent(ADDON_NAME, event)
		PixelDataWindow = WINDOW_MANAGER:CreateTopLevelWindow("Sandbox")
		PixelDataWindow:SetDimensions(100,100)

		PDL_InputReady  = CreateControl(nil, PixelDataWindow,  CT_LINE)
		PDL_InputReady:SetAnchor(TOPLEFT, PixelDataWindow, TOPLEFT, 1, 0)
		PDL_InputReady:SetAnchor(TOPRIGHT, PixelDataWindow, TOPLEFT, 1, 1)
		PDL_InputReady:SetColor(0,0,0,255)
	
		PDL_InCombat  = CreateControl(nil, PixelDataWindow,  CT_LINE)
		PDL_InCombat:SetAnchor(TOPLEFT, PixelDataWindow, TOPLEFT, 3, 0)
		PDL_InCombat:SetAnchor(TOPRIGHT, PixelDataWindow, TOPLEFT, 3, 1)
		PDL_InCombat:SetColor(0,0,0,255)
	
		PDL_HealingNeeded  = CreateControl(nil, PixelDataWindow,  CT_LINE)
		PDL_HealingNeeded:SetAnchor(TOPLEFT, PixelDataWindow, TOPLEFT, 5, 0)
		PDL_HealingNeeded:SetAnchor(TOPRIGHT, PixelDataWindow, TOPLEFT, 5, 1)
		PDL_HealingNeeded:SetColor(0,0,0,255)
	
		PDL_MagPlenty  = CreateControl(nil, PixelDataWindow,  CT_LINE)
		PDL_MagPlenty:SetAnchor(TOPLEFT, PixelDataWindow, TOPLEFT, 7, 0)
		PDL_MagPlenty:SetAnchor(TOPRIGHT, PixelDataWindow, TOPLEFT, 7, 1)
		PDL_MagPlenty:SetColor(0,0,0,255)

		PDL_Mounted  = CreateControl(nil, PixelDataWindow,  CT_LINE)
		PDL_Mounted:SetAnchor(TOPLEFT, PixelDataWindow, TOPLEFT, 9, 0)
		PDL_Mounted:SetAnchor(TOPRIGHT, PixelDataWindow, TOPLEFT, 9, 1)
		PDL_Mounted:SetColor(0,0,0,255)

		PDL_MajorResolve  = CreateControl(nil, PixelDataWindow,  CT_LINE)
		PDL_MajorResolve:SetAnchor(TOPLEFT, PixelDataWindow, TOPLEFT, 11, 0)
		PDL_MajorResolve:SetAnchor(TOPRIGHT, PixelDataWindow, TOPLEFT, 11, 1)
		PDL_MajorResolve:SetColor(0,0,0,255)

		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_MOUNTED_STATE_CHANGED, OnEventMountedStateChanged)
		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_EFFECT_CHANGED, OnEventEffectChanged)
	
	end
end

EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED, OnAddonLoaded)
