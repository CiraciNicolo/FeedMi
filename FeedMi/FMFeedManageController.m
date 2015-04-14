//
//  FMFeedManageController.m
//  FeedMi
//
//  Created by Nicolò Ciraci on 17/03/14.
//  Copyright (c) 2014 Nicolò Ciraci. All rights reserved.
//

#import "FMFeedManageController.h"
#import "Feed.h"
#import "NCUserDefault.h"
#import "NCAppDelegate.h"

@interface FMFeedManageController ()

@property (nonatomic, strong) UIBarButtonItem *end;
@property (nonatomic, strong) NSMutableArray *filtered;
@property (nonatomic) BOOL isSearching;

@end

@implementation FMFeedManageController

- (id)initWithStyle:(UITableViewStyle)style {
    
    self = [super initWithStyle:style];
    if (self) {
        
        _end = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(feedsSelected)];
        
        _feeds = [NSMutableArray new];
        _filtered = [NSMutableArray new];
        
        _searchBar = [[UISearchBar alloc] init];
        [_searchBar setDelegate:self];
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self.navigationItem setRightBarButtonItem:_end];
    self.title = @"Gestisci";
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return _searchBar;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return _childDelegate ? 40 : 0;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] init];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 40)];
    [button setTitle:@"Fatto" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor redColor]];
    [button addTarget:self action:@selector(feedsSelected) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:button];
    return view;
}

-(void)feedsSelected {
    
    if (_childDelegate) {
        
        [_childDelegate performSelector:@selector(userDidSelectedDesideredFeeds)];
    }
    else {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if(searchText.length == 0) {
        
        _isSearching = FALSE;
    }
    else {
        
        _isSearching = true;
        _filtered = [[NSMutableArray alloc] init];
        
        for (Feed *feed in _feeds) {
            
            NSRange nameRange = [feed.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound) {
                [_filtered addObject:feed];
            }
        }
    }
    
    [self.tableView reloadData];
    [searchBar becomeFirstResponder];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    [searchBar setShowsCancelButton:YES animated:YES];
    if (_childDelegate) {
        
        [_childDelegate performSelector:@selector(searchBarBeginEditing:) withObject:searchBar];
    }
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    [searchBar setShowsCancelButton:NO animated:YES];
    if (_childDelegate) {
        
        [_childDelegate performSelector:@selector(searchBarEndEditing:) withObject:searchBar];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_isSearching) {
        
        return [_filtered count];
    }
    
    return [_feeds count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    Feed *aFeed;
    
    if (_isSearching) {
        
        aFeed = [_filtered objectAtIndex:indexPath.row];
    }
    else {
        
        aFeed = [_feeds objectAtIndex:indexPath.row];
    }
    
    [cell.textLabel setTextColor:[UIColor colorFromHex:0x212121 andAlpha:1]];
    [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [cell.textLabel setText:aFeed.name];
    [cell.textLabel setNumberOfLines:0];
    [[aFeed enabled] boolValue] ? [cell setAccessoryType:UITableViewCellAccessoryCheckmark] : [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    
    Feed *aFeed;
    
    if (_isSearching) {
        
        aFeed = [_filtered objectAtIndex:indexPath.row];
    }
    else {
        
        aFeed = [_feeds objectAtIndex:indexPath.row];
    }
    
    [aFeed setEnabled:[NSNumber numberWithBool:![[aFeed enabled] boolValue]]];
    [[[NCAppDelegate sharedDelegate] managedObjectContext] save:nil];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
@end
