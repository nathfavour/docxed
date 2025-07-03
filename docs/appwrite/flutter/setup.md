beginner
10 min
Start with Flutter
Learn how to setup your first Flutter project powered by Appwrite.

Create Flutter project
Create a Flutter project.

Shell

flutter create my_app && cd my_app
Create project
Head to the Appwrite Console.

Create project screen

If this is your first time using Appwrite, create an account and create your first project.

Then, under Add a platform, add a Flutter app. You can choose between many different platfroms.

Web
iOS
Android
Linux
macOS
Windows
Add your app's name and package name, Your package name is generally the applicationId in your app-level build.gradle file.

In order to capture the Appwrite OAuth callback url, the following activity needs to be added inside the <application> tag, along side the existing <activity> tags in your AndroidManifest.xml. Be sure to replace the [PROJECT_ID] string with your actual Appwrite project ID. You can find your Appwrite project ID in you project settings screen in your Appwrite Console.

XML

<manifest ...>
  ...
  <application ...>
    ...
    <!-- Add this inside the `<application>` tag, along side the existing `<activity>` tags -->
    <activity android:name="com.linusu.flutter_web_auth_2.CallbackActivity" android:exported="true">
      <intent-filter android:label="flutter_web_auth_2">
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="appwrite-callback-[PROJECT_ID]" />
      </intent-filter>
    </activity>
  </application>
</manifest>
Add a platform

You can skip optional steps.

Install Appwrite
Install the Appwrite SDK for Flutter.

Shell

flutter pub add appwrite:17.0.0
Import Appwrite
Find your project's ID in the Settings page.

Project settings screen

Open the generated lib/main.dart and add the following code to it, replace <PROJECT_ID> with your project ID. This imports and initializes Appwrite.

Dart

import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Client client = Client()
      .setEndpoint("https://<REGION>.cloud.appwrite.io/v1")
      .setProject("<PROJECT_ID>");
  Account account = Account(client);

  runApp(MaterialApp(
    home: MyApp(account: account),
  ));
}
class MyApp extends StatefulWidget {
  final Account account;

  MyApp({required this.account});

  @override
  MyAppState createState() {
    return MyAppState();
  }
}
Create a login page
Then, append the following widgets to lib/main.dart create your login page.

Dart

class MyAppState extends State<MyApp> {
  models.User? loggedInUser;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  Future<void> login(String email, String password) async {
    await widget.account.createEmailPasswordSession(email: email, password: password);
    final user = await widget.account.get();
    setState(() {
      loggedInUser = user;
    });
  }

  Future<void> register(String email, String password, String name) async {
    await widget.account.create(
        userId: ID.unique(), email: email, password: password, name: name);
    await login(email, password);
  }

  Future<void> logout() async {
    await widget.account.deleteSession(sessionId: 'current');
    setState(() {
      loggedInUser = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(loggedInUser != null
                ? 'Logged in as ${loggedInUser!.name}'
                : 'Not logged in'),
            SizedBox(height: 16.0),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    login(emailController.text, passwordController.text);
                  },
                  child: Text('Login'),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    register(emailController.text, passwordController.text,
                        nameController.text);
                  },
                  child: Text('Register'),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    logout();
                  },
                  child: Text('Logout'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
All set
Run your project with flutter run and select a browser, platform, or emulator to run your project.