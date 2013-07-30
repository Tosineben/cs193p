//
//  AttributedStringViewController.m
//  Shutterbug
//
//  Created by Alden Quimby on 7/27/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "AttributedStringViewController.h"

@interface AttributedStringViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation AttributedStringViewController

- (void)setText:(NSAttributedString *)text
{
    _text = text;
    self.textView.attributedText = text;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // in case someone sets text before loading
    self.textView.attributedText = self.text;
}

@end
