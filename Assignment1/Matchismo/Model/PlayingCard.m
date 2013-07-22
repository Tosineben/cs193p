//
//  PlayingCard.m
//  Matchismo
//
//  Created by Alden Quimby on 7/16/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (NSString *)contents
{
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit])
    {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

// only matches if 1 or 2 other cards
- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([otherCards count] == 1)
    {
        PlayingCard *otherCard = [otherCards lastObject];
        
        // MEDIUM MATCH
        
        // rank match is worth 4x suit match
        if ([otherCard.suit isEqualToString:self.suit])
        {
            score = 2;
        }
        else if (otherCard.rank == self.rank)
        {
            score = 8;
        }
    }
    else if ([otherCards count] == 2)
    {
        PlayingCard *otherCard1 = [otherCards objectAtIndex:0];
        PlayingCard *otherCard2 = [otherCards objectAtIndex:1];
        
        // HARD MATCH
        
        if ([otherCard1.suit isEqualToString:self.suit] &&
            [otherCard2.suit isEqualToString:self.suit])
        {
            score = 4;
        }
        else if (otherCard1.rank == self.rank &&
                 otherCard2.rank == self.rank)
        {
            score = 16;
        }
        
        // EASY MATCH
        
        else if ([otherCard1.suit isEqualToString:self.suit] ||
                 [otherCard2.suit isEqualToString:self.suit] ||
                 [otherCard1.suit isEqualToString:otherCard2.suit])
        {
            score = 1;
        }
        else if (otherCard1.rank == self.rank ||
                 otherCard2.rank == self.rank ||
                 otherCard1.rank == otherCard2.rank)
        {
            score = 4;
        }
    }
    
    return score;
}

+ (NSArray *)validSuits
{
    static NSArray *validSuits = nil;
    if (!validSuits) validSuits = @[@"♠", @"♣", @"♥", @"♦"];
    return validSuits;
}

+ (NSArray *)rankStrings
{
    static NSArray *rankStrings = nil;
    if (!rankStrings) rankStrings = @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
    return rankStrings;
}

+ (NSUInteger)maxRank
{
    return [self rankStrings].count - 1;
}

@end
