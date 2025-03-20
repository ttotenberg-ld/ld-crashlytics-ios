# Define the iOS platform version
platform :ios, '13.0'

# Disable code signing for all pods
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
      config.build_settings['CODE_SIGNING_REQUIRED'] = 'NO'
      config.build_settings['CODE_SIGN_IDENTITY'] = ''
      
      # Fix deployment target warnings
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end

target 'CrashlyticsLaunchDarklyDemo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Firebase components
  pod 'FirebaseCore'
  pod 'FirebaseCrashlytics'
  pod 'FirebaseAnalytics'
  
  # LaunchDarkly SDK
  pod 'LaunchDarkly', '~> 9.12.3'

  target 'CrashlyticsLaunchDarklyDemoTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'CrashlyticsLaunchDarklyDemoUITests' do
    # Pods for testing
  end

end
