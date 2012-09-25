//
//  SamplePickerViewController.m
//  FWGridTableViewController_Test
//
//  Created by Marco Meschini on 7/17/12.
//  Copyright (c) 2012 Futureworkshops. All rights reserved.
//

#import "SamplePickerViewController.h"

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
                        @"ViewController",
                        @"TableViewController",
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
    
    cell.textLabel.text = [self.items objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *className = [self.items objectAtIndex:indexPath.row];
    UIViewController *vc = [[[NSClassFromString(className) alloc] init] autorelease];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
