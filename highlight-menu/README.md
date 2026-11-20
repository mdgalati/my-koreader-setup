# Highlight menu for KOReader + Aleph

A colour-first highlight menu for KOReader with the **Aleph** home/reader plugin:

- **Select text** → it's saved straight away in your last colour, and a small menu opens beside it: a row of colour circles (tap one to change the colour) and icon buttons: Add note, Handwritten note, Dictionary, X-Ray, Search.
- **Tap an existing highlight** → one menu with the colour circles (the current one is checked), then Style, Note, Handwritten note, Search, Details, Dictionary, X-Ray, Delete, plus the Start/End arrows to adjust it.
- The **colour panel** lists one colour per row, with a short description of what each colour is for.

Colour categories I use (names and colours are set in Aleph, see step 3):

| Colour | Name | What for |
|---|---|---|
| Yellow | Quotes / Prose | Great writing, memorable lines, or favourite passages |
| Blue | Plot / Core Ideas | Key story turning points in fiction, or main arguments in non-fiction |
| Green | World-Building / Context | Lore, character backgrounds, historical dates, or definitions |
| Red (shown lilac) | Reactions / Emotions | Scenes that surprised you, made you laugh, or hit hard emotionally |
| Orange | Check Later / Action | Questions to research, unfamiliar words, or practical advice to apply |

## Requirements

- KOReader (tested on v2026.07.1, Kobo Libra Colour)
- **Aleph 1.2.0** (`aleph.koplugin`). The Aleph part changes one Aleph file; it won't work with other versions or without Aleph.
- Handwritten note needs the Ink Away plugin, X-Ray is Aleph's own. Buttons for plugins you don't have simply don't appear.

## Install

**Back up `koreader/plugins/aleph.koplugin/aleph_highlight.lua` first.**

1. Copy `patches/2-highlight-colour-buttons.lua` into `koreader/patches/` (create the folder if needed).
2. Aleph part, either:
   - **Easy:** copy `aleph.koplugin/aleph_highlight.lua` over `koreader/plugins/aleph.koplugin/aleph_highlight.lua` (Aleph 1.2.0 only), or
   - **Patch:** in the `aleph.koplugin` folder run `patch -p1 < aleph-1.2.0-highlight-menu.diff`
3. Optional, the colour names and pastel colours: in Aleph's colour panel, hold a colour to rename it, or add this to the `aleph` table in `koreader/settings.reader.lua` (with KOReader closed):

   ```lua
   ["highlight_palette"] = {
       ["yellow"] = { ["hex"] = "#FFEC7A", ["name"] = "Quotes / Prose" },
       ["blue"]   = { ["hex"] = "#B5DBFF", ["name"] = "Plot / Core Ideas" },
       ["green"]  = { ["hex"] = "#BFE6B0", ["name"] = "World-Building / Context" },
       ["red"]    = { ["hex"] = "#CDB6F5", ["name"] = "Reactions / Emotions" },
       ["orange"] = { ["hex"] = "#FFB877", ["name"] = "Check Later / Action" },
   },
   ```
4. Restart KOReader.

The short labels under the circles (Quotes, Core, Context, Emotions, Action) and the descriptions are in `aleph_highlight.lua` (`MERGED_SHORT`, `SHORT`, `COLOR_DESCRIPTIONS`); edit them to match your own categories.

**Undo:** delete the patch file and put back your original `aleph_highlight.lua`.

Updating Aleph replaces `aleph_highlight.lua`, so the Aleph part has to be reapplied (the diff may need adjusting for a newer Aleph).

## Credits and license

- The idea of one-tap colour buttons in the selection menu comes from VeeBui's KOReader highlight menu patch (https://github.com/VeeBui/koReader-highlight-menu-patch). `2-highlight-colour-buttons.lua` is a new, independent patch written for this package.
- Made with the help of Claude Code.

**The Aleph files in this package are a modified version of Aleph (a fork of BookOrbit's KOReader plugin).**

> This is a modified version of BookOrbit and is not an official BookOrbit release.
> Modified: 2026-11-16 to 2026-11-20 (file `aleph_highlight.lua`, from Aleph 1.2.0).

Powered by BookOrbit — https://github.com/bookorbit/bookorbit
Copyright (C) 2025-2026 neon. Additional copyright is held by the respective BookOrbit contributors.
Licensed under the GNU Affero General Public License, version 3 only, with additional terms. This software is provided without warranty. You may redistribute and modify it under those terms.

The full license and notices are in the `license/` folder (`LICENSE`, `ADDITIONAL_TERMS.md`, `NOTICE`, `MODIFICATIONS.md`, `THIRD_PARTY_NOTICES.md`, `ZENOS_NOTICE.md`, `LICENSE-GPL-3.0.md`) and must be kept with these files.
