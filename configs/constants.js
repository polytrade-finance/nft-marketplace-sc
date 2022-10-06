require('dotenv').config();

const MUMBAI_RPC_URL = process.env.MUMBAI_RPC_URL || '';
const ACCOUNT_PRIVATE_KEY =
  process.env.ACCOUNT_PRIVATE_KEY ||
  '192686bcbbc6d6fef7d3d4a1c53438faad065927cc3bb18d5c6dcfc430aac527';
const MUMBAI_API_KEY = process.env.MUMBAI_API_KEY || '';
const NETWORK = process.env.NETWORK || 'mumbai';

const CONSTANTS = {
  MUMBAI_RPC_URL,
  ACCOUNT_PRIVATE_KEY,
  MUMBAI_API_KEY,
  NETWORK,
};

exports.default = CONSTANTS;
