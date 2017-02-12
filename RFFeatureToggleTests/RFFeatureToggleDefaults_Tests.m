//
//  RFFeatureToggleDefaults_Tests.m
//  RFFeatureToggle
//
//  Created by Dunja Lalic on 16/01/16.
//  Copyright (c) 2016 Lautsprecher Teufel GmbH. All rights reserved.
//

#import "RFFeatureToggleTest.h"

@interface RFFeatureToggleDefaults_Tests : RFFeatureToggleTest

@end

@implementation RFFeatureToggleDefaults_Tests

- (void)testBaseURLString
{
    [[RFFeatureToggleDefaults sharedDefaults] switchToCustomModeWithBaseURLString:@"https://test/"];
    
    XCTAssertTrue([RFFeatureToggleDefaults sharedDefaults].mode == RFFeatureToggleModeCustom,@"Mode should be custom");
    XCTAssertTrue([[RFFeatureToggleDefaults sharedDefaults].baseURLString isEqualToString:@"https://test/"],@"URL should be custom");
    
    [[RFFeatureToggleDefaults sharedDefaults] switchToMode:RFFeatureToggleModeProduction];
    
    XCTAssertTrue([RFFeatureToggleDefaults sharedDefaults].mode == RFFeatureToggleModeProduction,@"Mode should be production");
    XCTAssertTrue([[RFFeatureToggleDefaults sharedDefaults].baseURLString isEqualToString:@"https://production/"],@"URL should be production");
    
    [[RFFeatureToggleDefaults sharedDefaults] switchToMode:RFFeatureToggleModeStaging];
    
    XCTAssertTrue([RFFeatureToggleDefaults sharedDefaults].mode == RFFeatureToggleModeStaging,@"Mode should be staging");
    XCTAssertTrue([[RFFeatureToggleDefaults sharedDefaults].baseURLString isEqualToString:@"https://staging/"],@"URL should be staging");
    
    XCTAssertThrows([[RFFeatureToggleDefaults sharedDefaults] switchToMode:RFFeatureToggleModeCustom]);
}

@end
