
const hre = require("hardhat");

async function main() {
  console.log("deploying..");
  const TransferContract = await hre.ethers.getContractFactory("TransferContract");
  const transferContract = await TransferContract.deploy();

  await transferContract.deployed();

  console.log("TransferContract deployed to:", transferContract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
