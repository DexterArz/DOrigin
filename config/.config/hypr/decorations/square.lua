-----------------------
---- LOOK AND FEEL ----
-----------------------

--- imported colors.lua
local a = require("colors.colors")

hl.config({
    general = {
        gaps_in  = 14,
        gaps_out = 9,

        border_size = 3,

        col = {
            active_border   = a.orange,
            inactive_border = a.fg,
 2        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = true,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        
    },

    decoration = {
        rounding       = 0,
        rounding_power = 5,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = false,
            range        = 7,
            render_power = 1,
            -- color        = 	ff00003f,
            scale        = 1,
            offset       = {3 ,2.5}
        },

        blur = {
            enabled   = true,
            size      = 5,
            passes    = 3,
            vibrancy  = 1.1696,
            special = true,
            popups = true,
            noise = 0,
            -- new_optimizations = true
        },


       
    },



    animations = {
        enabled = true,
    },
})

