//
//  PlayingCardView.h
//  SuperCard
//
//  Created by Alden Quimby on 7/21/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;
@property (nonatomic) BOOL faceUp;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;

@end
