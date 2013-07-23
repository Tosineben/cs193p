//
//  SettingsViewController.m
//  Matchismo
//
//  Created by Alden Quimby on 7/22/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "SettingsViewController.h"
#import "GameSettings.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *matchBonusLabel;
@property (weak, nonatomic) IBOutlet UISlider *matchBonusSlider;
@property (weak, nonatomic) IBOutlet UILabel *mismatchPenaltyLabel;
@property (weak, nonatomic) IBOutlet UISlider *mismatchPenaltySlider;
@property (weak, nonatomic) IBOutlet UILabel *flipCostLabel;
@property (weak, nonatomic) IBOutlet UISlider *flipCostSlider;

@property (strong, nonatomic) GameSettings *settings;

@end

@implementation SettingsViewController

- (GameSettings *)settings
{
    if (!_settings) _settings = [[GameSettings alloc] init];
    return _settings;
}

- (void)setLabel:(UILabel *)label forSlider:(UISlider *)slider
{
    int value = lroundf(slider.value);
    [slider setValue:value animated:NO];
    label.text = [NSString stringWithFormat:@"%d", value];
}

- (IBAction)matchBonusSliderChanged
{
    [self setLabel:self.matchBonusLabel forSlider:self.matchBonusSlider];
    self.settings.matchBonus = [self.matchBonusLabel.text intValue];
}

- (IBAction)mismatchPenaltySliderChanged
{
    [self setLabel:self.mismatchPenaltyLabel forSlider:self.mismatchPenaltySlider];
    self.settings.mismatchPenalty = [self.mismatchPenaltyLabel.text intValue];
}

- (IBAction)flipCostSliderChanged
{
    [self setLabel:self.flipCostLabel forSlider:self.flipCostSlider];
    self.settings.flipCost = [self.flipCostLabel.text intValue];
}

// instantiated from storyboard
- (void)awakeFromNib
{
    [self setup];
}

// instantiated directly (never happens)
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self setup];
    return self;
}

// init that can't wait until viewDidLoad
- (void)setup
{
    
}

// normal init here
- (void)viewDidLoad
{
    [super viewDidLoad];
}

// when MVC appears on screen
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.matchBonusSlider.value = self.settings.matchBonus;
    self.mismatchPenaltySlider.value = self.settings.mismatchPenalty;
    self.flipCostSlider.value = self.settings.flipCost;
    
    [self setLabel:self.matchBonusLabel forSlider:self.matchBonusSlider];
    [self setLabel:self.mismatchPenaltyLabel forSlider:self.mismatchPenaltySlider];
    [self setLabel:self.flipCostLabel forSlider:self.flipCostSlider];
}

@end
