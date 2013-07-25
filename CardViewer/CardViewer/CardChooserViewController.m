//
//  CardChooserViewController.m
//  CardViewer
//
//  Created by Alden Quimby on 7/24/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "CardChooserViewController.h"
#import "CardDisplayViewController.h"

@interface CardChooserViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *suitSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (nonatomic) NSUInteger rank;
@property (nonatomic, readonly) NSString *suit;

@end

@implementation CardChooserViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    // only care about show card segue
    if (![segue.identifier isEqualToString:@"showCard"] ||
        ![segue.destinationViewController isKindOfClass:[CardDisplayViewController class]])
    {
        return;
    }
    
    // viewController has been instantiated, but not loaded
    // no outlets are loaded at this point
    // just use public API of controller
    
    CardDisplayViewController *cdvc = segue.destinationViewController;
    
    cdvc.rank = self.rank;
    cdvc.suit = self.suit;
    cdvc.title = [[self rankAsString] stringByAppendingString:self.suit];
}

- (NSString *)suit
{
    return [self.suitSegmentedControl titleForSegmentAtIndex:self.suitSegmentedControl.selectedSegmentIndex];
}

- (NSString *)rankAsString
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"][self.rank];
}

- (void)setRank:(NSUInteger)rank
{
    _rank = rank;
    self.rankLabel.text = [self rankAsString];
}

- (IBAction)changeRank:(UISlider *)sender
{
    self.rank = round(sender.value);
}

@end
