//
//  RFFeature+API.m
//  RFFeatureToggle
//
//  Created by Dunja Lalic on 13/01/16.
//  Copyright (c) 2016 Lautsprecher Teufel GmbH. All rights reserved.
//

#import "RFFeature+API.h"
#import "RFFeature+Mapping.h"
#import "RFFeatureToggleDefaults.h"
#import "RFFeatureCache.h"
#import "RFFeatureToggleLogging.h"

@implementation RFFeature (API)

+ (void)fetchFeaturesUsingBlock:(RFAPIResultBlock)block
{
    NSString *url = [[RFFeatureToggleDefaults sharedDefaults].baseURLString stringByAppendingString:[RFFeatureToggleDefaults sharedDefaults].endpoint];
    [[RFFeatureAPIClient sharedClient] GET:url
                                parameters:nil
                                   success:^(NSURLSessionDataTask *__unused task, id JSON) {
                                       RFLogDebug(@"Request to '%@' returned:\n%@",url,JSON);
                                       NSArray *objects = [RFFeature objectsFromJSON:JSON];
                                       [RFFeatureCache persistFeatures:objects];
                                       return block(YES, nil);
                                   }
                                   failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
                                       RFLogError(@"Error: request to '%@' returned:\n%@",url,error);
                                       return block(NO, error);
                                   }];
}

+ (BOOL)isEnabled:(NSString *)featureName
{
    NSArray *components = [featureName componentsSeparatedByString:@"."];

    if (components.count > 1)
    {
        RFFeature *feature = nil;
        NSArray *featureArray = [RFFeatureCache allFeatures];
        for (NSString *name in components)
        {
            feature = [RFFeature featureWithName:name inArray:featureArray];
            if (!feature)
            {
                return NO;
            }
            featureArray = feature.features;
        }
        return feature.isEnabled;
    }

    return [self isEnabledForName:featureName inArray:[RFFeatureCache allFeatures]];
}

+ (BOOL)isEnabledForName:(NSString *)featureName inArray:(NSArray *)array
{
    RFFeature *firstFoundObject = [self featureWithName:featureName inArray:array];
    return firstFoundObject ? firstFoundObject.isEnabled : NO;
}

+ (RFFeature *)featureWithName:(NSString *)featureName inArray:(NSArray *)array
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", featureName];
    NSArray *filteredArray = [array filteredArrayUsingPredicate:predicate];
    RFFeature *firstFoundObject = filteredArray.count > 0 ? filteredArray.firstObject : nil;
    return firstFoundObject;
}

@end
