# Search Functionality Troubleshooting Guide (Mobile)

## Problem: Search shows "500 error" or "Search failed"

If you're experiencing a 500 error when searching for patients on your mobile app, this guide will help you resolve it.

## Quick Solutions

### 1. Check Internet Connection
- Ensure your mobile device has a stable internet connection
- Try switching between WiFi and mobile data
- Check if other apps can access the internet

### 2. Verify API Endpoint
The search functionality makes API calls to:
```
https://app-audio-analyzer-887192895309.us-central1.run.app/api/users/search
```

### 3. Check Authentication
- Make sure you're properly signed in with Google
- Try signing out and signing back in
- Verify your Firebase authentication is working

## Common Error Messages and Solutions

### "Server error (500). Please check your internet connection and try again"
- **Solution**: Check your internet connection
- **Alternative**: Try again in a few minutes (server might be temporarily unavailable)

### "Network connection error"
- **Solution**: Check your internet connection
- **Alternative**: Switch between WiFi and mobile data

### "Authentication failed"
- **Solution**: Sign out and sign back in
- **Alternative**: Check if your Google account is working properly

## Technical Details

### Mobile vs Web
- **Mobile apps**: No CORS restrictions, direct API calls
- **Web apps**: CORS restrictions apply, requires proxy services

### API Configuration
The app automatically detects if it's running on mobile and:
- Uses direct API URLs (no proxy needed)
- Includes proper authentication headers
- Handles network errors appropriately

## For Developers

### Testing on Mobile
1. Use `flutter run` for Android/iOS
2. Check device logs for detailed error messages
3. Verify API endpoint is accessible from mobile network

### Common Mobile Issues
1. **Network permissions**: Ensure app has internet permission
2. **Firebase configuration**: Verify Firebase is properly configured for mobile
3. **API endpoint**: Check if backend is accessible from mobile networks

## Debugging Steps

### 1. Check Console Logs
Look for these log messages:
```
🔍 Search API URL: https://app-audio-analyzer-887192895309.us-central1.run.app/api/users/search
✅ Parsed patient response successfully!
❌ API call failed: 500
```

### 2. Test API Endpoint
Try accessing the API endpoint directly in a browser or using curl:
```bash
curl -H "Authorization: Bearer YOUR_TOKEN" \
     "https://app-audio-analyzer-887192895309.us-central1.run.app/api/users/search?name=test&page_size=10"
```

### 3. Check Firebase Authentication
Verify that Firebase authentication is working:
- Check if user is properly signed in
- Verify ID token is being generated
- Test with a different Google account

## Still Having Issues?

1. **Check device logs**: Use `flutter logs` or device debugging tools
2. **Test on different device**: Try on another phone or emulator
3. **Verify backend status**: Check if the backend server is running
4. **Contact support**: If the issue persists, contact the development team

## Files Modified for Mobile Optimization

- `lib/patient_search_screen.dart` - Simplified for mobile (no CORS handling)
- `lib/services/api_service.dart` - Direct API calls for mobile
- `lib/config/api_config.dart` - Mobile-optimized configuration
- `SEARCH_TROUBLESHOOTING.md` - This mobile-focused guide

## Mobile-Specific Features

### Offline Support
The app includes basic offline handling:
- Shows appropriate error messages when offline
- Graceful degradation when network is unavailable

### Network Retry
- Automatic retry for failed network requests
- User-friendly error messages
- Quick retry options

### Performance Optimization
- Optimized for mobile network conditions
- Efficient API calls
- Minimal data usage 