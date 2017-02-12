//
//  RFFeature_Tests.m
//  RFFeatureToggle
//
//  Created by Dunja Lalic on 14/01/16.
//  Copyright (c) 2016 Lautsprecher Teufel GmbH. All rights reserved.
//

#import "RFFeatureToggleTest.h"
#import "RFFeature+API.h"
#import "RFFeature+Mapping.h"
#import "RFFeatureCache.h"

@interface RFFeature_Tests : RFFeatureToggleTest

@end

@implementation RFFeature_Tests

#pragma mark - RFFeature

- (void)testIsEqual
{
    RFFeature *object1 = [RFFeature featureWithName:@"feature1" enabled:YES];
    RFFeature *object2 = [RFFeature featureWithName:@"feature1" enabled:YES];

    XCTAssertTrue([object1 isEqual:object2],@"Features should be equal");

    object1 = [RFFeature featureWithName:@"feature1" enabled:YES];
    object2 = [RFFeature featureWithName:@"feature2" enabled:NO];

    XCTAssertFalse([object1 isEqual:object2],@"Features should not be equal");

    RFFeature *object3 = [RFFeature featureWithName:@"feature3" enabled:NO];
    RFFeature *object4 = [RFFeature featureWithName:@"feature4" enabled:YES];
    object2.features = @[object3, object4];

    RFFeature *object5 = [RFFeature featureWithName:@"feature5" enabled:NO];
    RFFeature *object6 = [RFFeature featureWithName:@"feature6" enabled:YES];
    object3.features = @[object5, object6];

    XCTAssertFalse([object1 isEqual:object2],@"Features should not be equal");

    NSObject *object = [[NSObject alloc] init];
    XCTAssertFalse([object1 isEqual:object],@"Features should not be equal");
}

- (void)testDescription
{
    RFFeature *object = [RFFeature featureWithName:@"feature" enabled:YES];

    XCTAssertTrue([object.description isEqualToString:@"feature: enabled"],@"Feature's description should be 'feature: enabled'");
}

- (void)testRecursiveDescription
{
    RFFeature *object1 = [RFFeature featureWithName:@"feature1" enabled:YES];

    RFFeature *object2 = [RFFeature featureWithName:@"feature2" enabled:NO];
    RFFeature *object3 = [RFFeature featureWithName:@"feature3" enabled:NO];
    RFFeature *object4 = [RFFeature featureWithName:@"feature4" enabled:YES];
    object1.features = @[object2, object3, object4];

    RFFeature *object5 = [RFFeature featureWithName:@"feature5" enabled:NO];
    RFFeature *object6 = [RFFeature featureWithName:@"feature6" enabled:YES];
    object3.features = @[object5, object6];

    NSString *string = [object1 recursiveDescription];
    NSUInteger numberOfOccurrences = [string componentsSeparatedByString:@"|_"].count - 1;
    XCTAssertTrue(numberOfOccurrences == 5,@"There should be 5 branches");

    XCTAssertTrue([object1.recursiveDescription rangeOfString:@"feature6: enabled"].location != NSNotFound,@"Description should contain feature 6: enabled");
}

#pragma mark - RFFeature+Mapping

- (void)testFeatureWithName
{
    RFFeature *object1 = [RFFeature featureWithName:@"feature1" enabled:YES];

    XCTAssertTrue([object1.name isEqualToString:@"feature1"]);
    XCTAssertTrue(object1.isEnabled);

    RFFeature *object2 = [RFFeature featureWithName:@"feature2" enabled:NO];

    XCTAssertTrue([object2.name isEqualToString:@"feature2"],@"Feature name should be 'feature2'");
    XCTAssertFalse(object2.isEnabled,@"Feature should be enabled");
}

- (void)testObjectsFromJSON
{
    NSError *deserializingError = nil;
    NSURL *fixtureURL = [NSURL fileURLWithPath:[RFFeatureToggleTest fixturePath]];
    NSData *contentOfLocalFile = [NSData dataWithContentsOfURL:fixtureURL];
    id obj = [NSJSONSerialization JSONObjectWithData:contentOfLocalFile
                                            options:NSJSONReadingMutableContainers
                                            error:&deserializingError];
    XCTAssertNil(deserializingError,@"JSON parsing error should be nil");

    NSArray *objects = [RFFeature objectsFromJSON:obj];
    XCTAssertEqual(objects.count,10,@"There should be 10 objects");

    NSUInteger randomIndex = arc4random() % objects.count;
    RFFeature *object = objects[randomIndex];
    XCTAssertTrue([object isKindOfClass:[RFFeature class]],@"Any object should be RFFeature object");
}

- (void)testObjectsFromJSONWithArray
{
    id JSON = [NSArray array];

    NSArray *objects = [RFFeature objectsFromJSON:JSON];

    XCTAssertEqual(objects.count,0,@"There should be 0 objects");
}

#pragma mark - RFFeature+API

- (void)testFetchFeaturesUsingBlock_Success
{
    id <OHHTTPStubsDescriptor> stub = [RFFeatureToggleTest stubForSuccess];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch features: success"];

    [RFFeature fetchFeaturesUsingBlock:^(BOOL succeeded, NSError *error) {
        [expectation fulfill];
        XCTAssertTrue(succeeded,@"It should return success");
        XCTAssertNil(error,@"Error should be nil");
        XCTAssertEqual([RFFeatureCache allFeatures].count,10,@"There should be 10 objects");
    }];

    [self waitForExpectationsWithTimeout:0.5f handler:^(NSError *error) {
        XCTAssertNil(error);
    }];

    [OHHTTPStubs removeStub:stub];
}

- (void)testFetchFeaturesUsingBlock_Fail
{
    id <OHHTTPStubsDescriptor> stub = [RFFeatureToggleTest stubForFail];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch features: fail"];

    [RFFeature fetchFeaturesUsingBlock:^(BOOL succeeded, NSError *error) {
        [expectation fulfill];
        XCTAssertFalse(succeeded,@"It should return failure");
        XCTAssertNotNil(error,@"It should return an error");
    }];

    [self waitForExpectationsWithTimeout:0.5f handler:^(NSError *error) {
        XCTAssertNil(error,@"Error should be nil");
    }];

    [OHHTTPStubs removeStub:stub];
}

- (void)testIsFeatureEnabled
{
    id <OHHTTPStubsDescriptor> stub = [RFFeatureToggleTest stubForSuccess];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch features: success"];

    [RFFeature fetchFeaturesUsingBlock:^(BOOL succeeded, NSError *error) {
        [expectation fulfill];

        XCTAssertTrue([RFFeature isEnabled:@"ipsum"]);
        XCTAssertFalse([RFFeature isEnabled:@"lorem"]);
        XCTAssertTrue([RFFeature isEnabled:@"semper.aperiam"]);
        XCTAssertFalse([RFFeature isEnabled:@"comprehensam.aperiam"]);
    }];

    [self waitForExpectationsWithTimeout:0.5f handler:^(NSError *error) {
        XCTAssertNil(error,@"Error should be nil");
    }];

    [OHHTTPStubs removeStub:stub];
}

@end
