const hre = require("hardhat");

async function main() {
    const [deployer] = await hre.ethers.getSigners();

    console.log("Desplegando el contrato GovernanceDAO con la cuenta:", deployer.address);

    const savingsPercentage = 10; // se puede ajustar
    const GovernanceDAO = await hre.ethers.getContractFactory("GovernanceDAO");
    const governanceDAO = await GovernanceDAO.deploy(savingsPercentage);
    await governanceDAO.deployed();

    console.log("Contrato GovernanceDAO desplegado en:", governanceDAO.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
