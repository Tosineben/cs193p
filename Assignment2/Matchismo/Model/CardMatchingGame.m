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
@property (readwrite, nonatomic) int score;
@property (readwrite, nonatomic) NSString *descriptionOfLastFlip;

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
        _matchBonus = 4;
        _mismatchPenalty = 2;
        _flipCost = 1;
    }
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    // if this card is unplayable, do nothing (shouldn't happen)
    if (!card || card.isUnplayable)
    {
        return;
    }
    
    // flip card over
    card.faceUp = !card.isFaceUp;
    
    // only match if it's now face up
    if (!card.isFaceUp)
    {
        return;
    }

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
            
            self.score += matchScore * self.matchBonus;
            self.descriptionOfLastFlip = [NSString stringWithFormat:@"Matched %@ & %@ for %d points",
                                          card, [otherFaceUpCards componentsJoinedByString:@" & "], matchScore * self.matchBonus];
        }
        else
        {
            // no match
            for (Card *otherCard in otherFaceUpCards)
            {
                otherCard.faceUp = NO;
            }
            
            self.score -= self.mismatchPenalty;
            self.descriptionOfLastFlip = [NSString stringWithFormat:@"%@ & %@ don't match! %d point penalty!",
                                          card, [otherFaceUpCards componentsJoinedByString:@" & "], self.mismatchPenalty];
        }
    }
    
    self.score -= self.flipCost;
}

@end
