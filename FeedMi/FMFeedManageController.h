//
//  FMFeedManageController.h
//  FeedMi
//
//  Created by Nicolò Ciraci on 17/03/14.
//  Copyright (c) 2014 Nicolò Ciraci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMFeedManageControllerChildDelegate.h"

@interface FMFeedManageController : UITableViewController <UISearchBarDelegate>

@property (nonatomic, strong) id<FMFeedManageControllerChildDelegate> childDelegate;
@property (nonatomic, strong) NSMutableArray *feeds;
@property (nonatomic, strong) UISearchBar *searchBar;

@end
