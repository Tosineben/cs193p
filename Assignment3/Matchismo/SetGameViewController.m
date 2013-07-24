//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Alden Quimby on 7/22/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCard.h"
#import "SetCardDeck.h"
#import "SetCardView.h"
#import "SetCardCollectionViewCell.h"

@implementation SetGameViewController

- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

- (NSUInteger)startingCardCount
{
    return 12;
}

- (NSUInteger)numberOfMatchingCards
{
    return 3;
}

- (NSString *)gameType
{
    return @"Set Game";
}

- (BOOL)removeUnplayableCards
{
    return YES;
}

- (void)updateCell:(UICollectionViewCell *)cell
         usingCard:(Card *)card
       atIndexPath:(NSIndexPath *)indexPath
{
    if (![cell isKindOfClass:[SetCardCollectionViewCell class]] ||
        ![card isKindOfClass:[SetCard class]])
    {
        return;
    }
    
    SetCardView *setView = ((SetCardCollectionViewCell *)cell).setCardView;
    SetCard *setCard = (SetCard *)card;
    
    setView.color = setCard.color;
    setView.number = setCard.number;
    setView.shading = setCard.shading;
    setView.symbol = setCard.symbol;
    setView.faceUp = !indexPath.section ? setCard.faceUp : NO;
    setView.alpha = setCard.isUnplayable && !indexPath.section ? 0.3 : 1.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.section)
    {
        case 2:
            return CGSizeMake(40, 40);
        case 1:
            return CGSizeMake(150, 20);
        default:
            return CGSizeMake(65, 65);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    switch (section) {
        case 1:
            return UIEdgeInsetsMake(10, 10, 0, 0);
        default:
            return UIEdgeInsetsMake(10, 10, 10, 10);
    }
}

- (void)addSetCard:(SetCard *)setCard
            toView:(UIView *)view
               atX:(CGFloat)x
{
    CGFloat height = self.lastFlipLabel.bounds.size.height;
    SetCardView *setView = [[SetCardView alloc] initWithFrame:CGRectMake(x, 0, height, height)];
    setView.color = setCard.color;
    setView.number = setCard.number;
    setView.shading = setCard.shading;
    setView.symbol = setCard.symbol;
    setView.backgroundColor = [UIColor clearColor];
    [view addSubview:setView];
}

#define LASTFLIP_CARD_OFFSET_FACTOR 1.2

- (void)updateUILabel:(UILabel *)label
             withText:(NSString *)text
          andSetCards:(NSArray *)setCards
{
    if ([setCards count])
    {
        label.text = text;
        CGFloat x = [label.text sizeWithFont:label.font].width;
        
        for (SetCard *setCard in setCards)
        {
            [self addSetCard:setCard toView:label atX:x];
            x += label.bounds.size.height * LASTFLIP_CARD_OFFSET_FACTOR;
        }
    }
    else
    {
        label.text = @"";
    }
}

- (NSArray *)setCardsFromString:(NSString *)string
{
    NSString *pattern = [NSString stringWithFormat:@"(%@):(%@):(%@):(\\d+)",
                         [[SetCard validSymbols] componentsJoinedByString:@"|"],
                         [[SetCard validColors] componentsJoinedByString:@"|"],
                         [[SetCard validShadings] componentsJoinedByString:@"|"]];
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:0
                                                                             error:&error];
    if (error)
    {
        return nil;
    }
    
    NSArray *matches = [regex matchesInString:string
                                      options:0
                                        range:NSMakeRange(0, [string length])];
    if (![matches count])
    {
        return nil;
    }
    
    NSMutableArray *setCards = [[NSMutableArray alloc] init];
    for (NSTextCheckingResult *match in matches)
    {
        SetCard *setCard = [[SetCard alloc] init];
        setCard.symbol = [string substringWithRange:[match rangeAtIndex:1]];
        setCard.color = [string substringWithRange:[match rangeAtIndex:2]];
        setCard.shading = [string substringWithRange:[match rangeAtIndex:3]];
        setCard.number = [[string substringWithRange:[match rangeAtIndex:4]] intValue];
        [setCards addObject:setCard];
    }
    return setCards;
}

- (void)updateUI
{
    [super updateUI];
    
    for (UIView *view in self.lastFlipLabel.subviews)
    {
        [view removeFromSuperview];
    }
    
    if (self.game.descriptionOfLastFlip)
    {
        if ([self.game.descriptionOfLastFlip rangeOfString:@"Flipped up"].location != NSNotFound)
        {
            NSMutableArray *setCards = [[NSMutableArray alloc] init];
            for (int i = 0; i < self.game.numberOfCards; i++)
            {
                Card *card = [self.game cardAtIndex:i];
                if (card.isFaceUp && [card isKindOfClass:[SetCard class]])
                {
                    [setCards addObject:(SetCard *)card];
                }
            }
            [self updateUILabel:self.lastFlipLabel withText:@"" andSetCards:setCards];
        }
        else
        {
            NSArray *setCards = [self setCardsFromString:self.game.descriptionOfLastFlip];
            [self updateUILabel:self.lastFlipLabel withText:@"" andSetCards:setCards];
        }
    }
    
    [self.lastFlipLabel setNeedsDisplay];
}

@end
