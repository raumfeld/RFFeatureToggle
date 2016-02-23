//
//  RFTestingAppDelegate.m
//  RFFeatureToggle
//
//  Created by Dunja Lalic on 22/02/16.
//  Copyright © 2016 Raumfeld. All rights reserved.
//

#import "RFTestingAppDelegate.h"
#import "RFFeatureToggle.h"

@implementation RFTestingAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [RFFeatureToggle setLoggingLevel:RFFeatureToggleLoggingLevelOff];
    
    return YES;
}

@end
