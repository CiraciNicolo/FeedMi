//
//  FMFeedViewController.m
//  FeedMi
//
//  Created by Nicolò Ciraci on 14/04/15.
//  Copyright (c) 2015 Nicolò Ciraci. All rights reserved.
//

#import "FMFeedViewController.h"

@interface FMFeedViewController ()

@property (strong, nonatomic) NSDictionary *feed;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (strong, nonatomic) UIBarButtonItem *share;

@end

@implementation FMFeedViewController

-(instancetype)initWithFeed:(NSDictionary*)feed {
    
    if (self = [super init]) {
        
        _feed = [feed copy];
        
        _textView = [[UITextView alloc] initWithFrame:CGRectZero];
        _textView.editable = false;
        [_textView setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
        [_textView setTextColor:[UIColor colorFromHex:0x727272 andAlpha:1]];
        _textView.contentInset = UIEdgeInsetsZero;
        [_textView setText:_feed[@"description"]];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18]];
        [_titleLabel setTextColor:[UIColor colorFromHex:0x212121 andAlpha:1]];
        [_titleLabel setNumberOfLines:0];
        [_titleLabel setText:_feed[@"title"]];
        
        _dateLabel = [[UILabel alloc] init];
        [_dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:8]];
        [_dateLabel setTextColor:[UIColor colorFromHex:0x727272 andAlpha:1]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [_dateLabel setText:[formatter stringFromDate:feed[@"pubDate"]]];
        
        _share = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
        
        self.view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_textView];
        [self.view addSubview:_titleLabel];
        [self.view addSubview:_dateLabel];
    }
    
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self.navigationItem setRightBarButtonItem:_share];
    self.title = @"Dettagli";
}

-(void)viewWillLayoutSubviews {
    
    CGRect titleRect = [_feed[@"title"] boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:18]} context:nil];
    
    [_titleLabel setFrame:CGRectMake(10, 20, titleRect.size.width, titleRect.size.height)];
    [_textView setFrame:CGRectMake(10, 20 + titleRect.size.height, self.view.frame.size.width - 20, self.view.frame.size.height - titleRect.size.height - 20)];
    [_dateLabel setFrame:CGRectMake(self.view.frame.size.width - 60, 0, 60, 20)];
}

-(void)share:(id)sender {
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[[NSURL URLWithString:_feed[@"link"]]] applicationActivities:nil];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        activityViewController.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
    }
    [self.navigationController presentViewController:activityViewController animated:YES completion:nil];
}

@end
