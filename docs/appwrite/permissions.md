Permissions
Appwrite's permission mechanism offers a simple, yet flexible way to manage which users, teams, or roles can access a specific resource in your project, such as documents and files.

Using permissions, you can decide that only user A and user B will have read and update access to a specific database document, while user C and team X will be the only ones with delete access.

As the name suggests, read permission allows a user to read a resource, create allows users to create new resources, update allows a user to make changes to a resource, and delete allows the user to remove the resource.

All permissions can be granted to individuals or groups of users, entire teams, or only to team members with a specific role. Permission can also be granted based on authentication status, such as to all users, only authenticated users, or only guest users.

A project user can only grant permissions to a resource that they have. For example, if a user is trying to share a document with a team that they are not a member of, they will encounter a 401 not authorized error. If your app needs users to grant access to teams they're not a member of, you can create Appwrite Functions with a Server SDK to achieve this functionality.

Appwrite resource
An Appwrite resource can be a database, collection, document, bucket, or file. Each resource has its own set of permissions to define who can interact with it.

Using the Appwrite permissions mechanism, you can grant resource access to users, teams, and members with different roles.

Default values
If you create a resource using a Server SDK or the Appwrite Console without explicit permissions, no one can access it by default because the permissions will be empty. If you create a resource using a Client SDK without explicit permissions, the creator will be granted read, update, and delete permissions on that resource by default.

Server integration
Server integrations can be used for increased flexibility. When using a Server SDK in combination with the proper API key scopes, you can have any type of access to any of your project resources regardless of their permissions.

Using the server integration flexibility, you can change resource permissions, share resources between different users and teams, or edit and delete them without any limitations.

Permission types
In Client and Server SDKs, you will find a Permission class with helper methods for each role described below:

Type	Description
Permission.read()	Access to read a resource.
Permission.create()	Access to create new resources. Does not apply to files or documents. Applying this type of access to files or documents results in an error.
Permission.update()	Access to change a resource, but not remove or create new resources. Does not apply to functions.
Permission.delete()	Access to remove a resource. Does not apply to functions.
Permission.write()	Alias to grant create, update, and delete access for collections and buckets and update and delete access for documents and files.
Permission roles
In Client and Server SDKs, you will find a Role class with helper methods for each role described below:

Type	Description
Role.any()	Grants access to anyone.
Role.guests()	Grants access to any guest user without a session. Authenticated users don't have access to this role.
Role.users([STATUS])	Grants access to any authenticated or anonymous user. You can optionally pass the verified or unverified string to target specific types of users.
Role.user([USER_ID], [STATUS])	Grants access to a specific user by user ID. You can optionally pass the verified or unverified string to target specific types of users.
Role.team([TEAM_ID])	Grants access to any member of the specific team. To gain access to this permission, the user must be the team creator (owner), or receive and accept an invitation to join this team.
Role.team([TEAM_ID], [ROLE])	Grants access to any member who possesses a specific role in a team. To gain access to this permission, the user must be a member of the specific team and have the given role assigned to them. Team roles can be assigned when inviting a user to become a team member.
Role.member([MEMBERSHIP_ID])	Grants access to a specific member of a team. When the member is removed from the team, they will no longer have access.
Role.label([LABEL_ID])	Grants access to all accounts with a specific label ID. Once the label is removed from the user, they will no longer have access. Learn more about labels.
Examples
The examples below will show you how you can use the different Appwrite permissions to manage access control to your project resources.

The following examples are using the Appwrite Web SDK but can be applied similarly to any of the other Appwrite SDKs.

Example 1 - Basic usage
In the following example, we are creating a document that can be read by anyone, edited by writers or admins, and deleted by administrators or a user with the user ID user:5c1f88b42259e.

Web

import { Client, Databases, Permission, Role } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1')
    .setProject('<PROJECT_ID>');

const databases = new Databases(client);

let promise = databases.createDocument(
    '<DATABASE_ID>',
    '<COLLECTION_ID>',
    {'actorName': 'Chris Evans', 'height': 183},
    [
        Permission.read(Role.any()),                  // Anyone can view this document
        Permission.update(Role.team("writers")),      // Writers can update this document
        Permission.update(Role.team("admin")),        // Admins can update this document
        Permission.delete(Role.user("5c1f88b42259e")), // User 5c1f88b42259e can delete this document
        Permission.delete(Role.team("admin"))          // Admins can delete this document
    ]
);

promise.then(function (response) {
    console.log(response);
}, function (error) {
    console.log(error);
});
Example 2 - Team roles
In the following example, we are creating a document that can be read by members of the team with ID 5c1f88b87435e and can only be edited or deleted by members of the same team that possess the team role owner.

Web

import { Client, Databases, Permission, Role } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1')
    .setProject('<PROJECT_ID>');

const databases = new Databases(client);

let promise = databases.createDocument(
    '<DATABASE_ID>',
    '<COLLECTION_ID>',
    {'actorName': 'Chris Evans', 'height': 183},
    [
        Permission.read(Role.team("5c1f88b87435e")),             // Only users of team 5c1f88b87435e can read the document
        Permission.update(Role.team("5c1f88b87435e", "owner")), // Only users of team 5c1f88b87435e with the role owner can update the document
        Permission.delete(Role.team("5c1f88b87435e", "owner"))  // Only users of team 5c1f88b87435e with the role owner can delete the document
    ]
);

promise.then(function (response) {
    console.log(response);
}, function (error) {
    console.log(error);
});
Example 3 - Private documents
A common use case is to allow users to create documents that are only accessible to them. Here's how this can be achieved:

Configure the collection
First, configure your collection to:

Enable Document Security in Collection Settings

Grant only CREATE permission to all users at the collection level

Why this setup?
Document Security enables per-document permissions

Collection-level CREATE permission allows users to create documents

Omitting READ/UPDATE/DELETE at collection level prevents users from accessing all documents

Create a document for a user
When creating documents in your application, set document-level permissions to restrict access to only the creator:


import { Client, Databases, Permission, Role } from "appwrite";

const client = new Client()
    .setEndpoint('https://cloud.appwrite.io/v1')
    .setProject('<PROJECT_ID>');

const databases = new Databases(client);

let promise = databases.createDocument(
    '<DATABASE_ID>',
    '<COLLECTION_ID>',
    { 'title': 'My Private Document' },
    [
        Permission.read(Role.user('<USER_ID>')),    // Only this user can read
        Permission.update(Role.user('<USER_ID>')),  // Only this user can update
        Permission.delete(Role.user('<USER_ID>'))   // Only this user can delete
    ]
);

promise.then(function (response) {
    console.log(response);
}, function (error) {
    console.log(error);
});
Understanding the flow
Collection-level CREATE permission allows users to create new documents

When a document is created, we set permissions for only the creator

These document-level permissions ensure only the creator can read, update, or delete their documents

Other users can create their own documents but cannot access documents they didn't create