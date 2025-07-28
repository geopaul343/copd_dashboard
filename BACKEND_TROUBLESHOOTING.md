# Backend Troubleshooting Guide - 500 Error

## Problem: Backend API returning 500 Internal Server Error

The 500 error indicates that the backend server is experiencing an internal error. This is a server-side issue, not a client-side problem.

## Backend API Endpoint
```
https://app-audio-analyzer-887192895309.us-central1.run.app/api/users/search
```

## Common Backend Issues Causing 500 Errors

### 1. **Server Down or Unavailable**
- **Symptoms**: Connection timeout, server not responding
- **Check**: Try accessing the API endpoint directly
- **Solution**: Contact backend team to restart the server

### 2. **Database Connection Issues**
- **Symptoms**: 500 error with database-related error messages
- **Check**: Backend logs for database connection errors
- **Solution**: Check database connectivity and credentials

### 3. **Authentication/Authorization Problems**
- **Symptoms**: 500 error when token is invalid or expired
- **Check**: Verify Firebase token is valid and properly formatted
- **Solution**: Ensure proper token validation on backend

### 4. **API Endpoint Not Implemented**
- **Symptoms**: 500 error instead of 404
- **Check**: Verify `/api/users/search` endpoint exists
- **Solution**: Backend team needs to implement the endpoint

### 5. **Invalid Request Parameters**
- **Symptoms**: 500 error when sending search parameters
- **Check**: Verify request format matches backend expectations
- **Solution**: Check backend logs for parameter validation errors

## How to Test Backend API

### 1. **Test API Endpoint Directly**
```bash
# Test if server is reachable
curl -I https://app-audio-analyzer-887192895309.us-central1.run.app/api/users/search

# Test with authentication (replace YOUR_TOKEN)
curl -H "Authorization: Bearer YOUR_TOKEN" \
     "https://app-audio-analyzer-887192895309.us-central1.run.app/api/users/search?name=test&page_size=10"
```

### 2. **Check Server Status**
- Visit: https://app-audio-analyzer-887192895309.us-central1.run.app/
- Should return a response (even if it's an error page)

### 3. **Test with Different Parameters**
```bash
# Test with minimal parameters
curl -H "Authorization: Bearer YOUR_TOKEN" \
     "https://app-audio-analyzer-887192895309.us-central1.run.app/api/users/search"

# Test with different search terms
curl -H "Authorization: Bearer YOUR_TOKEN" \
     "https://app-audio-analyzer-887192895309.us-central1.run.app/api/users/search?name=john&page_size=5"
```

## Backend Logs Analysis

### What to Look For in Backend Logs:
1. **Error Stack Traces**: Full error details
2. **Database Errors**: Connection or query issues
3. **Authentication Errors**: Token validation problems
4. **Request Validation**: Parameter format issues
5. **Memory/Resource Issues**: Server overload

### Common Error Patterns:
```
ERROR: Database connection failed
ERROR: Invalid token format
ERROR: Missing required parameter 'name'
ERROR: Internal server error
ERROR: Out of memory
```

## Backend Configuration Issues

### 1. **Firebase Authentication**
- Verify Firebase project configuration
- Check if service account keys are valid
- Ensure Firebase Admin SDK is properly initialized

### 2. **Database Configuration**
- Check database connection strings
- Verify database credentials
- Ensure database is accessible from server

### 3. **API Route Configuration**
- Verify `/api/users/search` route is defined
- Check middleware configuration
- Ensure proper error handling

## Quick Diagnostic Steps

### Step 1: Check Server Status
```bash
curl -I https://app-audio-analyzer-887192895309.us-central1.run.app/
```

### Step 2: Test Authentication
```bash
# Get a valid token from your app
# Then test with that token
curl -H "Authorization: Bearer YOUR_ACTUAL_TOKEN" \
     "https://app-audio-analyzer-887192895309.us-central1.run.app/api/users/search"
```

### Step 3: Check Response Headers
```bash
curl -v -H "Authorization: Bearer YOUR_TOKEN" \
     "https://app-audio-analyzer-887192895309.us-central1.run.app/api/users/search"
```

### Step 4: Test Different Endpoints
```bash
# Test login endpoint
curl -X POST https://app-audio-analyzer-887192895309.us-central1.run.app/api/login \
     -H "Content-Type: application/json" \
     -d '{"user_id":"test","email":"test@test.com"}'

# Test other endpoints
curl https://app-audio-analyzer-887192895309.us-central1.run.app/api/patients
```

## Backend Team Checklist

### Immediate Actions:
1. **Check Server Logs**: Look for error details
2. **Verify Database**: Test database connectivity
3. **Check Authentication**: Verify Firebase configuration
4. **Test Endpoints**: Manually test API endpoints
5. **Monitor Resources**: Check server CPU/memory usage

### Code Review:
1. **Error Handling**: Ensure proper try-catch blocks
2. **Input Validation**: Validate all request parameters
3. **Authentication**: Verify token validation logic
4. **Database Queries**: Check for SQL injection vulnerabilities
5. **Response Format**: Ensure consistent JSON responses

## Expected Backend Response Format

### Success Response (200):
```json
{
  "message": "Users found successfully",
  "users": [
    {
      "id": "user123",
      "name": "John Doe",
      "email": "john@example.com",
      "userId": "P001234",
      "gender": "Male",
      "dateOfBirth": "1980-01-01T00:00:00.000Z",
      "copdDiagnosed": true,
      "copdStage": "Moderate",
      "smokingStatus": "Former",
      "homeOxygenEnabled": false,
      "pulseOximeter": true,
      "laennecAiStethoscope": false,
      "flareUpsNonHospital": true,
      "createdAt": "2024-01-01T00:00:00.000Z",
      "updatedAt": "2024-01-01T00:00:00.000Z"
    }
  ],
  "next_page_token": null
}
```

### Error Response (500):
```json
{
  "error": "Internal server error",
  "message": "Database connection failed",
  "status": 500
}
```

## Contact Information

### Backend Team Contact:
- **Email**: [backend-team-email]
- **Slack**: [backend-team-slack]
- **GitHub**: [backend-repository]

### Emergency Contacts:
- **On-call Engineer**: [emergency-contact]
- **System Administrator**: [sysadmin-contact]

## Next Steps

1. **Immediate**: Contact backend team with error details
2. **Short-term**: Implement proper error handling
3. **Long-term**: Add monitoring and alerting
4. **Prevention**: Regular health checks and testing 