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

#define NUMBER_OF_MATCHING_CARDS 3

- (int)match:(NSArray *)otherCards
{
    if ([otherCards count] != NUMBER_OF_MATCHING_CARDS - 1)
    {
        return 0;
    }
    
    int score = 0;

    NSMutableArray *colors = [[NSMutableArray alloc] init];
    NSMutableArray *symbols = [[NSMutableArray alloc] init];
    NSMutableArray *shadings = [[NSMutableArray alloc] init];
    NSMutableArray *numbers = [[NSMutableArray alloc] init];
    
    [colors addObject:self.color];
    [symbols addObject:self.symbol];
    [shadings addObject:self.shading];
    [numbers addObject:@(self.number)];
    
    for (id otherCard in otherCards)
    {
        if (![otherCard isKindOfClass:[SetCard class]])
        {
            continue;
        }

        SetCard *otherSetCard = (SetCard *)otherCard;
        
        // TODO are there hash sets?
        
        if (![colors containsObject:otherSetCard.color])
            [colors addObject:otherSetCard.color];
        
        if (![symbols containsObject:otherSetCard.symbol])
            [symbols addObject:otherSetCard.symbol];
        
        if (![shadings containsObject:otherSetCard.shading])
            [shadings addObject:otherSetCard.shading];
        
        if (![numbers containsObject:@(otherSetCard.number)])
            [numbers addObject:@(otherSetCard.number)];
    }
    
    if (([colors count] == 1 || [colors count] == NUMBER_OF_MATCHING_CARDS)
        && ([symbols count] == 1 || [symbols count] == NUMBER_OF_MATCHING_CARDS)
        && ([shadings count] == 1 || [shadings count] == NUMBER_OF_MATCHING_CARDS)
        && ([numbers count] == 1 || [numbers count] == NUMBER_OF_MATCHING_CARDS))
    {
        score = 4;
    }
    
    return score;
}

@end
