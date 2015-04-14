//
//  FMFeedTableViewController.m
//  FeedMi
//
//  Created by Nicolò Ciraci on 14/03/14.
//  Copyright (c) 2014 Nicolò Ciraci. All rights reserved.
//

#import "FMFeedTableViewController.h"
#import "NCFeedCell.h"
#import "Feed.h"
#import "FMFeedViewController.h"
#import "NSString+NCString.h"

@interface FMFeedTableViewController ()

@property (nonatomic, strong) NSMutableArray *feeds;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *downlaodedData;
@property (nonatomic, strong) NSXMLParser *parser;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic) BOOL canParseItem;
@property (nonatomic, strong) NSString *lastItem;
@property (nonatomic, strong) UIActivityIndicatorView *loading;

@end

@implementation FMFeedTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    
    self = [super initWithStyle:style];
    if (self) {
        
        _feeds = [NSMutableArray new];
        _canParseItem = NO;
        
        _errorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_errorLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20]];
        [_errorLabel setTextAlignment:NSTextAlignmentCenter];
        [_errorLabel setTextColor:[UIColor colorWithWhite:0.4 alpha:1]];
        [_errorLabel setHidden:YES];
        
        _loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_loading startAnimating];
        
        [self.tableView registerClass:[NCFeedCell class] forCellReuseIdentifier:@"Cell"];
        [self.tableView addSubview:_errorLabel];
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
 
    self.title = _feed.name;
    [_errorLabel setFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), CGRectGetHeight(self.tableView.frame))];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:_loading]];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [_connection cancel];
    [_parser abortParsing];
}

-(void)setFeed:(Feed *)feed {
    
    _feed = feed;
    [_feeds removeAllObjects];
    [self.tableView reloadData];
    
    
    if (_connection) [_connection cancel];
    if (_parser) [_parser abortParsing];
    _downlaodedData = [NSMutableData data];
    
    _connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_feed.url]] delegate:self];
    [_connection start];

}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [_downlaodedData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    _parser = [[NSXMLParser alloc] initWithData:_downlaodedData];
    [_parser setDelegate:self];
    [_parser parse];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [_loading stopAnimating];
    [_errorLabel setText:[error localizedFailureReason]];
    [_errorLabel setHidden:NO];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    if ([elementName isEqualToString:@"item"]) {
        
        [_feeds addObject:[NSMutableDictionary new]];
        _canParseItem = YES;
    }
    else if (_canParseItem && ([elementName isEqualToString:@"title"] || [elementName isEqualToString:@"link"] || [elementName isEqualToString:@"description"] || [elementName isEqualToString:@"pubDate"])) {
        
        [[_feeds lastObject] setObject:@"" forKey:elementName];
        _lastItem = elementName;
        _canParseItem = YES;
    }
    else {
        _canParseItem = NO;
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {

    if (_canParseItem && [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] != 0) {
        
        if ([_lastItem isEqualToString:@"pubDate"]) {
            
            NSDate *dateFromString = [self dateFromString:string];
            dateFromString ? [[_feeds lastObject] setObject:dateFromString forKey:_lastItem] : [[_feeds lastObject] setObject:[[[_feeds lastObject] objectForKey:_lastItem] stringByAppendingString:[string stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]]] forKey:_lastItem];
        }
        else {
            
            [[_feeds lastObject] setObject:[[[_feeds lastObject] objectForKey:_lastItem] stringByAppendingString:string] forKey:_lastItem];
        }
        
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if (_canParseItem && ([_lastItem isEqualToString:@"title"] || [_lastItem isEqualToString:@"description"]) && [_feeds count] > 0) {
        
        NSString *totalString = [[[_feeds lastObject] objectForKey:_lastItem] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            totalString = [[[totalString stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, totalString.length)] stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "] stringByStrippingHTML];
        [[_feeds lastObject] setObject:totalString forKey:_lastItem];
        
    }
}

-(NSDate *)dateFromString:(NSString*)string {
    
    NSError *error = NULL;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:(NSTextCheckingTypes)NSTextCheckingTypeDate error:&error];
    
    NSArray *matches = [detector matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    for (NSTextCheckingResult *match in matches) {
        if ([match resultType] == NSTextCheckingTypeDate) {
            
            return [match date];
        }
    }
    
    return nil;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    
    [_loading stopAnimating];
    [_errorLabel setText:@"Si è verificato un errore."];
    [_errorLabel setHidden:NO];
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
    
    [_loading stopAnimating];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_feeds count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary *feed = [_feeds objectAtIndex:indexPath.row];
    
    CGRect titleRect = [feed[@"title"] boundingRectWithSize:CGSizeMake(self.tableView.frame.size.width - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:14]} context:nil];
    CGRect descriptionRect = [[feed[@"description"] stringByStrippingHTML] boundingRectWithSize:CGSizeMake(self.tableView.frame.size.width - 20, 120) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:12]} context:nil];
    
    return CGRectGetHeight(titleRect) + CGRectGetHeight(descriptionRect) + 35;
}

- (NCFeedCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    NCFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if (!cell) {
        
        cell = [[NCFeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [cell.titleLabel setTextColor:[UIColor colorFromHex:0x212121 andAlpha:1]];
    [cell.descriptionLabel setTextColor:[UIColor colorFromHex:0x727272 andAlpha:1]];
    [cell.dateLabel setTextColor:[UIColor colorFromHex:0x727272 andAlpha:1]];
    
    NSDictionary *feed = [_feeds objectAtIndex:indexPath.row];
    [cell.titleLabel setText:feed[@"title"]];
    [cell.descriptionLabel setText:feed[@"description"]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [cell.dateLabel setText:[formatter stringFromDate:feed[@"pubDate"]]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
    FMFeedViewController *feedController = [[FMFeedViewController alloc] initWithFeed:[_feeds objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:feedController animated:true];
}

@end
