# Dio Pretty Logger Guide

## 🎯 **What is Dio Pretty Logger?**

Dio Pretty Logger is a logging interceptor for the Dio HTTP client that makes API debugging much easier by automatically logging all HTTP requests and responses in a beautiful, formatted way.

## ✨ **Benefits**

### **Before (Without Logger)**
```
I/flutter: 🔍 Search API URL: https://app-audio-analyzer-887192895309.us-central1.run.app/api/users/search?name=Jintappan&page_size=10
I/flutter: ❌ API call failed: 500
I/flutter: Response body: {"details":"\"no row field 'dateofbirth'\"","error":"Internal server error"}
```

### **After (With Pretty Logger)**
```
┌───────────────────────────────────────────────────────────────────────────────────────
│ 🌐 REQUEST
├───────────────────────────────────────────────────────────────────────────────────────
│ Method: GET
│ URL: https://app-audio-analyzer-887192895309.us-central1.run.app/api/users/search
│ Query Parameters: {name: Jintappan, page_size: 10}
│ Headers: {Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9..., Content-Type: application/json, Accept: application/json}
├───────────────────────────────────────────────────────────────────────────────────────
│ ⏱️ RESPONSE
├───────────────────────────────────────────────────────────────────────────────────────
│ Status Code: 500
│ Headers: {content-type: application/json}
│ Body: {
│   "details": "\"no row field 'dateofbirth'\"",
│   "error": "Internal server error"
│ }
├───────────────────────────────────────────────────────────────────────────────────────
│ ⏱️ Duration: 1.2s
└───────────────────────────────────────────────────────────────────────────────────────
```

## 🔧 **Configuration Options**

### **Basic Setup**
```dart
_dio.interceptors.add(PrettyDioLogger(
  requestHeader: true,    // Show request headers
  requestBody: true,      // Show request body
  responseBody: true,     // Show response body
  responseHeader: false,  // Hide response headers
  error: true,           // Show errors
  compact: true,         // Compact format
  maxWidth: 90,          // Max width of log
));
```

### **Advanced Options**
```dart
_dio.interceptors.add(PrettyDioLogger(
  requestHeader: true,
  requestBody: true,
  responseBody: true,
  responseHeader: false,
  error: true,
  compact: false,        // Full format
  maxWidth: 120,         // Wider logs
  logPrint: (obj) => print(obj), // Custom print function
));
```

## 🚀 **What You'll See**

### **Request Information**
- ✅ HTTP Method (GET, POST, PUT, DELETE)
- ✅ Full URL with query parameters
- ✅ Request headers (including Authorization)
- ✅ Request body (for POST/PUT requests)

### **Response Information**
- ✅ Status code (200, 401, 500, etc.)
- ✅ Response headers
- ✅ Response body (formatted JSON)
- ✅ Request duration

### **Error Information**
- ✅ Detailed error messages
- ✅ Stack traces
- ✅ Network error details

## 📱 **Perfect for Mobile Development**

### **Why It's Great for Your App**
1. **Easy Debugging** - See exactly what's being sent/received
2. **API Testing** - Verify request format and response
3. **Error Tracking** - Understand what went wrong
4. **Performance Monitoring** - See request durations
5. **Development Speed** - Faster debugging = faster development

### **Example Output for Your Search API**
```
┌───────────────────────────────────────────────────────────────────────────────────────
│ 🌐 REQUEST
├───────────────────────────────────────────────────────────────────────────────────────
│ Method: GET
│ URL: https://app-audio-analyzer-887192895309.us-central1.run.app/api/users/search
│ Query Parameters: {name: John, page_size: 10}
│ Headers: {
│   Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...
│   Content-Type: application/json
│   Accept: application/json
│ }
├───────────────────────────────────────────────────────────────────────────────────────
│ ⏱️ RESPONSE
├───────────────────────────────────────────────────────────────────────────────────────
│ Status Code: 200
│ Body: {
│   "message": "Users found successfully",
│   "users": [
│     {
│       "id": "user123",
│       "name": "John Doe",
│       "email": "john@example.com",
│       "userId": "P001234",
│       "gender": "Male",
│       "dateOfBirth": "1980-01-01T00:00:00.000Z",
│       "copdDiagnosed": true,
│       "copdStage": "Moderate"
│     }
│   ],
│   "next_page_token": null
│ }
├───────────────────────────────────────────────────────────────────────────────────────
│ ⏱️ Duration: 0.8s
└───────────────────────────────────────────────────────────────────────────────────────
```

## 🎯 **Current Issue Analysis**

With the pretty logger, you'll be able to see exactly what's happening with your current 500 error:

```
❌ Current Error: "no row field 'dateofbirth'"
```

This means the backend is looking for a field called `dateofbirth` but it doesn't exist in the database table. The pretty logger will show you:

1. **Exact request being sent**
2. **Full error response**
3. **Request timing**
4. **Headers and parameters**

## 📋 **Next Steps**

1. **Run your app** with the pretty logger
2. **Try searching** for a patient
3. **Check the logs** - you'll see beautiful formatted output
4. **Share the logs** with your backend team for debugging

The pretty logger will make it much easier to understand what's happening with your API calls! 🎉 