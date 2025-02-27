# Uncomment the next line to define a global platform for your project
# platform :ios, '13.0'

target 'socialApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for socialApp
    pod 'Alamofire', '~> 5.4'
    pod 'JGProgressHUD'
    pod 'SDWebImage'
    pod 'RxSwift', '6.2.0'
    pod 'RxCocoa', '6.2.0'
  end

  target 'socialAppTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'socialAppUITests' do
    # Pods for testing
  end

  post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
            end
        end
    end
  end
