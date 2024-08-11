//primerito el Foodorder y luego el OrderMananger que usa el Foodorder
const hre = require("hardhat");

async function main() {
    const [deployer] = await hre.ethers.getSigners();

    console.log("Desplegando contratos con la cuenta:", deployer.address);

    // Desplegar el contrato FoodOrder (este paso puede ser opcional si el contrato se despliega desde OrderManager)
    const FoodOrder = await hre.ethers.getContractFactory("FoodOrder");
    const foodOrder = await FoodOrder.deploy("Restaurant Name", ["Dish1", "Dish2"], 100, "123 Delivery St");
    await foodOrder.deployed();
    console.log("Contrato FoodOrder desplegado en:", foodOrder.address);

    // Desplegar el contrato OrderManager
    const OrderManager = await hre.ethers.getContractFactory("OrderManager");
    const orderManager = await OrderManager.deploy();
    await orderManager.deployed();
    console.log("Contrato OrderManager desplegado en:", orderManager.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
