require("@nomiclabs/hardhat-waffle");
require("dotenv").config({ path: ".env" });

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.4",
  networks: {
    localhost: {
      url: "http://localhost:8545",
    },
    rinkeby: {
      url: process.env.RINKEBY_MORALIS_URL,
      accounts: [process.env.ACC_PRIV_KEY],
    },
    goerli: {
      url: process.env.GOERLI_MORALIS_URL,
      accounts: [process.env.ACC_PRIV_KEY],
    }
  },
};