require('dotenv').config();

const GAS_REPORTER = process.env.GAS_REPORTER || true;
const MUMBAI_RPC_URL = process.env.MUMBAI_RPC_URL || '';
const ACCOUNT_PRIVATE_KEY =
  process.env.ACCOUNT_PRIVATE_KEY ||
  '192686bcbbc6d6fef7d3d4a1c53438faad065927cc3bb18d5c6dcfc430aac527';
const MUMBAI_API_KEY = process.env.MUMBAI_API_KEY || '';
const NETWORK = process.env.NETWORK || 'mumbai';
const NFT_NAME = process.env.NFT_NAME || 'Polytrade';
const NFT_SYMBOL = process.env.NFT_SYMBOL || 'TRADE';
const NFT_BASE_URI = process.env.NFT_BASE_URI || 'https://ipfs.io/ipfs/';
const TOKEN_NAME = process.env.TOKEN_NAME || 'StableToken';
const TOKEN_SYMBOL = process.env.TOKEN_SYMBOL || 'USDT';
const NFT_FORMULAS_CONTRACT_ADDRESS =
  process.env.NFT_FORMULAS_CONTRACT_ADDRESS ||
  '0x221392d7E8C428598F6A539dEEb0E48Ab248f456';
const NFT_CONTRACT_ADDRESS =
  process.env.NFT_CONTRACT_ADDRESS ||
  '0xfad00BE06BDFB2D245Fc307260BfefE87988Fee4';
const STABLE_COIN_ADDRESS =
  process.env.STABLE_COIN_ADDRESS ||
  '0x2F9CA3dC232DB81D3233FC7ABafE1e4Af893CA74';

const CONSTANTS = {
  GAS_REPORTER,
  MUMBAI_RPC_URL,
  ACCOUNT_PRIVATE_KEY,
  MUMBAI_API_KEY,
  NETWORK,
  NFT_NAME,
  NFT_SYMBOL,
  NFT_BASE_URI,
  TOKEN_NAME,
  TOKEN_SYMBOL,
  NFT_FORMULAS_CONTRACT_ADDRESS,
  NFT_CONTRACT_ADDRESS,
  STABLE_COIN_ADDRESS,
};

exports.default = CONSTANTS;
