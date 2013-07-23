//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Alden Quimby on 7/22/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "SetGameViewController.h"
#import "GameResult.h"
#import "SetCard.h"
#import "SetCardDeck.h"

@implementation SetGameViewController

@synthesize game = _game, gameResult = _gameResult;

- (CardMatchingGame *)game
{
    if (!_game)
    {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[[SetCardDeck alloc] init]];
        _game.numberMatchingCards = 3;
        _game.matchBonus = self.gameSettings.matchBonus;
        _game.mismatchPenalty = self.gameSettings.mismatchPenalty;
        _game.flipCost = self.gameSettings.flipCost;
    }
    return _game;
}

- (GameResult *)gameResult
{
    if (!_gameResult) _gameResult = [[GameResult alloc] init];
    _gameResult.gameType = @"Set Game";
    return _gameResult;
}

- (NSAttributedString *)updateAttributedString:(NSAttributedString *)attributedString
                          withAttributesOfCard:(SetCard *)card
{
    NSMutableAttributedString *mutableAttributedString = [attributedString mutableCopy];
    
    NSRange range = [[mutableAttributedString string] rangeOfString:card.contents];
    
    if (range.location != NSNotFound)
    {
        NSString *symbol = @"?";
        
        if ([card.symbol isEqualToString:@"oval"]) symbol = @"●";
        else if ([card.symbol isEqualToString:@"squiggle"]) symbol = @"▲";
        else if ([card.symbol isEqualToString:@"diamond"]) symbol = @"■";
        
        NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
        
        if ([card.color isEqualToString:@"red"])
            [attributes setObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
        else if ([card.color isEqualToString:@"green"])
            [attributes setObject:[UIColor greenColor] forKey:NSForegroundColorAttributeName];
        else if ([card.color isEqualToString:@"purple"])
            [attributes setObject:[UIColor purpleColor] forKey:NSForegroundColorAttributeName];
        
        if ([card.shading isEqualToString:@"solid"])
            [attributes setObject:@-5 forKey:NSStrokeWidthAttributeName];
        else if ([card.shading isEqualToString:@"striped"])
            [attributes addEntriesFromDictionary:@{
                     NSStrokeWidthAttributeName : @-5,
                     NSStrokeColorAttributeName : attributes[NSForegroundColorAttributeName],
                 NSForegroundColorAttributeName : [attributes[NSForegroundColorAttributeName] colorWithAlphaComponent:0.1]
             }];
        else if ([card.shading isEqualToString:@"open"])
            [attributes setObject:@5 forKey:NSStrokeWidthAttributeName];
        
        symbol = [symbol stringByPaddingToLength:card.number withString:symbol startingAtIndex:0];
        
        [mutableAttributedString replaceCharactersInRange:range
                                     withAttributedString:[[NSAttributedString alloc] initWithString:symbol
                                                                                          attributes:attributes]];
    }
    
    return mutableAttributedString;
}

- (void)updateUI
{
    NSString *lastFlipText = self.game.descriptionOfLastFlip ? self.game.descriptionOfLastFlip : @"";
    NSAttributedString *lastFlip = [[NSAttributedString alloc] initWithString:lastFlipText];
    
    for (UIButton *cardButton in self.cardButtons)
    {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:card.contents];
        
        if ([card isKindOfClass:[SetCard class]])
        {
            SetCard *setCard = (SetCard *)card;
            title = [self updateAttributedString:title withAttributesOfCard:setCard];
            lastFlip = [self updateAttributedString:lastFlip withAttributesOfCard:setCard];
        }
        
        [cardButton setAttributedTitle:title forState:UIControlStateNormal];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        
        // completely remove unplayable cards
        cardButton.alpha = card.isUnplayable ? 0.0 : 1.0;
        
        if (card.isFaceUp)
        {
            [cardButton setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1.0]];
        }
        else
        {
            [cardButton setBackgroundColor:[UIColor clearColor]];
        }
    }
    
    [super updateUI];
    
    self.lastFlipLabel.attributedText = lastFlip;
}

@end
