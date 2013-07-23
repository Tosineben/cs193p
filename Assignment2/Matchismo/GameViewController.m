//
//  GameViewController.m
//  Matchismo
//
//  Created by Alden Quimby on 7/22/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "GameViewController.h"

@implementation GameViewController

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];}

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (NSMutableArray *)history
{
    if (!_history) _history = [[NSMutableArray alloc] init];
    return _history;
}

- (CardMatchingGame *)game { return nil; } // abstract
- (GameResult *)gameResult { return nil; } // abstract

- (GameSettings *)gameSettings
{
    if (!_gameSettings) _gameSettings = [[GameSettings alloc] init];
    return _gameSettings;
}

- (void)updateUI
{
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];

    if (self.historySlider.value == self.historySlider.minimumValue)
    {
        self.lastFlipLabel.text = @"";
    }
    else
    {
        self.lastFlipLabel.text = self.history[(int)self.historySlider.value - 1];
    }
    
    self.lastFlipLabel.alpha = self.historySlider.value == self.historySlider.maximumValue ? 1.0 : 0.5;
}

- (void)updateSliderRange
{
    int maxValue = [self.history count];
    if (maxValue < 0)
    {
        maxValue = 0;
    }
    self.historySlider.maximumValue = maxValue;
}

- (IBAction)deal
{
    self.game = nil;
    self.gameResult = nil;
    self.history = nil;
    self.flipCount = 0;
    self.gameModeControl.enabled = YES;
    [self updateSliderRange];
    [self updateUI];
}

- (IBAction)flipCard:(UIButton *)sender
{
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    self.gameModeControl.enabled = NO;
    self.gameResult.score = self.game.score;
    
    // add history if there is a new one
    if (![@"" isEqualToString:self.game.descriptionOfLastFlip])
    {
        [self.history addObject:self.game.descriptionOfLastFlip];
    }

    [self updateSliderRange];
    [self.historySlider setValue:self.historySlider.maximumValue animated:YES];
    
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
}

// when MVC appears and disappears from screen
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // settings come from another tab, so they might have changed
    self.game.matchBonus = self.gameSettings.matchBonus;
    self.game.mismatchPenalty = self.gameSettings.mismatchPenalty;
    self.game.flipCost = self.gameSettings.flipCost;
    
    [self updateUI];
}

@end
