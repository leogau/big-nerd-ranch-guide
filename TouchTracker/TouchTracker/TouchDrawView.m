//
//  TouchDrawView.m
//  TouchTracker
//
//  Created by Leo Gau on 3/14/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "TouchDrawView.h"
#import "Line.h"

@interface TouchDrawView ()

@end

@implementation TouchDrawView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.linesInProcess = [[NSMutableDictionary alloc] init];
        self.completeLines = [[NSMutableArray alloc] init];
        
        self.backgroundColor = [UIColor whiteColor];
        self.multipleTouchEnabled = YES;
    }
    
    return self;
}

#pragma mark - UIView

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 10.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    // Draw complete lines in black
    [[UIColor blackColor] set];
    for (Line *line in self.completeLines) {
        CGContextMoveToPoint(context, line.begin.x, line.begin.y);
        CGContextAddLineToPoint(context, line.end.x, line.end.y);
        CGContextStrokePath(context);
    }
    
    // Draw lines in process in red
    [[UIColor redColor] set];
    for (NSValue *value in self.linesInProcess) {
        Line *line = self.linesInProcess[value];
        CGContextMoveToPoint(context, line.begin.x, line.begin.y);
        CGContextAddLineToPoint(context, line.end.x, line.begin.y);
        CGContextStrokePath(context);
    }
}

#pragma mark - Instance

- (void)clearAll
{
    // Clear the collections
    [self.linesInProcess removeAllObjects];
    [self.completeLines removeAllObjects];
    
    // Redraw
    [self setNeedsDisplay];
}

- (void)endTouches:(NSSet *)touches
{
    // Remove ending touches from dictionary
    for (UITouch *touch in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:touch];
        Line *line = self.linesInProcess[key];
        
        // If this is a double tap, 'line' will be nil
        // so make sure not to add it to the array
        if (line) {
            [self.completeLines addObject:line];
            [self.linesInProcess removeObjectForKey:key];
        }
    }
    
    // Redraw
    [self setNeedsDisplay];
}

#pragma mark - UIResponder

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        // Is this a double tap?
        if ([touch tapCount] > 1) {
            [self clearAll];
            return;
        }
        
        // Use the touch object (packed in an NSValue) as the key
        NSValue *key = [NSValue valueWithNonretainedObject:touch];
        
        // Create a line for the value
        CGPoint loc = [touch locationInView:self];
        Line *newLine = [[Line alloc] init];
        [newLine setBegin:loc];
        [newLine setEnd:loc];
        
        // Put pair in dictionary
        self.linesInProcess[key] = newLine;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Update linesInProcess with moved touches
    for (UITouch *touch in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:touch];
        
        // Find the line for this touch
        Line *line = self.linesInProcess[key];
        
        // Update the line
        CGPoint loc = [touch locationInView:self];
        line.end = loc;
    }
    
    // Redraw
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endTouches:touches];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endTouches:touches];
}

@end
