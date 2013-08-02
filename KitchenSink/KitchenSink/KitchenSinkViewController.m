//
//  KitchenSinkViewController.m
//  KitchenSink
//
//  Created by Alden Quimby on 7/31/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "KitchenSinkViewController.h"
#import "AskerViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "CMMotionManager+Shared.h"

@interface KitchenSinkViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *kitchenSink;
@property (weak, nonatomic) NSTimer *drainTimer; // system has strong pointer when scheduled
@property (weak, nonatomic) UIActionSheet *sinkControlActionSheet;
@property (strong, nonatomic) UIPopoverController *imagePickerPopover;

@end

@implementation KitchenSinkViewController

#pragma mark - drift

#define DRIFT_HZ 10
#define DRIFT_RATE 10

- (void)startDrift
{
    CMMotionManager *motionManager = [CMMotionManager sharedMotionManager];
    if ([motionManager isAccelerometerAvailable])
    {
        [motionManager setAccelerometerUpdateInterval:1/DRIFT_HZ];
        [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue]
                                            withHandler:^(CMAccelerometerData *data, NSError *error) {
            // move each view based on acceleration
            for (UIView *view in self.kitchenSink.subviews)
            {
                CGPoint center = view.center;
                center.x += data.acceleration.x * DRIFT_RATE;
                center.y -= data.acceleration.y * DRIFT_RATE;
                view.center = center;
                
                // if off screen, remove view
                if (!CGRectContainsRect(self.kitchenSink.bounds, view.frame) &&
                    !CGRectIntersectsRect(self.kitchenSink.bounds, view.frame))
                {
                    [view removeFromSuperview];
                }
            }
        }];
    }
}

- (void)stopDrift
{
    CMMotionManager *motionManager = [CMMotionManager sharedMotionManager];
    [motionManager stopAccelerometerUpdates];
}

- (IBAction)addFoodPhoto:(UIBarButtonItem *)sender
{
    [self presentImagePicker:UIImagePickerControllerSourceTypeSavedPhotosAlbum sender:sender];
}

- (IBAction)takeFoodPhoto:(UIBarButtonItem *)sender
{
    [self presentImagePicker:UIImagePickerControllerSourceTypeCamera sender:sender];
}

- (void)presentImagePicker:(UIImagePickerControllerSourceType) type
                    sender:(UIBarButtonItem *)sender
{
    if (!self.imagePickerPopover && [UIImagePickerController isSourceTypeAvailable:type])
    {
        NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:type];
        if ([mediaTypes containsObject:(NSString *)kUTTypeImage])
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = type;
            picker.mediaTypes = @[(NSString *)kUTTypeImage];
            picker.allowsEditing = YES;
            picker.delegate = self;
            
            BOOL isPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
            if ((type != UIImagePickerControllerSourceTypeCamera) && isPad)
            {
                self.imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:picker];
                [self.imagePickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                self.imagePickerPopover.delegate = self; // do to respond to popover delegate
            }
            else
            {
                // just doing a camera, modal it
                [self presentViewController:picker animated:YES completion:nil];
            }
        }
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.imagePickerPopover = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#define MAX_IMAGE_WIDTH 200

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // get image and drop into kitchen sink
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image)
    {
        image = info[UIImagePickerControllerOriginalImage];
    }
    
    if (image)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
        // camera takes huge photos, scale it down
        CGRect frame = imageView.frame;
        if (frame.size.width > MAX_IMAGE_WIDTH)
        {
            frame.size.height = (frame.size.height / frame.size.width) * MAX_IMAGE_WIDTH;
            frame.size.width = MAX_IMAGE_WIDTH;
        }
        imageView.frame = frame;
        
        [self setRandomLocationForView:imageView];
        [self.kitchenSink addSubview:imageView];
    }
    
    if (self.imagePickerPopover)
    {
        [self.imagePickerPopover dismissPopoverAnimated:YES]; // take popover off screen
        self.imagePickerPopover = nil; // now we don't care about it anymore
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#define SINK_CONTROL @"Sink Controls"
#define SINK_CONTROL_STOP_DRAIN @"Stopper Drain"
#define SINK_CONTROL_UNSTOP_DRAIN @"Unstopper Drain"
#define SINK_CONTROL_CANCEL @"Cancel"
#define SINK_CONTROL_EMPTY @"Empty Sink"

- (IBAction)controlSink:(UIBarButtonItem *)sender
{
    if (self.sinkControlActionSheet)
    {
        return;
    }
    
    NSString *drainButton = self.drainTimer ? SINK_CONTROL_STOP_DRAIN : SINK_CONTROL_UNSTOP_DRAIN;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:SINK_CONTROL delegate:self cancelButtonTitle:SINK_CONTROL_CANCEL destructiveButtonTitle:SINK_CONTROL_EMPTY otherButtonTitles:drainButton, nil];
    
    [actionSheet showFromBarButtonItem:sender animated:YES];
    
    self.sinkControlActionSheet = actionSheet;
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.destructiveButtonIndex)
    {
        [self.kitchenSink.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    else
    {
        NSString *choice =  [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([choice isEqualToString:SINK_CONTROL_STOP_DRAIN])
        {
            [self stopDrainTimer];
        }
        else if ([choice isEqualToString:SINK_CONTROL_UNSTOP_DRAIN])
        {
            [self startDrainTimer];
        }
    }
}

#define DISH_CLEANING_INTERVAL 2.0

- (void)cleanDish
{
    if (self.kitchenSink.window)
    {
        [self addFood:nil];
        [self performSelector:@selector(cleanDish) withObject:nil afterDelay:DISH_CLEANING_INTERVAL];
    }
}

// start late
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startDrainTimer];
    [self startDrift];
    
    [self cleanDish];
}

// stop early
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopDrainTimer];
    [self stopDrift];
}

#define DRAIN_DURATION 3.0
#define DRAIN_DELAY 1.0

- (void)startDrainTimer
{
    self.drainTimer = [NSTimer scheduledTimerWithTimeInterval:DRAIN_DURATION/3 target:self selector:@selector(drain:) userInfo:nil repeats:YES];
}

- (void)stopDrainTimer
{
    [self.drainTimer invalidate]; // because it's weak, this will set it to nil
}

- (void)drain:(NSTimer *)timer
{
    [self drain];
}

- (void)drain
{
    for (UIView *view in self.kitchenSink.subviews)
    {
        // make sure view isn't already draining
        CGAffineTransform transform = view.transform;
        if (CGAffineTransformIsIdentity(transform))
        {
            [UIView animateWithDuration:DRAIN_DURATION/3
                                  delay:DRAIN_DELAY
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                 view.transform = CGAffineTransformRotate(CGAffineTransformScale(transform, 0.7, 0.7), 2*M_PI/3);
             }
                             completion:^(BOOL finished) {
                 if (finished) [UIView animateWithDuration:DRAIN_DURATION/3
                                       delay:0
                                     options:UIViewAnimationOptionCurveLinear
                                  animations:^{
                                      view.transform = CGAffineTransformRotate(CGAffineTransformScale(transform, 0.4, 0.4), -2*M_PI/3);
                                  }
                  completion:^(BOOL finished) {
                      if (finished) [UIView animateWithDuration:DRAIN_DURATION/3
                                            delay:0
                                          options:UIViewAnimationOptionCurveLinear
                                       animations:^{
                                           view.transform = CGAffineTransformScale(transform, 0.1, 0.1);
                                       }
                       completion:^(BOOL finished) {
                           if (finished)
                           {
                               [view removeFromSuperview];
                           }
                       }];
                  }];
             }];
        }
    }
}

// tap anywhere on kitchen sink
- (IBAction)tap:(UITapGestureRecognizer *)sender
{
    CGPoint tapLocation = [sender locationInView:self.kitchenSink];
    
    for (UIView *view in self.kitchenSink.subviews)
    {
        // view.bounds is subviews coordinate system, we want
        // kitchen sink coordinate system, so use view.frame
        if (CGRectContainsPoint(view.frame, tapLocation))
        {
            // tap occured on this view
            
            [UIView animateWithDuration:DRAIN_DURATION delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                [self setRandomLocationForView:view];
                view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.99, 0.99);
            } completion:^(BOOL finished) {
                view.transform = CGAffineTransformIdentity;
            }];
        }
    }
}

- (void)addFood:(NSString *)food
{
    UILabel *foodLabel = [[UILabel alloc] init];
    
    static NSDictionary *foods = nil;
    if (!foods)
    {
        foods = @{
            @"Jello" : [UIColor blueColor], @"Broccoli" : [UIColor greenColor],
            @"Beet" : [UIColor redColor], @"Eggplant" : [UIColor purpleColor],
            @"Carrot" : [UIColor orangeColor], 
        };
    }
    
    if (![food length])
    {
        food = [[foods allKeys] objectAtIndex:arc4random()%[foods count]];
        foodLabel.textColor = [foods objectForKey:food];
    }
    
    foodLabel.text = food;
    foodLabel.font = [UIFont systemFontOfSize:46];
    foodLabel.backgroundColor = [UIColor clearColor];
    [foodLabel sizeToFit];
    [self setRandomLocationForView:foodLabel];
    [self.kitchenSink addSubview:foodLabel];
}

- (void)setRandomLocationForView:(UIView *)view
{
    CGRect sinkBounds = CGRectInset(self.kitchenSink.bounds, view.frame.size.width/2, view.frame.size.height/2);
    CGFloat x = arc4random() % (int)sinkBounds.size.width + view.frame.size.width/2;
    CGFloat y = arc4random() % (int)sinkBounds.size.height + view.frame.size.height/2;
    view.center = CGPointMake(x, y);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Ask"])
    {
        AskerViewController *asker = segue.destinationViewController;
        asker.question = @"What food do you want in the sink?";
    }
}

- (IBAction)cancelAsking:(UIStoryboardSegue *)segue
{
    // do nothing, just an unwind segue
}

- (IBAction)doneAsking:(UIStoryboardSegue *)segue
{
    AskerViewController *asker = segue.sourceViewController;
    
    [self addFood:asker.answer];
}

@end
