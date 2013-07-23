//
//  GameResultViewController.m
//  Matchismo
//
//  Created by Alden Quimby on 7/17/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "GameResultViewController.h"
#import "GameResult.h"

@interface GameResultViewController ()

@property (weak, nonatomic) IBOutlet UITextView *display;
@property (strong, nonatomic) NSArray *allGameResults;

@end

@implementation GameResultViewController

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

// when geometry changes
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

// when MVC appears and disappears from screen
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.allGameResults = [GameResult allGameResults];
    [self updateUI];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

// when memory gets low
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// sets red badge icon on tab
- (void)setBadgeValue:(NSString *)value
{
    self.tabBarItem.badgeValue = value;
}

// ensures the view and model are in sync
- (void)updateUI
{
    NSString *displayText = @"";
    for (GameResult *result in self.allGameResults)
    {
        displayText = [displayText stringByAppendingFormat:@"%@: %d (%@, %gs)\n",
                       result.gameType,
                       result.score,
                       [NSDateFormatter localizedStringFromDate:result.end
                                                      dateStyle:NSDateFormatterShortStyle
                                                      timeStyle:NSDateFormatterShortStyle],
                       round(result.duration)];
    }
    self.display.text = displayText;
}

- (IBAction)sortByDate
{
    self.allGameResults = [self.allGameResults sortedArrayUsingSelector:@selector(compareDate:)];
    [self updateUI];
}

- (IBAction)sortByScore
{
    self.allGameResults = [self.allGameResults sortedArrayUsingSelector:@selector(compareScore:)];
    [self updateUI];
}

- (IBAction)sortByDuration
{
    self.allGameResults = [self.allGameResults sortedArrayUsingSelector:@selector(compareDuration:)];
    [self updateUI];
}

@end
