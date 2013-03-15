//
//  TouchDrawView.h
//  TouchTracker
//
//  Created by Leo Gau on 3/14/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TouchDrawView : UIView

- (void)clearAll;

@property (nonatomic) NSMutableDictionary *linesInProcess;
@property (nonatomic) NSMutableArray *completeLines;

@end
