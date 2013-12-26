XtifyLib
========

Xtify library for iOS application with CocoaPods integration.

Example of usage
========

Using cocoapods.

#### Podfile, example:
platform :ios, '6.0'

pod 'XtifyLib'

post_install do |installer|
    config = <<-XTIFYGLOBAL_H
#define xAppKey @"<your app key>"
#define xLocationRequired NO
#define xRunAlsoInBackground FALSE
#define xDesiredLocationAccuracy kCLLocationAccuracyKilometer  // kCLLocationAccuracyBest
#define xBadgeManagerMethod XLInboxManagedMethod
#define xLogging TRUE
#define xMultipleMarkets FALSE
XTIFYGLOBAL_H
    File.open("Pods/XtifyLib/XtifyLib/XtifyGlobal.h", "w") do |file|
      file.puts config
    end
end
##
