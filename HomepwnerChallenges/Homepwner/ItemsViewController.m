//
//  ItemsViewController.m
//  Homepwner
//
//  Created by Leo Gau on 3/9/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "ItemsViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"

@interface ItemsViewController ()
@property (nonatomic) NSMutableArray *under50;
@property (nonatomic) NSMutableArray *over50;
@end

@implementation ItemsViewController

- (NSMutableArray *)under50
{
    if (!_under50) {
        _under50 = [[NSMutableArray alloc] init];
    }
    return _under50;
}

- (NSMutableArray *)over50
{
    if (!_over50) {
        _over50 = [[NSMutableArray alloc] init];
    }
    return _over50;
}

- (id)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        for (int i = 0; i < 5; i++) {
            BNRItem *item = [[BNRItemStore sharedStore] createItem];
            if (item.valueInDollars < 50) {
                [self.under50 addObject:item];
            } else {
                [self.over50 addObject:item];
            }
        }
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat result = 60.0;
    
    if (indexPath.section == 1 && indexPath.row == [self.over50 count]) {
        result = 44.0;
    }
    
    return result;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section) {
        return [self.over50 count] + 1;
    }
    
    return [self.under50 count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Check for a reusable cell first, use that if it exists
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    // If there is no reusable cell of this type, create a new one
    if (!cell) {
        // Create an instance of UITableViewCell, with default appearance
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    BNRItem *p;
    if (indexPath.section) {
        if (indexPath.row < [self.over50 count]) {
            p = self.over50[indexPath.row];
        }
    } else {
        p = self.under50[indexPath.row];
    }
    
    if (p) {
        cell.textLabel.text = p.description;
        cell.textLabel.font = [UIFont systemFontOfSize:20.0];
    } else {
        cell.textLabel.text = @"No More Items!";
    }

    
    return cell;
}

@end
