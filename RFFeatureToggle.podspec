Pod::Spec.new do |s|
  s.name             = "RFFeatureToggle"
  s.version          = "1.0.4"
  s.license          = "MIT"
  s.summary          = "A simple A/B testing framework for remotely switching features on and off and having the changes reflect in the app immediately."
  s.homepage         = "https://github.com/raumfeld/RFFeatureToggle"
  s.author           = { "Dunja Lalic" => "Dunja Lalic <dunja.lalic@teufel.de>" }
  s.source           = { :git => "https://github.com/raumfeld/RFFeatureToggle.git", :tag => s.version.to_s }
  s.platform         = :ios, '9.3'
  s.requires_arc     = true
  s.screenshot       = "https://raw.githubusercontent.com/raumfeld/RFFeatureToggle/master/Docs/RFFeatureTableViewController.gif"

  s.source_files = 'RFFeatureToggle/Classes/**/*'

  s.dependency 'AFNetworking'
end
