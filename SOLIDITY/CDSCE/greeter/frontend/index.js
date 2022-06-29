// Variables globales.
let provider;
let contract;

// Cuando cargue la página, conectamos con la cartera.
window.addEventListener("load", connectWallet);

async function connectWallet() {
      // Conectamos con la cartera.
      provider = new ethers.providers.Web3Provider(window.ethereum);

      // Accedemos a la cuenta.
      await provider.send("eth_requestAccounts");
  
      // Obtenemos el firmante, y obtenemos una instancia del contrato 
      //    usando la direccion, el abi, y el firmante.
      const signer = provider.getSigner();
      contract = new ethers.Contract("0xb56e487c1f4a1ef3d6f1C5686f33924003160Ff0", abiJSON.abi, signer);

      // Obtenemos el greeter.
      getGreeter();
}

// Funciones principales.
async function getGreeter() {
    const greeter = await contract.greet();
    document.getElementById("greeter").innerText = greeter;
}

async function setGreeter() {
    const greeter = document.getElementById("input").value;
    const tx = await contract.setGreeting(greeter);
    await tx.wait();
    getGreeter();
}
