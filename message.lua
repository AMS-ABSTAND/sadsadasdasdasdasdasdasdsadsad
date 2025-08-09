diff --git a/message.lua b/message.lua
index d5e360366df72a688150a2a4329969d02af65364..9973e0f10b5711508d141909e95b8bce6fe71609 100644
--- a/message.lua
+++ b/message.lua
@@ -1,144 +1,147 @@
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
 local weapons = {
     ["ash"] = {
         name = "R4-C (Ash/Ram)",
         X_SHIFT_EARLY = 0,
         X_SHIFT_MID   = -1,
         X_SHIFT_LATE  = -1,
         X_FROM1       = 6,
         X_FROM2       = 13,
         Y_SCALE_MID   = 1.10,
         Y_SCALE_LATE  = 1.13,
         Y_FROM1       = 8,
         Y_FROM2       = 13,
-        pattern = {
-            {x =  0, y = 31, delay = 7},
-            {x = -1, y = 29, delay = 7},
-            {x =  0, y = 26, delay = 6},
-            {x = -1, y = 27, delay = 5},
-            {x =  0, y = 25, delay = 5},
-            {x =  0, y = 23, delay = 4},
-            {x =  0, y = 21, delay = 4},
-            {x = -1, y = 21, delay = 3},
-            {x =  0, y = 18, delay = 3},
-            {x = -1, y = 16, delay = 3},
-            {x = -1, y = 13, delay = 3},
-            {x = -1, y = 11, delay = 3},
-            {x = -1, y =  9, delay = 3},
-            {x = -1, y =  7, delay = 3},
-            {x = -1, y =  6, delay = 3},
-        }
+        pattern = {
+            -- Normalized values to ensure the recoil compensation ramps down smoothly
+            { x =  0, y = 31, delay = 7 },
+            { x = -1, y = 29, delay = 7 },
+            { x =  0, y = 26, delay = 6 },
+            { x = -1, y = 24, delay = 5 },
+            { x =  0, y = 22, delay = 5 },
+            { x =  0, y = 20, delay = 4 },
+            { x =  0, y = 18, delay = 4 },
+            { x = -1, y = 16, delay = 3 },
+            { x =  0, y = 14, delay = 3 },
+            { x = -1, y = 12, delay = 3 },
+            { x = -1, y = 10, delay = 3 },
+            { x = -1, y =  8, delay = 3 },
+            { x = -1, y =  6, delay = 3 },
+            { x = -1, y =  4, delay = 3 },
+            { x = -1, y =  2, delay = 3 },
+        }
     },
 
-["552"] = { -- Grim’s 552 Commando recoil compensation
-    name = "552 Commando (Grim)",
-    X_SHIFT_EARLY = 0,
-    X_SHIFT_MID   = 0,
-    X_SHIFT_LATE  = 0,
-    X_FROM1       = 1,
-    X_FROM2       = 6,
-    Y_SCALE_MID   = 1.0,
-    Y_SCALE_LATE  = 1.05,
-    Y_FROM1       = 4,
-    Y_FROM2       = 8,
-    pattern = {
-        { x = -1,  y = -20, delay = 7 },
-        { x = -1,  y = -19, delay = 6 },
-        { x = -1,  y = -18, delay = 6 },
-        { x = -1,  y = -17, delay = 5 },
-        { x = -1,  y = -16, delay = 5 },
-        { x = -1,  y = -15, delay = 4 },
-        { x = -1,  y = -14, delay = 4 },
-        { x = -1,  y = -13, delay = 3 },
-        { x = -1,  y = -12, delay = 3 },
-        { x = -1,  y = -11, delay = 3 },
-        { x = -1,  y = -10, delay = 3 },
-    }
-}
+    ["552"] = { -- Grim’s 552 Commando recoil compensation
+        name = "552 Commando (Grim)",
+        X_SHIFT_EARLY = 0,
+        X_SHIFT_MID   = 0,
+        X_SHIFT_LATE  = 0,
+        X_FROM1       = 1,
+        X_FROM2       = 6,
+        Y_SCALE_MID   = 1.0,
+        Y_SCALE_LATE  = 1.05,
+        Y_FROM1       = 4,
+        Y_FROM2       = 8,
+        pattern = {
+            -- All Y values are positive so that the mouse is moved down to compensate for recoil
+            { x = -1, y = 20, delay = 7 },
+            { x = -1, y = 19, delay = 6 },
+            { x = -1, y = 18, delay = 6 },
+            { x = -1, y = 17, delay = 5 },
+            { x = -1, y = 16, delay = 5 },
+            { x = -1, y = 15, delay = 4 },
+            { x = -1, y = 14, delay = 4 },
+            { x = -1, y = 13, delay = 3 },
+            { x = -1, y = 12, delay = 3 },
+            { x = -1, y = 11, delay = 3 },
+            { x = -1, y = 10, delay = 3 },
+        }
+    }
 }
 
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
 
-        elseif arg == 4 then
-            -- Switch weapon profile
-            if currentWeapon == "ash" then
-                currentWeapon = "552"
-            else
-                currentWeapon = "ash"
-            end
-            OutputLogMessage("Switched to: %s\n", getWeapon().name)
+        elseif arg == 4 then
+            -- Switch weapon profile
+            if currentWeapon == "ash" then
+                currentWeapon = "552"
+            else
+                currentWeapon = "ash"
+            end
+            recoilIndex = 1
+            OutputLogMessage("Switched to: %s\n", getWeapon().name)
 
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
 
-    if event == "MOUSE_BUTTON_RELEASED" and arg == 1 then
-        recoilIndex = 1
-    end
-end
+    if event == "MOUSE_BUTTON_RELEASED" and (arg == 1 or arg == 3) then
+        recoilIndex = 1
+    end
+end
