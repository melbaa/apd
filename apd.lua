local ADDON_NAME = "apd"

APD = {}

local playerClass = string.upper(UnitClass('player'));

-- Interface
APD.f1 = CreateFrame("Frame",nil,UIParent)
APD.f1:SetMovable(true)
APD.f1:EnableMouse(true)
APD.f1:SetWidth(100) 
APD.f1:SetHeight(100) 
APD.f1:SetAlpha(.90);
APD.f1:SetPoint("CENTER",350,-100)
APD.f1.text = APD.f1:CreateFontString(nil,"ARTWORK") 
APD.f1.text:SetFont("Fonts\\ARIALN.ttf", 24, "OUTLINE")
APD.f1.text:SetPoint("CENTER",0,0)
APD.f1:RegisterForDrag("LeftButton")
APD.f1:SetScript("OnDragStart", function() APD.f1:StartMoving() end)
APD.f1:SetScript("OnDragStop", function()
    APD.f1:StopMovingOrSizing()
    point, _, rel_point, x_offset, y_offset = APD.f1:GetPoint()

    if x_offset < 20 and x_offset > -20 then
        x_offset = 0
    end

    apd_opts.point = point
    apd_opts.rel_point = rel_point
    apd_opts.x_offset = floor(x_offset / 1) * 1
    apd_opts.y_offset = floor(y_offset / 1) * 1
end);
APD.f1:Hide()

function APD:Init()
    if not apd_opts then
        apd_opts = {
            point = "CENTER",
            rel_point = "CENTER",
            x_offset = 350,
            y_offset = -100,
        }
    end

    APD.f1:SetPoint(apd_opts.point, UIParent, apd_opts.rel_point, apd_opts.x_offset, apd_opts.y_offset)
end
 
function displayupdate(show, message)
    if show == 1 then
        APD.f1.text:SetText(message)
        APD.f1:Show()
    elseif show == 2 then
        APD.f1:Hide()
    else
        APD.f1:Hide()
    end
end

function displayString()
    local ret
    if playerClass=="WARRIOR" then
        ret = displayAP()
    elseif playerClass=="PRIEST" then
        ret = displaySP()
    elseif playerClass=="ROGUE" then
        ret = displayAP()
    elseif playerClass=="HUNTER" then
        ret = displayRAP()
    elseif playerClass=="MAGE" then
        ret = displaySP()
    elseif playerClass=="WARLOCK" then
        ret = displaySP()
    else
        ret = displayAP()
    end
    return ret
end

function displayAP()
    local base, posBuff, negBuff = UnitAttackPower("player");
    local ap = base + posBuff + negBuff;
    return "|cffffffff AP "..ap
end

function displayRAP()
    local base, posBuff, negBuff = UnitRangedAttackPower("player");
    local ap = base + posBuff + negBuff;
    return "|cffffffff RAP "..ap
end

function displaySP()
    local sp = GetSpellBonusDamage(1);
    -- Holy
    -- sp = GetSpellBonusDamage(2);
    -- Fire
    -- sp = GetSpellBonusDamage(3);
    -- Nature
    -- sp = GetSpellBonusDamage(4);
    -- Frost
    -- sp = GetSpellBonusDamage(5);
    -- Shadow
    -- sp = GetSpellBonusDamage(6);
    -- Arcane
    -- sp = GetSpellBonusDamage(7);

    return "|cffffffff SP "..sp
end

-- f1:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
-- f1:RegisterEvent("PLAYER_TALENT_UPDATE")
-- f1:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
-- f1:RegisterEvent("PLAYER_REGEN_DISABLED")
-- f1:RegisterEvent("PLAYER_REGEN_ENABLED")
APD.f1:RegisterEvent("ADDON_LOADED")
-- f1:RegisterEvent("PLAYER_ENTERING_WORLD")
APD.f1:RegisterEvent("UNIT_INVENTORY_CHANGED")
APD.f1:RegisterEvent("UNIT_AURA")

APD.f1:SetScript("OnEvent", function()
    -- local base, posBuff, negBuff = UnitAttackPower("player");
    -- local ap = base + posBuff + negBuff;
    displayupdate(1, displayString())
    -- DEFAULT_CHAT_FRAME:AddMessage("|cFFF5F54A attack power display:|r " .. tostring(event) .. " " .. tostring(arg1) ,1,1,1)
    if event == "ADDON_LOADED" then
        if arg1 == ADDON_NAME then
            DEFAULT_CHAT_FRAME:AddMessage("|cFFF5F54A attack power display:|r Loaded",1,1,1)
            APD:Init()
        end
    end
end);
