//
//  main.m
//  RFFeatureToggle
//
//  Created by Dunja Lalic on 01/14/2016.
//  Copyright (c) 2016 Raumfeld. All rights reserved.
//

@import UIKit;
#import "RFAppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        Class appDelegateClass = NSClassFromString(@"RFTestingAppDelegate");
        if (!appDelegateClass)
            appDelegateClass = [RFAppDelegate class];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass(appDelegateClass));
    }
}
