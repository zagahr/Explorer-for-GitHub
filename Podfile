ENV['COCOAPODS_DISABLE_STATS'] = "true"
inhibit_all_warnings!
use_frameworks!

target 'Explorer' do
    platform :ios, '11.4'
    
    pod 'Apollo'
    pod 'TinyConstraints'
    pod 'XLPagerTabStrip', '~> 8.1'
    pod 'Firebase/Core'
    pod 'Firebase/Functions'
    pod 'CodableFirebase'
    pod 'Firebase/RemoteConfig'
    pod 'Firebase/Performance'
    pod 'Fabric', '~> 1.8.2'
    pod 'Crashlytics', '~> 3.11.1'
    pod 'AcknowList', '~> 1.7'

    target 'ExplorerTests' do
        inherit! :search_paths
    end

    target 'ExplorerUITests' do
        inherit! :search_paths
        # Pods for testing
    end
end
