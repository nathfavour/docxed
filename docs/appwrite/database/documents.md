Documents
Each piece of data or information in Appwrite Databases is a document. Documents have a structure defined by the parent collection.

Create documents
Permissions required
You must grant create permissions to users at the collection level before users can create documents. Learn more about permissions

In most use cases, you will create documents programmatically.


import { Client, Databases, ID } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1')
    .setProject('<PROJECT_ID>');

const databases = new Databases(client);

const promise = databases.createDocument(
    '<DATABASE_ID>',
    '[COLLECTION_ID]',
    ID.unique(),
    {}
);

promise.then(function (response) {
    console.log(response);
}, function (error) {
    console.log(error);
});
During testing, you might prefer to create documents in the Appwrite Console. To do so, navigate to the Documents tab of your collection and click the Add document button.

List documents
Permissions required
You must grant read permissions to users at the collection level before users can read documents. Learn more about permissions

Documents can be retrieved using the List Document endpoint.

Results can be filtered, sorted, and paginated using Appwrite's shared set of query methods. You can find a full guide on querying in the Queries Guide.

By default, results are limited to the first 25 items. You can change this through pagination.


import { Client, Databases, Query } from "appwrite";

const client = new Client()
    .setEndpoint("https://<REGION>.cloud.appwrite.io/v1")
    .setProject("<PROJECT_ID>");

const databases = new Databases(client);

let promise = databases.listDocuments(
    "<DATABASE_ID>",
    "<COLLECTION_ID>",
    [
        Query.equal('title', 'Avatar')
    ]
);

promise.then(function (response) {
    console.log(response);
}, function (error) {
    console.log(error);
});
Permissions
In Appwrite, permissions can be granted at the collection level and the document level. Before a user can create a document, you need to grant create permissions to the user.

Read, update, and delete permissions can be granted at both the collection and document level. Users only need to be granted access at either the collection or document level to access documents.

