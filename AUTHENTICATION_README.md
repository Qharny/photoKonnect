# PhotoConnect Authentication with Shared Preferences

This document explains how the authentication system works with shared preferences to ensure users only need to login or signup once unless they log out.

## Overview

The authentication system uses a combination of:
- **Shared Preferences**: For persistent local storage of authentication state
- **Supabase**: For backend authentication and user management
- **AuthService**: Centralized authentication management

## Key Features

### 1. Persistent Login State
- Users remain logged in across app restarts
- Authentication state is stored locally using Shared Preferences
- No need to re-authenticate unless explicitly logged out

### 2. User Type Management
- Supports two user types: `client` and `photographer`
- Different navigation flows based on user type
- User type is persisted and used for routing

### 3. Onboarding Flow
- First-time users see onboarding screens
- After completing onboarding, users are marked as "not new"
- Onboarding is only shown once per device

### 4. Secure Logout
- Complete logout functionality that clears all local data
- Redirects to authentication landing page
- Maintains Supabase session management

## Implementation Details

### AuthService (`lib/services/auth_service.dart`)

The central authentication service that manages:

```dart
// Check authentication state
static Future<bool> isLoggedIn()
static Future<bool> isNewUser()
static Future<String?> getUserType()

// Authentication operations
static Future<bool> signIn({email, password, userType})
static Future<bool> signUp({email, password, name, userType})
static Future<void> signOut()

// User data management
static Future<String?> getUserEmail()
static Future<String?> getUserName()
static Future<String?> getUserId()
```

### Shared Preferences Keys

The following keys are used to store authentication data:

- `is_logged_in`: Boolean indicating if user is logged in
- `is_new_user`: Boolean indicating if user is new (for onboarding)
- `user_type`: String indicating user type ('client' or 'photographer')
- `user_email`: String storing user's email
- `user_name`: String storing user's name
- `user_id`: String storing user's unique ID

### Navigation Flow

1. **Splash Screen**: Checks authentication state and routes accordingly
2. **Onboarding**: For new users, shows onboarding then marks as not new
3. **Authentication**: For logged out users, shows login/signup options
4. **Home Screens**: For logged in users, routes to appropriate home based on user type

### Logout Functionality

Logout is available in:
- **Profile Page**: Logout button in app bar
- **Settings Page**: Logout option in settings list

Both locations show a confirmation dialog before logging out.

## Usage Examples

### Checking Authentication State

```dart
// Check if user is logged in
bool isLoggedIn = await AuthService.isLoggedIn();

// Check if user is new (for onboarding)
bool isNewUser = await AuthService.isNewUser();

// Get user type for routing
String? userType = await AuthService.getUserType();
```

### User Login

```dart
// Client login
bool success = await AuthService.signIn(
  email: 'client@example.com',
  password: 'password123',
  userType: 'client',
);

// Photographer login
bool success = await AuthService.signIn(
  email: 'photographer@example.com',
  password: 'password123',
  userType: 'photographer',
);
```

### User Signup

```dart
// Client signup
bool success = await AuthService.signUp(
  email: 'newclient@example.com',
  password: 'password123',
  name: 'John Doe',
  userType: 'client',
);

// Photographer signup
bool success = await AuthService.signUp(
  email: 'newphotographer@example.com',
  password: 'password123',
  name: 'Jane Smith',
  userType: 'photographer',
);
```

### Logout

```dart
// Logout user
await AuthService.signOut();
// This clears all local data and Supabase session
```

### Debug Utilities

The `AuthUtils` class provides debugging and utility functions:

```dart
// Print current auth state to console
await AuthUtils.printAuthState();

// Clear all auth data (for testing)
await AuthUtils.clearAllAuthData();

// Get appropriate home route
String homeRoute = await AuthUtils.getHomeRoute();
```

## Security Considerations

1. **Local Storage**: Shared preferences are stored locally and not encrypted by default
2. **Session Management**: Supabase handles secure session management
3. **Data Clearing**: Logout properly clears all local authentication data
4. **User Type Validation**: User type is validated during authentication

## Testing

To test the authentication flow:

1. **Fresh Install**: Should show onboarding
2. **After Onboarding**: Should show authentication landing
3. **After Login**: Should navigate to appropriate home screen
4. **App Restart**: Should skip login and go directly to home
5. **Logout**: Should clear data and return to authentication landing

## Troubleshooting

### Common Issues

1. **User stuck in onboarding**: Check `is_new_user` value in shared preferences
2. **User not staying logged in**: Verify `is_logged_in` is being set to true
3. **Wrong home screen**: Check `user_type` value
4. **Logout not working**: Ensure `AuthService.signOut()` is called

### Debug Commands

```dart
// Print current state
await AuthUtils.printAuthState();

// Clear all data to reset
await AuthUtils.clearAllAuthData();
```

## Future Enhancements

1. **Biometric Authentication**: Add fingerprint/face ID support
2. **Remember Me**: Option to stay logged in longer
3. **Auto-logout**: Automatic logout after inactivity
4. **Multi-device Sync**: Sync authentication state across devices
5. **Offline Support**: Handle authentication when offline 