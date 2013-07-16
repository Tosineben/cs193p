//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Alden Quimby on 7/16/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"

@interface CardGameViewController ()

@property (nonatomic) int flipCount;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (strong, nonatomic) Deck *deck;

@end

@implementation CardGameViewController

- (Deck *)deck
{
    if (!_deck) _deck = [[PlayingCardDeck alloc] init];
    return _deck;
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    self.flipCount++;
    
    if (sender.isSelected)
    {
        Card *randomCard = [self.deck drawRandomCard];
        
        if (randomCard)
        {
            [sender setTitle:randomCard.contents forState:UIControlStateSelected];
        }
        else
        {
            [sender setEnabled:NO];
            sender.alpha = 0.3;
        }
    }
}

@end
