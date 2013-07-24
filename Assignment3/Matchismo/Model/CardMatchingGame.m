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
@property (readwrite, nonatomic) NSString *descriptionOfLastFlip;
@property (strong, nonatomic) Deck *deck;

@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (int)numberOfCards
{
    return [self.cards count];
}

- (BOOL)deckIsEmpty
{
    return !self.deck.numberOfCardsInDeck;
}

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self)
    {
        _deck = deck;
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
    
    NSMutableArray *otherFaceUpCards = [[NSMutableArray alloc] init];
    for (Card *otherCard in self.cards)
    {
        if (otherCard.isFaceUp && !otherCard.isUnplayable)
        {
            [otherFaceUpCards addObject:otherCard];
        }
    }
    
    // flip card over
    card.faceUp = !card.isFaceUp;
    
    // only match if it's now face up
    if (!card.isFaceUp)
    {
        self.descriptionOfLastFlip = @"";
        return;
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

- (BOOL)validCombination:(NSArray *)combination
{
    for (NSNumber *i in combination)
    {
        Card *card = self.cards[[i intValue]];
        if (card.isUnplayable)
        {
            return NO;
        }
    }
    return YES;
}

- (NSArray *)cardsFromCombination:(NSArray *)combination
                   startWithIndex:(int)start
{
    NSMutableArray *cards = [[NSMutableArray alloc] init];
    for (int i = start; i < [combination count]; i++)
    {
        [cards addObject:self.cards[[combination[i] intValue]]];
    }
    return cards;
}

- (NSArray *)cardsFromCombination:(NSArray *)combination
{
    return [self cardsFromCombination:combination startWithIndex:0];
}

- (NSArray *)otherCardsFromCombination:(NSArray *)combination
{
    return [self cardsFromCombination:combination startWithIndex:1];
}

- (NSArray *)nextCombinationAfter:(NSArray *)combination
{
    NSMutableArray *next = [combination mutableCopy];
    
    int n = [self.cards count];
    int k = self.numberMatchingCards;
    int i = k - 1;
    
    next[i] = @([next[i] intValue] + 1);
    while ((i > 0) && ([next[i] intValue] > n - k + i))
    {
        i--;
        next[i] = @([next[i] intValue] + 1);
    }
    
    if ([next[0] intValue] > n - k)
    {
        return nil;
    }
    
    for (i = i + 1; i < k; i++)
    {
        next[i] = @([next[i - 1] intValue] + 1);
    }
    
    return next;
}

- (NSArray *)matchingCards
{
    NSMutableArray *combination = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.numberMatchingCards; i++)
    {
        [combination addObject:@(i)];
    }
    
    NSArray *matchedCards;
    
    NSArray *nextCombo = combination;
    while (nextCombo)
    {
        if (![self validCombination:nextCombo])
        {
            continue;
        }
        if ([self.cards[[nextCombo[0] intValue]] match:[self otherCardsFromCombination:nextCombo]])
        {
            matchedCards = [self cardsFromCombination:nextCombo];
            break;
        }
        nextCombo = [self nextCombinationAfter:nextCombo];
    }
    
    return matchedCards;
}

- (void)removeCardAtIndex:(NSUInteger)index
{
    [self.cards removeObjectAtIndex:index];
}

- (void)drawNewCard
{
    Card *card = [self.deck drawRandomCard];
    if (card)
    {
        [self.cards addObject:card];
    }
}

@end
