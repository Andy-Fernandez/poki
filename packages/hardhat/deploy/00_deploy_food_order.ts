// deploy/00_deploy_food_order.ts
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const deployFunction: DeployFunction = async (hre: HardhatRuntimeEnvironment) => {
  const { deployments, getNamedAccounts } = hre;
  // const { deployments, getNamedAccounts, ethers } = hre;
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  // Deploy OrderManager contract
  const orderManager = await deploy("OrderManager", {
    from: deployer,
    log: true,
  });

  console.log("OrderManager deployed at:", orderManager.address);
};

export default deployFunction;
