# iOS Code Signing

## New provision profile

- Update profile in Xcode configuration
- Make release archive locally
- Copy `ExportOptions.plist` from archive to `ios/`
- Next steps below

## Add/Update

- Export certificate to `.p12` with password PASS[*]
- Put certificate to this folder as `dev.p12`
- Put provision profile to this folder as `dev.mobileprovision`
- Execute encryption script `ecrypt.sh`
- Use the same password PASS during encryption
- Confirm override existing files
- Push new `*.gpg` files to the repository

> PASS — it's a password that saved in Github Secrets and used to release code signing (see .github/workflows/release_ios_*).

## Resources

- [GitHub Creating and storing encrypted secrets](https://docs.github.com/en/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets)
