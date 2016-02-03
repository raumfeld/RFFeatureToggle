//
//  RFFetureToggle_Tests.m
//  RFFeatureToggle
//
//  Created by Dunja Lalic on 21/01/16.
//  Copyright (c) 2016 Lautsprecher Teufel GmbH. All rights reserved.
//

#import "RFFeatureToggleTest.h"
#import "RFFeatureCache.h"
#import "RFFeature+API.h"

@interface RFFetureToggle_Tests : RFFeatureToggleTest

@end

@implementation RFFetureToggle_Tests

- (void)testIsEnabled
{
    id mock = OCMClassMock([RFFeature class]);
    
    [[mock expect] isEnabled:@"feature"];
    
    [RFFeatureToggle isEnabled:@"feature"];
    
    [mock verify];
    [mock stopMocking];
}

- (void)testRefresh
{
    id mock = OCMClassMock([RFFeature class]);
    
    [[mock expect] fetchFeaturesUsingBlock:[OCMArg invokeBlock]];
    
    [RFFeatureToggle refreshFeatures];
    
    [mock verify];
    [mock stopMocking];
}

- (void)testAllFeatures
{
    id mock = OCMClassMock([RFFeatureCache class]);
    
    [[mock expect] allFeatures];
    
    [RFFeatureToggle allFeatures];
    
    [mock verify];
    [mock stopMocking];
}

@end
