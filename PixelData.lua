local ADDON_NAME = "PixelData"
local ADDON_VERSION = "1.0"
local ADDON_AUTHOR = "Tom Cumbow"

local SV


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
		PDL_InputReady:SetAnchor(TOPLEFT, PixelDataWindow, TOPLEFT, 0, 0)
		PDL_InputReady:SetAnchor(TOPRIGHT, PixelDataWindow, TOPLEFT, 0, 1)
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
	
	end
end

EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED, OnAddonLoaded)
