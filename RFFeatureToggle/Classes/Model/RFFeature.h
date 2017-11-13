//
//  RFFeature.h
//  RFFeatureToggle
//
//  Created by Dunja Lalic on 13/01/16.
//  Copyright (c) 2016 Lautsprecher Teufel GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
   `RFFeature` is a model object for a feature collected from the API.
    Conforms to `NSCoding` protocol.
 */
@interface RFFeature : NSObject <NSCoding>

/**
   The name of the feature as defined by API.
 */
@property (nonatomic, strong) NSString *name;

/**
   The enabled value of the feature as defined by API.
 */
@property (nonatomic, getter = isEnabled) BOOL enabled;

/**
   Feature's subfeature instances.

   @return    An array of `RFFeature` instances.
 */
@property (nonatomic, strong) NSArray *features;

/**
   Description override that simplifies `RFFeature` inspection.

   @return        Returns a feature name with formatted enabled value.
 */
- (NSString *)description;

/**
   Recursive description that simplifies `RFFeature` subfeatures inspection.

   @return        Returns a structured list of feature and all of its subfeatures.
 */
- (NSString *)recursiveDescription;

@end

NS_ASSUME_NONNULL_END
