--[[
2-highlight-colour-buttons.lua - KOReader user patch (2026-11-20)

The text-selection menu gets one-tap colour buttons (yellow, blue, green,
red, orange) plus Add note, Dictionary and Search; the other stock buttons
are dropped. Buttons that plugins add later (Ink Away's handwritten note,
Aleph's X-Ray) stay. QR code and Aleph's Pin are hidden in this menu only.

With the modified Aleph aleph_highlight.lua from this package, the colour
buttons are drawn as a row of colour circles with an icon row below.
Without it, they show as plain text buttons named after your colours.

Edit COLOURS / KEEP below to change the buttons.
Undo: delete this file and restart KOReader.
]]

local ReaderHighlight = require("apps/reader/modules/readerhighlight")

-- Colour buttons, in order (KOReader colour ids).
local COLOURS = { "yellow", "blue", "green", "red", "orange" }

-- Stock buttons to keep, with the key that sets their place (menus sort by key).
local KEEP = {
    add_note = "002_add_note",
    dictionary = "05_dictionary",
    search = "15_search",
}

-- Plugin buttons hidden in the selection menu only (they keep working elsewhere).
local HIDE_IN_SELECT = {
    ["12_generate_qr_code"] = true,
    ["13_aleph_pin"] = true,
}

-- Save the selection with a given style and colour, then restore the defaults.
function ReaderHighlight:saveHighlightFormatted(extend_to_sentence, drawer, color)
    local hv = self.view.highlight
    local old_drawer, old_color = hv.saved_drawer, hv.saved_color
    hv.saved_drawer = drawer or old_drawer
    hv.saved_color = color or old_color
    local ok, index = pcall(self.saveHighlight, self, extend_to_sentence)
    hv.saved_drawer, hv.saved_color = old_drawer, old_color
    if not ok then error(index, 0) end
    return index
end

-- A button that saves the selection in `color`, named after the colour's
-- current name (rename colours in Aleph's colour panel and the buttons follow).
local function colourButton(color)
    return function(this)
        local label = color
        for _i, entry in ipairs(this.highlight_colors or {}) do
            if entry[2] == color then label = entry[1]; break end
        end
        return {
            text = label,
            enabled = this.hold_pos ~= nil,
            callback = function()
                this:saveHighlightFormatted(false, this.view.highlight.saved_drawer or "lighten", color)
                this:onClose()
            end,
        }
    end
end

local orig_init = ReaderHighlight.init
function ReaderHighlight:init(...)
    orig_init(self, ...)
    local buttons = {}
    for i, color in ipairs(COLOURS) do
        buttons[string.format("%04d_hl_%s", i, color)] = colourButton(color)
    end
    for key, fn in pairs(self._highlight_buttons or {}) do
        local name = (tostring(key):gsub("^[%d_]+", ""))
        if KEEP[name] then buttons[KEEP[name]] = fn end
    end
    self._highlight_buttons = buttons

    -- Hide some plugin buttons while the selection menu opens (instance-level,
    -- so it still wraps whatever replaces the menu later, e.g. Aleph).
    self.onShowHighlightMenu = function(this, ...)
        local saved = {}
        for key in pairs(HIDE_IN_SELECT) do
            if this._highlight_buttons[key] then
                saved[key] = this._highlight_buttons[key]
                this._highlight_buttons[key] = nil
            end
        end
        local ok, res = pcall(ReaderHighlight.onShowHighlightMenu, this, ...)
        for key, fn in pairs(saved) do this._highlight_buttons[key] = fn end
        if not ok then error(res, 0) end
        return res
    end
end
