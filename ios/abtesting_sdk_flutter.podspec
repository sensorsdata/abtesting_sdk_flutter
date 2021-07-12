#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint abtesting_sdk_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'abtesting_sdk_flutter'
  s.version          = '0.0.1'
  s.summary          = 'A/B Testing Flutter Plugin'
  s.description      = <<-DESC
A/B Testing Flutter Plugin
                       DESC
  s.homepage         = 'http://github.com/sensorsdata/abtesting_sdk_flutter'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'SensorsData' => 'zhangwei@sensorsdata.cn' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'
  s.dependency  'SensorsABTesting'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
