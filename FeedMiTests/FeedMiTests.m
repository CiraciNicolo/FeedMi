//
//  FeedMiTests.m
//  FeedMiTests
//
//  Created by Nicolò Ciraci on 14/03/14.
//  Copyright (c) 2014 Nicolò Ciraci. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NCAppDelegate.h"
#import "Feed.h"

@interface FeedMiTests : XCTestCase

@end

@implementation FeedMiTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testURLs {
    
    [[[[NCAppDelegate sharedDelegate] allFeeds] mutableCopy] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        Feed *feed = (Feed*)obj;
        NSURLResponse *response;
        NSError *error;
        
        [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:feed.url]] returningResponse:&response error:&error];
        XCTAssertNotEqual([response MIMEType], @"application/rss+xml", @"Page at URL: %@ is not an RSS feed.", response.URL.absoluteString);
    }];
}

@end
