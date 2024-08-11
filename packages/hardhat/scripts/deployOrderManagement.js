const hre = require("hardhat");

async function main() {
    const [deployer] = await hre.ethers.getSigners();

    console.log("Desplegando el contrato OrderManagement con la cuenta:", deployer.address);

    const OrderManagement = await hre.ethers.getContractFactory("OrderManagement");
    const orderManagement = await OrderManagement.deploy();
    await orderManagement.deployed();

    console.log("Contrato OrderManagement desplegado en:", orderManagement.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
