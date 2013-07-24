//
//  GameViewController.m
//  Matchismo
//
//  Created by Alden Quimby on 7/22/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController() <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *addCardsButton;
@property (weak, nonatomic) IBOutlet UIButton *cheatButton;

@property (strong, nonatomic) GameResult *gameResult;
@property (strong, nonatomic) NSMutableArray *matchedCards; // of Card
@property (strong, nonatomic) NSArray *cheatCards; // of Card

@end

@implementation GameViewController

- (NSMutableArray *)matchedCards
{
    if (!_matchedCards) _matchedCards = [[NSMutableArray alloc] init];
    return _matchedCards;
}

- (void)clearCell:(UICollectionViewCell *)cell
{
    for (UIView *view in cell.subviews)
    {
        if ([view isKindOfClass:[UIImageView class]])
        {
            [view removeFromSuperview];
        }
    }
}

- (CGFloat)minOf:(CGFloat)f1 and:(CGFloat)f2
{
    if (f1 < f2)
    {
        return f1;
    }
    else
    {
        return f2;
    }
}

- (void)updateCell:(UICollectionViewCell *)cell
       ifCheatCard:(Card *)card
{
    if (![self.cheatCards containsObject:card])
    {
        return;
    }
    
    UIImage *image = [UIImage imageNamed:@"star.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    CGFloat min = [self minOf:cell.bounds.size.width and:cell.bounds.size.height];
    imageView.frame = CGRectMake(min / 10, min / 10, min / 5, min / 5);
    [cell addSubview:imageView];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    switch (section)
    {
        case 2:
            return [self.matchedCards count];
        case 1:
            return [self.matchedCards count] ? 1 : 0;
        default:
            return self.game.numberOfCards;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
    {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayingCard" forIndexPath:indexPath];

        [self clearCell:cell];
        [self updateCell:cell usingCard:self.matchedCards[indexPath.item] atIndexPath:indexPath];
        
        return cell;
    }
    else if (indexPath.section == 1)
    {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HeaderCell" forIndexPath:indexPath];

        UILabel *textLabel = [[UILabel alloc] initWithFrame:cell.bounds];
        textLabel.text = @"matched cards";
        textLabel.textColor = [UIColor blackColor];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.font = [UIFont fontWithName:@"System Bold" size:20.0];
        [cell addSubview:textLabel];
        
        return cell;
    }
    else
    {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayingCard" forIndexPath:indexPath];

        [self clearCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card atIndexPath:indexPath];
        [self updateCell:cell ifCheatCard:card];
        
        return cell;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (Deck *)createDeck { return nil; } // abstract

- (CardMatchingGame *)game
{
    if (!_game)
    {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount usingDeck:[self createDeck]];
        
        _game.numberMatchingCards = self.numberOfMatchingCards;
        _game.matchBonus = self.gameSettings.matchBonus;
        _game.mismatchPenalty = self.gameSettings.mismatchPenalty;
        _game.flipCost = self.gameSettings.flipCost;
        _game.numberOfCards = 4;
    }
    
    return _game;
}

- (GameResult *)gameResult
{
    if (_gameResult) _gameResult = [[GameResult alloc] init];
    _gameResult.gameType = self.gameType;
    return _gameResult;
}

- (GameSettings *)gameSettings
{
    if (!_gameSettings) _gameSettings = [[GameSettings alloc] init];
    return _gameSettings;
}

- (void)updateCell:(UICollectionViewCell *)cell
         usingCard:(Card *)card
       atIndexPath:(NSIndexPath *)indexPath
{
    // abstract
}

- (void)updateUI
{
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells])
    {
        [self clearCell:cell];
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        
        if (indexPath.section == 2)
        {
            Card *card = self.matchedCards[indexPath.item];
            [self updateCell:cell usingCard:card atIndexPath:indexPath];
        }
        else
        {
            Card *card = [self.game cardAtIndex:indexPath.item];
            [self updateCell:cell usingCard:card atIndexPath:indexPath];
            [self updateCell:cell ifCheatCard:card];
        }
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.lastFlipLabel.text = self.game.descriptionOfLastFlip;
    
    // only enable cheat button if there are possible matches
    if ([[self.game matchingCards] count])
    {
        self.cheatButton.enabled = YES;
        self.cheatButton.alpha = 1.0;
    }
    else
    {
        self.cheatButton.enabled = NO;
        self.cheatButton.alpha = 0.5;
    }
}

- (IBAction)cheatButtonPressed
{
    self.cheatCards = [self.game matchingCards];
    [self updateUI];
}

- (IBAction)addCardsButtonPressed:(UIButton *)sender
{
    int numberCardsToAdd = sender.tag + 3; // TODO
    
    // if there are any possible matches, penalize
    if ([[self.game matchingCards] count])
    {
        self.game.score -= self.gameSettings.mismatchPenalty * numberCardsToAdd;
        self.gameResult.score = self.game.score;
    }
    
    for (int i = 0; i < numberCardsToAdd; i++)
    {
        [self.game drawNewCard];
        NSArray *toInsert = @[[NSIndexPath indexPathForItem:(self.game.numberOfCards - 1)
                                                  inSection:0]];
        [self.cardCollectionView insertItemsAtIndexPaths:toInsert];
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:(self.game.numberOfCards - 1)
                                                 inSection:0];
    
    [self.cardCollectionView scrollToItemAtIndexPath:indexPath
                                    atScrollPosition:UICollectionViewScrollPositionBottom
                                            animated:YES];
    
    [self updateUI];
    
    // if out of cards, show an alert because game is over
    if (self.game.deckIsEmpty)
    {
        sender.enabled = NO;
        sender.alpha = 0.5;
        
        if (![[self.game matchingCards] count])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"No matches left."
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Game Over!", nil];
            
            [alert show];
        }
    }
}

- (IBAction)deal
{
    self.game = nil;
    self.gameResult = nil;
    self.matchedCards = nil;
    self.cheatCards = nil;
    
    if (!self.game.deckIsEmpty)
    {
        self.addCardsButton.enabled = YES;
        self.addCardsButton.alpha = 1.0;
    }
    
    [self.cardCollectionView reloadData];
    [self updateUI];
}

- (IBAction)flipCard:(UITapGestureRecognizer *)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    
    // only flip in first section
    if (!indexPath || indexPath.section != 0)
    {
        return;
    }
    
    [self.game flipCardAtIndex:indexPath.item];
    
    NSMutableArray *deleteIndexPaths = [[NSMutableArray alloc] init];
    NSMutableArray *matchedIndexPaths = [[NSMutableArray alloc] init];
    
    for (int i = self.game.numberOfCards - 1; i >= 0; i--)
    {
        Card *card = [self.game cardAtIndex:i];
        
        if (!card.isUnplayable)
        {
            continue;
        }
        
        if (![self.matchedCards containsObject:card])
        {
            [matchedIndexPaths addObject:[NSIndexPath indexPathForItem:[self.matchedCards count] inSection:2]];
            [self.matchedCards addObject:card];
        }
        
        if (self.removeUnplayableCards)
        {
            [self.game removeCardAtIndex:i];
            [deleteIndexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
        }
    }
    
    [self.cardCollectionView performBatchUpdates:^{
        if ([deleteIndexPaths count])
        {
            [self.cardCollectionView deleteItemsAtIndexPaths:deleteIndexPaths];
        }
        if ([matchedIndexPaths count])
        {
            self.cheatCards = nil;
            [self.cardCollectionView insertItemsAtIndexPaths:matchedIndexPaths];
            if ([self.matchedCards count] == self.numberOfMatchingCards)
            {
                [self.cardCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:1]]];
            }
        }
    } completion:nil];
    
    self.gameResult.score = self.game.score;
    
    [self updateUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // settings come from another tab, so they might have changed
    self.game.matchBonus = self.gameSettings.matchBonus;
    self.game.mismatchPenalty = self.gameSettings.mismatchPenalty;
    self.game.flipCost = self.gameSettings.flipCost;
    
    // TODO is this needed?
    [self updateUI];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.cardCollectionView.delegate = self;
    
    [self updateUI];
}

@end
