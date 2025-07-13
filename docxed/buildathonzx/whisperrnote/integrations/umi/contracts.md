Deploying Move Smart Contract
In this guide, we will walk through deploying a simple Move smart contract on Umi. We'll use a basic counter example, build the contract using Umi SDK, deploy it with Hardhat.

1. Setting Up the Hardhat Environment
Install Hardhat and required dependencies:


npm install --save-dev hardhat @nomicfoundation/hardhat-toolbox @moved/hardhat-plugin @aptos-labs/ts-sdk
Initialize a Hardhat project:


npx hardhat init
Follow steps with the Create an empty hardhat.config.js option.

Add the Umi plugin and network description to hardhat.config.js:


require("@nomicfoundation/hardhat-toolbox");
require("@moved/hardhat-plugin");

module.exports = {
  defaultNetwork: "devnet",
  networks: {
    devnet: {
      url: "https://devnet.uminetwork.com",
      accounts: ["YOUR_PRIVATE_KEY"]
    }
  }
};
Make sure to put in your private key in place of YOUR_PRIVATE_KEY. You can obtain this key from your crypto wallet. We recommend creating a burner account for testing.

2. Creating a Move Smart Contract
We'll start with a simple counter contract that increments a stored value. First, create a contracts/counter folder to keep our Move contract project.


mkdir contracts contracts/counter
cd contracts/counter
Inside this folder run the following command to create a simple counter project:


aptos move init --name counter
If the command fails, ensure the CLI is installed correctly for Move project compilation, following the Installation step.

Inside the contracts/sources/ folder create a file named counter.move and paste the following in the file:


module example::Counter {
    use std::signer;

    struct Counter has key, store {
        value: u64,
    }

    public entry fun initialize(account: &signer) {
        move_to(account, Counter { value: 0 });
    }

    public entry fun increment(account: &signer) acquires Counter {
        let counter = borrow_global_mut<Counter>(signer::address_of(account));
        counter.value = counter.value + 1;
    }

    public fun get(account: address): u64 acquires Counter {
        let counter = borrow_global<Counter>(account);
        counter.value
    }
}
Next we'll define our example address in the Move.toml file. So, add your wallet address under the [addresses] list replacing the ACCOUNT_ADDRESS. In the same file change the rev of the Aptos Framework dependency to the latest supported version. The final Move.toml should look like:


[package]
name = "counter"
version = "1.0.0"
authors = []

[addresses]
example = "ACCOUNT_ADDRESS"

[dependencies.AptosFramework]
git = "https://github.com/aptos-labs/aptos-framework.git"
rev = "aptos-release-v1.27"
subdir = "aptos-framework"
Finally let's compile the Move contract, from the top project folder:


npx hardhat compile
3. Deploying the Contract
Create a script to deploy the generated contract artifact. Create a file under scripts/deploy.js with the following code. Make sure the scripts folder is inside the Hardhat folder and not the counter project folder.


const { ethers } = require('hardhat');
const { AccountAddress, EntryFunction, FixedBytes, parseTypeTag } = require('@aptos-labs/ts-sdk');
const { TransactionPayloadEntryFunction, TypeTagSigner } = require('@aptos-labs/ts-sdk');

async function main() {
  const contractName = 'counter';
  const [deployer] = await ethers.getSigners();
  const moduleAddress = deployer.address.replace('0x', '0x000000000000000000000000');

  const Counter = await ethers.getContractFactory(contractName);
  const counter = await Counter.deploy();
  await counter.waitForDeployment();
  console.log(`Counter is deployed to: ${deployer.address}::${contractName}`);

  const address = AccountAddress.fromString(moduleAddress);
  const addressBytes = [33, 0, ...address.toUint8Array()];
  const signer = new FixedBytes(new Uint8Array(addressBytes));

  const entryFunction = EntryFunction.build(
    `${moduleAddress}::${contractName}`,
    'initialize',
    [], // Use `parseTypeTag(..)` to get type arg from string
    [signer]
  );
  const transactionPayload = new TransactionPayloadEntryFunction(entryFunction);
  const payload = transactionPayload.bcsToHex();
  const request = {
    to: deployer.address,
    data: payload.toString(),
  };
  await deployer.sendTransaction(request);
  console.log('Initialize transaction sent');
}

main()
  .then(() => process.exit(0))
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });
Ensure your wallet has sufficient test ETH for the address used above. Get tokens from the Faucet.

Deploy the contract using a single command, Hardhat takes care of the rest:


npx hardhat run scripts/deploy.js
After deployment, locate your contract on the Umi block explorer. Search the deployer address to verify its status and details.

With these steps, you've successfully deployed and now checkout Use Contract to interact with your Move smart contract!