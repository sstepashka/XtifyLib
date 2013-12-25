Pod::Spec.new do |s|
  s.name         = 'XtifyLib'
  s.version      = '1.0'
  s.summary      = 'Xtify library for iOS application with CocoaPods integration.'
  s.platform = :ios, '6.0'
  s.author = {
    'Dmitriy Kuragin' => 'dkuragin@ya.ru'
  }
  s.homepage = 'https://github.com/sstepashka/XtifyLib'
  s.source = {
    :git => 'https://github.com/sstepashka/XtifyLib.git',
    :tag => 'v1.0'
  }
  s.source_files = 'XtifyLib/*.{h,m}'
  s.ios.vendored_frameworks = 'XtifyLib/XtifyPush.embeddedframework/XtifyPush.framework'
  s.resources = 'XtifyLib/XtifyPush.embeddedframework/Resources/*'
  s.frameworks = 'Foundation', 'UIKit', 'CoreGraphics', 'SystemConfiguration', 'MapKit', 'CoreData', 'MessageUI', 'CoreLocation', 'CFNetwork', 'MobileCoreServices', 'CoreTelephony'
  s.library = 'xml', 'z'
  s.compiler_flags = '-all_load', '-ObjC'

  s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libz', '$(SDKROOT)/usr/include/libxml'}
end
