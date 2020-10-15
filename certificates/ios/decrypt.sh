
echo "Decrypt dev certificate..."
gpg --quiet --batch --yes --decrypt \
    --passphrase="$IOS_PASSPHRASE" \
    --output prod.p12 \
    prod.p12.gpg

echo "Decrypt provision profile..."
gpg --quiet --batch --yes --decrypt \
    --passphrase="$IOS_PASSPHRASE" \
    --output prod.mobileprovision \
    prod.mobileprovision.gpg