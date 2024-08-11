async function main() {
    const [deployer] = await ethers.getSigners();

    console.log("Desplegando contratos con el account:", deployer.address);

    const OrderManager = await ethers.getContractFactory("OrderManager");
    const orderManager = await OrderManager.deploy();
    await orderManager.deployed();

    console.log("OrderManager desplegado en:", orderManager.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
