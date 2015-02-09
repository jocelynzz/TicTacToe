//
//  ViewController.h
//  TicTacToe
//
//  Created by Jocelyn on 2/07/15.
//  Copyright (c) 2015 Jocelyn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LetterImageView.h"
#import "AudioToolbox/AudioToolbox.h"
#import "AVFoundation/AVfoundation.h"

@interface ViewController : UIViewController<UIGestureRecognizerDelegate,UIAlertViewDelegate>

@property (assign,nonatomic) NSInteger numofRound;
@property (assign,nonatomic) LetterImageView *symbolNextRound;
@property (strong,nonatomic) NSMutableArray *grids;
@property (strong,nonatomic) NSMutableArray *gridRecord;
- (IBAction)tapInfoButton:(id)sender;
@end
