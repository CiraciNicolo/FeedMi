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
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:feed.url]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            XCTAssertNotEqual([(NSHTTPURLResponse *)response statusCode], 200, @"Page at URL: %@ not found", response.URL.absoluteString);
        }];
    }];
}

@end
