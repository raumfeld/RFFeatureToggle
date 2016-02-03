//
//  RFFeatureToggle.h
//  RFFeatureToggle
//
//  Created by Dunja Lalic on 21/01/16.
//  Copyright (c) 2016 Lautsprecher Teufel GmbH. All rights reserved.
//

#import "RFFeatureToggleDefaults.h"
#import "RFFeature.h"

@interface RFFeatureToggle : NSObject

/**
   Returns an enabled value for feature with name. For features that have subfeatures, accepts a dot separated synthax like "feature.subfeature.subsubfeature".

   @param featureName A name of the feature as defined on server or a dot separated string of subfeature.
   @returns           YES if feature exists in current cache and is enabled, NO otherwise.
 */
+ (BOOL)isEnabled:(NSString *)featureName;

/**
   Initiates an API call to refresh features and persists the newly fetched features. Can be called on `applicationDidBecomeActive:` or when needed.
   @note Is automatically called based on `refreshTimeInterval` value specified in `RFFeatureToggleDefaults` if the app has been continuously running in foreground.
 */
+ (void)refreshFeatures;

/**
   An array of `RFFeature` instances loaded from `NSUserDefaults`.

   @return    An array of `RFFeature` instances.
 */
+ (NSArray *)allFeatures;

@end
