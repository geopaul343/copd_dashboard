# COPD Clinical Dashboard - Mobile App

A beautiful, modern Flutter mobile application for managing COPD patient data and clinical workflows.

## 🚀 Features

### **Authentication**
- ✅ Google Sign-In integration
- ✅ Firebase Authentication
- ✅ Secure backend API calls
- ✅ Automatic session management

### **Dashboard**
- 📊 **Home Tab**: Overview with statistics and quick actions
- 👥 **Patients Tab**: Complete patient list with status indicators
- 📈 **Analytics Tab**: Data visualization and insights (coming soon)
- 👤 **Profile Tab**: User settings and account management

### **Patient Management**
- 📋 Patient list with real-time status
- 🏥 Patient condition tracking (COPD Stages 1-3)
- 📊 Vital signs monitoring (Oxygen levels, Heart rate, Temperature)
- 📅 Last visit tracking
- 🎨 Beautiful status indicators (Stable, Improving, Critical)

### **UI/UX Features**
- 🎨 Modern Material Design 3
- 🌈 Beautiful gradient backgrounds
- ✨ Smooth animations and transitions
- 📱 Responsive design for all screen sizes
- 🎯 Intuitive navigation with bottom tabs
- 🔄 Pull-to-refresh functionality

## 📱 Screenshots

### Authentication Screen
- Beautiful gradient background
- Animated logo and title
- Google Sign-In button
- Error handling with user-friendly messages

### Dashboard
- Welcome section with user info
- Statistics cards (Total Patients, Active Cases, Appointments)
- Quick action buttons
- Recent patients list

### Patient Cards
- Patient avatars with initials
- Status badges with color coding
- Vital signs display
- Last visit information

## 🛠 Technical Stack

### **Frontend**
- **Framework**: Flutter 3.7.2+
- **Language**: Dart
- **UI**: Material Design 3
- **State Management**: StatefulWidget with setState
- **Animations**: AnimationController with TickerProviderStateMixin

### **Backend Integration**
- **HTTP Client**: Dio
- **API Service**: Centralized API service class
- **Authentication**: Firebase Auth + Google Sign-In
- **Error Handling**: Comprehensive error management

### **Dependencies**
```yaml
firebase_core: ^3.8.0
firebase_auth: ^5.3.3
google_sign_in: ^6.2.2
dio: ^5.7.0
```

## 🚀 Getting Started

### **Prerequisites**
- Flutter SDK 3.7.2 or higher
- Android Studio / VS Code
- Firebase project configured
- Google OAuth credentials

### **Installation**

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd copd_clinical_dashbord
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Add `google-services.json` to `android/app/`
   - Add `GoogleService-Info.plist` to `ios/Runner/`
   - Configure Firebase in Firebase Console

4. **Configure Google Sign-In**
   - Enable Google Sign-In in Firebase Console
   - Add SHA-1 fingerprint for Android
   - Configure OAuth consent screen

5. **Run the app**
   ```bash
   flutter run
   ```

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry point
├── auth_screen_mobile.dart            # Mobile authentication screen
├── patient_dashboard_mobile.dart      # Main dashboard
├── config/
│   └── api_config.dart               # API configuration
├── services/
│   └── api_service.dart              # API service layer
└── widgets/
    └── cors_debug_widget.dart        # Web CORS debug widget
```

## 🔧 Configuration

### **API Configuration**
The app uses a centralized API configuration in `lib/config/api_config.dart`:

```dart
class ApiConfig {
  static const String baseUrl = 'https://your-api-url.com';
  
  static String getApiUrl(String endpoint) {
    return '$baseUrl$endpoint';
  }
  
  static Map<String, String> getDefaultHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }
}
```

### **Firebase Configuration**
Ensure your Firebase configuration is properly set up:

1. **Android**: `android/app/google-services.json`
2. **iOS**: `ios/Runner/GoogleService-Info.plist`
3. **Web**: `web/index.html` (Google Sign-In client ID)

## 🎨 Customization

### **Colors and Themes**
The app uses a blue color scheme that can be easily customized:

```dart
// Primary colors
Colors.blue.shade400
Colors.blue.shade600
Colors.blue.shade700

// Background gradients
LinearGradient(
  colors: [Colors.blue.shade50, Colors.white, Colors.blue.shade50],
)
```

### **Adding New Features**
1. **New API endpoints**: Add methods to `ApiService`
2. **New screens**: Create new widgets and add to navigation
3. **New patient data**: Extend the patient data model

## 📊 API Endpoints

The app integrates with these backend endpoints:

- `POST /api/login` - User authentication
- `GET /api/patients` - Get patient list
- `GET /api/patients/{id}` - Get patient details
- `PUT /api/patients/{id}` - Update patient data
- `GET /api/analytics` - Get analytics data

## 🔒 Security Features

- ✅ Firebase Authentication
- ✅ Google Sign-In
- ✅ Secure API calls with headers
- ✅ Error handling for network issues
- ✅ Session management

## 🐛 Troubleshooting

### **Common Issues**

1. **Google Sign-In not working**
   - Check Firebase Console configuration
   - Verify SHA-1 fingerprint for Android
   - Ensure OAuth consent screen is configured

2. **API calls failing**
   - Check network connectivity
   - Verify API endpoint URLs
   - Check backend server status

3. **Build errors**
   - Run `flutter clean`
   - Run `flutter pub get`
   - Check Flutter version compatibility

### **Debug Mode**
Enable debug logging by checking console output for:
- API call details
- Authentication flow
- Error messages

## 📈 Future Enhancements

### **Planned Features**
- [ ] Real-time patient data updates
- [ ] Push notifications
- [ ] Offline data sync
- [ ] Advanced analytics dashboard
- [ ] Patient photo upload
- [ ] Voice notes
- [ ] Multi-language support

### **Technical Improvements**
- [ ] State management with Provider/Riverpod
- [ ] Local database with SQLite
- [ ] Image caching
- [ ] Performance optimizations
- [ ] Unit and widget tests

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the troubleshooting section

---

**Built with ❤️ using Flutter** 