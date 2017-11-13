//
//  RFFeatureCache.h
//  RFFeatureToggle
//
//  Created by Dunja Lalic on 13/01/16.
//  Copyright (c) 2016 Lautsprecher Teufel GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFFeature.h"

NS_ASSUME_NONNULL_BEGIN

/**
   `RFFeatureCache` is a singleton that loads and persists a set of `RFFeature` instances to `NSUserDefaults` and handles automatic refresh if enabled.
 */
@interface RFFeatureCache : NSObject

/**
   Initializes and returns a singleton instance of `RFFeatureCache`.

   @return    The shared `RFFeatureCache` instance.
 */
+ (instancetype)sharedCache;

/**
   Initiates an API call to refresh features. Can be called on `applicationDidBecomeActive:` or when needed.
   @note Is automatically called based on `refreshTimeInterval` value specified in `RFFeatureToggleDefaults` if app has been continuously running in foreground.
 */
+ (void)refreshFeatures;

/**
   An array of `RFFeature` instances loaded from `NSUserDefaults`.

   @return    An array of `RFFeature` instances.
 */
+ (nullable NSArray *)allFeatures;

/**
   Persists an array of `RFFeature` instances to `NSUserDefaults`.

   @param features    An array of `RFFeature` instances.
 */
+ (void)persistFeatures:(nullable NSArray *)features;

/**
   Compares stored date of last successful update with current date and returns the difference.

   @return    A time interval since last succesful update in seconds.
 */
+ (NSTimeInterval)timeIntervalSinceLastSuccessfulUpdate;

@end

NS_ASSUME_NONNULL_END
