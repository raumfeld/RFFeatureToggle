//
//  RFFeatureToggle.m
//  RFFeatureToggle
//
//  Created by Dunja Lalic on 21/01/16.
//  Copyright (c) 2016 Lautsprecher Teufel GmbH. All rights reserved.
//

#import "RFFeatureToggle.h"
#import "RFFeatureCache.h"
#import "RFFeature+API.h"

@implementation RFFeatureToggle

+ (BOOL)isEnabled:(NSString *)featureName
{
    return [RFFeature isEnabled:featureName];
}

+ (void)refreshFeatures
{
    [RFFeatureCache refreshFeatures];
}

+ (NSArray *)allFeatures
{
    return [RFFeatureCache allFeatures];
}

@end
