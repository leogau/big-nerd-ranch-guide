//
//  TouchDrawView.h
//  TouchTracker
//
//  Created by Leo Gau on 3/14/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Line;
@interface TouchDrawView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic) NSMutableDictionary *linesInProcess;
@property (nonatomic) NSMutableArray *completeLines;
@property (nonatomic, weak) Line *selectedLine;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

- (void)clearAll;
- (Line *)lineAtPoint:(CGPoint)p;

@end
