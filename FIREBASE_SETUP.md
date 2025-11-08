# Firebase Setup Instructions

## Step 1: Configure Firebase Project

1. Make sure you're logged into Firebase:
   ```bash
   firebase login
   ```

2. Run FlutterFire CLI to configure your project:
   ```bash
   flutterfire configure --project=mystudytech
   ```

   Note: If the project doesn't exist, create it first at https://console.firebase.google.com/

## Step 2: Update firebase_options.dart

After running `flutterfire configure`, the `lib/firebase_options.dart` file will be automatically generated with your project's configuration.

## Step 3: Enable Authentication in Firebase Console

1. Go to https://console.firebase.google.com/
2. Select your project "mystudytech"
3. Navigate to **Authentication** in the left sidebar
4. Click **Get Started**
5. Enable **Email/Password** authentication method
6. Click **Save**

## Step 4: Test the App

The app now supports:
- ✅ Email/Password registration
- ✅ Email/Password login
- ✅ Password reset
- ✅ User profile display
- ✅ Logout functionality

## Features Implemented

### Authentication Service (`lib/services/auth_service.dart`)
- Sign in with email and password
- Register with email and password
- Sign out
- Password reset email
- Update user profile
- Comprehensive error handling

### Login Screen
- Firebase authentication integration
- Fallback to demo credentials if Firebase is not configured
- Password reset functionality
- Error handling with user-friendly messages

### Register Screen
- Firebase user registration
- Profile name update
- Password validation
- Success/error notifications

### Settings Screen
- Displays current user's email and name
- Firebase logout integration

## Important Notes

- The app will work with demo credentials (`demo@prohome.com` / `demo123`) if Firebase is not configured
- Make sure to enable Email/Password authentication in Firebase Console before using real authentication
- The `firebase_options.dart` file contains placeholder values - these will be replaced when you run `flutterfire configure`

