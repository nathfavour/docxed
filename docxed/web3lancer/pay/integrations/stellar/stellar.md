Invoke a contract function in a Stellar transaction using SDKs
This is a simple example using the Stellar SDK to create, simulate, and then assemble a Stellar transaction which invokes an increment function of the auth example contract.

JavaScript
Python
Java
tip
Please go to the project homepage of JavaScript SDK to learn how to install it.

First, upload the bytes of the example contract onto the blockchain using Stellar CLI. This is called "install" because, from the perspective of the blockchain itself, this contract has been installed.

stellar contract build
stellar contract upload --wasm target/wasm32-unknown-unknown/release/test_auth_contract.wasm --network testnet

This will return a hash; save that, you'll use it soon. For this example, we will use bc7d436bab44815c03956b344dc814fac3ef60e9aca34c3a0dfe358fcef7527f.

No contract has yet been deployed with this hash. In Soroban, you can have many Smart Contracts which all reference the same Wasm hash, defining their behavior. We'll do that from the following JavaScript code itself.

import { Keypair } from "@stellar/stellar-sdk"
import { Client, basicNodeSigner } from "@stellar/stellar-sdk/contract"
import { Server } from "@stellar/stellar-sdk/rpc"

// As mentioned, we are using Testnet for this example
const rpcUrl = "https://soroban-testnet.stellar.org"
const networkPassphrase = "Test SDF Network ; September 2015"
const wasmHash = "bc7d436bab44815c03956b344dc814fac3ef60e9aca34c3a0dfe358fcef7527f"

/**
 * Generate a random keypair and fund it
 */
async function generateFundedKeypair() {
  const keypair = Keypair.random();
  const server = new Server(rpcUrl);
  await server.requestAirdrop(keypair.publicKey());
  return keypair
}

(async () => {
  // The source account will be used to sign and send the transaction.
  const sourceKeypair = await generateFundedKeypair()

  // If you are using a browser, you can pass in `signTransaction` from your
  // Wallet extension such as Freighter. If you're using Node, you can use
  // `signTransaction` from `basicNodeSigner`.
  const { signTransaction } = basicNodeSigner(sourceKeypair, networkPassphrase)

  // This constructs and simulates a deploy transaction. Once we sign and send
  // this below, it will create a brand new smart contract instance that
  // references the wasm we uploaded with the CLI.
  const deployTx = await Client.deploy(
    null, // if the contract has a `__constructor` function, its arguments go here
    {
      networkPassphrase,
      rpcUrl,
      wasmHash,
      publicKey: sourceKeypair.publicKey(),
      signTransaction,
    }
  )
  // Like other `Client` methods, `deploy` returns an `AssembledTransaction`,
  // which wraps logic for signing, sending, and awaiting completion of the
  // transaction. Once that all completes, the `result` of this transaction
  // will contain the final `Client` instance, which we can use to invoke
  // methods on the new contract. Here we are using JS destructuring to get the
  // `result` key from the object returned by `signAndSend`, and put it in a
  // local variable called `client`.
  const { result: client } = await deployTx.signAndSend()

  ...

Client from existing Contract
If you don't need to deploy a contract, and instead already know a deployed contract's ID, you can instantiate a Client for it directly. This uses similar arguments to the ones to Client.deploy above, with the addition of contractId:

-const deployTx = await Client.deploy(
-  null,
-  {
+const client = await Client.from({
+  contractId: "C123abc…",
   networkPassphrase,
   rpcUrl,
   wasmHash,
   publicKey: sourceKeypair.publicKey(),
   signTransaction,
 })

Now that we instantiated a client, we can use it to call methods on the contract. Picking up where we left off:

  ...

  // This will construct and simulate an `increment` transaction. Since the
  // `auth` contract requires that this transaction be signed, we will need to
  // call `signAndSend` on it, like we did with `deployTx` above.
  const incrementTx = await client.increment({
    user: sourceKeypair.publicKey(), // who needs to sign
    value: 1, // how much to increment by
  })

  // For calls that don't need to be signed, you can get the `result` of their
  // simulation right away, on a call like `client.increment()` above.
  const { result } = await incrementTx.signAndSend()

  // Now you can do whatever you need to with the `result`, which in this case
  // contains the new value of the incrementor/counter.
  console.log("New incremented value:", result)
})();

Guides in this category:
📄️ Install and deploy a smart contract with code
Install and deploy a smart contract with code

📄️ Install WebAssembly (Wasm) bytecode using code
Install the Wasm of the contract using js-stellar-sdk

📄️ Invoke a contract function in a Stellar transaction using SDKs
Use the Stellar SDK to create, simulate, and assemble a transaction

📄️ simulateTransaction RPC method guide
simulateTransaction examples and tutorials guide

📄️ Submit a transaction to Stellar RPC using the JavaScript SDK
Use a looping mechanism to submit a transaction to the RPC

Did you find this page helpful?
Edit this page
Last updated on Apr 29, 2025 by Nando Vieira
