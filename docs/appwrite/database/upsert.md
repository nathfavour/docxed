Skip to content
appwrite
Blog
/
Announcing Database Upsert: Simplify your database interactions
July 8, 2025
•
5 min
Announcing Database Upsert: Simplify your database interactions
A cleaner, faster, and atomic way to manage your documents in Appwrite.

Jake Barnby
Jake Barnby
Engineering Lead

SHARE


Working with databases often involves small but repetitive decisions like checking if a document exists, choosing between creating or updating, handling errors that come from guessing wrong. These steps are not difficult on their own, but over time they add complexity to your code and friction to your workflow.

To simplify this, we introduce Database Upsert in Appwrite.

How it works
Upsert allows you to create or update a document using a single API call. If the document does not exist, it is created. If it does, it is updated. You no longer need to write separate logic to check for existence or handle 404 responses. The server handles that for you.

This change removes the need for client-side conditionals, reduces the number of requests between your app and the database, and helps avoid potential race conditions. It is a small shift in how you interact with the database, but one that can make your code cleaner and your application logic easier to follow.

Ideal for multi-client scenarios
Whether you synchronize mobile data, handle background worker processes, or collect data from IoT devices, Database Upsert ensures data consistency. Its fully atomic nature prevents race conditions, keeping your data accurate and consistent, no matter how many clients interact simultaneously.

This brings you immediate benefits such as:

Fewer network calls: Combine GET, POST, and PATCH into a single, efficient API request.

Race-free writes: Ensure atomic operations that prevent conflicts.

Cleaner, simpler code: Reduce branching logic and improve readability.

Idempotency: Safe and easy retries ensure consistent behaviour.

How it works
Implementing Upsert is straightforward and intuitive:


import { Client, Databases, ID } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1')
    .setProject('<PROJECT_ID>');

const databases = new Databases(client);

const result = await databases.upsertDocument(
    '<DATABASE_ID>',
    '<COLLECTION_ID>',
    ID.unique(),
    {
	    'name': 'Document 1',
	    'description': 'Description 1'
    }
);
Database Upsert was developed to enhance developer productivity and satisfaction, providing a feature that matches or surpasses competitive solutions. Whether using Appwrite Cloud or a self-hosted setup, Database Upsert integrates smoothly into your development workflow.

This feature simplifies your database interactions, enhancing efficiency, reducing complexity, and empowering you to build faster.

More resources
Read the documentation to get started

Announcing Bulk API: Handle heavy data workloads with ease

Build a personal CRM with SvelteKit and Appwrite Databases

Announcing: Document imports from CSV files

Table of Contents
How it works
Ideal for multi-client scenarios
More resources

Back to Top
Start building with Appwrite today
Read next
Announcing Bulk API: Handle heavy data workloads with ease
Announcing Bulk API: Handle heavy data workloads with ease
Jake Barnby
Jake Barnby
July 3, 2025
5 min
Build a personal CRM with SvelteKit and Appwrite Databases
Build a personal CRM with SvelteKit and Appwrite Databases
Aditya Oberai
Aditya Oberai
July 3, 2025
10 min
Announcing: Document imports from CSV files
Announcing: Document imports from CSV files
Darshan Pandya
Darshan Pandya
July 1, 2025
5 min
Subscribe to our newsletter
Sign up to our company blog and get the latest insights from Appwrite. Learn more about engineering, product design, building community, and tips & tricks for using Appwrite.

Enter your email
appwrite
Quick starts
Web
Next.js
React
Vue.js
Nuxt
SvelteKit
Refine
Angular
React Native
Flutter
Apple
Android
Qwik
Astro
Solid
Products
Auth
Databases
Storage
Functions
Messaging
Realtime
Hosting
Network
Learn
Blog
Docs
Integrations
Community
Init
Threads
Changelog
Roadmap
Source code
Programs
Heroes
Startups
Education
Partners
About
Company
Pricing
Careers
Store
Contact us
Assets
Security
Copyright © 2025 Appwrite

Terms
Privacy
Cookies
