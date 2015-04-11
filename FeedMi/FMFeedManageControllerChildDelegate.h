//
//  FMFeedManageControllerChildDelegate.h
//  FeedMi
//
//  Created by Nicolò Ciraci on 17/03/14.
//  Copyright (c) 2014 Nicolò Ciraci. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FMFeedManageControllerChildDelegate <NSObject>

-(void)searchBarBeginEditing:(UISearchBar*)searchBar;
-(void)searchBarEndEditing:(UISearchBar*)searchBar;
-(void)userDidSelectedDesideredFeeds;


@end
