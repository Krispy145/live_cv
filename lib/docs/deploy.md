# Deploy with CI/CD Setup

- First in ios directory and android directory
  - run `fastlane init`

### iOS Deployment

#### First Build

- Archive your ios flaver environment on Xcode
- Create an App on App Store Connect
- Create an idenifier in app store connect with the app ID
- Invite Testers accordingly

#### Setup App Store Connect API Key

To get an App Store Connect API key follow these steps

1. **Log in to App Store Connect**

- Go to the [App Store Connect](https://appstoreconnect.apple.com/) website and sign in with your Apple ID associated with your Developer Program account.

1. **Access API Keys section**

- After logging in, click on the "Users and Access" section from the main dashboard.

1. **Navigate to API Keys**

- In the "Users and Access" section, select the "Integrations" tab located at the top of the page.

1. **Create a new API Key**

- Click on the plus (+) button to create a new API key.
- Fill in the required information, such as the name of the key and access rights (such as App Manager, Developer, Marketing, etc.).

1. **Generate the API Key**

- After filling in the necessary details, click on "Generate".
- Once the key is generated, you will see the new key listed under the "Integration" tab.

1. **Download the API Key**

- Apple will provide you with a key ID, a private key file (in `.p8` format), and other necessary details.
- Download the private key file immediately as you will not be able to download it again. Make sure to store it securely.

1. **Note down the Key ID and other details**

- Along with the private key file, make sure to note down the key ID, issuer ID, and other relevant details provided. These are necessary for configuring your API requests.

1. **Use the API Key**

- There is an _app_store_connect.json_ template inside the ios/templates folder that must be used inside the specific Firebase/{environment} folders to ensure team wide deployment.
- Take the contents of the .p8 file and paste it in the json under the "key" field. ensure that the contents are a single line, but have the \n separator for each line.
- Pupulate the "issuer_id" and "key_id" appropriately as well

And thats it, you should be able to use the `yak deploy` cli command now to deploy to ios.

If you have ay issues, this link provides helpful images and details to walk you through the process

[https://o-ifeanyi.hashnode.dev/flutter-fastlane-part-1#heading-ios-set-up](https://o-ifeanyi.hashnode.dev/flutter-fastlane-part-1#heading-android-set-up)

### Android Deployment

#### First Build

- Create an App on the Google Play Console
- Manually make first deployment
  - flutter build appbundle
  - Visit Google Play Console
  - Add the necessary app details as prompted
  - Invite Testers accordingly
  - Create new release in internal testing channel
- Google Play Android Developer API
  - [https://console.developers.google.com/apis/api/androidpublisher.googleapis.com/overview]()

#### Setup Google Service Account Key

To attain a Google Play Console service account JSON key for your application, follow these steps

1. **Log in to Google Play Console**

   - Go to the [Google Play Console](https://play.google.com/console) website and sign in with your Google account associated with your Developer Program.

2. **Access API Access**

   - In the left-hand menu, navigate to "Setup" and then select "API access".

3. **Create a new service account**

   - If you haven’t already linked your Google Play Console with a Google Cloud project, you’ll need to do so. Click on the "Choose a project to link" button and follow the prompts to link a Google Cloud project.
   - After linking the project, click on the "Create new service account" button.

4. **Go to the Google Cloud Platform**

   - You will be redirected to the Google Cloud Platform (GCP) service accounts page.
   - Click on "Create service account".

5. **Fill in the service account details**

   - Enter a name and description for the service account.
   - Click "Create".

6. **Grant the service account access to the project**

   - In the "Service account permissions" section, select the role "Service Account User".
   - Click "Continue".

7. **Create and download the JSON key**

   - Under the "Grant users access to this service account" section, you can skip this step by clicking "Done".
   - In the list of service accounts, find the one you just created and click on it.
   - Go to the "Keys" tab, click on "Add Key", and select "Create new key".
   - Choose "JSON" and click "Create". The JSON key file will be downloaded automatically.
   - Name the file google*play*{env}}.json and save this file in android/app/src/{environment}

8. **Grant API access in Google Play Console**

   - Return to the Google Play Console and in the "API access" page, click on "Grant Access" for the newly created service account.
   - Assign the necessary permissions to the service account. For example, you might need to give "Release Manager" permissions for publishing apps.

9. **Use the JSON key**

   - The downloaded JSON key file contains all the necessary credentials and permissions to authenticate API requests.
   - This file needs to be added to the android/app/src/{environment} folder for use with the CI/CD command
   - Use this JSON key file in your automation tools or CI/CD pipelines to interact with the Google Play Console API.

And thats it, you should be able to use the `yak deploy` cli command now to deploy to android.

If you have ay issues, this link provides helpful images and details to walk you through the process

[https://docs.codemagic.io/yaml-publishing/google-play/#configure-google-play-api-access]()

By following these steps, you will have successfully created and obtained a Google Play Console service account JSON key, enabling you to automate and manage various aspects of your app in the Google Play Store.

### Web Deployment

#### First Build

- Login to the appropriate Firebase account
  - run `firebase login`
- Initialize Firebase Hosting
  - run `firebase init`
  - follow prompts to setup hosting for the {envirnment} project

And thats it, you should be able to use the `yak deploy` cli command now to deploy to web.

### CLI Command Usage

- `yak deploy` from **root** of Project folder

* Select environment (from options)

  - **dev**
  - **stage**
  - **prod**

* Select version type (from options)

  - **build**
    - 0.0.0+1
  - **patch**
    - 0.0.1
  - **minor**
    - 0.1.0
  - **major**
    - 1.0.0

* Select channel (from options)

  - **alpha**

    - _Android calls it Internal_

  - **beta**

    - _Android calls it Alpha_

  - **production**

    - _Android calls it Production_

* Select platform to deploy to

  - mobile
  - web
  - both

* Check details and confirm

  - Hits Makefile command to bump version, and then to deploy to web, ios, android
  - Web
    - Uses .firebasesrc to select project
  - iOS
    - Uses iOS Appfile to hit iOS Fastfile deploy command for relevant settings
  - Android
    - Uses Android Appfile to hit Android Fastfile deploy command for relevant settin

### iOS Deployment:

#### Setup App Store Connect API Key:

To get an App Store Connect API key follow these steps:

1. **Log in to App Store Connect** :

- Go to the [App Store Connect](https://appstoreconnect.apple.com/) website and sign in with your Apple ID associated with your Developer Program account.

1. **Access API Keys section** :

- After logging in, click on the "Users and Access" section from the main dashboard.

1. **Navigate to API Keys** :

- In the "Users and Access" section, select the "Integrations" tab located at the top of the page.

1. **Create a new API Key** :

- Click on the plus (+) button to create a new API key.
- Fill in the required information, such as the name of the key and access rights (such as App Manager, Developer, Marketing, etc.).

1. **Generate the API Key** :

- After filling in the necessary details, click on "Generate".
- Once the key is generated, you will see the new key listed under the "Integration" tab.

1. **Download the API Key** :

- Apple will provide you with a key ID, a private key file (in `.p8` format), and other necessary details.
- Download the private key file immediately as you will not be able to download it again. Make sure to store it securely.

1. **Note down the Key ID and other details** :

- Along with the private key file, make sure to note down the key ID, issuer ID, and other relevant details provided. These are necessary for configuring your API requests.

1. **Use the API Key** :

- There is an _app_store_connect.json_ template inside the ios/templates folder that must be used inside the specific Firebase/{environment} folders to ensure team wide deployment.
- Take the contents of the .p8 file and paste it in the json under the "key" field. ensure that the contents are a single line, but have the \n separator for each line.
- Pupulate the "issuer_id" and "key_id" appropriately as well

And thats it, you should be able to use the `yak deploy` cli command now to deploy to ios.

If you have ay issues, this link provides helpful images and details to walk you through the process:

[https://o-ifeanyi.hashnode.dev/flutter-fastlane-part-1#heading-ios-set-up](https://o-ifeanyi.hashnode.dev/flutter-fastlane-part-1#heading-android-set-up)

### Android Deployment:

#### Setup Google Service Account Key:

To attain a Google Play Console service account JSON key for your application, follow these steps:

1. **Log in to Google Play Console**:

   - Go to the [Google Play Console](https://play.google.com/console) website and sign in with your Google account associated with your Developer Program.

2. **Access API Access**:

   - In the left-hand menu, navigate to "Setup" and then select "API access".

3. **Create a new service account**:

   - If you haven’t already linked your Google Play Console with a Google Cloud project, you’ll need to do so. Click on the "Choose a project to link" button and follow the prompts to link a Google Cloud project.
   - After linking the project, click on the "Create new service account" button.

4. **Go to the Google Cloud Platform**:

   - You will be redirected to the Google Cloud Platform (GCP) service accounts page.
   - Click on "Create service account".

5. **Fill in the service account details**:

   - Enter a name and description for the service account.
   - Click "Create".

6. **Grant the service account access to the project**:

   - In the "Service account permissions" section, select the role "Service Account User".
   - Click "Continue".

7. **Create and download the JSON key**:

   - Under the "Grant users access to this service account" section, you can skip this step by clicking "Done".
   - In the list of service accounts, find the one you just created and click on it.
   - Go to the "Keys" tab, click on "Add Key", and select "Create new key".
   - Choose "JSON" and click "Create". The JSON key file will be downloaded automatically. Save this file securely as you will need it for authentication.

8. **Grant API access in Google Play Console**:

   - Return to the Google Play Console and in the "API access" page, click on "Grant Access" for the newly created service account.
   - Assign the necessary permissions to the service account. For example, you might need to give "Release Manager" permissions for publishing apps.

9. **Use the JSON key**:

   - The downloaded JSON key file contains all the necessary credentials and permissions to authenticate API requests.
   - This file needs to be added to the android/app/src/{environment} folder for use with the CI/CD command
   - Use this JSON key file in your automation tools or CI/CD pipelines to interact with the Google Play Console API.

And thats it, you should be able to use the `yak deploy` cli command now to deploy to android.

If you have ay issues, this link provides helpful images and details to walk you through the process:

[https://docs.codemagic.io/yaml-publishing/google-play/#configure-google-play-api-access]()

By following these steps, you will have successfully created and obtained a Google Play Console service account JSON key, enabling you to automate and manage various aspects of your app in the Google Play Store.

#### CLI Command Usage:

- `yak run build:{env}` to build the platform releases
- `yak deploy` from **root** of Project folder
- Select environment (from options)
  - **dev**
  - **stage**
  - **prod**
- Select version type (from options)
  - **build**
    - 0.0.0+1
  - **patch**
    - 0.0.1
  - **minor**
    - 0.1.0
  - **major**
    - 1.0.0
- Select channel (from options)
  - **alpha**
    - _Android calls it Internal_
  - **beta**
    - _Android calls it Alpha_
  - **production**
    - _Android calls it Production_
  -
- Select platform to deploy to
  - mobile
  - web
  - both
- Check details and confirm
  - Hits Makefile command to bump version, and then to deploy to web, ios, android
  - Web
    - Uses .firebasesrc to select project
  - iOS
    - Uses iOS Appfile to hit iOS Fastfile deploy command for relevant settings
  - Android
    - Uses Android Appfile to hit Android Fastfile deploy command for relevant settings
