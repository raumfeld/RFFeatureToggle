//
//  RFFeatureAPIClient_Tests.m
//  RFFeatureToggle
//
//  Created by Dunja Lalic on 15/01/16.
//  Copyright (c) 2016 Lautsprecher Teufel GmbH. All rights reserved.
//

#import "RFFeatureToggleTest.h"
#import <RFFeatureToggle/RFFeatureAPIClient.h>

@interface RFFeatureAPIClient_Tests : RFFeatureToggleTest

@end

@implementation RFFeatureAPIClient_Tests

- (void)setUp
{
    NSDictionary *params = @{kRFFeatureToggleBaseURLStringForStagingKey : @"https://staging/",
                             kRFFeatureToggleBaseURLStringForProductionKey : @"https://production/"};
    [RFFeatureToggleDefaults sharedDefaultsWithMode:RFFeatureToggleModeStaging params:params];
}

- (NSDictionary *)testHeaders
{
    return @{@"key1" : @"value1",
             @"key2" : @"value2"};
}

- (void)testBaseURL
{
    XCTAssertTrue([[RFFeatureToggleDefaults sharedDefaults].baseURLString isEqualToString:@"https://staging/"],@"Base URL should be 'https://staging/'");
}

- (void)testPinningCertificate
{
    [RFFeatureAPIClient pinCertificateWithName:@"google.com"];
    
    AFSecurityPolicy *policy = [RFFeatureAPIClient sharedClient].securityPolicy;
    XCTAssertTrue(policy.SSLPinningMode == AFSSLPinningModeCertificate,@"Pinning mode must be certificate");
    XCTAssertTrue(policy.allowInvalidCertificates,@"Invalid certificates should be allowed");
    XCTAssertFalse(policy.validatesDomainName,@"Validates domain name must be set to false");
    XCTAssertFalse(policy.validatesCertificateChain,@"Validates certificate chain must be set to false");
}

- (void)testRemovingPinnedCertificate
{
    [RFFeatureAPIClient pinCertificateWithName:nil];
    
    AFSecurityPolicy *policy = [RFFeatureAPIClient sharedClient].securityPolicy;
    XCTAssertTrue(policy.SSLPinningMode == AFSSLPinningModeNone,@"Pinning mode must be none");
}

- (void)testHeadersAreAttached
{
    [RFFeatureAPIClient attachHeaderValues:[self testHeaders]];
    
    XCTAssertEqual([RFFeatureAPIClient sharedClient].requestSerializer.HTTPRequestHeaders[@"key1"],@"value1",@"Headers should contain 'value1' for 'key1'");
    XCTAssertEqual([RFFeatureAPIClient sharedClient].requestSerializer.HTTPRequestHeaders[@"key2"],@"value2",@"Headers should contain 'value2' for 'key2'");
}

@end
