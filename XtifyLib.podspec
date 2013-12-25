Pod::Spec.new do |s|
  s.name         = 'XtifyLib'
  s.version      = '1.0'
  s.summary      = 'Xtify library for iOS application with CocoaPods integration.'
  s.platform = :ios
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
  s.frameworks = 'Foundation', 'UIKit', 'CoreGraphics', 'SystemConfiguration', 'MapKit', 'CoreData', 'MessageUI', 'CoreLocation', 'CFNetwork', 'MobileCoreServices', 'CoreTelephony', 'libxml2.2', 'libz.1.1.3'
end
