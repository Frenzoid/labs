// global variables.
let provider;
let contract;



// On page load, we connect to the wallet.
window.addEventListener("load", connectWallet);

// We create an async function so we can use await, instead of .thens, because .thens are ugly af.
async function connectWallet() {

    // We connect to the wallet.
    provider = new ethers.providers.Web3Provider(window.ethereum);

    // Get the user's wallet.
    await provider.send("eth_requestAccounts");

    // Get the contract.
    const signer = provider.getSigner(); // Below address = deployed contract address.
    contract = new ethers.Contract("0x5FbDB2315678afecb367f032d93F642f64180aa3", ContractMeta.abi, signer);
}



// Main button functions.
async function transferTokens() {
    try {
        const transaction = await contract.transferTokens(10000);
        const ctx = await transaction.wait();

        console.log("Transfer successful!", ctx);
    } catch (error) {
        console.log("REVERTED!", error);
    }
}


async function hello() {
    try {
        const transaction = await contract.hello("Hi! :D");
        const ctx = await transaction.wait();

        console.log("Transfer successful!", ctx);
    } catch (error) {
        console.log("REVERTED!", error);
    }
}