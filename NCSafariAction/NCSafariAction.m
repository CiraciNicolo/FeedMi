//
//  NCSafariAction.m
//
//  Created by Nicolò Ciraci on 16/04/15.
//  Copyright (c) 2015 Nicolò Ciraci. All rights reserved.
//

#import "NCSafariAction.h"

@interface NCSafariAction ()

@property (nonatomic, strong) NSURL *url;

@end

@implementation NCSafariAction

+ (UIActivityCategory)activityCategory {
    
    return UIActivityCategoryAction;
}

- (NSString *)activityType {
    
    return NSStringFromClass([self class]);
}

- (NSString *)activityTitle {
    
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:NSStringFromClass([self class]) withExtension:@"bundle"]];
    return NSLocalizedStringFromTableInBundle(@"Open in Safari", NSStringFromClass([self class]), bundle, nil);
}

- (UIImage *)activityImage {
    
    return [UIImage imageNamed:@"NCSafariAction.bundle/NCSafariActionIcon"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    
    NSArray *urls = [activityItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.class = %@" argumentArray:@[[NSURL class]]]];
    if ([urls count]) {
        
        return [[UIApplication sharedApplication] canOpenURL:[urls firstObject]];
    }
    
    return false;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    
    NSArray *urls = [activityItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.class = %@" argumentArray:@[[NSURL class]]]];
    _url = [urls firstObject];
}

- (void)performActivity {
    
    if (_url) {
        
        [self activityDidFinish:[[UIApplication sharedApplication] openURL:_url]];
    }
    else {
        
        [self activityDidFinish:false];
    }
}

@end
