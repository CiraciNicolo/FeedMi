//
//  NCFeedCell.m
//  FeedMi
//
//  Created by Nicolò Ciraci on 17/03/14.
//  Copyright (c) 2014 Nicolò Ciraci. All rights reserved.
//

#import "NCFeedCell.h"

@implementation NCFeedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14]];
        [_titleLabel setNumberOfLines:0];
        
        _descriptionLabel = [[UILabel alloc] init];
        [_descriptionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        [_descriptionLabel setNumberOfLines:10];
        [_descriptionLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        
        _dateLabel = [[UILabel alloc] init];
        [_dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:8]];
        
        [self addSubview:_titleLabel];
        [self addSubview:_descriptionLabel];
        [self addSubview:_dateLabel];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    [_titleLabel setFrame:CGRectMake(10, 10, CGRectGetWidth(self.frame) - 20, 25)];
    [_descriptionLabel setFrame:CGRectMake(10, 35, CGRectGetWidth(self.frame) - 20, CGRectGetHeight(self.frame) - 35)];
    [_dateLabel setFrame:CGRectMake(self.frame.size.width - 60, 0, 60, 20)];
}

@end
