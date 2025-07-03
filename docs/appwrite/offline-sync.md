Christy Jacob
Data replication with RxDB
RxDB (Reactive Database) is a client-side, NoSQL database designed for JavaScript applications. It emphasizes real-time data synchronization, offline-first capabilities, and reactive programming paradigms. RxDB is particularly suited for applications that require seamless user experiences across various platforms, including web browsers, mobile devices, and desktop environments.

How does the integration work?
RxDB integrates with Appwrite through a replication plugin that enables two-way data synchronization between a client-side RxDB instance and an Appwrite Database. This setup allows apps to store data locally (using data stores such as LocalStorage, SQLite, or IndexedDB) and push/pull changes from the Appwrite backend. When offline, the app continues to function smoothly using RxDB's local-first model, and once connectivity is restored, it syncs changes with Appwrite. Conflict handling, soft deletion, and live replication are handled seamlessly using RxDB’s built-in tools and Appwrite’s Realtime API.

How to implement
To implement the RxDB integration, there are several steps you must complete:

Step 1: Configure Appwrite project
For this step, you must create an account on Appwrite Cloud or self-host Appwrite if you haven’t already. Head over to the Appwrite console, go to the Settings page, and copy your project ID and API endpoint for further usage. Next, go to the Databases page from the left sidebar, create a new database with the ID mydb, and then a collection with the ID humans (save both IDs for further usage).

Click on the Attributes tab and add the following attributes (schema used for demo purposes):

Key	Type	Size	Required
name	String	100	Yes
age	Integer		Yes
homeAddress	String	2000	Yes
deleted	Boolean		Yes
Note: The deleted attribute is necessary to add because RxDB only soft deletes to prevent data loss in offline scenarios (no hard deletion of data occurs).

Then, head to the Settings tab of your collection, scroll down to the Permissions section, and the following:

Role	Create	Read	Update	Delete
Any	Yes	Yes	Yes	Yes
Note: While RxDB does not allow you to manually configure permissions for each document, if your app uses Appwrite Auth and document-level permissions are enabled for your collection, the Appwrite SDK will automatically assign read and write permissions to the logged-in user for each document created.

Step 2: Install Appwrite Web SDK and RxDB library
Open the terminal in your app’s working directory and run the following command:

Bash

npm install appwrite rxdb
In your app’s .env file, add the following:

Bash

APPWRITE_ENDPOINT=https://cloud.appwrite.io/v1
APPWRITE_PROJECT_ID=your-project-id
APPWRITE_DATABASE_ID=your-database-id
APPWRITE_COLLECTION_ID=your-collection-id
Then, import all necessary libraries in your code:

JavaScript

import { replicateAppwrite } from 'rxdb/plugins/replication-appwrite';
import { createRxDatabase, addRxPlugin, RxCollection } from 'rxdb/plugins/core';
import { getRxStorageLocalstorage } from 'rxdb/plugins/storage-localstorage';
import { Client } from 'appwrite';
Step 3: Setup Appwrite client
To create an Appwrite client, add the following code:

JavaScript

export const client = new Client()
	.setEndpoint(process.env.APPWRITE_ENDPOINT)
	.setEndpointRealtime(process.env.APPWRITE_ENDPOINT)
	.setProject(process.env.APPWRITE_PROJECT_ID);
Step 4: Create an RxDB database and collection
To create an RxDB database and collection, first, you must prepare a database schema via the following code:

JavaScript

const mySchema = {
    title: 'my schema',
    version: 0,
    primaryKey: 'id',
    type: 'object',
    properties: {
        id: {
            type: 'string',
            maxLength: 100
        },
        name: {
            type: 'string'
        },
				age: {
					type: 'number'
				},
        homeAddress: {
            type: 'string'
        }
    },
    required: ['id', 'name', 'age', 'homeAddress']
};
Using this schema, you can create a database and collection via the following code:

JavaScript

const db = await createRxDatabase({
    name: 'mydb',
    storage: getRxStorageLocalstorage()
});

await db.addCollections({
    humans: {
        schema: mySchema
    }
});

const collection = db.humans;
Note: Please ensure that the names of your RxDB database and collection match the IDs of your Appwrite database and collection.

Step 5: Start replication
To start data replication, add the following code:

JavaScript

const replicationState = replicateAppwrite({
    replicationIdentifier: 'my-appwrite-replication',
    client,
    databaseId: process.env.APPWRITE_DATABASE_ID,
    collectionId: process.env.APPWRITE_COLLECTION_ID,
    deletedField: 'deleted', // Field that represents deletion in Appwrite
    collection,
    pull: {
        batchSize: 10,
    },
    push: {
        batchSize: 10
    },
    /*
     * ...
     * You can set all other options for RxDB replication states
     * like 'live' or 'retryTime'
     * ...
     */
});