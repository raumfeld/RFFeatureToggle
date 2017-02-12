//
//  RFFeatureTableViewController.h
//  RFFeatureToggle
//
//  Created by Dunja Lalic on 01/14/2016.
//  Copyright (c) 2016 Raumfeld. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RFFeature;

/**
   `RFFeatureTableViewController` is a table view controller that displays all the loaded features in a master-detail fashion.
   - Feature list can be refreshed via refresh control.
   - Features that have subfeatures are selectable and can be navigated to by passing `RFFeature` instance.
   - The subfeatures are shown as detail if there's a navigation controller provided, otherwise modally.
 */
@interface RFFeatureTableViewController : UITableViewController

/**
   The instance of `RFFeature` object whose subfeatures should be shown.
 */
@property (nonatomic, strong) RFFeature *feature;

/**
   Initiates a call to API to refresh feature list

   @param sender   A refresh control instance if avaliable
 */
- (void)refresh:(UIRefreshControl *)sender;

/**
   Handles API error

   @param error   An error instance
 */
- (void)handleError:(NSError *)error;

@end
