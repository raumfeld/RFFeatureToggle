project 'RFFeatureToggle.xcodeproj'
platform :ios, '12.0'
use_frameworks!
inhibit_all_warnings!

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
    
    pod "OHHTTPStubs"
    pod "OCMock"
end
