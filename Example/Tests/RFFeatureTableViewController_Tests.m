//
//  RFFeatureTableViewController_Tests.m
//  RFFeatureToggle
//
//  Created by Dunja Lalic on 15/01/16.
//  Copyright (c) 2016 Lautsprecher Teufel GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <FBSnapshotTestCase/FBSnapshotTestCase.h>
#import "RFFeatureToggleTest.h"
#import <RFFeatureToggle/RFFeatureToggle.h>
#import <RFFeatureToggle/RFFeatureTableViewController.h>
#import "RFFeature+API.h"

@interface RFFeatureTableViewController_Tests : FBSnapshotTestCase

@property (nonatomic, strong) RFFeatureTableViewController *sut;

@end

@implementation RFFeatureTableViewController_Tests

- (void)setUp
{
    [super setUp];

    NSDictionary *params = @{kRFFeatureToggleBaseURLStringForStagingKey : @"https://staging/",
                             kRFFeatureToggleBaseURLStringForProductionKey : @"https://production/"};
    [RFFeatureToggleDefaults sharedDefaultsWithMode:RFFeatureToggleModeProduction params:params];

    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:bundle];
    RFFeatureTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"FeatureTable"];
    [vc viewDidLoad];
    self.sut = vc;
}

- (void)testRootTableView
{
    id <OHHTTPStubsDescriptor> stub = [RFFeatureToggleTest stubForSuccess];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch features: error"];

    [self.sut viewWillAppear:YES];
    [self.sut refresh:nil];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [expectation fulfill];
    });

    [self waitForExpectationsWithTimeout:1.0f handler:^(NSError *error) {
        XCTAssertNil(error);

        FBSnapshotVerifyView(self.sut.view, nil);
    }];

    [OHHTTPStubs removeStub:stub];
}

- (void)testRootTableViewWithError
{
    id <OHHTTPStubsDescriptor> stub = [RFFeatureToggleTest stubForFail];

    id sutMock = OCMPartialMock(self.sut);

    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch features: error"];

    [self.sut viewWillAppear:YES];
    [self.sut refresh:nil];

    [[sutMock expect] handleError:OCMOCK_ANY];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [expectation fulfill];
    });

    [self waitForExpectationsWithTimeout:1.0f handler:^(NSError *error) {
        XCTAssertNil(error);

        [sutMock verify];
        [sutMock stopMocking];
    }];

    [OHHTTPStubs removeStub:stub];
}

- (void)testPushSubfeaturesTableView
{
    id sutMock = OCMPartialMock(self.sut);

    id mockNavController = [OCMockObject mockForClass:[UINavigationController class]];
    [[[sutMock stub] andReturn:mockNavController] navigationController];

    id <OHHTTPStubsDescriptor> stub = [RFFeatureToggleTest stubForSuccess];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch features: success"];

    [RFFeature fetchFeaturesUsingBlock:^(BOOL succeeded, NSError *error) {
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.5f handler:^(NSError *error) {
        XCTAssertNil(error);

        [self.sut viewWillAppear:YES];

        UIViewController *viewController = [OCMArg checkWithBlock:^BOOL (id obj) {
            RFFeatureTableViewController *vc = obj;
            return ([vc isKindOfClass:[RFFeatureTableViewController class]] &&
                    (vc.feature != nil));
        }];
        [[mockNavController expect] pushViewController:viewController animated:YES];

        [self.sut tableView:self.sut.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];

        [mockNavController verify];
        [sutMock verify];
        [mockNavController stopMocking];
        [sutMock stopMocking];
    }];

    [OHHTTPStubs removeStub:stub];
}

- (void)testPresentSubfeaturesTableView
{
    id sutMock = OCMPartialMock(self.sut);
    [[[sutMock stub] andReturn:nil] navigationController];

    id <OHHTTPStubsDescriptor> stub = [RFFeatureToggleTest stubForSuccess];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch features: success"];

    [RFFeature fetchFeaturesUsingBlock:^(BOOL succeeded, NSError *error) {
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.5f handler:^(NSError *error) {
        XCTAssertNil(error);

        [self.sut viewWillAppear:YES];

        UINavigationController *navigationViewController = [OCMArg checkWithBlock:^BOOL (id obj) {
            UINavigationController *nc = obj;
            return ([nc isKindOfClass:[UINavigationController class]] &&
                    (nc.viewControllers != nil));
        }];
        [[sutMock expect] presentViewController:navigationViewController animated:YES completion:NULL];

        [self.sut tableView:self.sut.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];

        [sutMock verify];
        [sutMock stopMocking];
    }];

    [OHHTTPStubs removeStub:stub];
}

- (void)testDontDisplaySubfeaturesIfThereArentAny
{
    id sutMock = OCMPartialMock(self.sut);

    id <OHHTTPStubsDescriptor> stub = [RFFeatureToggleTest stubForSuccess];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch features: success"];

    [RFFeature fetchFeaturesUsingBlock:^(BOOL succeeded, NSError *error) {
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.5f handler:^(NSError *error) {
        XCTAssertNil(error);

        [self.sut viewWillAppear:YES];

        [[sutMock reject] presentViewController:OCMOCK_ANY animated:YES completion:NULL];

        [self.sut tableView:self.sut.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

        [sutMock verify];
        [sutMock stopMocking];
    }];

    [OHHTTPStubs removeStub:stub];
}

- (void)testRemoveRefreshControl
{
    self.sut.feature = [[RFFeature alloc] init];

    [self.sut viewWillAppear:YES];

    XCTAssertNil(self.sut.refreshControl);

    self.sut.feature = nil;
}

@end
