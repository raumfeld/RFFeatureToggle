//
//  RFFeature+Mapping.h
//  RFFeatureToggle
//
//  Created by Dunja Lalic on 13/01/16.
//  Copyright (c) 2016 Lautsprecher Teufel GmbH. All rights reserved.
//

#import "RFFeature.h"

NS_ASSUME_NONNULL_BEGIN

/**
   `RFFeature+Mapping` is an extension of `RFFeature` that maps JSON to `RFFeature` objects.
 */
@interface RFFeature (Mapping)

/**
   Creates and returns an `RFFeature` instance

   @param name    The name of the feature
   @param enabled YES if feature is enabled, NO otherwise
   @return        Returns a `RFFeature` instance with input parameters set
 */
+ (instancetype)featureWithName:(NSString *)name enabled:(BOOL)enabled;

/**
   Creates and returns an array of `RFFeature` instances parsed from the JSON

   @param object  A JSON object, expected to be `NSDictionary`
   @return        An array of `RFFeature` instances
 */
+ (NSArray *)objectsFromJSON:(id)object;

@end

NS_ASSUME_NONNULL_END
