const hre = require("hardhat");

async function main() {
    const [deployer] = await hre.ethers.getSigners();

    console.log("Desplegando el contrato SavingsDAO con la cuenta:", deployer.address);

    const savingsPercentage = 10; // Ajusta el porcentaje como desees
    const SavingsDAO = await hre.ethers.getContractFactory("SavingsDAO");
    const savingsDAO = await SavingsDAO.deploy(savingsPercentage);
    await savingsDAO.deployed();

    console.log("Contrato SavingsDAO desplegado en:", savingsDAO.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
