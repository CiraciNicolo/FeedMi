//
//  FMSelectionFeedController.m
//  FeedMi
//
//  Created by Nicolò Ciraci on 17/03/14.
//  Copyright (c) 2014 Nicolò Ciraci. All rights reserved.
//

#import "FMSelectionFeedController.h"
#import "FMFeedTableViewController.h"
#import "FMWelcomeViewController.h"
#import "FMFeedManageController.h"
#import "NCUserDefault.h"
#import "NCAppDelegate.h"
#import "Feed.h"

@interface FMSelectionFeedController ()

@property (nonatomic, strong) NSMutableArray *enabledFeeds;
@property (nonatomic, strong) UIBarButtonItem *left;

@end

@implementation FMSelectionFeedController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        _enabledFeeds = [NSMutableArray new];
        _left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(manageFeeds)];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.title = @"FeedMi";
    [self.navigationItem setLeftBarButtonItem:_left];
    self.navigationItem.title = @"";
    
    _enabledFeeds = [[[NCAppDelegate sharedDelegate] allEndabledFeeds] mutableCopy];
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated {
    
    if (![[NCUserDefault sharedSettings] hadFirstTime]) {
        
        FMWelcomeViewController *welcome = [[FMWelcomeViewController alloc] init];
        [self presentViewController:welcome animated:YES completion:nil];
    }
    
}

-(void)manageFeeds {
    
    FMFeedManageController *manager = [[FMFeedManageController alloc] initWithStyle:UITableViewStylePlain];
    manager.feeds = [[[NCAppDelegate sharedDelegate] allFeeds] mutableCopy];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:manager];
    
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[_enabledFeeds filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.type = %d", section]] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    BOOL ateneoExists = [[_enabledFeeds filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.type = 0"]] count] > 0;
    BOOL dipartimentiExists = [[_enabledFeeds filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.type = 1"]] count] > 0;
    
    if ((ateneoExists && dipartimentiExists) || (ateneoExists && !dipartimentiExists && section == 0) || (!ateneoExists && dipartimentiExists && section == 0)) {
        
        return 30;
    }
    
    return 0;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    BOOL ateneoExists = [[_enabledFeeds filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.type = 0"]] count] > 0;
    BOOL dipartimentiExists = [[_enabledFeeds filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.type = 1"]] count] > 0;
    
    if (ateneoExists && section == 0) {
        
        return @"Ateneo";
    }
    else if ((dipartimentiExists && section == 1) || (!ateneoExists && dipartimentiExists && section == 0)) {
        
        return @"Dipartimenti";
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    view.tintColor = [UIColor colorFromHex:0xf57c00 andAlpha:1];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    Feed *aFeed = [[_enabledFeeds filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.type = %d", indexPath.section]] objectAtIndex:indexPath.row];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell.textLabel setTextColor:[UIColor colorFromHex:0x212121 andAlpha:1]];
    [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [cell.textLabel setText:aFeed.name];
    [cell.textLabel setNumberOfLines:0];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
    
    Feed *aFeed = [[_enabledFeeds filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.type = %d", indexPath.section]] objectAtIndex:indexPath.row];
    FMFeedTableViewController *controller = [[FMFeedTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [controller setFeed:aFeed];
    
    [self.navigationController pushViewController:controller animated:YES];
}

@end
