// Importa hardhat, y sus funcionalidades
const hre = require("hardhat");

// Funcion principal de despliegue.
async function main() {
  
  // Obtiene el contrato usando la factoria de contratos de Hardhat.
  //   Hardhat automaticamente detecta que contratos hay creatos en la
  //   carpeta "contracts" y los compila en una factoria de contratos.
  const Greeter = await hre.ethers.getContractFactory("Greeter");

  // Desplegamos el contrato, pasamos al constructor un valor.
  //   devuelve una instancia de la transaccion de creacion del contrato.
  const greeterInstance = await Greeter.deploy("Hola mundo!");

  // Esperamos a que la transaccion se complete.
  await greeterInstance.deployed();

  // Una vez desplegado, mostramos por consola la dirección del contrato.
  console.log("Greeter deployed to:", greeterInstance.address);
}


// Ejecutamos la funcion principal.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
