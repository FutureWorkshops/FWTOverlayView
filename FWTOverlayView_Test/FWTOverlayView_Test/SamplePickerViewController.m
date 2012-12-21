//
//  SamplePickerViewController.m
//  FWGridTableViewController_Test
//
//  Created by Marco Meschini on 7/17/12.
//  Copyright (c) 2012 Futureworkshops. All rights reserved.
//

#import "SamplePickerViewController.h"
#import "ScrollViewController.h"
#import "TableViewController.h"

@interface SamplePickerViewController ()
{
    NSArray *_items;
}
@property (nonatomic, retain) NSArray *items;
@end

@implementation SamplePickerViewController
@synthesize items = _items;

- (void)dealloc
{
    self.items = nil;
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    
    self.title = @"Pick a sample";
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor lightGrayColor];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

#pragma mark - Getters
- (NSArray *)items
{
    if (!self->_items)
        self->_items = [@[
                        [ScrollViewController scrollViewControllerWithContentSize:CGSizeMake(CGRectGetWidth(self.view.frame), 3000.0f) title:@"vertical"],
                        [ScrollViewController scrollViewControllerWithContentSize:CGSizeMake(3000.0f, CGRectGetHeight(self.view.frame)) title:@"horizontal"],
                        [ScrollViewController scrollViewControllerWithContentSize:CGSizeMake(3000.0f, 3000.0f) title:@"vertical+horizontal"],
                        [[[TableViewController alloc] init] autorelease],
                        ] retain];
    
    return self->_items;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    
    UIViewController *vc = [self.items objectAtIndex:indexPath.row];
    cell.textLabel.text = vc.title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = [self.items objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
