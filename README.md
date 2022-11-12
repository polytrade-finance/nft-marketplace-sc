![ImmuneBytesAudits](https://img.shields.io/badge/ImmuneBytes-Passed-brightgreen?logo=springsecurity)
![HackenAudits](https://img.shields.io/badge/Hacken-Passed-brightgreen?logo=springsecurity)
[![Coverage Status](https://coveralls.io/repos/github/polytrade-finance/nft-marketplace-sc/badge.svg?branch=dev)](https://coveralls.io/github/polytrade-finance/nft-marketplace-sc?branch=dev)
![Solidity](https://shields.io/badge/solidity-0.8.17-blue?logo=solidity)
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

- Deploy `Formulas` contract.
- Deploy `AssetNFT` contract using a reference to the deployed `Formulas` contract.
- Deploy the stable coin `Token` contract.
- Users should deposit their tokens before or during the staking period
- Run `Start()` function launch the staking
- Users can claim their rewards using `claimRewards()`
- Once staking is over users can withdraw their initial deposit using `withdraw()` (`withdraw()` calls `claimRewards()`)

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.js
```

Steps to deploy and verify:

1- Create Smart Contract
2- Create deploy.js file
3- Use `npx hardhat run scripts/scriptName.js --network mumbai` command to run a script on polygon mumbai network
3- Use `npx hardhat deploy ContractNameIndex --network mumbai` command to run the deployment task on polygon mumbai network
4- Check network list available to verify from the hardhat framework `npx hardhat verify --list-networks`
5- Use `npx hardhat verify --contract contracts/SCFileName.sol:SCName --network mumbai SMART_CONTRACT_ADDRESS "Smart Contract Parameter 1" "Smart Contract Parameter 2"` to verify on polygon mumbai network
