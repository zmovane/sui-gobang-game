# A gobang game based on sui devnet

## Module testing

```
sui move test -p ./gobang-contracts
```

## Module publish

```
sui client publish -p gobang-contracts --gas-budget 10000
```

## Run

```
yarn workspace gobang-frontend dev
```
