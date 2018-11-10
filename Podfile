# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Queue' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for hb
pod 'Firebase'
pod 'Firebase/Core'
pod 'Firebase/Auth'
pod 'Firebase/Database'
pod 'Firebase/Storage'
pod 'FirebaseUI/Storage'
pod 'GoogleSignIn'
pod 'GoogleMaps'
pod 'GooglePlaces'


end

post_install do |installer|
    installer.pods_project.build_configuration_list.build_configurations.each do |configuration|
        configuration.build_settings['CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES'] = 'YES'
        inhibit_all_warnings!
    end
end
