-- Multi-Weapon Recoil Script
-- 800 DPI, Flash Hider + Vertical Grip (or similar setup)

local isRecoilEnabled = false
local recoilIndex = 1
local currentWeapon = "ash" -- default weapon

-- === Config ===
local CONFIG = { DPI = 800 }
local DPI_FACTOR = CONFIG.DPI / 800
local sensitivityMultiplier = 1.0

-- === Weapon Patterns ===
local weapons = require("weapons")

-- === Helpers ===
local function getWeapon()
    return weapons[currentWeapon]
end

local function x_shift_for(idx)
    local w = getWeapon()
    if idx >= w.X_FROM2 then return w.X_SHIFT_LATE
    elseif idx >= w.X_FROM1 then return w.X_SHIFT_MID
    else return w.X_SHIFT_EARLY end
end

local function y_scale_for(idx)
    local w = getWeapon()
    if idx >= w.Y_FROM2 then return w.Y_SCALE_LATE
    elseif idx >= w.Y_FROM1 then return w.Y_SCALE_MID
    else return 1.0 end
end

local function MoveMouseStep(step, idx)
    idx = idx or recoilIndex
    local adjX = math.floor((step.x + x_shift_for(idx)) * DPI_FACTOR * sensitivityMultiplier)
    local adjY = math.floor(step.y * y_scale_for(idx) * DPI_FACTOR * sensitivityMultiplier)
    MoveMouseRelative(adjX, adjY)
    Sleep(step.delay or 5)
end

-- === Logic ===
function OnEvent(event, arg)
    if event == "PROFILE_ACTIVATED" then
        EnablePrimaryMouseButtonEvents(true)
        isRecoilEnabled = false
        recoilIndex = 1
        OutputLogMessage("Active weapon: %s\n", getWeapon().name)
    end

    if event == "MOUSE_BUTTON_PRESSED" then
        if arg == 5 then
            -- Toggle recoil ON/OFF
            isRecoilEnabled = not isRecoilEnabled
            OutputLogMessage("Recoil %s\n", isRecoilEnabled and "ON" or "OFF")

        elseif arg == 4 then
            -- Switch weapon profile
            if currentWeapon == "ash" then
                currentWeapon = "552"
            else
                currentWeapon = "ash"
            end
            recoilIndex = 1
            OutputLogMessage("Switched to: %s\n", getWeapon().name)

        elseif arg == 1 and isRecoilEnabled then
            -- Apply recoil only if right click is also held
            if IsMouseButtonPressed(3) then
                local w = getWeapon()
                if recoilIndex > #w.pattern then recoilIndex = 1 end
                MoveMouseStep(w.pattern[recoilIndex], recoilIndex)
                recoilIndex = recoilIndex + 1

                -- Keep calling recursively as long as left + right click held
                if IsMouseButtonPressed(1) and IsMouseButtonPressed(3) then
                    OnEvent("MOUSE_BUTTON_PRESSED", 1)
                else
                    recoilIndex = 1
                end
            end
        end
    end

    if event == "MOUSE_BUTTON_RELEASED" and (arg == 1 or arg == 3) then
        recoilIndex = 1
    end
end
