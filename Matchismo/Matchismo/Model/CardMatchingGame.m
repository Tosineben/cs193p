//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Alden Quimby on 7/16/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property (strong, nonatomic) NSMutableArray *cards;
@property (nonatomic) int score;
@property (strong, nonatomic) NSString *descriptionOfLastFlip;

@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self)
    {
        for (int i = 0; i < count; i++)
        {
            Card *card = [deck drawRandomCard];
            if (card)
            {
                self.cards[i] = card;
            }
            else
            {
                self = nil; // fail to initialize
            }
        }
    }
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    // if this card is unplayable, do nothing (shouldn't happen)
    if (!card || card.isUnplayable)
    {
        return;
    }
    
    if (card.isFaceUp)
    {
        // if flipping card down, don't say what it was or the game is pointless!
        self.descriptionOfLastFlip = @"Flipped down a card";
    }
    else
    {        
        NSMutableArray *otherFaceUpCards = [[NSMutableArray alloc] init];
        
        for (Card *otherCard in self.cards)
        {
            if (otherCard.isFaceUp && !otherCard.isUnplayable)
            {
                [otherFaceUpCards addObject:otherCard];
            }
        }
        
        // if we don't have enough face up cards yet, do nothing
        if ([otherFaceUpCards count] + 1 != self.numberMatchingCards)
        {
            self.descriptionOfLastFlip = [NSString stringWithFormat:@"Flipped up %@", card];
        }
        else
        {
            int matchScore = [card match:otherFaceUpCards];
            if (matchScore)
            {
                for (Card *otherCard in otherFaceUpCards)
                {
                    otherCard.unplayable = YES;
                }
                card.unplayable = YES;
                
                self.score += matchScore * MATCH_BONUS;
                self.descriptionOfLastFlip = [NSString stringWithFormat:@"Matched %@ & %@ for %d points",
                                              card, [otherFaceUpCards componentsJoinedByString:@" & "], matchScore * MATCH_BONUS];
            }
            else
            {
                // no match
                for (Card *otherCard in otherFaceUpCards)
                {
                    otherCard.faceUp = NO;
                }
                
                self.score -= MISMATCH_PENALTY;
                self.descriptionOfLastFlip = [NSString stringWithFormat:@"%@ & %@ don't match! %d point penalty!",
                                              card, [otherFaceUpCards componentsJoinedByString:@" & "], MISMATCH_PENALTY];
            }
        }
    }
    
    // flip card over
    card.faceUp = !card.isFaceUp;
    self.score -= FLIP_COST;
}

@end
