//
//  GameViewController.h
//  Matchismo
//
//  Created by Alden Quimby on 7/22/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"
#import "GameResult.h"
#import "GameSettings.h"

@interface GameViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lastFlipLabel;

@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) GameSettings *gameSettings;

@property (strong, nonatomic) NSString *gameType;
@property (nonatomic) NSUInteger startingCardCount;
@property (nonatomic) NSUInteger numberOfMatchingCards;
@property (nonatomic) BOOL removeUnplayableCards;

- (Deck *)createDeck;

- (void)updateUI;

- (void)updateCell:(UICollectionViewCell *)cell
         usingCard:(Card *)card
       atIndexPath:(NSIndexPath *)indexPath;

@end
