//
//  TimeViewController.m
//  HypnoTime
//
//  Created by Leo Gau on 3/9/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "TimeViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TimeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation TimeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"Time";
        self.tabBarItem.image = [UIImage imageNamed:@"Time.png"];
    }
    
    return self;
}

- (IBAction)showCurrentTime:(UIButton *)sender
{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    self.timeLabel.text = [formatter stringFromDate:now];
    
//    [self spinTimeLabel];
    [self bounceTimeLabal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];

    NSLog(@"TimeViewController loaded its view.");
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"CurrentTimeVIewController will appear");
    [super viewWillAppear:animated];
    [self showCurrentTime:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"CurrentTimeViewController will DISappear");
    [super viewWillDisappear:animated];
}

- (void)spinTimeLabel
{
    // Ceate a basic animation
    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    
    spin.delegate = self;
    
    // fromValue is implied
    [spin setToValue:@(M_PI * 2.0)];
    [spin setDuration:1.0];
    
    // Set the timing function
    CAMediaTimingFunction *tf = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    spin.timingFunction = tf;
    
    [self.timeLabel.layer addAnimation:spin forKey:@"spinAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"%@ finished: %d", anim, flag);
}

- (void)bounceTimeLabal
{
    // Create a key frame animation
    CAKeyframeAnimation *bounce = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    // Create the values it will pass through
    CATransform3D forward = CATransform3DMakeScale(1.3, 1.3, 1);
    CATransform3D back = CATransform3DMakeScale(0.7, 0.7, 1);
    CATransform3D forward2 = CATransform3DMakeScale(1.2, 1.2, 1);
    CATransform3D back2 = CATransform3DMakeScale(0.9, 0.9, 1);
    bounce.values = @[ [NSValue valueWithCATransform3D:CATransform3DIdentity],
                       [NSValue valueWithCATransform3D:forward],
                       [NSValue valueWithCATransform3D:back],
                       [NSValue valueWithCATransform3D:forward2],
                       [NSValue valueWithCATransform3D:back2],
                       [NSValue valueWithCATransform3D:CATransform3DIdentity] ];
    
    // Set the duration
    bounce.duration = 0.6;
    
    // Animate the layter
    [self.timeLabel.layer addAnimation:bounce forKey:@"bounceAnimation"];
}

@end
