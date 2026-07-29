-- Input configuration.

hl.config({
    input = {
        kb_layout = "us",
        numlock_by_default = true,

        sensitivity = 0.1,
        accel_profile = "adaptive",

        touchpad = {
            natural_scroll = false,
            tap_to_click = true,
            disable_while_typing = true,
        },
    },

    cursor = {
        no_warps = true,
        hide_on_key_press = true,
        inactive_timeout = 3,
    },
})

hl.device({
    name = "syna8006:00-06cb:cd8b-touchpad",
    sensitivity = 0.3,
})
