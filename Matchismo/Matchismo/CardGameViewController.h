//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Alden Quimby on 7/16/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CardGameViewController : UIViewController

@property (nonatomic) NSUInteger startingCardCount; // abstract

- (Deck *)createDeck; // abstract

- (void)updateCell:(UICollectionViewCell *)cell
         usingCard:(Card *)card
           animate:(BOOL)animate; // abstract

@end
