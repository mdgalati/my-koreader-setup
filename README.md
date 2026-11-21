# My KOReader setup

Tweaks and patches from my KOReader setup on a **Kobo Libra Colour** (KOReader v2026.07.1, with the **[Aleph](https://github.com/lara-2-ko/aleph.koplugin)** home/reader plugin by lara_2 / [lara-2-ko](https://github.com/lara-2-ko), which most of this builds on. Go check it out!). Each folder is one tweak with its own README and install steps, so you can take only what you want.

| Tweak | What it does | Needs |
|---|---|---|
| [highlight-menu](highlight-menu/) | Colour-first highlight menu: selecting text saves it at once, then colour circles + icon buttons (note, handwritten note, dictionary, X-Ray, search); one merged menu when you tap a highlight; colour categories with descriptions | KOReader + Aleph 1.2.0 |
| [kobo-backup-mac](kobo-backup-mac/) | Plug in the Kobo → a dialog offers a backup of everything except the books (settings, highlights, notes, stats, plugins, dictionaries) into a git repository, optionally pushed to a private GitHub repo | macOS + git |

More to come.

## Before you install anything

- **Back up** the files a tweak replaces (each README says which).
- Patches go in `koreader/patches/`; restart KOReader after adding or removing one.
- Tweaks marked "Aleph" change Aleph's own files, so updating Aleph undoes them, and they're tied to the Aleph version named in their README.

## License

Each folder states its own license. Folders containing modified Aleph files are a **modified version of Aleph / BookOrbit, not an official release**, and come with the AGPL-3.0 license and BookOrbit's additional terms in their `license/` folder. Those files must stay together.

## Credits

- Highlight menu patch: adapted from [VeeBui's Highlight Suite](https://github.com/VeeBui/KOReader-patches/tree/main/Highlight%20Suite) (Custom Select Text Menu), which credits [edo-jan](https://github.com/koreader/koreader/issues/12480#issuecomment-2835548463).
- **[Aleph](https://github.com/lara-2-ko/aleph.koplugin) by lara_2 ([lara-2-ko](https://github.com/lara-2-ko))**: the home screen, reader menus, highlight menu, X-Ray and bookmarks I customised are all Aleph's work; my changes are small tweaks on top. Aleph started from [BookOrbit](https://github.com/bookorbit/bookorbit)'s plugin, with a redesigned reader.

Made with the help of Claude Code.
