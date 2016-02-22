//
//  RFFeatureToggleDefaults.m
//  RFFeatureToggle
//
//  Created by Dunja Lalic on 13/01/16.
//  Copyright (c) 2016 Lautsprecher Teufel GmbH. All rights reserved.
//

#import "RFFeatureToggleDefaults.h"
#import "RFFeatureCache.h"

NSString *const kRFFeatureToggleBaseURLStringForStagingKey = @"kRFFeatureToggleBaseURLStringForStagingKey";
NSString *const kRFFeatureToggleBaseURLStringForProductionKey = @"kRFFeatureToggleBaseURLStringForProductionKey";
NSString *const kRFFeatureToggleAPIEndpointKey = @"kRFFeatureToggleAPIEndpointKey";
NSString *const kRFFeatureToggleRequestHeadersDictionaryKey = @"kRFFeatureToggleHeaderDictionaryKey";

NSString *const RFFeatureToggleUpdatedNotification = @"RFFeatureToggleUpdatedNotification";

@interface RFFeatureToggleDefaults ()

@property (nonatomic,copy) NSString *productionURLString;
@property (nonatomic,copy) NSString *stagingURLString;

@end

@implementation RFFeatureToggleDefaults

static RFFeatureToggleDefaults *sharedDefaults = nil;

+ (instancetype)sharedDefaultsWithMode:(RFFeatureToggleMode)mode params:(NSDictionary *)params
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedDefaults = [[self alloc] initWithMode:mode params:params];
    });
    return sharedDefaults;
}

+ (instancetype)sharedDefaults
{
    NSAssert(sharedDefaults != nil, @"sharedDefaults called before sharedDefaultsWithMode:params:");
    return sharedDefaults;
}

- (instancetype)initWithMode:(RFFeatureToggleMode)mode params:(NSDictionary *)params
{
    self = [super init];
    if (self)
    {
        NSAssert(params, @"Params can't be nil. Please provide a dictionary with API URLs for staging & production");
        NSAssert(params[kRFFeatureToggleBaseURLStringForStagingKey], @"Please provide the API URL for staging");
        NSAssert(params[kRFFeatureToggleBaseURLStringForProductionKey], @"Please provide the API URL for production");

        self.productionURLString = params[kRFFeatureToggleBaseURLStringForProductionKey];
        self.stagingURLString = params[kRFFeatureToggleBaseURLStringForStagingKey];
        
        [self switchToMode:mode];

        if (params[kRFFeatureToggleAPIEndpointKey])
        {
            _endpoint = params[kRFFeatureToggleAPIEndpointKey];
        }
        else
        {
            _endpoint = @"features.json";
        }
        
        _requestHeadersDictionary = params[kRFFeatureToggleRequestHeadersDictionaryKey];
        
        self.refreshTimeInterval = 24*60*60;

        [RFFeatureCache sharedCache];
    }
    return self;
}

- (void) switchToMode:(RFFeatureToggleMode)mode
{
    _mode = mode;
    
   NSAssert((self.mode != RFFeatureToggleModeCustom), @"Please use switchToCustomModeWithBaseURLString: to set custom mode.");
    
    switch (self.mode) {
        case RFFeatureToggleModeStaging:
            _baseURLString = self.stagingURLString;
            break;
        case RFFeatureToggleModeProduction:
            _baseURLString = self.productionURLString;
            break;
        default:
            break;
    }
}

- (void) switchToCustomModeWithBaseURLString:(NSString *)baseURLString
{
    _mode = RFFeatureToggleModeCustom;
    _baseURLString = baseURLString;
}

@end
