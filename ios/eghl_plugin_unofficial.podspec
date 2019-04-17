#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'eghl_plugin_unofficial'
  s.version          = '0.0.1'
  s.summary          = 'eGHL payment plugin. Unofficial version. Please use the official version.'
  s.description      = <<-DESC
eGHL payment plugin. Unofficial version. Please use the official version.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.ios.deployment_target = '8.0'

  s.resource = 'eghl-sdk/guidehandicon.png'
  s.ios .vendored_libraries = 'eghl-sdk/libEGHLPayment.a'
end

