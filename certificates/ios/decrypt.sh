
echo "Decrypt dev certificate..."
gpg --quiet --batch --yes --decrypt \
    --passphrase="$IOS_PASSPHRASE" \
    --output dev.p12 \
    dev.p12.gpg

echo "Decrypt provision profile..."
gpg --quiet --batch --yes --decrypt \
    --passphrase="$IOS_PASSPHRASE" \
    --output dev.mobileprovision \
    dev.mobileprovision.gpg