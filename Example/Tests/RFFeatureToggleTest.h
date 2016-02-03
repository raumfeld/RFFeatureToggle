//
//  RFFeatureToggleTest.h
//  RFFeatureToggle
//
//  Created by Dunja Lalic on 16/01/16.
//  Copyright (c) 2016 Lautsprecher Teufel GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <OCMock/OCMock.h>
#import <RFFeatureToggle/RFFeatureToggle.h>

@interface RFFeatureToggleTest : XCTestCase

+ (NSString *)fixturePath;
+ (id <OHHTTPStubsDescriptor>)stubForSuccess;
+ (id <OHHTTPStubsDescriptor>)stubForFail;
+ (void)waitForVerifiedMock:(OCMockObject *)inMock delay:(NSTimeInterval)inDelay;

@end
