require('dotenv').config();

const MUMBAI_RPC_URL = process.env.MUMBAI_RPC_URL || '';
const ACCOUNT_PRIVATE_KEY =
  process.env.ACCOUNT_PRIVATE_KEY ||
  '192686bcbbc6d6fef7d3d4a1c53438faad065927cc3bb18d5c6dcfc430aac527';
const MUMBAI_API_KEY = process.env.MUMBAI_API_KEY || '';
const NETWORK = process.env.NETWORK || 'mumbai';
const NFT_NAME = process.env.NFT_NAME || 'Polytrade';
const NFT_SYMBOL = process.env.NFT_SYMBOL || 'TRADE';
const NFT_BASE_URI = process.env.NFT_BASE_URI || 'https://ipfs.tech/';

const CONSTANTS = {
  MUMBAI_RPC_URL,
  ACCOUNT_PRIVATE_KEY,
  MUMBAI_API_KEY,
  NETWORK,
  NFT_NAME,
  NFT_SYMBOL,
  NFT_BASE_URI,
};

exports.default = CONSTANTS;
