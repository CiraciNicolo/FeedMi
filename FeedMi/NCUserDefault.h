//
//  NCUserDefault.h
//  FeedMi
//
//  Created by Nicolò Ciraci on 14/03/14.
//  Copyright (c) 2014 Nicolò Ciraci. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Feed;

@interface NCUserDefault : NSObject

@property (nonatomic) BOOL hadFirstTime;

+(instancetype)sharedSettings;

@end
