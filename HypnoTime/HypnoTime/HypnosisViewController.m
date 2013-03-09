//
//  HypnosisViewController.m
//  HypnoTime
//
//  Created by Leo Gau on 3/9/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "HypnosisViewController.h"
#import "HypnosisView.h"

@implementation HypnosisViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Set the tab bar item label
        self.tabBarItem.title = @"Hypnosis";
        self.tabBarItem.image = [UIImage imageNamed:@"Hypno"];
    }
    
    return self;
}

- (void)loadView
{
    // Create a view
    CGRect frame = [[UIScreen mainScreen] bounds];
    HypnosisView *hv = [[HypnosisView alloc] initWithFrame:frame];
    
    // Set it as *the* view of this view controller
    self.view = hv;
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Red", @"Green", @"Blue"]];
    [segmentedControl addTarget:self
                         action:@selector(segmentedControlBtn:)
               forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
}

- (void)segmentedControlBtn:(UISegmentedControl *)sender
{    
    NSInteger selectedIdx = sender.selectedSegmentIndex;
    switch (selectedIdx) {
        case 0:
            [(HypnosisView *)self.view setCircleColor:[UIColor redColor]];
            break;
        case 1:
            [(HypnosisView *)self.view setCircleColor:[UIColor greenColor]];
            break;
        case 2:
            [(HypnosisView *)self.view setCircleColor:[UIColor blueColor]];
            break;
        default:
            break;
    }
}

- (void)viewDidLoad
{
    // Always call the super implementation of viewDidLoad
    [super viewDidLoad];
    
    NSLog(@"HypnosisViewController loaded its view");
}

@end
