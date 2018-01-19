# Uncomment this line to define a global platform for your project
platform :ios, '9.0'


def shared_pods
    #RX
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'RxBlocking'
    #pod 'RxTests'
    
    #network
    pod 'Alamofire'
    pod 'AlamofireImage' 
    pod 'AlamofireNetworkActivityIndicator'
    pod 'RxAlamofire'
    #    pod 'Timberjack'                        , :git => 'https://github.com/dodgecm/Timberjack.git', :branch => 'swift-3'
    pod 'ObjectMapper'
    pod 'lf'
    
    #UI
    pod 'iOSSharedViewTransition'
    pod 'UIScrollView-InfiniteScroll'
    pod 'ParallaxBlur'
    pod 'IQKeyboardManagerSwift'
    pod 'MMDrawerController'
    pod 'UIColor_Hex_Swift'
    pod 'SMCalloutView'
    pod 'GoogleMaps'
    pod "FSCalendar"
    pod 'BABFrameObservingInputAccessoryView'

    #others
    pod 'PocketSVG'
    pod 'Validator'
    pod "SimplifiedNotificationCenter"
    pod 'EZSwiftExtensions'
end

target 'IOSExperiments' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for IOSExperiments
  shared_pods

  target 'IOSExperimentsTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'IOSExperimentsUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end


#post_install do |installer|
#  installer.pods_project.targets.each do |target|
#    target.build_configurations.each do |config|
#      config.build_settings['SWIFT_VERSION'] = '3.0'
#    end
#  end
#end
