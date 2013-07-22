//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Alden Quimby on 7/22/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardCollectionViewCell.h"

@implementation PlayingCardGameViewController

- (NSUInteger) startingCardCount
{
    return 20;
}

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (void)updateCell:(UICollectionViewCell *)cell
         usingCard:(Card *)card
           animate:(BOOL)animate
{
    // make sure we have the correct types
    if (![cell isKindOfClass:[PlayingCardCollectionViewCell class]] ||
        ![card isKindOfClass:[PlayingCard class]])
    {
        return;
    }
    
    PlayingCardView *playingCardView = ((PlayingCardCollectionViewCell *)cell).playCardView;
    PlayingCard *playingCard = (PlayingCard *)card;
    
    // synchronize model and view
    playingCardView.rank = playingCard.rank;
    playingCardView.suit = playingCard.suit;
    playingCardView.alpha = playingCard.isUnplayable ? 0.3 : 1.0;
    
    // if faceUp is changing, maybe animate it
    if (animate && playingCard.isFaceUp != playingCardView.faceUp)
    {
        [UIView transitionWithView:playingCardView
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            playingCardView.faceUp = playingCard.isFaceUp;
                        }
                        completion:NULL];
    }
    else
    {
        // not sure why this is needed, but UI messes up without it
        playingCardView.faceUp = playingCard.isFaceUp;
    }
}

@end
