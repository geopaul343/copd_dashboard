# Firebase Setup Guide for COPD Clinical Dashboard

## Step 1: Firebase Console Setup

### 1.1 Go to Firebase Console
1. Visit [Firebase Console](https://console.firebase.google.com/)
2. Select your existing project "copd nurse dashboard" or create a new one

### 1.2 Enable Authentication
1. In the Firebase console, go to **Authentication** → **Sign-in method**
2. Click on **Google** provider
3. Click **Enable**
4. Add your email as an authorized domain
5. Add support email (your email)
6. Click **Save**

### 1.3 Add Web App
1. Go to **Project Overview** → **Add app** → **Web** (</> icon)
2. App nickname: `COPD Clinical Dashboard`
3. Check "Also set up Firebase Hosting" (optional)
4. Click **Register app**
5. Copy the Firebase config object - you'll need this!

### 1.4 Add Flutter App (for mobile later)
1. Go to **Project Overview** → **Add app** → **Android** (Android icon)
2. Android package name: `com.example.copd_clinical_dashbord`
3. Download `google-services.json` and place it in `android/app/`

## Step 2: Update Firebase Configuration

### 2.1 Get Your Firebase Config
From the Firebase Console → Project Settings → General → Your apps → Web app:

```javascript
const firebaseConfig = {
  apiKey: "your-api-key-here",
  authDomain: "copd-nurse-dashboard.firebaseapp.com",
  projectId: "copd-nurse-dashboard",
  storageBucket: "copd-nurse-dashboard.appspot.com",
  messagingSenderId: "123456789",
  appId: "your-app-id-here",
  measurementId: "your-measurement-id-here"
};
```

### 2.2 Update lib/firebase_options.dart
Replace the placeholder values in `lib/firebase_options.dart` with your actual values:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'your-actual-web-api-key',
  appId: 'your-actual-web-app-id',
  messagingSenderId: 'your-actual-sender-id',
  projectId: 'copd-nurse-dashboard',
  authDomain: 'copd-nurse-dashboard.firebaseapp.com',
  storageBucket: 'copd-nurse-dashboard.appspot.com',
  measurementId: 'your-actual-measurement-id',
);
```

## Step 3: Web Configuration for Google Sign-In

### 3.1 Update web/index.html
Add this meta tag in the `<head>` section of `web/index.html`:

```html
<meta name="google-signin-client_id" content="YOUR_WEB_CLIENT_ID.apps.googleusercontent.com">
```

Get the Web Client ID from:
Firebase Console → Authentication → Sign-in method → Google → Web SDK configuration

## Step 4: Test the Setup

### 4.1 Run the app
```bash
flutter run -d chrome
```

### 4.2 Test Google Sign-In
1. Click "Continue with Google"
2. Complete the Google sign-in flow
3. You should be redirected to the patient dashboard
4. Check Firebase Console → Authentication → Users to see your signed-in user

## Step 5: Security Rules (Optional but Recommended)

### 5.1 Firestore Security Rules
If you plan to use Firestore later:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## Troubleshooting

### Common Issues:

1. **"Google Sign-In failed"**
   - Check that Google provider is enabled in Firebase Console
   - Verify that your domain is added to authorized domains
   - Make sure the Web Client ID is correctly added to index.html

2. **"Firebase not initialized"**
   - Check that firebase_options.dart has correct values
   - Ensure Firebase.initializeApp() is called in main.dart

3. **"Invalid API key"**
   - Double-check all API keys and IDs in firebase_options.dart
   - Make sure you're using the web config for web platform

## Next Steps

Once authentication is working:
1. Add user profile management
2. Implement patient data storage in Firestore
3. Add real-time updates for patient alerts
4. Set up cloud functions for notifications

## Files to Update

After getting your Firebase config:
- [ ] `lib/firebase_options.dart` - Add your actual API keys
- [ ] `web/index.html` - Add Google Client ID meta tag
- [ ] `android/app/google-services.json` - Add for Android support

---

**Need Help?** 
- Firebase Documentation: https://firebase.google.com/docs/flutter/setup
- Google Sign-In for Flutter: https://pub.dev/packages/google_sign_in 