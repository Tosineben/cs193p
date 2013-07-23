//
//  SetCard.m
//  Matchismo
//
//  Created by Alden Quimby on 7/22/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

@synthesize color = _color, symbol = _symbol, shading = _shading;

- (NSString *)color
{
    return _color ? _color : @"?";
}

- (void)setColor:(NSString *)color
{
    if ([[SetCard validColors] containsObject:color])
    {
        _color = color;
    }
}

- (NSString *)symbol
{
    return _symbol ? _symbol : @"?";
}

- (void)setSymbol:(NSString *)symbol
{
    if ([[SetCard validSymbols] containsObject:symbol])
    {
        _symbol = symbol;
    }
}

- (NSString *)shading
{
    return _shading ? _shading : @"?";
}

- (void)setShading:(NSString *)shading
{
    if ([[SetCard validShadings] containsObject:shading])
    {
        _shading = shading;
    }
}

+ (NSArray *)validColors
{
    static NSArray *valid = nil;
    if (!valid) valid = @[@"red", @"green", @"purple"];
    return valid;
}

+ (NSArray *)validSymbols
{
    static NSArray *valid = nil;
    if (!valid) valid = @[@"oval", @"squiggle", @"diamond"];
    return valid;
}

+ (NSArray *)validShadings
{
    static NSArray *valid = nil;
    if (!valid) valid = @[@"solid", @"open", @"striped"];
    return valid;
}

+ (NSUInteger)maxNumber
{
    return 3;
}

- (NSString *)contents
{
    return [NSString stringWithFormat:@"%@:%@:%@:%d", self.symbol, self.color, self.shading, self.number];
}

- (int)match:(NSArray *)otherCards
{
    return [super match:otherCards]; // TODO
}

@end
