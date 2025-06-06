// scripts/deploy.js

const { ethers } = require("hardhat");

async function main() {
  const HelloWorld = await ethers.getContractFactory("HelloWorld");
  console.log("Déploiement du contrat HelloWorld en cours…");
  const hello = await HelloWorld.deploy();

  await hello.deployTransaction.wait();

  console.log("HelloWorld déployé à :", hello.address);

  let message = await hello.getMessage();
  console.log("Message initial :", message);

  const tx = await hello.setMessage("Salut Hardhat !");
  await tx.wait();

  message = await hello.getMessage();
  console.log("Message après modification :", message);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
