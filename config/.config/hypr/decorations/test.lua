-----------------------
---- LOOK AND FEEL ----
-----------------------

--- imported colors.lua
local a = require("colors.colors")

hl.config({
    general = {
        gaps_in  = 7,
        gaps_out = 14,

        border_size = 1,

        col = {
            active_border   = a.red,
            inactive_border = a.fg,
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = true,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        
    },

    decoration = {
        rounding       = 14,
        rounding_power = 5,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1,
        inactive_opacity = 1,

        shadow = {
            enabled      = true,
            range        = 7,
            render_power = 1,
            color        = a.bg0,
            scale        = 2,
            offset       = {1 ,1}
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
        -- glow = {
        --     enabled = true;
        --     color =0xee33ccff;
        --     render_power = 1;
        --     range = 21
        -- }
     
       
    },


    animations = {
        enabled = true,
    },
})

