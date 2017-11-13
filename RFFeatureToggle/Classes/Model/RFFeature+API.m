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
    NSDictionary *parameters = nil;
    void (^progress)(NSProgress *) = nil;
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
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    SEL selectorInAFNetworkingVersion3 = @selector(GET:parameters:progress:success:failure:);
#pragma clang diagnostic pop
    if ([[RFFeatureAPIClient sharedClient] respondsToSelector:selectorInAFNetworkingVersion3])
    {
        NSMethodSignature *signature = [[RFFeatureAPIClient sharedClient] methodSignatureForSelector:selectorInAFNetworkingVersion3];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:[RFFeatureAPIClient sharedClient]];
        [invocation setSelector:selectorInAFNetworkingVersion3];
        [invocation setArgument:&url atIndex:2];
        [invocation setArgument:&parameters atIndex:3];
        [invocation setArgument:&progress atIndex:4];
        [invocation setArgument:&success atIndex:5];
        [invocation setArgument:&failure atIndex:6];
        [invocation invoke];
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[RFFeatureAPIClient sharedClient] GET:url
                                    parameters:parameters
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
