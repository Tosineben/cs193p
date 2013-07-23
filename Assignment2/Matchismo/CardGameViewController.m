//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Alden Quimby on 7/16/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"

@implementation CardGameViewController

@synthesize game = _game, gameResult = _gameResult;

- (CardMatchingGame *)game
{
    if (!_game)
    {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[[PlayingCardDeck alloc] init]];
        _game.numberMatchingCards = 2;
        // TODO set 3 settings here?
    }
    return _game;
}

- (GameResult *)gameResult
{
    if (!_gameResult) _gameResult = [[GameResult alloc] init];
    _gameResult.gameType = @"Card Match";
    return _gameResult;
}

- (void)updateUI
{
    UIImage *cardBackImage = [UIImage imageNamed:@"cardback.png"];
    UIImage *cardFrontImage = [[UIImage alloc] init];
    
    for (int i = 0; i < self.cardButtons.count; i++)
    {
        UIButton *cardButton = [self.cardButtons objectAtIndex:i];
        Card *card = [self.game cardAtIndex:i];

        // set up card back
        cardButton.imageEdgeInsets = UIEdgeInsetsMake(1, 5, 1, 5);
        [cardButton setImage:cardBackImage forState:UIControlStateNormal];
        
        // set up card front
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        [cardButton setImage:cardFrontImage forState:UIControlStateSelected];
        [cardButton setImage:cardFrontImage forState:UIControlStateSelected|UIControlStateDisabled];
        
        // set up state
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    }
    
    [super updateUI];
}

@end
