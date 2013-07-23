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

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (weak, nonatomic) IBOutlet UILabel *lastFlipLabel;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@property (strong, nonatomic) NSMutableArray *history;

@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeControl;

@property (strong, nonatomic) CardMatchingGame *game;

@property (strong, nonatomic) GameResult *gameResult;

@property (strong, nonatomic) GameSettings *gameSettings;

- (void)updateUI;

- (IBAction)flipCard:(UIButton *)sender;
- (IBAction)dealButtonPressed:(UIButton *)sender;
- (IBAction)cardModeChanged:(UISegmentedControl *)sender;
- (IBAction)historySliderChanged:(UISlider *)sender;
- (void)updateSliderRange;

@end
