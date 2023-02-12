# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'MandiriTMDB' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  def utilities
    pod 'RxSwift', '~> 5.1.3'
    pod 'RxCocoa', '~> 5.1.3'
    pod 'RxBlocking', '~> 5.1.3'
    pod 'Kingfisher', '~> 6.3.1'
  end
  
  def unit_test_dependencies
    pod 'Cuckoo', '1.7.1'
    pod 'RxSwift', '~> 5.1.3'
    pod 'RxCocoa', '~> 5.1.3'
    pod 'RxBlocking', '~> 5.1.3'
  end
  # Pods for MandiriTMDB
  utilities

  target 'MandiriTMDBTests' do
    inherit! :search_paths
    # Pods for testing
    unit_test_dependencies
  end

  target 'MandiriTMDBUITests' do
    # Pods for testing
  end

end
