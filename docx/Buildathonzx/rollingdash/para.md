Expo

Copy page

Learn how to integrate the Para SDK with Expo projects.

Expo is a framework built on React Native that provides many out-of-the-box features, similar to NextJS for web but designed for mobile development. Para provides a @getpara/react-native-wallet package that works seamlessly in both React Native bare and Expo workflows, utilizing the device’s Native Passkeys for secure wallet management.

​
Prerequisites
To use Para, you need an API key. This key authenticates your requests to Para services and is essential for integration.

Don’t have an API key yet? Request access to the Developer Portal to create API keys, manage billing, teams, and more.

To ensure passkey functionality works correctly:

Enable biometric or device unlock settings (fingerprint, face unlock, or PIN)
On Android sign in to a Google account on the device (required for Google Play Services passkey management)
​
Dependency Installation
Install the required dependencies:


npm

yarn

pnpm

bun

Copy
pnpm add @getpara/react-native-wallet @react-native-async-storage/async-storage react-native-keychain react-native-modpow react-native-passkey react-native-quick-base64 @craftzdog/react-native-buffer react-native-quick-crypto
​
Project Setup
To use the @getpara/react-native-wallet package in your Expo project, you will need to do some initial project setup.

For passkeys to work correctly we have to setup the Relying Party ID for both iOS and Android. This ensures passkeys are bound to the domains they were created for.

Your apps must be registered with Para to link the passkey to the correct domain. You can find this configuration options your Developer Portal under the ‘Configuration’ tab of the API key label as Native Passkey Configuration.

​
Platform-Specific Configuration
iOS
Android
Configure your app.json file to enable passkey functionality and secure communication:

app.json

Copy
{
  "expo": {
    "ios": {
      "bundleIdentifier": "your.app.bundleIdentifier",
      "associatedDomains": [
        "webcredentials:app.beta.usecapsule.com?mode=developer",
        "webcredentials:app.usecapsule.com"
      ]
    }
  }
}
Important: Your teamId + bundleIdentifier must be registered with the Para team to set up associated domains. For example, if your Team ID is A1B2C3D4E5 and Bundle Identifier is com.yourdomain.yourapp, provide A1B2C3D4E5.com.yourdomain.yourapp to Para. This is required by Apple for passkey security. Allow up to 24 hours for domain propagation. You can find this setting in the Developer Portal under the ‘Configuration’ tab of the API key label as Native Passkey Configuration.
​
Configure Metro Bundler
Create or update metro.config.js in your project with the following node module resolutions. This will ensure that any library that depends on global modules like crypto or buffer will be properly resolved in the Expo environment.

metro.config.js

Copy
const { getDefaultConfig } = require("expo/metro-config");

const config = getDefaultConfig(__dirname);

config.resolver.extraNodeModules = {
  crypto: require.resolve("react-native-quick-crypto"),
  buffer: require.resolve("@craftzdog/react-native-buffer"),
};

module.exports = config;
​
Import Required Shims
Import the Para Wallet shim in your root layout file to ensure proper global module shimming. This ensures that the necessary modules are available globally in your application. Ensure this is the very first import in your root layout file.

app/_layout.tsx

Copy
import "@getpara/react-native-wallet/dist/shim";
// ... rest of your imports and layout code
Alternatively, you can create a custom entry point to handle the shimming. This will ensure that the shim occurs before the Expo Router entry point.


Custom Entry Point

​
Prebuild and Run
Since native modules are required, you’ll need to use Expo Development Build to ensure that linking is successful. This means using the expo prebuild command to generate the necessary native code and then run your app using expo run:ios or expo run:android.


Copy
npx expo prebuild
npx expo run:ios
npx expo run:android
You cannot use Expo Go as it doesn’t support native module linking. When running via yarn start, switch to development mode by pressing s, then i for iOS or a for Android.
​
Using the Para SDK
The @getpara/react-native-wallet provides two main authentication methods: email-based and phone-based. Both flows utilize Native Passkeys for secure and seamless authentication.

On mobile Para doesn’t provide a modal component. Instead you can create your own auth screens with either email, phone number, or oauth using the available methods in the Para SDK.

​
Setup the Para Client
First, set up the Para client singleton and initialize it in your app:

para.ts

Copy
import { ParaMobile, Environment } from "@getpara/react-native-wallet";

export const para = new ParaMobile(Environment.BETA, YOUR_API_KEY);
Then initialize it in your app entry point:

app/_layout.tsx

Copy
import { para } from "../para";
import { useEffect } from "react";

export default function Layout() {
  useEffect(() => {
    const initPara = async () => {
      await para.init();
    };

    initPara();
  }, []);
  // ... rest of your layout code
}
Para offers two hosted environments: Environment.BETA (alias Environment.DEVELOPMENT) for testing, and Environment.PROD (alias Environment.PRODUCTION) for live use. Select the environment that matches your current development phase.

Beta Testing Credentials In the BETA Environment, you can use any email ending in @test.getpara.com (like dev@test.getpara.com) or US phone numbers (+1) in the format (area code)-555-xxxx (like (425)-555-1234). Any OTP code will work for verification with these test credentials. These credentials are for beta testing only. You can delete test users anytime in the beta developer console to free up user slots.

​
Authentication Methods
Email Authentication
Phone Authentication
OAuth Authentication
​
Create a User with Email
Implement a user registration flow with email verification:


Copy
const handleUserRegistration = async (email: string) => {
  const userExists = await para.checkIfUserExists({ email });
  if (userExists) {
    await para.login({ email });
    return true; // User logged in
  }
  await para.createUser({ email });
  return false; // Verification needed
};

const handleVerification = async (email: string, verificationCode: string) => {
  const biometricsId = await para.verifyEmailBiometricsId({ verificationCode });
  
  if (biometricsId) {
    await para.registerPasskey({ email, biometricsId });
    return true;
  }
  
  return false;
};

// Usage example:
const needsVerification = await handleUserRegistration("user@example.com");

if (!needsVerification) {
  await handleVerification("user@example.com", "123456");
}
​
Login with Email
Authenticate an existing user with their email:


Copy
const handleLogin = async (email: string): Promise<boolean> => {
  try {
    const userExists = await para.checkIfUserExists({ email });
    if (userExists) {
      await para.login({ email });
      return true; // User logged in successfully
    } else {
      return false; // User does not exist
    }
  } catch (error) {
    // Handle error
    return false;
  }
};
​
Create a Wallet After Authentication
After the user has successfully authenticated, you can create their wallet:


Copy
const createWallet = async (): Promise<string | undefined> => {
  try {
    const { recoverySecret } = await para.createWalletPerMissingType({ skipDistribute: false });
    return recoverySecret;
  } catch (error) {
    // Handle error
    return undefined;
  }
};
Make sure to securely store the recovery secret returned from wallet creation. This is essential for account recovery.
By following these steps, you can implement a secure and user-friendly authentication system in your Expo application using the Para SDK.

​
Examples
For practical implementations of the Para SDK in Expo environments, check out our GitHub repository:

Para Expo Integration Examples
Para Expo Integration Examples
Explore our repository containing Expo implementations, along with shared UI components demonstrating Para integration.

​
Troubleshooting
If you encounter issues during the integration or usage of the Para SDK in your Expo application, here are some common problems and their solutions:


Para SDK initialization fails


Native modules are not found or linked


Passkey operations fail or throw errors


Crypto-related errors or undefined functions


Authentication fails or API requests are rejected


Expo-specific build issues

For a more comprehensive list of solutions, including Expo-specific issues, visit our troubleshooting guide:

Troubleshooting
Troubleshooting
Our troubleshooting guide provides solutions to common integration and usage problems.

​
Next Steps
After integrating Para, you can explore other features and integrations to enhance your Para experience.

EVM Integration
EVM Integration
Learn how to use Para with EVM-compatible libraries like ethers.js, viem, and wagmi.

Solana Integration
Solana Integration
Discover how to integrate Para with solana-web3.js.

Cosmos Integration
Cosmos Integration
Explore Para integration with Cosmos ecosystem using CosmJS, Cosmos Kit, and Graz.

























































































































































































Setup
Expo

Copy page

Learn how to integrate the Para SDK with Expo projects.

Expo is a framework built on React Native that provides many out-of-the-box features, similar to NextJS for web but designed for mobile development. Para provides a @getpara/react-native-wallet package that works seamlessly in both React Native bare and Expo workflows, utilizing the device’s Native Passkeys for secure wallet management.

​
Prerequisites
To use Para, you need an API key. This key authenticates your requests to Para services and is essential for integration.

Don’t have an API key yet? Request access to the Developer Portal to create API keys, manage billing, teams, and more.

To ensure passkey functionality works correctly:

Enable biometric or device unlock settings (fingerprint, face unlock, or PIN)
On Android sign in to a Google account on the device (required for Google Play Services passkey management)
​
Dependency Installation
Install the required dependencies:


npm

yarn

pnpm

bun

Copy
pnpm add @getpara/react-native-wallet @react-native-async-storage/async-storage react-native-keychain react-native-modpow react-native-passkey react-native-quick-base64 @craftzdog/react-native-buffer react-native-quick-crypto
​
Project Setup
To use the @getpara/react-native-wallet package in your Expo project, you will need to do some initial project setup.

For passkeys to work correctly we have to setup the Relying Party ID for both iOS and Android. This ensures passkeys are bound to the domains they were created for.

Your apps must be registered with Para to link the passkey to the correct domain. You can find this configuration options your Developer Portal under the ‘Configuration’ tab of the API key label as Native Passkey Configuration.

​
Platform-Specific Configuration
iOS
Android
Configure your app.json file to enable passkey functionality and secure communication:

app.json

Copy
{
  "expo": {
    "ios": {
      "bundleIdentifier": "your.app.bundleIdentifier",
      "associatedDomains": [
        "webcredentials:app.beta.usecapsule.com?mode=developer",
        "webcredentials:app.usecapsule.com"
      ]
    }
  }
}
Important: Your teamId + bundleIdentifier must be registered with the Para team to set up associated domains. For example, if your Team ID is A1B2C3D4E5 and Bundle Identifier is com.yourdomain.yourapp, provide A1B2C3D4E5.com.yourdomain.yourapp to Para. This is required by Apple for passkey security. Allow up to 24 hours for domain propagation. You can find this setting in the Developer Portal under the ‘Configuration’ tab of the API key label as Native Passkey Configuration.
​
Configure Metro Bundler
Create or update metro.config.js in your project with the following node module resolutions. This will ensure that any library that depends on global modules like crypto or buffer will be properly resolved in the Expo environment.

metro.config.js

Copy
const { getDefaultConfig } = require("expo/metro-config");

const config = getDefaultConfig(__dirname);

config.resolver.extraNodeModules = {
  crypto: require.resolve("react-native-quick-crypto"),
  buffer: require.resolve("@craftzdog/react-native-buffer"),
};

module.exports = config;
​
Import Required Shims
Import the Para Wallet shim in your root layout file to ensure proper global module shimming. This ensures that the necessary modules are available globally in your application. Ensure this is the very first import in your root layout file.

app/_layout.tsx

Copy
import "@getpara/react-native-wallet/dist/shim";
// ... rest of your imports and layout code
Alternatively, you can create a custom entry point to handle the shimming. This will ensure that the shim occurs before the Expo Router entry point.


Custom Entry Point

​
Prebuild and Run
Since native modules are required, you’ll need to use Expo Development Build to ensure that linking is successful. This means using the expo prebuild command to generate the necessary native code and then run your app using expo run:ios or expo run:android.


Copy
npx expo prebuild
npx expo run:ios
npx expo run:android
You cannot use Expo Go as it doesn’t support native module linking. When running via yarn start, switch to development mode by pressing s, then i for iOS or a for Android.
​
Using the Para SDK
The @getpara/react-native-wallet provides two main authentication methods: email-based and phone-based. Both flows utilize Native Passkeys for secure and seamless authentication.

On mobile Para doesn’t provide a modal component. Instead you can create your own auth screens with either email, phone number, or oauth using the available methods in the Para SDK.

​
Setup the Para Client
First, set up the Para client singleton and initialize it in your app:

para.ts

Copy
import { ParaMobile, Environment } from "@getpara/react-native-wallet";

export const para = new ParaMobile(Environment.BETA, YOUR_API_KEY);
Then initialize it in your app entry point:

app/_layout.tsx

Copy
import { para } from "../para";
import { useEffect } from "react";

export default function Layout() {
  useEffect(() => {
    const initPara = async () => {
      await para.init();
    };

    initPara();
  }, []);
  // ... rest of your layout code
}
Para offers two hosted environments: Environment.BETA (alias Environment.DEVELOPMENT) for testing, and Environment.PROD (alias Environment.PRODUCTION) for live use. Select the environment that matches your current development phase.

Beta Testing Credentials In the BETA Environment, you can use any email ending in @test.getpara.com (like dev@test.getpara.com) or US phone numbers (+1) in the format (area code)-555-xxxx (like (425)-555-1234). Any OTP code will work for verification with these test credentials. These credentials are for beta testing only. You can delete test users anytime in the beta developer console to free up user slots.

​
Authentication Methods
Email Authentication
Phone Authentication
OAuth Authentication
​
Create a User with Email
Implement a user registration flow with email verification:


Copy
const handleUserRegistration = async (email: string) => {
  const userExists = await para.checkIfUserExists({ email });
  if (userExists) {
    await para.login({ email });
    return true; // User logged in
  }
  await para.createUser({ email });
  return false; // Verification needed
};

const handleVerification = async (email: string, verificationCode: string) => {
  const biometricsId = await para.verifyEmailBiometricsId({ verificationCode });
  
  if (biometricsId) {
    await para.registerPasskey({ email, biometricsId });
    return true;
  }
  
  return false;
};

// Usage example:
const needsVerification = await handleUserRegistration("user@example.com");

if (!needsVerification) {
  await handleVerification("user@example.com", "123456");
}
​
Login with Email
Authenticate an existing user with their email:


Copy
const handleLogin = async (email: string): Promise<boolean> => {
  try {
    const userExists = await para.checkIfUserExists({ email });
    if (userExists) {
      await para.login({ email });
      return true; // User logged in successfully
    } else {
      return false; // User does not exist
    }
  } catch (error) {
    // Handle error
    return false;
  }
};
​
Create a Wallet After Authentication
After the user has successfully authenticated, you can create their wallet:


Copy
const createWallet = async (): Promise<string | undefined> => {
  try {
    const { recoverySecret } = await para.createWalletPerMissingType({ skipDistribute: false });
    return recoverySecret;
  } catch (error) {
    // Handle error
    return undefined;
  }
};
Make sure to securely store the recovery secret returned from wallet creation. This is essential for account recovery.
By following these steps, you can implement a secure and user-friendly authentication system in your Expo application using the Para SDK.

​
Examples
For practical implementations of the Para SDK in Expo environments, check out our GitHub repository:

Para Expo Integration Examples
Para Expo Integration Examples
Explore our repository containing Expo implementations, along with shared UI components demonstrating Para integration.

​
Troubleshooting
If you encounter issues during the integration or usage of the Para SDK in your Expo application, here are some common problems and their solutions:


Para SDK initialization fails


Native modules are not found or linked


Passkey operations fail or throw errors


Crypto-related errors or undefined functions


Authentication fails or API requests are rejected


Expo-specific build issues

For a more comprehensive list of solutions, including Expo-specific issues, visit our troubleshooting guide:

Troubleshooting
Troubleshooting
Our troubleshooting guide provides solutions to common integration and usage problems.

​
Next Steps
After integrating Para, you can explore other features and integrations to enhance your Para experience.

EVM Integration
EVM Integration
Learn how to use Para with EVM-compatible libraries like ethers.js, viem, and wagmi.

Solana Integration
Solana Integration
Discover how to integrate Para with solana-web3.js.

Cosmos Integration
Cosmos Integration
Explore Para integration with Cosmos ecosystem using CosmJS, Cosmos Kit, and Graz.