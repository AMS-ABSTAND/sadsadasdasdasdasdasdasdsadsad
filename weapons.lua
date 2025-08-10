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
        pattern = {
            -- Normalized values to ensure the recoil compensation ramps down smoothly
            { x =  0, y = 31, delay = 7 },
            { x = -1, y = 29, delay = 7 },
            { x =  0, y = 26, delay = 6 },
            { x = -1, y = 24, delay = 5 },
            { x =  0, y = 22, delay = 5 },
            { x =  0, y = 20, delay = 4 },
            { x =  0, y = 18, delay = 4 },
            { x = -1, y = 16, delay = 3 },
            { x =  0, y = 14, delay = 3 },
            { x = -1, y = 12, delay = 3 },
            { x = -1, y = 10, delay = 3 },
            { x = -1, y =  8, delay = 3 },
            { x = -1, y =  6, delay = 3 },
            { x = -1, y =  4, delay = 3 },
            { x = -1, y =  2, delay = 3 },
        }
    },

    ["552"] = { -- Grim’s 552 Commando recoil compensation
        name = "552 Commando (Grim)",
        X_SHIFT_EARLY = 0,
        X_SHIFT_MID   = 0,
        X_SHIFT_LATE  = 0,
        X_FROM1       = 1,
        X_FROM2       = 6,
        Y_SCALE_MID   = 1.0,
        Y_SCALE_LATE  = 1.05,
        Y_FROM1       = 4,
        Y_FROM2       = 8,
        pattern = {
            -- All Y values are positive so that the mouse is moved down to compensate for recoil
            { x = -1, y = 20, delay = 7 },
            { x = -1, y = 19, delay = 6 },
            { x = -1, y = 18, delay = 6 },
            { x = -1, y = 17, delay = 5 },
            { x = -1, y = 16, delay = 5 },
            { x = -1, y = 15, delay = 4 },
            { x = -1, y = 14, delay = 4 },
            { x = -1, y = 13, delay = 3 },
            { x = -1, y = 12, delay = 3 },
            { x = -1, y = 11, delay = 3 },
            { x = -1, y = 10, delay = 3 },
        }
    }
}

return weapons
