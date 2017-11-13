//
//  RFFeatureTableViewController.m
//  RFFeatureToggle
//
//  Created by Dunja Lalic on 01/14/2016.
//  Copyright (c) 2016 Raumfeld. All rights reserved.
//

#import "RFFeatureTableViewController.h"
#import "RFFeatureToggle.h"
#import "RFFeature+API.h"

@interface RFFeatureTableViewController ()

/**
   An array of `RFFeature` instances.
 */
@property (nonatomic, strong) NSArray *features;

- (void)handleError:(NSError *)error;

@end

@implementation RFFeatureTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (self.feature)
    {
        self.title = self.feature.name;
        self.features = self.feature.features;

        //remove refresh control as only the root list of features can be refreshed
        [self.refreshControl endRefreshing];
        self.refreshControl = nil;
    }
    else
    {
        self.title = @"All features";
        self.features = [self sortedFeatures:[RFFeatureToggle allFeatures]];
    }
}

#pragma mark - Actions

- (void)refresh:(UIRefreshControl *)sender
{
    [RFFeature fetchFeaturesUsingBlock:^(BOOL succeeded, NSError *error) {
        [sender endRefreshing];
        self.features = [self sortedFeatures:[RFFeatureToggle allFeatures]];
        [self.tableView reloadData];
        if (error)
        {
            [self handleError:error];
        }
    }];
}

- (NSArray *)sortedFeatures:(NSArray *)features
{
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortedArray = [features sortedArrayUsingDescriptors:@[descriptor]];
    return sortedArray;
}

- (void)handleError:(NSError *)error
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"An error occurred", @"Error message title") message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"") style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)dismiss:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.features.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"RFFeatureCell";

    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        UISwitch *enabledSwitch = [[UISwitch alloc] init];
        enabledSwitch.userInteractionEnabled = NO;
        cell.accessoryView = enabledSwitch;
    }

    RFFeature *feature = self.features[indexPath.row];
    cell.textLabel.text = feature.name;

    if (feature.features.count > 0)
    {
        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        UISwitch *enabledSwitch = (UISwitch *)cell.accessoryView;
        enabledSwitch.on = feature.isEnabled;
    }

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    RFFeature *feature = self.features[indexPath.row];
    if (feature.features.count == 0)
    {
        return;
    }

    RFFeatureTableViewController *vc = [[RFFeatureTableViewController alloc] initWithNibName:nil bundle:nil];
    vc.feature = feature;
    if (self.navigationController)
    {
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        vc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss:)];
        [self presentViewController:nc animated:YES completion:NULL];
    }
}

@end
