//
//  TableViewController.m
//  FWTOverlayView_Test
//
//  Created by Marco Meschini on 25/09/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "TableViewController.h"
#import "OverlayView.h"
#import "UITableView+FWTOverlayView.h"
#import <QuartzCore/QuartzCore.h>

@interface Item : NSObject
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *dateString;
@property (nonatomic, retain) NSString *timeString;
@end

@implementation Item

- (void)dealloc
{
    self.timeString = nil;
    self.date = nil;
    self.dateString = nil;
    [super dealloc];
}

@end

@interface TableViewController ()
@property (nonatomic, retain) NSArray *data;
@end

@implementation TableViewController
@synthesize data = _data;

- (void)dealloc
{
    self.data = nil;
    [super dealloc];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.title = @"table";
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.tableView.backgroundColor = [UIColor colorWithWhite:.8f alpha:1.0f];
    
    UIView *overlayView = [[[OverlayView alloc] initWithFrame:CGRectMake(.0f, .0f, 80.0f, 34.0f)] autorelease];
    self.tableView.fwt_overlayView = overlayView;
    self.tableView.fwt_overlayViewEdgeInsets = (UIEdgeInsets){2.0f, 2.0f, 2.0f, 10.0f};
    self.tableView.fwt_overlayViewFlexibleMargin = UIViewAutoresizingFlexibleLeftMargin;
    
    __block typeof(overlayView) weakOverlayView = overlayView;
    self.tableView.fwt_layoutBlock = ^(BOOL animated){
        if (animated)
        {
            //
            CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
            opacity.fromValue = @.0f;
            opacity.toValue = @1.0f;
            
            CABasicAnimation *translation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
            translation.fromValue = @40;
            
            CAAnimationGroup *group = [CAAnimationGroup animation];
            group.animations = @[opacity, translation];
            group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
            weakOverlayView.layer.opacity = 1.0f;
            [weakOverlayView.layer addAnimation:group forKey:@"groupAnimation"];
        }
        else
        {
            weakOverlayView.layer.opacity = 1.0f;
        }
    };

    self.tableView.fwt_dismissBlock = ^(){
        //
        CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacity.fromValue = @1.0f;
        opacity.toValue = @.0f;
        
        CABasicAnimation *translation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
        translation.toValue = @40;
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.animations = @[opacity, translation];
        group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        weakOverlayView.layer.opacity = .0f;
        [weakOverlayView.layer addAnimation:group forKey:@"groupAnimation"];
    };
}

#pragma mark - Getters
- (NSArray *)data
{
    if (!self->_data)
    {
        NSInteger count = 100;
        NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:count];
        NSDateFormatter *dfTime = [[[NSDateFormatter alloc] init] autorelease];
        dfTime.calendar = [NSCalendar currentCalendar];
        dfTime.timeStyle = NSDateFormatterShortStyle;
        NSDateFormatter *dfDate = [[[NSDateFormatter alloc] init] autorelease];
        dfDate.calendar = [NSCalendar currentCalendar];
        dfDate.dateStyle = NSDateFormatterShortStyle;
        
        for (unsigned i=0; i<count; i++)
        {
            NSDate *date = [[self class] randomTimelineDateWithIndex:i];
        
            Item *item = [[Item alloc] init];
            item.date = date;
            item.timeString = [dfTime stringFromDate:date];
            item.dateString = [dfDate stringFromDate:date];
            
            [tmp addObject:item];
            
            [item release];
        }
        
        self->_data = [[NSArray alloc] initWithArray:tmp];
    }
    
    return self->_data;
}

+ (NSDate *)randomTimelineDateWithIndex:(NSInteger)index
{
    NSTimeInterval interval = (86400*.5f)*index;
    NSInteger random = (arc4random()%((NSInteger)(863*.5f)))+1;
    interval += (random*100);
    return [NSDate dateWithTimeIntervalSinceNow:-interval];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    
    Item *item = [self.data objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"row:%i, %@", indexPath.row, item.timeString];
    cell.detailTextLabel.text = item.dateString;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@", indexPath);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    Item *item = [self.data objectAtIndex:self.tableView.fwt_overlayViewIndexPath.row];
    OverlayView *overlayView = (OverlayView *)scrollView.fwt_overlayView;
    overlayView.textLabel.text = item.timeString;
    overlayView.detailTextLabel.text = item.dateString;
}

@end
