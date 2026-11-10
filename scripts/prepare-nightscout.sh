#!/bin/bash

# Both apps use the same filename. Preserve an existing native App Store app
# before Homebrew installs the API-secret-compatible version in /Applications.
prepareNightscoutApp() {
    [ "$(uname -s)" = "Darwin" ] || return 0
    local app="/Applications/Nightscout Menu Bar.app"
    local backup="$HOME/Applications/Nightscout Menu Bar (App Store).app"
    local bundle_id
    [ -d "$app" ] || return 0
    bundle_id=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$app/Contents/Info.plist") || return 1
    [ "$bundle_id" = "com.greatmachineinthesky.NightscoutMenuBar" ] || return 0
    if [ -e "$backup" ]; then
        echo "Cannot migrate Nightscout: $backup already exists. Move it aside and rerun update." >&2
        return 1
    fi
    /usr/bin/osascript -e 'if application id "com.greatmachineinthesky.NightscoutMenuBar" is running then tell application id "com.greatmachineinthesky.NightscoutMenuBar" to quit' || return 1
    mkdir -p "$HOME/Applications" || return 1
    mv "$app" "$backup" || return 1
    echo "Preserved the previous Nightscout app at $backup (preferences unchanged)."
}
