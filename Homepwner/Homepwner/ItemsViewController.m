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
#import "HomepwnerItemCell.h"
#import "BNRImageStore.h"
#import "ImageViewController.h"

@interface ItemsViewController ()
@end

@implementation ItemsViewController

- (id)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.navigationItem.title = @"Homepwner";
        
        // Create a new bar button item that will send
        // addNewItem: to ItemsViewController
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        
        // Set this bar button item as the right item in the navigationItem
        self.navigationItem.rightBarButtonItem = bbi;
        self.navigationItem.leftBarButtonItem = [self editButtonItem];
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Load the NIB file
    UINib *nib = [UINib nibWithNibName:@"HomepwnerItemCell" bundle:nil];
    
    // Register this NIB which contians the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"HomepwnerItemCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - IBActions

- (IBAction)addNewItem:(UIButton *)sender
{
    // Create a new BNRItem and add it to the store
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
    
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:YES];
    detailViewController.item = newItem;
    detailViewController.dismissBlock = ^{
        [self.tableView reloadData];
    };
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:NO];
    
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    BNRItem *selectedItem = items[indexPath.row];
    
    // Give detail view controller a pointer to the item object in row
    detailViewController.item = selectedItem;
    
    // Push it onto the top of the navigation controller's stack
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNRItem *p = [[BNRItemStore sharedStore] allItems][indexPath.row];
    
    // Get the new or recycled cell
    HomepwnerItemCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"HomepwnerItemCell"];
    
    cell.controller = self;
    cell.cellTableView = tableView;
    
    // Configure the cell with the BNRItem
    cell.nameLabel.text = p.itemName;
    cell.serialNumberLabel.text = p.serialNumber;
    cell.valueLabel.text = [NSString stringWithFormat:@"%d", p.valueInDollars];
    if (p.valueInDollars > 50) {
        cell.valueLabel.textColor = [UIColor greenColor];
    } else {
        cell.valueLabel.textColor = [UIColor redColor];
    }

    cell.thumbnailView.image = p.thumbnail;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If the table view is asking to commit a delete command...
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BNRItemStore *ps = [BNRItemStore sharedStore];
        NSArray *items = [ps allItems];
        BNRItem *p = items[indexPath.row];
        [ps removeItem:p];
        
        // We also remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

#pragma mark - Instance

- (void)showImage:(id)sender atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Going to show the image for %@", indexPath);
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        // Get the item for the index path
        BNRItem *item = [[BNRItemStore sharedStore] allItems][indexPath.row];
        NSString *imageKey = item.imageKey;
        
        // If there is no image, we don't need to display anything
        UIImage *img = [[BNRImageStore sharedStore] imageForKey:imageKey];
        if (!img) return;
        
        // Make a rectangle that the frame of the button relative to
        // our table view
        CGRect rect = [self.view convertRect:[sender bounds] fromView:sender];
        
        // Create a new ImageViewController and set its image
        ImageViewController *ivc = [[ImageViewController alloc] init];
        ivc.image = img;
        
        // Present a 600x600 popover from the rect
        self.imagePopover = [[UIPopoverController alloc] initWithContentViewController:ivc];
        self.imagePopover.delegate = self;
        self.imagePopover.popoverContentSize = CGSizeMake(600, 600);
        [self.imagePopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

#pragma mark - UIPopoverController

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self.imagePopover dismissPopoverAnimated:YES];
    self.imagePopover = nil;
}

@end
