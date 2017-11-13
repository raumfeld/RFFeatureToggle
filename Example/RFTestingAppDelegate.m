//
//  RFTestingAppDelegate.m
//  RFFeatureToggle
//
//  Created by Dunja Lalic on 22/02/16.
//  Copyright © 2016 Raumfeld. All rights reserved.
//

#import "RFTestingAppDelegate.h"
#import "RFFeatureToggle.h"
#import "RFFeatureTableViewController.h"

@implementation RFTestingAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [RFFeatureToggle setLoggingLevel:RFFeatureToggleLoggingLevelOff];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIViewController *vc = [[RFFeatureTableViewController alloc] initWithNibName:nil bundle:nil];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
