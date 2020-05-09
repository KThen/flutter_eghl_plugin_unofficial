#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint eghlpluginunofficial.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'eghl_plugin_unofficial'
  s.version          = '1.0.0'
  s.summary          = 'eGHL payment plugin. Unofficial version. Please use the official version.'
  s.description      = <<-DESC
eGHL payment plugin. Unofficial version. Please use the official version.
                       DESC
  s.homepage         = 'https://github.com/KThen/flutter_eghl_plugin_unofficial'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'KThen' => 'dinosts.official@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }

  s.preserve_paths = ['EGHL.framework', 'EGHL.bundle']
  s.xcconfig = { 'OTHER_LDFLAGS' => '-framework EGHL' }
  s.vendored_frameworks = 'EGHL.framework'
  s.resources = 'EGHL.bundle'
end
