//
//  LetterImageView.m
//  TicTacToe
//
//  Created by Jocelyn on 2/07/15.
//  Copyright (c) 2015 Jocelyn. All rights reserved.
//

#import "LetterImageView.h"

@implementation LetterImageView

-(void) waitiforDrag{
    [UIView animateWithDuration:0.5 delay:1.0 options:UIViewAnimationOptionCurveLinear                      animations:^{
        self.transform = CGAffineTransformScale(self.transform, 2.0, 2.0);
        self.alpha = 0.5;
    }
                     completion:^(BOOL completed) {
                         [UIView animateWithDuration:0.5 delay:0.1 options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              self.transform =
                                              CGAffineTransformScale(self.transform, 0.5, 0.5);
                                              self.alpha = 1.0f;
                                          }
                                          completion:^(BOOL finished) {
                                           
                                          }];
                         
                     }];
    self.userInteractionEnabled = YES;
}

-(void) deactivateLetter{
    self.userInteractionEnabled = NO;
}

-(void) backtoOriginX{
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.center = CGPointMake(85, 425);
                     } completion:^(BOOL finished) {
                   
                     }];
}
     
-(void) backtoOriginO{
        
         [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.center = CGPointMake(235, 425);
                     } completion:^(BOOL finished) {
                
                     }];
}

-(void) removeSymbol{
    [UIView animateWithDuration:0.2 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.transform = CGAffineTransformScale(self.transform, 2.0, 2.0);
                         self.alpha = 1.0f;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.8 delay:0.2 options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              self.transform =
                                              CGAffineTransformScale(self.transform, 0.5, 0.5);
                                              self.alpha = 0.5f;
                                          }
                                          completion:^(BOOL finished) {
                                              [self removeFromSuperview];
                                          }];
                         
                     }];
}

@end
