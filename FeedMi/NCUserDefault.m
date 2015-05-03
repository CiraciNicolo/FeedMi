//
//  NCUserDefault.m
//  FeedMi
//
//  Created by Nicolò Ciraci on 14/03/14.
//  Copyright (c) 2014 Nicolò Ciraci. All rights reserved.
//

#import "NCUserDefault.h"

#define kHFT @"kHadFirstTime"

@implementation NCUserDefault

+(NSUserDefaults*)sharedUserDefault {
    
    static NSUserDefaults *sharedUserDefault = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedUserDefault = [NSUserDefaults standardUserDefaults];
    });
    
    return sharedUserDefault;
}

+(instancetype)sharedSettings {
    
    static NCUserDefault *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        shared = [[NCUserDefault alloc] init];
    });
    
    return shared;
}

-(BOOL)hadFirstTime {
    
    return [[NCUserDefault sharedUserDefault] boolForKey:kHFT];
}

-(void)setHadFirstTime:(BOOL)hadFirstTime {
    
    [[NCUserDefault sharedUserDefault] setBool:hadFirstTime forKey:kHFT];
    [[NCUserDefault sharedUserDefault] synchronize];
}

@end
