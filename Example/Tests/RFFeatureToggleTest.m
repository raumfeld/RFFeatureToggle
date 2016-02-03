//
//  RFFeatureToggleTest.m
//  RFFeatureToggle
//
//  Created by Dunja Lalic on 16/01/16.
//  Copyright (c) 2016 Lautsprecher Teufel GmbH. All rights reserved.
//

#import "RFFeatureToggleTest.h"
#import <OHHTTPStubs/OHHTTPStubsResponse+JSON.h>
#import <OHHTTPStubs/OHPathHelpers.h>

@implementation RFFeatureToggleTest

- (void)setUp
{
    [super setUp];

    NSDictionary *params = @{kRFFeatureToggleBaseURLStringForStagingKey : @"https://staging/",
                             kRFFeatureToggleBaseURLStringForProductionKey : @"https://production/"};
    [RFFeatureToggleDefaults sharedDefaultsWithMode:RFFeatureToggleModeProduction params:params];
}

- (void)tearDown
{
    [super tearDown];
    [OHHTTPStubs removeAllStubs];
}

+ (NSString *)fixturePath
{
    return OHPathForFile(@"response.json", self.class);
}

+ (id <OHHTTPStubsDescriptor>)stubForSuccess
{
    return [OHHTTPStubs stubRequestsPassingTest:^BOOL (NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFileAtPath:[self fixturePath]
                                                statusCode:200
                                                   headers:@{@"Content-Type":@"application/json"}];
    }];
}

+ (id <OHHTTPStubsDescriptor>)stubForFail
{
    return [OHHTTPStubs stubRequestsPassingTest:^BOOL (NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFileAtPath:@""
                                                statusCode:500
                                                   headers:@{@"Content-Type":@"application/json"}];
    }];
}

+ (void)waitForVerifiedMock:(OCMockObject *)inMock delay:(NSTimeInterval)inDelay
{
    NSTimeInterval i = 0;
    while (i < inDelay)
    {
        @try
        {
            [inMock verify];
            return;
        }
        @catch (NSException *e)
        {
        }
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
        i += 0.5;
    }
    [inMock verify];
}

@end
