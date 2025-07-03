Start with Databases
Create database
Head to your Appwrite Console and create a database and name it Oscar. Optionally, add a custom database ID.

Create collection
Create a collection and name it My books. Optionally, add a custom collection ID.

Navigate to Attributes and create attributes by clicking Create attribute and select String. Attributes define the structure of your collection's documents. Enter Attribute key and Size. For example, title and 100.

Navigate to Settings > Permissions and add a new role Any. Check the CREATE and READ permissions, so anyone can create and read documents.

Create documents
To create a document use the createDocument method.

In the Settings menu, find your project ID and replace <PROJECT_ID> in the example.

Navigate to the Oscar database, copy the database ID, and replace <DATABASE_ID>. Then, in the My books collection, copy the collection ID, and replace <COLLECTION_ID>.


import { Client, Databases, ID } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1')
    .setProject('<PROJECT_ID>');

const databases = new Databases(client);

const promise = databases.createDocument(
    '<DATABASE_ID>',
    '<COLLECTION_ID>',
    ID.unique(),
    { "title": "Hamlet" }
);

promise.then(function (response) {
    console.log(response);
}, function (error) {
    console.log(error);
});
The response should look similar to this.

JSON

{
    "title": "Hamlet",
    "$id": "65013138dcd8618e80c4",
    "$permissions": [],
    "$createdAt": "2023-09-13T03:49:12.905+00:00",
    "$updatedAt": "2023-09-13T03:49:12.905+00:00",
    "$databaseId": "650125c64b3c25ce4bc4",
    "$collectionId": "650125cff227cf9f95ad"
}
List documents
To read and query data from your collection, use the listDocuments endpoint.

Like the previous step, replace <PROJECT_ID>, <DATABASE_ID>, and<COLLECTION_ID> with their respective IDs.


import { Client, Databases, Query } from "appwrite";

const client = new Client()
    .setEndpoint("https://<REGION>.cloud.appwrite.io/v1")
    .setProject("<PROJECT_ID>")

const databases = new Databases(client);

let promise = databases.listDocuments(
    "<DATABASE_ID>",
    "<COLLECTION_ID>",
    [
        Query.equal('title', 'Hamlet')
    ]
);

promise.then(function (response) {
    console.log(response);
}, function (error) {
    console.log(error);
});