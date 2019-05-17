LHGWSTConfig = {}
local config_frame

LHGWSTConfig.UpdateConfigFrameValues = function()
    LHGWSTConfig.config_frame.lock_checkbtn:SetChecked(LHG_WeapSwingTimer_Settings.is_locked)
    LHGWSTConfig.config_frame.width_editbox:SetText(tostring(LHG_WeapSwingTimer_Settings.width))
    LHGWSTConfig.config_frame.height_editbox:SetText(tostring(LHG_WeapSwingTimer_Settings.height))
    LHGWSTConfig.config_frame.xoffset_editbox:SetText(tostring(LHG_WeapSwingTimer_Settings.x_pos))
    LHGWSTConfig.config_frame.xoffset_editbox:SetText(tostring(LHG_WeapSwingTimer_Settings.x_pos))
    LHGWSTConfig.config_frame.yoffset_editbox:SetText(tostring(LHG_WeapSwingTimer_Settings.y_pos))
    LHGWSTConfig.config_frame.combat_alpha_slider:SetValue(LHG_WeapSwingTimer_Settings.in_combat_alpha)
    LHGWSTConfig.config_frame.ooc_alpha_slider:SetValue(LHG_WeapSwingTimer_Settings.ooc_alpha)
    LHGWSTConfig.config_frame.backplane_alpha_slider:SetValue(LHG_WeapSwingTimer_Settings.backplane_alpha)
end

local function Width_OnEnterPressed(self)
    self:ClearFocus()
    LHG_WeapSwingTimer_Settings.width = tonumber(self:GetText())
    LHGWSTMain.UpdateVisuals()
end

local function Height_OnEnterPressed(self)
    self:ClearFocus()
    LHG_WeapSwingTimer_Settings.height = tonumber(self:GetText())
    LHGWSTMain.UpdateVisuals()
end

local function XOffset_OnEnterPressed(self)
    self:ClearFocus()
    LHG_WeapSwingTimer_Settings.x_pos = tonumber(self:GetText())
    LHGWSTMain.UpdateVisuals()
end

local function YOffset_OnEnterPressed(self)
    self:ClearFocus()
    LHG_WeapSwingTimer_Settings.y_pos = tonumber(self:GetText())
    LHGWSTMain.UpdateVisuals()
end

local function CombatAlpha_OnValueChanged(self)
    LHG_WeapSwingTimer_Settings.in_combat_alpha = tonumber(self:GetValue())
    LHGWSTMain.UpdateVisuals()
end

local function OOCAlpha_OnValueChanged(self)
    LHG_WeapSwingTimer_Settings.ooc_alpha = tonumber(self:GetValue())
    LHGWSTMain.UpdateVisuals()
end

local function BackplaneAlpha_OnValueChanged(self)
    LHG_WeapSwingTimer_Settings.backplane_alpha = tonumber(self:GetValue())
    LHGWSTMain.UpdateVisuals()
end

local function HideConfigFrame()
    LHGWSTConfig.config_frame:Hide()
end

local function ConfigFrame_OnDragStart()
    LHGWSTConfig.config_frame:StartMoving()
end

local function ConfigFrame_OnDragStop()
    LHGWSTConfig.config_frame:StopMovingOrSizing()
end

local function TextFactory(parent, text, size)
    local text_obj = parent:CreateFontString(nil, "ARTWORK")
    text_obj:SetFont("Fonts/FRIZQT__.ttf", size)
    text_obj:SetJustifyV("CENTER")
    text_obj:SetJustifyH("CENTER")
    text_obj:SetText(text)
    return text_obj
end

local function EditBoxFactory(parent, title, enter_func)
    local edit_box_obj = CreateFrame("EditBox", nil, parent)
    edit_box_obj.title_text = TextFactory(edit_box_obj, title, 11)
    edit_box_obj.title_text:SetPoint("TOP", 0, 10)
    edit_box_obj:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true,
        tileSize = 100,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4}
    })
    edit_box_obj:SetBackdropColor(0,0,0,1)
    edit_box_obj:SetSize(100, 25)
    edit_box_obj:SetMultiLine(false)
    edit_box_obj:SetAutoFocus(false)
    edit_box_obj:SetMaxLetters(4)
    edit_box_obj:SetJustifyH("CENTER")
	edit_box_obj:SetJustifyV("CENTER")
    edit_box_obj:SetFontObject(GameFontNormal)
    edit_box_obj:SetScript("OnEnterPressed", function(self)
        enter_func(self)
    end)
    edit_box_obj:SetScript("OnEscapePressed", function(self)
        self:ClearFocus()
    end)
    return edit_box_obj
end

--simple round number func
  local SimpleRound = function(val,valStep)
    return floor(val/valStep)*valStep
  end
 
--basic slider func
local CreateBasicSlider = function(parent, name, title, minVal, maxVal, valStep, func)
    local slider = CreateFrame("Slider", name, parent, "OptionsSliderTemplate")
    local editbox = CreateFrame("EditBox", "$parentEditBox", slider, "InputBoxTemplate")
    slider:SetMinMaxValues(minVal, maxVal)
    --slider:SetValue(0)
    slider:SetValueStep(valStep)
    slider.text = _G[name.."Text"]
    slider.text:SetText(title)
    slider.textLow = _G[name.."Low"]
    slider.textHigh = _G[name.."High"]
    slider.textLow:SetText(floor(minVal))
    slider.textHigh:SetText(floor(maxVal))
    slider.textLow:SetTextColor(0.8,0.8,0.8)
    slider.textHigh:SetTextColor(0.8,0.8,0.8)
    slider:SetObeyStepOnDrag(true)
    editbox:SetSize(45,30)
    editbox:ClearAllPoints()
    editbox:SetPoint("LEFT", slider, "RIGHT", 15, 0)
    editbox:SetText(slider:GetValue())
    editbox:SetAutoFocus(false)
    slider:SetScript("OnValueChanged", function(self)
        editbox:SetText(tostring(SimpleRound(self:GetValue(), valStep)))
        func(self)
    end)
    editbox:SetScript("OnTextChanged", function(self)
        local val = self:GetText()
        if tonumber(val) then
            self:GetParent():SetValue(val)
        end
    end)
    editbox:SetScript("OnEnterPressed", function(self)
        local val = self:GetText()
        if tonumber(val) then
            self:GetParent():SetValue(val)
            self:ClearFocus()
        end
    end)
    slider.editbox = editbox
    return slider
end

LHGWSTConfig.CreateLHGWSTConfigFrame = function()
    -- Setup the config frame
    LHGWSTConfig.config_frame = CreateFrame("Frame", "WSTConfigFrame", UIParent)
    local config_frame = LHGWSTConfig.config_frame
    config_frame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true,
        tileSize = 100,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4}
    })
    config_frame:SetBackdropColor(0,0,0,1)
    config_frame:SetWidth(250)
    config_frame:SetHeight(310)
    config_frame:SetPoint("CENTER", 0, 0)
    config_frame:Hide()
    -- Setup the config frame's title
    config_frame.title_frame = CreateFrame("Frame", "WSTConfigFrameTitle", config_frame)
    config_frame.title_frame:SetBackdrop({
        bgFile = "Interface/FrameGeneral/UI-Background-Rock",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true,
        tileSize = 100,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4}
    })
    config_frame.title_frame:SetBackdropColor(1,1,1,1)
    config_frame.title_frame:SetWidth(config_frame:GetWidth())
    config_frame.title_frame:SetHeight(30)
    config_frame.title_frame:SetPoint("TOP", 0, 0)
    -- Add the title's name
    config_frame.title_frame.text = TextFactory(
        config_frame.title_frame, "WeaponSwingTimer", 16)
    config_frame.title_frame.text:SetPoint("CENTER", 0, 0)
    -- Add the close button
    config_frame.title_frame.close_btn = CreateFrame("Button", "WSTCloseButton", config_frame.title_frame)
    config_frame.title_frame.close_btn:SetWidth(20)
    config_frame.title_frame.close_btn:SetHeight(20)
    config_frame.title_frame.close_btn:SetNormalTexture("Interface/Addons/WeaponSwingTimer/Images/CloseUp")
    config_frame.title_frame.close_btn:SetPushedTexture("Interface/Addons/WeaponSwingTimer/Images/CloseDown")
    config_frame.title_frame.close_btn:SetPoint("RIGHT", -5, 0)
    config_frame.title_frame.close_btn:SetScript("OnClick", HideConfigFrame)
    -- Add the lock checkbox
    config_frame.lock_checkbtn = CreateFrame("CheckButton", "WSTLockCheckbtn", config_frame, "OptionsCheckButtonTemplate")
    config_frame.lock_checkbtn:SetPoint("TOPLEFT", 17, -40)
    getglobal(config_frame.lock_checkbtn:GetName() .. 'Text'):SetText(" Lock Frame")
    config_frame.lock_checkbtn.tooltip = "Prevents the frame from being dragged."
    config_frame.lock_checkbtn:SetScript("OnClick", function(self)
        LHG_WeapSwingTimer_Settings.is_locked = self:GetChecked()
    end)
    config_frame.lock_checkbtn:SetChecked(LHG_WeapSwingTimer_Settings.is_locked)
    -- Add restore defaults button
    config_frame.restore_defaults_btn = CreateFrame("Button", nil, config_frame)
	config_frame.restore_defaults_btn:SetPoint("TOPRIGHT", -20, -37)
	config_frame.restore_defaults_btn:SetWidth(75)
	config_frame.restore_defaults_btn:SetHeight(25)
	config_frame.restore_defaults_btn:SetText("Defaults")
	config_frame.restore_defaults_btn:SetNormalFontObject("GameFontNormal")
	local ntex = config_frame.restore_defaults_btn:CreateTexture()
	ntex:SetTexture("Interface/Buttons/UI-Panel-Button-Up")
	ntex:SetTexCoord(0, 0.625, 0, 0.6875)
	ntex:SetAllPoints()	
	config_frame.restore_defaults_btn:SetNormalTexture(ntex)
	local htex = config_frame.restore_defaults_btn:CreateTexture()
	htex:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight")
	htex:SetTexCoord(0, 0.625, 0, 0.6875)
	htex:SetAllPoints()
	config_frame.restore_defaults_btn:SetHighlightTexture(htex)
	local ptex = config_frame.restore_defaults_btn:CreateTexture()
	ptex:SetTexture("Interface/Buttons/UI-Panel-Button-Down")
	ptex:SetTexCoord(0, 0.625, 0, 0.6875)
	ptex:SetAllPoints()
	config_frame.restore_defaults_btn:SetPushedTexture(ptex)
    config_frame.restore_defaults_btn:SetScript("OnClick", LHGWSTCore.RestoreDefaults)
    -- Add the width control
    config_frame.width_editbox = EditBoxFactory(config_frame, "Width", Width_OnEnterPressed)
    config_frame.width_editbox:SetPoint("TOP", -55, -80, "BOTTOMRIGHT", 60, -140)
    config_frame.width_editbox:SetText(tostring(LHG_WeapSwingTimer_Settings.width))
    -- Add the height control
    config_frame.height_editbox = EditBoxFactory(config_frame, "Height", Height_OnEnterPressed)
    config_frame.height_editbox:SetPoint("TOP", 55, -80)
    config_frame.height_editbox:SetText(tostring(LHG_WeapSwingTimer_Settings.height))
    -- Add the x offset control
    config_frame.xoffset_editbox = EditBoxFactory(config_frame, "X Offset", XOffset_OnEnterPressed)
    config_frame.xoffset_editbox:SetPoint("TOP", -55, -120)
    config_frame.xoffset_editbox:SetText(tostring(LHG_WeapSwingTimer_Settings.x_pos))
    -- Add the y offset control
    config_frame.yoffset_editbox = EditBoxFactory(config_frame, "Y Offset", YOffset_OnEnterPressed)
    config_frame.yoffset_editbox:SetPoint("TOP", 55, -120)
    config_frame.yoffset_editbox:SetText(tostring(LHG_WeapSwingTimer_Settings.y_pos))
    -- Add the alpha sliders
    config_frame.combat_alpha_slider = CreateBasicSlider(config_frame, "WSTCombatAlphaSlider", "In Combat Alpha", 0, 1, 0.05, CombatAlpha_OnValueChanged)
    config_frame.combat_alpha_slider:SetPoint("TOP", -30, -170)
    config_frame.combat_alpha_slider:SetValue(LHG_WeapSwingTimer_Settings.in_combat_alpha)
    config_frame.ooc_alpha_slider = CreateBasicSlider(config_frame, "WSTOOCAlphaSlider", "Out of Combat Alpha", 0, 1, 0.05, OOCAlpha_OnValueChanged)
    config_frame.ooc_alpha_slider:SetPoint("TOP", -30, -220)
    config_frame.ooc_alpha_slider:SetValue(LHG_WeapSwingTimer_Settings.ooc_alpha)
    config_frame.backplane_alpha_slider = CreateBasicSlider(config_frame, "WSTBackPlaneAlphaSlider", "Backplane Alpha", 0, 1, 0.05, BackplaneAlpha_OnValueChanged)
    config_frame.backplane_alpha_slider:SetPoint("TOP", -30, -270)
    config_frame.backplane_alpha_slider:SetValue(LHG_WeapSwingTimer_Settings.backplane_alpha)
    -- parent, name, title, minVal, maxVal, valStep
    -- Set the scripts that control the config_frame
    config_frame:SetMovable(true)
    config_frame.title_frame:EnableMouse(true)
    config_frame.title_frame:RegisterForDrag("LeftButton")
    config_frame.title_frame:SetScript("OnDragStart", ConfigFrame_OnDragStart)
    config_frame.title_frame:SetScript("OnDragStop", ConfigFrame_OnDragStop)
    -- return the config frame
    return config_frame
end
