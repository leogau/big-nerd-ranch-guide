//
//  DetailViewController.h
//  Homepwner
//
//  Created by Leo Gau on 3/10/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRItem;
@interface DetailViewController : UIViewController <UINavigationControllerDelegate,
                                                    UIImagePickerControllerDelegate,
                                                    UITextFieldDelegate,
                                                    UIPopoverControllerDelegate>

- (id)initForNewItem:(BOOL)isNew;

@property (nonatomic) BNRItem *item;
@property (nonatomic, copy) void (^dismissBlock) (void);

@end
