Pod::Spec.new do |s|
  s.name             = 'BitmovinComScoreAnalytics'
  s.version          = '0.9.0'
  s.summary          = 'ComScore Analytics integration for the Bitmovin Player iOS SDK'
  s.description      = <<-DESC
  Comscore Analytics Integration for the Bitmovin Player iOS SDK
                       DESC

  s.swift_version    = '4.2'
  s.homepage         = 'https://github.com/Cory Zachman/BitmovinComScoreAnalytics'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Cory Zachman' => 'cory.zachman@bitmovin.com' }
  s.source           = { :git => 'https://github.com/bitmovin/bitmovin-player-ios-integrations-comscore', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.tvos.deployment_target = '9.0'
  s.ios.dependency 'BitmovinPlayer', '~> 2.15'
  s.tvos.dependency 'BitmovinPlayer', '~> 2.15'
  s.ios.dependency 'ComScore'
  s.tvos.dependency 'ComScore'
  s.source_files = 'BitmovinComscoreAnalytics/Classes/**/*'  

end
