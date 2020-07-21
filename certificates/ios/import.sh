
echo "Install profiles..."
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
UUID=`/usr/libexec/PlistBuddy -c 'Print :UUID' /dev/stdin <<< $(security cms -D -i ./dev.mobileprovision)`
cp dev.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/$UUID.mobileprovision
ls ~/Library/MobileDevice/Provisioning\ Profiles
echo "Done."

KEYCHAIN=~/Library/Keychains/build.keychain
echo "Install dev certificate..."
echo "Configure keychain"
security create-keychain -p "" "$KEYCHAIN"
security list-keychains -s "$KEYCHAIN"
security default-keychain -s "$KEYCHAIN"
security unlock-keychain -p "" "$KEYCHAIN"
security set-keychain-settings
security list-keychains
echo "Import..."
security import dev.p12 -t agg -k "$KEYCHAIN" -P "$IOS_PASSPHRASE" -A
security set-key-partition-list -S apple-tool:,apple: -s -k "" "$KEYCHAIN"
echo "Done."
