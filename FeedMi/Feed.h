//
//  Feed.h
//  FeedMi
//
//  Created by Nicolò Ciraci on 17/03/14.
//  Copyright (c) 2014 Nicolò Ciraci. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Feed : NSManagedObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *type;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSNumber *enabled;

@end
