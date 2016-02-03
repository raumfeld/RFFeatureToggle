//
//  RFFeatureCache.m
//  RFFeatureToggle
//
//  Created by Dunja Lalic on 13/01/16.
//  Copyright (c) 2016 Lautsprecher Teufel GmbH. All rights reserved.
//

#import "RFFeatureCache.h"
#import "RFFeature+API.h"
#import "RFFeatureToggleDefaults.h"

static NSString *const RFFeatureTogglePlistNameKey = @"RFFeatureTogglePlistNameKey";
static NSString *const RFFeatureToggleLastUpdatedPlistNameKey = @"RFFeatureToggleLastUpdatedPlistNameKey";

@interface RFFeatureCache ()

@end

@implementation RFFeatureCache

static RFFeatureCache *sharedCache;

+ (instancetype)sharedCache
{
    static dispatch_once_t once;

    dispatch_once(&once, ^{
        sharedCache = [[self alloc] init];
    });
    return sharedCache;
}

- (instancetype)init
{
    self = [super init];

    if (self)
    {
        [self subscribeToNotifications];
    }

    return self;
}

- (void)dealloc
{
    [self unsubscribeFromNotifications];
}

- (void)subscribeToNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

- (void)unsubscribeFromNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
}

+ (void)refreshFeatures
{
    [[RFFeatureCache sharedCache] refreshFeatures];
}

+ (NSArray *)allFeatures
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:RFFeatureTogglePlistNameKey];
    if (!data) {
        return nil;
    }
    NSArray *featureArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return featureArray;
}

+ (void)storeLastUpdateDate:(NSDate *)date
{
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:RFFeatureToggleLastUpdatedPlistNameKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDate *)lastUpdateDate
{
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:RFFeatureToggleLastUpdatedPlistNameKey];
    return date;
}

+ (NSTimeInterval)timeIntervalSinceLastSuccessfulUpdate
{
    return [[NSDate date] timeIntervalSinceDate:[self lastUpdateDate]];
}

+ (void)persistFeatures:(NSArray *)features
{
    NSSet *set1 = [NSSet setWithArray:[self allFeatures]];
    NSSet *set2 = [NSSet setWithArray:features];

    if (![set1 isEqualToSet:set2]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:RFFeatureToggleUpdatedNotification object:nil];
    }

    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:features] forKey:RFFeatureTogglePlistNameKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self storeLastUpdateDate:[NSDate date]];

    //schedule automatic refresh
    if ([RFFeatureToggleDefaults sharedDefaults].refreshTimeInterval > 0)
    {
        [[RFFeatureCache sharedCache] performSelector:@selector(refreshFeatures) withObject:nil afterDelay:[RFFeatureToggleDefaults sharedDefaults].refreshTimeInterval];
    }
}

#pragma mark - Actions

//A convenience method to handle target for performSelector: and cancelPreviousPerformRequestsWithTarget:
- (void)refreshFeatures
{
    [RFFeature fetchFeaturesUsingBlock:^(BOOL succeeded, NSError *error) {
        
    }];
}

#pragma mark - Notifications

- (void)applicationDidEnterBackground:(NSNotification *)note
{
    [NSObject cancelPreviousPerformRequestsWithTarget:[RFFeatureCache sharedCache] selector:@selector(refreshFeatures) object:nil];
}

@end
