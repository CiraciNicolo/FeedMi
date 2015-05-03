//
//  FMFeedTableViewController.h
//  FeedMi
//
//  Created by Nicolò Ciraci on 14/03/14.
//  Copyright (c) 2014 Nicolò Ciraci. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Feed;

@interface FMFeedTableViewController : UITableViewController <NSURLConnectionDataDelegate, NSXMLParserDelegate>

@property (nonatomic, strong) Feed *feed;

@end
