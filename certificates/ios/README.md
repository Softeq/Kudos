# iOS Code Signing

## Add/Update

- Export certificate to `.p12` with password PASS
- Put certificate to this folder as `dev.p12`
- Put provision profile to this folder as `dev.mobileprovision`
- Execute encryption script `ecrypt.sh`
- Use the same password PASS during encryption
- Confirm override existing files
- Push new `*.gpg` files to the repository

## Resources

- [GitHub Creating and storing encrypted secrets](https://docs.github.com/en/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets)
