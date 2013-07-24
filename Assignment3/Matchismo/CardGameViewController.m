//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Alden Quimby on 7/16/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCardView.h"
#import "PlayingCard.h"
#import "PlayingCardCollectionViewCell.h"

@implementation CardGameViewController

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (NSUInteger)startingCardCount
{
    return self.gameSettings.numberPlayingCards;
}

- (NSUInteger)numberOfMatchingCards
{
    return 2;
}

- (NSString *)gameType
{
    return @"Card Match";
}

- (BOOL)removeUnplayableCards
{
    return NO;
}

- (void)updateCell:(UICollectionViewCell *)cell
         usingCard:(Card *)card
       atIndexPath:(NSIndexPath *)indexPath
{
    if (![cell isKindOfClass:[PlayingCardCollectionViewCell class]] ||
        ![card isKindOfClass:[PlayingCard class]])
    {
        return;
    }
    
    PlayingCardView *cardView = ((PlayingCardCollectionViewCell *)cell).playCardView;
    PlayingCard *playingCard = (PlayingCard *)card;
    
    cardView.rank = playingCard.rank;
    cardView.suit = playingCard.suit;
    cardView.faceUp = !indexPath.section ? playingCard.isFaceUp : YES;
    cardView.alpha = playingCard.isUnplayable && !indexPath.section ? 0.3 : 1.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.section)
    {
        case 2:
            return CGSizeMake(56, 72);
        case 1:
            return CGSizeMake(150, 20);
        default:
            return CGSizeMake(70, 90);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    switch (section) {
        case 1:
            return UIEdgeInsetsMake(10, 10, 0, 0);
        default:
            return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}
@end
