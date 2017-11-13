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
    void (^success)(NSURLSessionDataTask *, id) = ^(NSURLSessionDataTask *task, id _Nullable responseObject) {
        RFLogDebug(@"Request to '%@' returned:\n%@",url,responseObject);
        NSArray *objects = [RFFeature objectsFromJSON:responseObject];
        [RFFeatureCache persistFeatures:objects];
        return block(YES, nil);
    };
    void (^failure)(NSURLSessionDataTask *, NSError *) = ^(NSURLSessionDataTask *task, NSError *error) {
        RFLogError(@"Error: request to '%@' returned:\n%@",url,error);
        return block(NO, error);
    };
    if ([[RFFeatureAPIClient sharedClient] respondsToSelector:@selector(GET:parameters:progress:success:failure:)]) {
        [[RFFeatureAPIClient sharedClient] GET:url
                                    parameters:nil
                                      progress:nil
                                       success:success
                                       failure:failure];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[RFFeatureAPIClient sharedClient] GET:url
                                    parameters:nil
                                       success:success
                                       failure:failure];
#pragma clang diagnostic pop
    }
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
