//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Alden Quimby on 7/16/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lastFlipLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeControl;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

@property (nonatomic) int flipCount;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) NSMutableArray *history;

@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if (!_game)
    {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                           usingDeck:[[PlayingCardDeck alloc] init]];
        _game.numberMatchingCards = self.gameModeControl.selectedSegmentIndex + 2;
    }
    return _game;
}

- (NSMutableArray *)history
{
    if (!_history) _history = [[NSMutableArray alloc] init];
    return _history;
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
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
        cardButton.imageEdgeInsets = UIEdgeInsetsMake(1, 1, 1, 1);
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
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];

    NSLog(@"a: %d", [self.history count]);
    NSLog(@"b: %d", (int)self.historySlider.value);
    
    if (self.historySlider.value == self.historySlider.minimumValue)
    {
        self.lastFlipLabel.text = @"";
    }
    else
    {
        self.lastFlipLabel.text = self.history[(int)self.historySlider.value - 1];
    }
    
    self.lastFlipLabel.alpha = self.historySlider.value == self.historySlider.maximumValue ? 1.0 : 0.3;
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    self.historySlider.maximumValue = self.flipCount;}

- (IBAction)deal
{
    self.game = nil;
    self.history = nil;
    self.flipCount = 0;
    self.gameModeControl.enabled = YES;
    [self updateUI];
}

- (IBAction)flipCard:(UIButton *)sender
{
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    self.gameModeControl.enabled = NO;
    self.historySlider.value = self.historySlider.maximumValue;
    [self.history addObject:self.game.descriptionOfLastFlip];
    [self updateUI];
}

- (IBAction)changeGameMode
{
    self.game.numberMatchingCards = self.gameModeControl.selectedSegmentIndex + 2;
}

- (IBAction)updateHistory
{
    self.historySlider.value = roundf(self.historySlider.value);
    [self updateUI];
    NSLog(@"%d", (int)self.historySlider.value);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateUI];
}

@end
