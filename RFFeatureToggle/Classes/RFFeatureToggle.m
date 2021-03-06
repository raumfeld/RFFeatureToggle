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

#ifdef DEBUG
static RFFeatureToggleLoggingLevel kRFFeatureToggleLoggingLevel = RFFeatureToggleLoggingLevelDebug;
#else
static RFFeatureToggleLoggingLevel kRFFeatureToggleLoggingLevel = RFFeatureToggleLoggingLevelError;
#endif

@implementation RFFeatureToggle

static NSUserDefaults *(^_userDefaults)(void) = ^{
    return [NSUserDefaults standardUserDefaults];
};

+ (NSUserDefaults * _Nonnull (^)(void))userDefaults
{
    return _userDefaults;
}

+ (void)setUserDefaults:(NSUserDefaults * _Nonnull (^)(void))userDefaults
{
    _userDefaults = userDefaults;
}

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

+ (RFFeatureToggleLoggingLevel) loggingLevel
{
    return kRFFeatureToggleLoggingLevel;
}

+ (void) setLoggingLevel:(RFFeatureToggleLoggingLevel)level
{
    kRFFeatureToggleLoggingLevel = level;
}

@end
