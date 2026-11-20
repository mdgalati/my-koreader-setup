#!/bin/sh
# Installs the Kobo backup prompt: copies the two scripts to ~/Kobo and
# registers a launch agent that runs kobo-plugged-in.sh when a drive appears.
# Undo: sh install.sh --uninstall

LABEL="local.kobo-backup-prompt"
DEST="$HOME/Kobo"
PLIST="$HOME/Library/LaunchAgents/$LABEL.plist"
HERE="$(cd "$(dirname "$0")" && pwd)"

if [ "$1" = "--uninstall" ]; then
    launchctl bootout "gui/$(id -u)/$LABEL" 2>/dev/null
    rm -f "$PLIST"
    echo "Removed the launch agent. The scripts in $DEST and your backups were left alone."
    exit 0
fi

mkdir -p "$DEST" "$HOME/Library/LaunchAgents"
cp "$HERE/backup-kobo.sh" "$HERE/kobo-plugged-in.sh" "$DEST/"
chmod +x "$DEST/backup-kobo.sh" "$DEST/kobo-plugged-in.sh"

cat > "$PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>$LABEL</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/sh</string>
        <string>$DEST/kobo-plugged-in.sh</string>
    </array>
    <key>WatchPaths</key>
    <array>
        <string>/Volumes</string>
    </array>
    <key>StandardErrorPath</key>
    <string>$DEST/backup-kobo.log</string>
</dict>
</plist>
EOF

launchctl bootout "gui/$(id -u)/$LABEL" 2>/dev/null
launchctl bootstrap "gui/$(id -u)" "$PLIST" && echo "Installed. Plug in your Kobo and tap Connect to try it."
