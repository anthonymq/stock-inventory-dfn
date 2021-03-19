# DFINITY-Vue
https://sdk.dfinity.org/docs/developers-guide/tutorials/explore-templates.html

```
DFX_VERSION=0.6.26 sh -ci "$(curl -fsSL https://sdk.dfinity.org/install.sh)"
dfx start
```
```
dfx deploy
ou
dfx canister create --all
dfx build
dfx canister install --all -m reinstall
```

```
dfx deploy dfinity_vue --argument "(principal \"$(dfx identity get-principal)\")"
dfx canister call dfinity_vue my_role
(you should be owner)

\\ to give access to a new user, you need is Principal
dfx canister call dfinity_vue assign_role "(principal \"PRINCIPAL\", opt variant{authorized})"
```