![ImmuneBytesAudits](https://img.shields.io/badge/ImmuneBytes-Passed-brightgreen?logo=springsecurity)
![HackenAudits](https://img.shields.io/badge/Hacken-Passed-brightgreen?logo=springsecurity)
[![Coverage Status](https://coveralls.io/repos/github/polytrade-finance/nft-marketplace-sc/badge.svg?branch=dev)](https://coveralls.io/github/polytrade-finance/nft-marketplace-sc?branch=dev)
[![NPM](https://shields.io/badge/npm-8.3.1-red?logo=npm)](https://www.npmjs.com/package/npm/v/8.3.1)
[![Solidity](https://shields.io/badge/solidity-0.8.17-blue?logo=solidity)](https://docs.soliditylang.org/en/v0.8.17/)
[![Hardhat](https://shields.io/badge/hardhat-2.12.0-black?logo=hardhat)](https://www.npmjs.com/package/hardhat)
![Packagist](https://img.shields.io/packagist/l/doctrine/orm.svg?style=flat)

<div align="center">
    <a href="https://polytrade.finance/" target="_blank">
	    <img src="./assets/polytrade.png" alt="polytrade"/>
    </a>
</div>

# NFT Marketplace

This project is a marketplace to show NFTs which will be holding details from an asset.
These will act as a token representing the underlying assets and will allow users to buy RWA in the DeFi space.

## Contracts

### 1) Formulas

Provide external functions to calculate all formulas using a specific asset's parameters.

### 2) AssetNFT

Provide external functions that use a reference to the `Formulas` contract to calculate all formulas using a specific asset's number.

#### Metadata

```
   struct Metadata {
        uint48 paymentReceiptDate;
        uint48 paymentReserveDate;
        uint buyerAmountReceived;
        uint supplierAmountReceived;
        uint reservePaidToSupplier;
        uint reservePaymentTransactionId;
        uint amountSentToLender;
        InitialMetadata initialMetadata;
    }
```

#### InitialMetadata

```
   struct InitialMetadata {
        uint24 factoringFee;
        uint24 discountFee;
        uint24 lateFee;
        uint24 bankChargesFee;
        uint24 additionalFee;
        uint16 gracePeriod;
        uint16 advanceRatio;
        uint48 dueDate;
        uint48 invoiceDate;
        uint48 fundsAdvancedDate;
        uint invoiceAmount;
        uint invoiceLimit;
    }
```

#### `constructor(string memory name_, string memory symbol_, string memory baseURI_, address formulasAddress_) ERC721(name_, symbol_)` (public)

Implements the `ERC721` constructor, and uses the reference to the `Formulas` contract (`formulasAddress_`).
It needs the name (`name_`) and symbol (`symbol_`) of the NFT, and the base URI (`baseURI_`) that will be used as an accessor to the asset data location on _IPFS_ server.

#### `createAsset(address receiver, uint assetNumber, InitialMetadata calldata initialMetadata)` (external onlyOwner)

Mint a new asset with a uniq number (`assetNumber`) initiated with metadata (`initialMetadata`) to a specific address (`receiver`)

#### `setFormulas(address formulasAddress)` (external onlyOwner)

Set the private reference of the needed formulas contract

#### `setBaseURI(string calldata newBaseURI)` (external onlyOwner)

Set the private base URI for the assets storage

#### `setAdditionalMetadata(uint assetNumber, uint buyerAmountReceived, uint supplierAmountReceived, uint paymentReceiptDate)` (external onlyOwner)

Set the additional metadata: Payment receipt date & amount paid by buyer & amount paid by supplier

#### `setAssetSettledMetadata(uint assetNumber, uint reservePaidToSupplier, uint reservePaymentTransactionId, uint paymentReserveDate, uint amountSentToLender)` (external onlyOwner)

Set the settlement metadata: reserved payment date & amount sent to supplier & the payment transaction ID & amount sent to lender

#### `getAsset(uint assetNumber)` (external view)

Return the initial metadata for a specific asset (`assetNumber`)

#### `getFormulas()` (external view)

Return the Formulas contract address

#### `getBaseURI()` (external view)

Return the base URI

#### `calculateLateDays(uint assetNumber)` (external view)

Uses the Formulas contract to calculate the number of late days for a specific asset (`assetNumber`)

#### `calculateDiscountAmount(uint assetNumber)` (external view)

Uses the Formulas contract to calculate the discount amount for a specific asset (`assetNumber`)

#### `calculateLateAmount(uint assetNumber)` (external view)

Uses the Formulas contract to calculate the late amount for a specific asset (`assetNumber`)

#### `calculateAdvancedAmount(uint assetNumber)` (external view)

Uses the Formulas contract to calculate the advanced amount for a specific asset (`assetNumber`)

#### `calculateFactoringAmount(uint assetNumber)` (external view)

Uses the Formulas contract to calculate the factoring amount for a specific asset (`assetNumber`)

#### `calculateReserveAmount(uint assetNumber)` (external view)

Uses the Formulas contract to calculate the reserve amount for a specific asset (`assetNumber`)

#### `calculateInvoiceTenure(uint assetNumber)` (external view)

Uses the Formulas contract to calculate the invoice tenure for a specific asset (`assetNumber`)

#### `calculateFinanceTenure(uint assetNumber)` (external view)

Uses the Formulas contract to calculate the finance tenure for a specific asset (`assetNumber`)

#### `calculateTotalFees(uint assetNumber)` (external view)

Uses the Formulas contract to calculate the total fees amount for a specific asset (`assetNumber`)

#### `calculateNetAmountPayableToClient(uint assetNumber)` (external view)

Uses the Formulas contract to calculate the net amount payable to the client for a specific asset (`assetNumber`)

#### `calculateTotalAmountReceived(uint assetNumber)` (external view)

Uses the Formulas contract to calculate the total amount received for a specific asset (`assetNumber`)

#### `tokenURI(uint assetNumber)` (public view virtual override)

Return the storage URI of a specific asset (`assetNumber`)

### 3) Token

An inheritance of the `ERC20` token, will be used to pay for the asset NFTs.

#### Constructor

Implement the `ERC20` constructor, needs the name (`name_`) and symbol (`symbol_`) of the NFT.
Will mint a specific amount of tokens (`totalSupply_`) to the receiver address (`receiver_`)

```
   constructor(
        string memory name_,
        string memory symbol_,
        address receiver_,
        uint totalSupply_
    ) ERC20(name_, symbol_)
```

### 4) Marketplace

Provide external functions that let users to buy a specific asset NFT and pay tokens to this contract.

#### `constructor(address assetNFTAddress, address stableTokenAddress)` (public)

Uses the provided addresses (`assetNFTAddress` & `stableTokenAddress`) to set the references of the asset NFT contract and the stable coin contract.

#### `setAssetNFT(address assetNFTAddress)` (external onlyOwner)

Sets the asset NFT reference address (`assetNFTAddress`) in case of change it.

#### `setStableToken(address stableTokenAddress)` (external onlyOwner)

Sets the stable token reference address (`stableTokenAddress`) in case of change it.

#### `buy(uint assetNumber)` (external)

Lets the users to buy a specific asset NFT (`assetNumber`) and pay stable token for it.

#### `batchBuy(uint[] calldata assetNumbers)` (external)

Lets the users a collection af assets in terms of executing a checkout of multiple NFTs and reducing the transaction fees.

#### `getAssetNFT()` (external view)

Returns the address of the asset NFT reference.

#### `getStableCoin()` (external view)

Returns the address of the stable token reference.

## Workflow

- Deploy and verify `Formulas` contract:
  1. `npx hardhat deploy 3 --network mumbai`
  2. `npx hardhat verify --contract contracts/Formulas/Formulas.sol:Formulas --network mumbai FORMULAS_CONTRACT_ADDRESS`
- Deploy and verify `AssetNFT` contract:
  1. `npx hardhat deploy 0 --network mumbai`
  2. `npx hardhat verify --contract contracts/AssetNFT/AssetNFT.sol:AssetNFT --network mumbai ASSET_NFT_CONTRACT_ADDRESS "Name" "SYMBOL" "BASE_URI" "FORMULAS_CONTRACT_ADDRESS"`
- Deploy and verify `Token` contract:
  1. `npx hardhat deploy 4 --network mumbai`
  2. `npx hardhat verify --contract contracts/Token/Token.sol:Token --network mumbai TOKEN_CONTRACT_ADDRESS "Name" "SYMBOL" "RECEIVER_ADDRESS" "totalSupply"`
- Deploy and verify `Marketplace` contract:
  1. `npx hardhat deploy 1 --network mumbai`
  2. `npx hardhat verify --contract contracts/Marketplace/Marketplace.sol:Marketplace --network mumbai MARKETPLACE_CONTRACT_ADDRESS "ASSET_NFT_CONTRACT_ADDRESS" "TOKEN_CONTRACT_ADDRESS"`
- Mint a new asset NFT from `AssetNFT` contract to your first wallet address (`createAsset` function from `AssetNFT` contract)
- Use the calculation functions to check the asset data
- Calculate the reserved amount of this asset using `calculateReserveAmount` function and save it as the value of it
- Approve the created asset to the marketplace contract (`approve` function from `AssetNFT` contract)
- Transfer some stable tokens to your second wallet address (`transfer` function from `Token` contract)
- Approve the marketplace for the value of the invoice (`approve` function from `Token` contract)
- Use your second wallet address to buy this asset (`buy` function from `Marketplace` contract)
