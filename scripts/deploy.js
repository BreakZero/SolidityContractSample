
const hre = require("hardhat");

async function main() {
    const PasswordManager = await hre.ethers.getContractFactory("EasyPassword");
    const passwordManager = await PasswordManager.deploy();
  
    await passwordManager.deployed();
    console.log("EasyPassword deployed to ", passwordManager.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });