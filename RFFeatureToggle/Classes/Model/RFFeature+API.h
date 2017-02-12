//
//  RFFeature+API.h
//  RFFeatureToggle
//
//  Created by Dunja Lalic on 13/01/16.
//  Copyright (c) 2016 Lautsprecher Teufel GmbH. All rights reserved.
//

#import "RFFeature.h"
#import "RFFeatureAPIClient.h"

/**
   `RFFeature+API` is a model-controller type extension of `RFFeature` that makes all API calls related to features.
 */
@interface RFFeature (API)

/**
   Creates an API call and persists the results in `RFFeatureCache`.

   @param block   A block to identify if the call to API is succesful or not.
 */
+ (void)fetchFeaturesUsingBlock:(RFAPIResultBlock)block;

/**
   Returns an enabled value for feature with name. For features that have subfeatures, accepts a dot separated synthax like "feature.subfeature.subsubfeature".

   @param featureName A name of the feature as defined on server or a dot separated string of subfeature.
   @returns           YES if feature exists in current cache and is enabled, NO otherwise.
 */
+ (BOOL)isEnabled:(NSString *)featureName;

@end
