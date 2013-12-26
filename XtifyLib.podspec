Pod::Spec.new do |s|
  s.name         = 'XtifyLib'
  s.version      = '2.51'
  s.summary      = 'Xtify library for iOS application with CocoaPods integration.'
  s.platform = :ios, '6.0'
  s.author = {
    'Dmitriy Kuragin' => 'dkuragin@ya.ru'
  }
  s.license =  'Apache License, Version 2.0'
  s.homepage = 'https://github.com/sstepashka/XtifyLib'
  s.source = {
    :git => 'https://github.com/sstepashka/XtifyLib.git',
    :tag => 'v2.51'
  }

  s.ios.dependency 'Reachability'
  s.ios.dependency 'SBJson'
  s.ios.dependency 'ASIHTTPRequest'

  s.source_files = 'XtifyLib/*.{h,m}'
  s.ios.vendored_frameworks = 'XtifyLib/XtifyPushNoDependencies.framework'
  s.frameworks = 'Foundation', 'UIKit', 'CoreGraphics', 'SystemConfiguration', 'MapKit', 'CoreData', 'MessageUI', 'CoreLocation', 'CFNetwork', 'MobileCoreServices', 'CoreTelephony'
  s.library = 'xml2.2', 'z'

  s.source_files 'XtifyGlobal.h'

  s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libz' '$(SDKROOT)/usr/include/libxml'}
end
