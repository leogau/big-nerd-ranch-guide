//
//  TouchDrawView.m
//  TouchTracker
//
//  Created by Leo Gau on 3/14/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "TouchDrawView.h"
#import "Line.h"

@implementation TouchDrawView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.linesInProcess = [[NSMutableDictionary alloc] init];
        self.completeLines = [[NSMutableArray alloc] init];
        
        self.backgroundColor = [UIColor whiteColor];
        self.multipleTouchEnabled = YES;
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tapRecognizer];
        
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:longPressRecognizer];
        
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveLine:)];
        self.panGestureRecognizer.delegate = self;
        self.panGestureRecognizer.cancelsTouchesInView = NO;
        [self addGestureRecognizer:self.panGestureRecognizer];
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
        CGContextAddLineToPoint(context, line.end.x, line.end.y);
        CGContextStrokePath(context);
    }
    
    // If there is a selected line, draw it
    if (self.selectedLine) {
        [[UIColor greenColor] set];
        CGContextMoveToPoint(context, self.selectedLine.begin.x, self.selectedLine.begin.y);
        CGContextAddLineToPoint(context, self.selectedLine.end.x, self.selectedLine.end.y);
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

- (void)tap:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"Recognized tap");
    
    CGPoint point = [gestureRecognizer locationInView:self];
    self.selectedLine = [self lineAtPoint:point];
    
    // If we just tapped, remove all lines in process
    // so that a tap doesn't result in a new line
    [self.linesInProcess removeAllObjects];
    
    if (self.selectedLine) {
        
        [self becomeFirstResponder];
        
        // Grab the menu controller
        UIMenuController *menu = [UIMenuController sharedMenuController];
        
        // Create a new "delete" UIMenuItem
        UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(deleteLine:)];
        [menu setMenuItems:@[deleteItem]];
        
        // Tell the menu where it should come from and show it
        [menu setTargetRect:CGRectMake(point.x, point.y, 2, 2) inView:self];
        [menu setMenuVisible:YES animated:YES];
    }
    
    [self setNeedsDisplay];
}

- (Line *)lineAtPoint:(CGPoint)p
{
    // Find a line close to p
    for (Line *line in self.completeLines) {
        CGPoint start = line.begin;
        CGPoint end = line.end;
        
        // Check a few points on the line
        for (float t = 0.0; t <= 1.0; t += 0.05) {
            float x = start.x + t * (end.x - start.x);
            float y = start.y + t * (end.y - end.x);
            
            // If the tapped point is within 20 points,
            // let's return this line
            if (hypot(x - p.x, y - p.y) < 20.0) {
                return line;
            }
        }
    }
    
    // If nothing is close enough to the tapped point,
    // then we didn't select a line
    return nil;
}

- (void)deleteLine:(id)sender
{
    // Remove the selected line from the list of completeLines
    [self.completeLines removeObject:self.selectedLine];
    
    // Redraw everything
    [self setNeedsDisplay];
}

- (void)longPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gestureRecognizer locationInView:self];
        self.selectedLine = [self lineAtPoint:point];
        
        if (self.selectedLine) {
            [self.linesInProcess removeAllObjects];
        }
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        self.selectedLine = nil;
    }
    [self setNeedsDisplay];
}

- (void)moveLine:(UIPanGestureRecognizer *)panGestureRecognizer
{
    // If we haven't selected a line, we don't do anything here
    if (!self.selectedLine) return;
    
    // When the pan recognizer changes its position...
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        // How far has the pan moved?
        CGPoint translation = [panGestureRecognizer translationInView:self];
        
        // Add the translation to the current begin and end points of the line
        CGPoint begin = self.selectedLine.begin;
        CGPoint end = self.selectedLine.end;
        begin.x += translation.x;
        begin.y += translation.y;
        end.x += translation.x;
        end.y += translation.y;
        
        // Set the new beginning and end points of the line
        self.selectedLine.begin = begin;
        self.selectedLine.end = end;
        
        // Redraw the line
        [self setNeedsDisplay];
        
        // Reset translation delta start
        [panGestureRecognizer setTranslation:CGPointZero inView:self];
        
    }
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

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return (gestureRecognizer == self.panGestureRecognizer);
}

@end
