//
//  NCAppDelegate.h
//  FeedMi
//
//  Created by Nicolò Ciraci on 14/03/14.
//  Copyright (c) 2014 Nicolò Ciraci. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (instancetype)sharedDelegate;
-(NSArray*)allFeeds;
-(NSArray*)allEndabledFeeds;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
