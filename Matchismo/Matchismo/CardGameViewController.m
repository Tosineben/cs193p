//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Alden Quimby on 7/16/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "GameResult.h"

@interface CardGameViewController () <UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *lastFlipLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;

@property (nonatomic) int flipCount;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) GameResult *gameResult;
@property (strong, nonatomic) NSMutableArray *history;

@end

@implementation CardGameViewController

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1; // same as default, this is an optional method
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.startingCardCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayingCard" forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    
    // when card is first coming on screen, don't animate
    [self updateCell:cell usingCard:card animate:NO];
    
    return cell;
}

- (void)updateCell:(UICollectionViewCell *)cell
         usingCard:(Card *)card
           animate:(BOOL)animate
{ } // abstract

- (GameResult *)gameResult
{
    if (!_gameResult) _gameResult = [[GameResult alloc] init];
    return _gameResult;
}

- (CardMatchingGame *)game
{
    if (!_game)
    {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount
                                                  usingDeck:[self createDeck]];
    }
    return _game;
}
                 
- (Deck *)createDeck { return nil; } // abstract

- (NSMutableArray *)history
{
    if (!_history) _history = [[NSMutableArray alloc] init];
    return _history;
}

- (void)updateUI
{
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells])
    {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        
        // when updating UI, animate
        [self updateCell:cell usingCard:card animate:YES];
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.lastFlipLabel.text = [self.history lastObject];
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)deal
{
    self.game = nil;
    self.gameResult = nil;
    self.history = nil;
    self.flipCount = 0;
    [self updateUI];
}

- (IBAction)flipCard:(UITapGestureRecognizer *)gesture
{
    // do the flip
    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    if (!indexPath)
    {
        return; // tapped in empty space
    }
    [self.game flipCardAtIndex:indexPath.item];
    
    // update
    self.flipCount++;
    [self.history addObject:self.game.descriptionOfLastFlip];
    [self updateUI];
    self.gameResult.score = self.game.score;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateUI];
}

@end
