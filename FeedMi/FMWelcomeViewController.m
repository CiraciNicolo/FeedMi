//
//  FMWelcomeViewController.m
//  FeedMi
//
//  Created by Nicolò Ciraci on 14/03/14.
//  Copyright (c) 2014 Nicolò Ciraci. All rights reserved.
//

#import "FMWelcomeViewController.h"
#import "FMFeedManageController.h"
#import "NCAppDelegate.h"
#import "NCUserDefault.h"
#import "Feed.h"

@interface FMWelcomeViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) FMFeedManageController *feedManager;

@end

@implementation FMWelcomeViewController

-(instancetype)init {
    
    self = [super init];
    if (self) {
        
        _feedManager = [[FMFeedManageController alloc] initWithStyle:UITableViewStylePlain];
        _feedManager.childDelegate = self;
        
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_indicatorView startAnimating];
        
        _textLabel = [[UILabel alloc] init];
        [_textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:28]];
        [_textLabel setTextColor:[UIColor whiteColor]];
        [_textLabel setTextAlignment:NSTextAlignmentCenter];
        [_textLabel setText:@"Importo feed..."];
        
        [self.view setBackgroundColor:[UIColor colorFromHex:0xFF9800 andAlpha:1]];
        [self.view addSubview:_indicatorView];
        [self.view addSubview:_textLabel];
        [self.view addSubview:_feedManager.tableView];
        
    }
    
    return self;
}

-(void)importFromPlist {
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"FEED_RSS" ofType:@"plist"];
    NSArray *totalFeeds = [NSArray arrayWithContentsOfFile:filePath];
    
    for (NSDictionary *feed in totalFeeds) {
        
        Feed *aFeed = [NSEntityDescription insertNewObjectForEntityForName:@"Feed" inManagedObjectContext:[[NCAppDelegate sharedDelegate] managedObjectContext]];
        [aFeed setEnabled:@(NO)];
        [aFeed setName:feed[@"NAME"]];
        [aFeed setType:feed[@"TYPE"]];
        [aFeed setUrl:feed[@"URL"]];
        
        [[[NCAppDelegate sharedDelegate] managedObjectContext] save:nil];
        
    }
    
    [[NCUserDefault sharedSettings] setHadFirstTime:YES];
    _feedManager.feeds = [[[NCAppDelegate sharedDelegate] allFeeds] mutableCopy];
    [_feedManager.tableView reloadData];
    
    [UIView animateWithDuration:0.5f animations:^{
    
        [_textLabel setFrame:CGRectSetOrigin(_textLabel.frame, CGPointMake(0, 20))];
        
        [_indicatorView setFrame:CGRectSetOrigin(_indicatorView.frame, CGPointMake(self.view.center.x - 50/2, -100))];
        [_indicatorView.layer setOpacity:0];
        
        [_feedManager.tableView setFrame:CGRectSetOrigin(_feedManager.tableView.frame, CGPointMake(20, 60))];
        
    } completion:^(BOOL finished) {
        
        [_textLabel setText:@"Seleziona i feed che vuoi seguire"];
        [_textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14]];
        
        [_indicatorView removeFromSuperview];
        
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [_feedManager.tableView setFrame:CGRectMake(20, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame) - 40, CGRectGetHeight(self.view.frame) - 100)];
    [_indicatorView setFrame:CGRectMake(self.view.center.x - 50/2, self.view.center.y - 100, 50, 50)];
    [_textLabel setFrame:CGRectMake(0, self.view.center.y - 20, CGRectGetWidth(self.view.frame), 40)];
}

-(void)viewDidAppear:(BOOL)animated {
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [self importFromPlist];
}

-(void)searchBarBeginEditing:(UISearchBar *)searchBar {
    
    [UIView animateWithDuration:0.3f animations:^{
        
        [_feedManager.tableView setFrame:CGRectSetHeight(_feedManager.tableView.frame, _feedManager.tableView.frame.size.height - 216 + 40)];
    }];
}

-(void)searchBarEndEditing:(UISearchBar *)searchBar {
    
    [UIView animateWithDuration:0.3f animations:^{
        
        [_feedManager.tableView setFrame:CGRectSetHeight(_feedManager.tableView.frame, CGRectGetHeight(self.view.frame) - 100)];
    }];
}

-(void)userDidSelectedDesideredFeeds {
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [self dismissViewControllerAnimated:YES completion:^{
      
        UITableViewController *previousController = (UITableViewController*)[self presentingViewController];
        [[previousController tableView] reloadData];
    }];
}

@end
