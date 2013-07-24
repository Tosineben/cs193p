//
//  SetCardCollectionViewCell.h
//  Matchismo
//
//  Created by Alden Quimby on 7/23/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetCardView.h"

@interface SetCardCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet SetCardView *setCardView;

@end
