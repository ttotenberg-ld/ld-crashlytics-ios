# Crashlytics LaunchDarkly iOS Demo

This project demonstrates the integration of Firebase Crashlytics and LaunchDarkly in an iOS application, providing a unified approach to crash reporting, feature flagging, and analytics tracking.

## Features

- Unified crash reporting and analytics tracking
- Integrated LaunchDarkly feature flag management
- Comprehensive error tracking and logging
- User action tracking across both platforms
- Breadcrumb tracking for crash context
- Custom value and metadata support

## Requirements

- iOS 13.0+
- Xcode 14.0+
- CocoaPods

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/ld-crashlytics-ios.git
cd ld-crashlytics-ios
```

2. Install dependencies using CocoaPods:
```bash
pod install
```

3. Open the workspace:
```bash
open CrashlyticsLaunchDarklyDemo.xcworkspace
```

4. Configure your Firebase and LaunchDarkly credentials:
   - Add your `GoogleService-Info.plist` file to the project
   - Set your LaunchDarkly mobile key in the appropriate configuration file

## Usage

The project provides a unified interface for tracking events in both Crashlytics and LaunchDarkly. Here are some examples:

```swift
// Log a message
Crashlytics.log(message: "User completed onboarding", metadata: ["step": "final"])

// Track a user action
Crashlytics.trackUserAction("button_tap", parameters: ["screen": "home"])

// Record an error
Crashlytics.recordError(error, metadata: ["context": "payment_flow"])

// Leave a breadcrumb
Crashlytics.leaveBreadcrumb("Cart updated", metadata: ["items": "3"])

// Set a custom value
Crashlytics.setCustomValue("premium", forKey: "user_tier")
```

Each of these methods will automatically track the event in both Crashlytics and LaunchDarkly, providing unified analytics and crash reporting.

## Customizing LaunchDarkly Tracking

Each tracking method accepts an optional `onTrack` callback that allows you to customize the LaunchDarkly tracking behavior:

```swift
Crashlytics.log(message: "Custom event") {
    LDClient.get()?.track(key: "custom_event", data: [
        "timestamp": Date().timeIntervalSince1970,
        "custom_field": "value"
    ])
}
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Firebase Crashlytics
- LaunchDarkly
- CocoaPods 