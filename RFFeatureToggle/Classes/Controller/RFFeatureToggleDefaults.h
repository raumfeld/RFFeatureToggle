//
//  RFFeatureToggleDefaults.h
//  RFFeatureToggle
//
//  Created by Dunja Lalic on 13/01/16.
//  Copyright (c) 2016 Lautsprecher Teufel GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSUInteger, RFFeatureToggleMode)
{
    RFFeatureToggleModeProduction,    /// Production
    RFFeatureToggleModeStaging,       /// Staging
    RFFeatureToggleModeCustom         /// Custom base URL is set
};

/**
 Setup parameters dictionary keys.
 */
extern NSString *const kRFFeatureToggleBaseURLStringForStagingKey;
extern NSString *const kRFFeatureToggleBaseURLStringForProductionKey;
extern NSString *const kRFFeatureToggleAPIEndpointKey;
extern NSString *const kRFFeatureToggleRequestHeadersDictionaryKey;

/**
 Notification name to observe.
 */
extern NSString *const RFFeatureToggleUpdatedNotification;

/**
   `RFFeatureToggleDefaults` is a singleton that holds defaults for Raumfeld Feature Toggle.

   @warning Initialize by calling [RFFeatureToggleDefaults sharedDefaultsWithMode:RFFeatureToggleModeProduction params:params];
 */
@interface RFFeatureToggleDefaults : NSObject

/**
   Type of defaults, see `RFFeatureToggleMode` for options.
 */
@property (nonatomic, readonly) RFFeatureToggleMode mode;

/**
 Base URL for the API call.
 */
@property (nonatomic, readonly) NSString *baseURLString;

/**
 API endpoint. Defaults to "features.json" if not provided on initialization in ´kRFFeatureToggleAPIEndpointKey´
 */
@property (nonatomic, readonly) NSString *endpoint;

/**
 Optional, stores a request headers dictionary provided on initialization in `kRFFeatureToggleRequestHeadersDictionaryKey`
 */
@property (nonatomic, strong, readonly) NSDictionary *requestHeadersDictionary;

/**
   Refresh time interval
   @note Defaults to 24 hours. Set to 0 to disable automatic refresh.
 */
@property (nonatomic) NSTimeInterval refreshTimeInterval;

/**
   Initializes and returns a singleton instance of `RFFeatureToggleDefaults`.

   @return    The shared `RFFeatureToggleDefaults` instance.
 */
+ (instancetype)sharedDefaults;

/**
 Initializes and returns a singleton instance of `RFFeatureToggleDefaults`.
   @param mode    Type of defaults to initialize, see `RFFeatureToggleMode` for options
   @param params  A dictionary of parameters with keys
   @return  The shared `RFFeatureToggleDefaults` instance.
 */
+ (instancetype)sharedDefaultsWithMode:(RFFeatureToggleMode)mode params:(NSDictionary *)params;

/**
 Switches to mode and reflects the change in `baseURLString`. Refresh should be called afterwards to reflect the changes.
 
 @param mode    Desired `RFFeatureToggleMode` mode.
 */
- (void) switchToMode:(RFFeatureToggleMode)mode;

/**
 Switches to custom mode with custom base url and reflects the change in `baseURLString`. Refresh should be called afterwards to reflect the changes.
 
 @param baseURLString    Base URL string to use.
 */
- (void) switchToCustomModeWithBaseURLString:(NSString *)baseURLString;

@end
