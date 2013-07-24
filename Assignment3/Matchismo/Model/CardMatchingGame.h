//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Alden Quimby on 7/16/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

// designated initializer
- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck;

- (void)flipCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (void)removeCardAtIndex:(NSUInteger)index;
- (void)drawNewCard;

- (NSArray *)matchingCards;

@property (nonatomic) int score;
@property (nonatomic, readwrite) int numberMatchingCards;
@property (nonatomic, readonly) NSString *descriptionOfLastFlip;
@property (nonatomic) BOOL deckIsEmpty;
@property (nonatomic) int numberOfCards;

// settings
@property (nonatomic) int matchBonus;
@property (nonatomic) int mismatchPenalty;
@property (nonatomic) int flipCost;

@end
