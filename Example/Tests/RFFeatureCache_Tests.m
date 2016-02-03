//
//  RFFeatureCache_Tests.m
//  RFFeatureToggle
//
//  Created by Dunja Lalic on 16/01/16.
//  Copyright (c) 2016 Lautsprecher Teufel GmbH. All rights reserved.
//

#import "RFFeatureToggleTest.h"
#import <RFFeatureToggle/RFFeature+Mapping.h>
#import <RFFeatureToggle/RFFeature+API.h>
#import <RFFeatureToggle/RFFeatureCache.h>

@interface RFFeatureCache_Tests : RFFeatureToggleTest

@property (nonatomic, strong) id sutMock;

@end

@implementation RFFeatureCache_Tests

- (void)setUp
{
    [super setUp];

    self.sutMock = OCMPartialMock([RFFeatureCache sharedCache]);
}

- (void)tearDown
{
    [super tearDown];

    [self.sutMock stopMocking];
}

- (void)testTimeIntervalSinceLastSuccessfulUpdate
{
    id <OHHTTPStubsDescriptor> stub = [RFFeatureToggleTest stubForSuccess];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch features: success"];

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:0.0f];

    [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"RFFeatureToggleLastUpdatedPlistNameKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [RFFeature fetchFeaturesUsingBlock:^(BOOL succeeded, NSError *error) {
        [expectation fulfill];

        NSDate *storedDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"RFFeatureToggleLastUpdatedPlistNameKey"];
        XCTAssertTrue([date compare:storedDate] == NSOrderedAscending,@"Start date should be lower than stored date");
        NSTimeInterval seconds = [RFFeatureCache timeIntervalSinceLastSuccessfulUpdate];
        XCTAssertTrue(seconds < 5.0f,@"Time since last successful update should be lower than 5 seconds");
    }];

    [self waitForExpectationsWithTimeout:0.5f
                                 handler:^(NSError *error) {
        XCTAssertNil(error,@"Error should be nil");
    }];

    [OHHTTPStubs removeStub:stub];
}

- (void)testRefresh
{
    id featureMock = OCMClassMock([RFFeature class]);

    [[featureMock expect] fetchFeaturesUsingBlock:[OCMArg invokeBlock]];

    [RFFeatureCache refreshFeatures];

    [featureMock verify];
    [featureMock stopMocking];
}

- (void)testLoadPlist
{
    RFFeature *object1 = [RFFeature featureWithName:@"feature1" enabled:YES];
    RFFeature *object2 = [RFFeature featureWithName:@"feature2" enabled:NO];

    RFFeature *object3 = [RFFeature featureWithName:@"feature3" enabled:NO];
    RFFeature *object4 = [RFFeature featureWithName:@"feature4" enabled:YES];
    object2.features = @[object3, object4];

    RFFeature *object5 = [RFFeature featureWithName:@"feature5" enabled:NO];
    RFFeature *object6 = [RFFeature featureWithName:@"feature6" enabled:YES];
    object3.features = @[object5, object6];

    NSArray *objects = @[object1, object2];

    [RFFeatureCache persistFeatures:objects];

    NSArray *loadedObjects = [RFFeatureCache allFeatures];

    XCTAssertTrue([RFFeature isEnabled:@"feature2.feature3.feature6"]);
    XCTAssertTrue([RFFeature isEnabled:@"feature2.feature4"]);
    XCTAssertFalse([RFFeature isEnabled:@"feature2.feature3.feature7"]);

    XCTAssertTrue([objects isEqualToArray:loadedObjects]);
}

- (void)testUpdatedFeatures
{
    //clean up current data
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"RFFeatureTogglePlistNameKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    //create and persist new data
    RFFeature *object1 = [RFFeature featureWithName:@"feature1" enabled:YES];
    RFFeature *object2 = [RFFeature featureWithName:@"feature2" enabled:NO];

    RFFeature *object3 = [RFFeature featureWithName:@"feature3" enabled:NO];
    RFFeature *object4 = [RFFeature featureWithName:@"feature4" enabled:YES];
    object2.features = @[object3, object4];

    RFFeature *object5 = [RFFeature featureWithName:@"feature5" enabled:NO];
    RFFeature *object6 = [RFFeature featureWithName:@"feature6" enabled:YES];
    object3.features = @[object5, object6];
    
    NSArray *objects = @[object1, object2];

    [RFFeatureCache persistFeatures:objects];
    
    //subscribe to notification
    [self expectationForNotification:RFFeatureToggleUpdatedNotification object:nil handler:nil];
    
    //create and persist modified data
    object1 = [RFFeature featureWithName:@"feature1" enabled:NO];
    object5 = [RFFeature featureWithName:@"feature5" enabled:YES];
    object6 = [RFFeature featureWithName:@"feature6" enabled:NO];
    object3.features = @[object5, object6];
    object2.features = @[object3, object4];

    objects = @[object1, object2];

    [RFFeatureCache persistFeatures:objects];
    
    [self waitForExpectationsWithTimeout:0.5f handler:^(NSError *error) {
        XCTAssertNil(error,@"Error should be nil");
    }];
}

- (void)testUpdatedFeaturesWithNoChange
{
    //clean up current data
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"RFFeatureTogglePlistNameKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //create and persist new data
    RFFeature *object1 = [RFFeature featureWithName:@"feature1" enabled:YES];
    RFFeature *object2 = [RFFeature featureWithName:@"feature2" enabled:NO];
    
    RFFeature *object3 = [RFFeature featureWithName:@"feature3" enabled:NO];
    RFFeature *object4 = [RFFeature featureWithName:@"feature4" enabled:YES];
    object2.features = @[object3, object4];
    
    RFFeature *object5 = [RFFeature featureWithName:@"feature5" enabled:NO];
    RFFeature *object6 = [RFFeature featureWithName:@"feature6" enabled:YES];
    object3.features = @[object5, object6];
    
    NSArray *objects = @[object1, object2];
    
    [RFFeatureCache persistFeatures:objects];
    
    //subscribe to notification
    OCMockObject *notificationMock = OCMClassMock([NSNotificationCenter class]);
    [[[notificationMock stub] andReturn:[NSNotificationCenter new]] defaultCenter];
    [[notificationMock reject] postNotificationName:RFFeatureToggleUpdatedNotification object:nil];
    
    [RFFeatureCache persistFeatures:objects];
    
    [notificationMock verify];
    [notificationMock stopMocking];
}

- (void)testAutoUpdate
{
    [RFFeatureToggleDefaults sharedDefaults].refreshTimeInterval = 0.01f;

    [[self.sutMock expect] refreshFeatures];

    [RFFeatureCache persistFeatures:nil];

    [RFFeatureToggleTest waitForVerifiedMock:self.sutMock delay:2.0f];

    [RFFeatureToggleDefaults sharedDefaults].refreshTimeInterval = 24*60*60;
}

- (void)testSubsribedToApplicationDidEnterBackground
{
    [[self.sutMock expect] applicationDidEnterBackground:[OCMArg any]];

    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidEnterBackgroundNotification object:nil];

    [self.sutMock verify];
}

- (void)testCancelAutoUpdateOnApplicationDidEnterBackground
{
    [[self.sutMock reject] refreshFeatures];

    [[RFFeatureCache sharedCache] performSelector:@selector(refreshFeatures) withObject:nil afterDelay:1.0f];

    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidEnterBackgroundNotification object:nil];

    OCMVerifyAllWithDelay(self.sutMock, 2.0f);
}

- (void)testUnsubscribe
{
    __weak RFFeatureCache *weakReference;

    @autoreleasepool {
        RFFeatureCache *reference = [[RFFeatureCache alloc] init];
        weakReference = reference;

        [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    XCTAssertNil(weakReference,@"Object instance should be nil");
}

@end
