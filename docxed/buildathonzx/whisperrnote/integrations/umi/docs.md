Interacting with Solidity Contract
In this guide, we will create a simple website that interacts with your deployed Solidity smart contract. The website will allow users to increment the counter and display its current value using Solidity transactions and Viem SDK.

1. Setting Up the Next.js Project
Create a new Next.js project with TypeScript:

npx create-next-app@latest my-solidity-dapp --typescript
cd my-solidity-dapp
Install the required dependencies:

npm install viem @mysten/bcs ethers
2. Adding Configuration for Transactions
Create a new file config.ts to define methods for creating a transaction payload and sending transactions using the Viem SDK.


import { bcs } from '@mysten/bcs';
import { ethers } from 'ethers';
import { createPublicClient, createWalletClient, custom, defineChain } from 'viem';
import { publicActionsL2, walletActionsL2 } from 'viem/op-stack';
import { abi } from './Counter.json';

const COUNTER_CONTRACT_ADDRESS = 'CONTRACT_ADDRESS';

const FUNCTION_SERIALIZER = bcs.enum('SerializableTransactionData', {
  EoaBaseTokenTransfer: null,
  ScriptOrDeployment: null,
  EntryFunction: null,
  L2Contract: null,
  EvmContract: bcs.byteVector(),
});

const serializeFunction = (data: string): `0x${string}` => {
  const code = Uint8Array.from(Buffer.from(data.replace('0x', ''), 'hex'));
  const evmFunction = FUNCTION_SERIALIZER.serialize({ EvmContract: code }).toBytes();
  return '0x' + Buffer.from(evmFunction).toString('hex');
};

export const devnet = defineChain({
  id: 42069,
  sourceId: 42069,
  name: 'Umi',
  nativeCurrency: {
    decimals: 18,
    name: 'Ether',
    symbol: 'ETH',
  },
  rpcUrls: {
    default: {
      http: ['https://devnet.uminetwork.com'],
    },
  },
});

export const getAccount = async () => {
  const [account] = await window.ethereum!.request({
    method: 'eth_requestAccounts',
  });
  return account;
};

export const publicClient = () =>
  createPublicClient({
    chain: devnet,
    transport: custom(window.ethereum!),
  }).extend(publicActionsL2());

export const walletClient = () =>
  createWalletClient({
    chain: devnet,
    transport: custom(window.ethereum!),
  }).extend(walletActionsL2());

export const getFunction = async (name: string) => {
  const counter = new ethers.Contract(COUNTER_CONTRACT_ADDRESS, abi);
  const tx = await counter.getFunction(name).populateTransaction();
  return { to: tx.to as `0x${string}`, data: serializeFunction(tx.data) };
};
Make sure to change the CONTRACT_ADDRESS with the address of your deployed project from previous step.

3. Building the Web Interface
Create a simple UI with an input field, buttons, and a display for the counter value.
Add a function to fetch the current counter value from the smart contract using Viem.
Implement a function to send a transaction that increments the counter.
Example Code (Counter Interaction)
Create a new file src/app/Counter.tsx:


'use client';
import { useEffect, useState } from 'react';
import { getAccount, getFunction, publicClient, walletClient } from '@/config';
import { toBigInt } from 'ethers';

export default function Counter() {
  const [counter, setCounter] = useState(0);

  const fetchCounter = async () => {
    const { to, data } = await getFunction('count');
    const response = await publicClient().call({ to, data });

    if (!response.data) throw Error('No data found');
    if (typeof response.data == 'string') throw Error('Data is not an array of bytes');
    const count = toBigInt(new Uint8Array(response.data));
    setCounter(Number(count));
  };

  const incrementCounter = async () => {
    const { to, data } = await getFunction('increment');
    const hash = await walletClient().sendTransaction({ account: await getAccount(), to, data });
    await publicClient().waitForTransactionReceipt({ hash });
    fetchCounter();
  };

  useEffect(() => {
    fetchCounter();
  }, []);

  return (
    <div className="text-center m-24">
      <h1 className="py-6">Counter: {counter}</h1>
      <button className="bg-blue-700 rounded-lg px-5 py-2.5" type="button" onClick={incrementCounter}>
        Increment
      </button>
    </div>
  );
}
4. Integrating the Counter Component
Replace the contents of src/app/page.tsx with:


import Counter from "./Counter";

export default function Home() {
  return (
    <div>
      <h1>Solidity Counter DApp</h1>
      <Counter />
    </div>
  );
}
5. Running the Website
Start the development server:


npm run dev
Open http://localhost:3000 in your browser to interact with the contract.

To add an extra layer of protection for your account, consider using a secondary Ethereum wallet. We've successfully tested this approach with MetaMask Flash Wallet.

Conclusion
You've successfully created a simple Next.js website to interact with your Solidity smart contract. Users can now send transactions to increment the counter and retrieve its value. In the next section, we will explore deploying this website for public access.