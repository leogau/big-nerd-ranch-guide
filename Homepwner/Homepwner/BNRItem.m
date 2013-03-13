//
//  BNRItem.m
//  RandomPossessions
//
//  Created by Leo Gau on 3/6/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "BNRItem.h"

@interface BNRItem ()
@property (nonatomic, strong) NSDate *dateCreated;
@end


@implementation BNRItem

+ (id)randomItem
{
    // Create an array of three adjectives
    NSArray *randomAdjectiveList = @[@"Fluffy", @"Rusty", @"Shiny"];
    
    // Create an array of three nouns
    NSArray *randomNounList = @[@"Bear", @"Spork", @"Mac"];
    
    // Get the index of a random adjective/noun from the lists
    // NOTE: The % operator, called the modulo operator, give you the remainder.
    // So adjectiveIndex is a random number from 0 to 2 inclusive
    NSInteger adjectiveIndex = rand() % [randomAdjectiveList count];
    NSInteger nounIndex = rand() % [randomNounList count];
    
    // NOTE: NSInteger is not an object, but a type definition for "unsigned long"
    NSString *randomName = [NSString stringWithFormat:@"%@ %@", randomAdjectiveList[adjectiveIndex], randomNounList[nounIndex]];
    int randomValue = rand() % 100;
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                    '0' + rand() % 10,
                                    'A' + rand() % 25,
                                    '0' + rand() % 10,
                                    'A' + rand() % 26,
                                    '0' + rand() % 10];
    
    return [[self alloc] initWithItemName:randomName valueInDollars:randomValue serialNumber:randomSerialNumber];
}

- (void)setContainedItem:(BNRItem *)containedItem
{
    _containedItem = containedItem;
    
    // When given an item to contain, the contained
    // item will be given a pointer to its container
    containedItem.container = self;
}

- (id)init
{
    return [self initWithItemName:@"Item" valueInDollars:0 serialNumber:@""];
}

- (id)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber
{
    // Call the superclass's designated initializer
    self = [super init];
    // Did the superclass's designated initializer succeed?
    if (self) {
        // Give the instance variables initial values
        self.itemName = name;
        self.serialNumber = sNumber;
        self.valueInDollars = value;
        self.dateCreated = [[NSDate alloc] init];
    }
    
    // Return the address of the newly initialized object
    return self;
}

- (id)initWithItemName:(NSString *)name serialNumber:(NSString *)sNumber
{
    return [self initWithItemName:name valueInDollars:0 serialNumber:sNumber];
}

- (void)dealloc
{
    NSLog(@"dealloc %@", self);
}

- (NSString *)description
{
    NSString *description = [[NSString alloc] initWithFormat:@"%@ (%@): Worth %d, recorded on %@", self.itemName, self.serialNumber, self.valueInDollars, self.dateCreated];
    return description;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.itemName forKey:@"itemName"];
    [aCoder encodeObject:self.serialNumber forKey:@"serialNumber"];
    [aCoder encodeObject:self.dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:self.imageKey forKey:@"imageKey"];
    
    [aCoder encodeInt:self.valueInDollars forKey:@"valueInDollars"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.itemName = [aDecoder decodeObjectForKey:@"itemName"];
        self.serialNumber = [aDecoder decodeObjectForKey:@"serialNumber"];
        self.dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        self.imageKey = [aDecoder decodeObjectForKey:@"imageKey"];
        
        self.valueInDollars = [aDecoder decodeIntForKey:@"valueInDollars"];
    }
    
    return self;
}

@end
