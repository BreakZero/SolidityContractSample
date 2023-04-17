// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function printGroups(groups) {
  for (const group of groups) {
    console.log(`Group Name: ${group}`);
  }
}

async function main() {
  const [owner, tipper, tipper2, tipper3] = await hre.ethers.getSigners();
  console.log("=== starting ===");
  console.log(`Owner: ${owner.address}, ${tipper.address}, ${tipper2.address}, ${tipper3}`);

  const PasswordManager = await hre.ethers.getContractFactory("EasyPassword");
  const passwordManager = await PasswordManager.deploy();

  await passwordManager.deployed();

  const groups = await passwordManager.connect(owner).loadGroups();
  printGroups(groups);

  await passwordManager.connect(owner).createGroup("Group1");

  const groups1 = await passwordManager.connect(owner).loadGroups();
  printGroups(groups1);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
