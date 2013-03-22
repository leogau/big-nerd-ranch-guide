//
//  BNRExecutor.h
//  Blocky
//
//  Created by Leo Gau on 3/21/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRExecutor : NSObject

@property (nonatomic, copy) int (^equation)(int, int);

- (int)computeWithValue:(int)value1 andValue:(int)value2;

@end
