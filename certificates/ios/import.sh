
echo "Install profiles..."
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp dev.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/86ce4d81-fd7e-46b2-ae6a-3092b4af6cd7.mobileprovision

echo "Install dev certificate..."
security create-keychain -p "" build.keychain
security import dev.p12 -t agg -k ~/Library/Keychains/build.keychain -P "$IOS_PASSPHRASE" -A

security list-keychains -s ~/Library/Keychains/build.keychain
security default-keychain -s ~/Library/Keychains/build.keychain
security unlock-keychain -p "" ~/Library/Keychains/build.keychain

security set-key-partition-list -S apple-tool:,apple: -s -k "" ~/Library/Keychains/build.keychain
