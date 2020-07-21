
echo "Encrypt dev certificate..."
gpg --symmetric --cipher-algo AES256 dev.p12

echo "Encrypt provision profile..."
gpg --symmetric --cipher-algo AES256 dev.mobileprovision
