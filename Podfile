project 'RFFeatureToggle.xcodeproj'
platform :ios, '8.0'
use_frameworks!

def shared_pods
    pod "RFFeatureToggle", :path => "."
end

target "RFFeatureToggle" do
    shared_pods
end

target "Example" do
    shared_pods
end

target "RFFeatureToggleTests" do
    shared_pods
    
  pod "FBSnapshotTestCase/Core"
  pod "OHHTTPStubs"
  pod "OCMock"
end
