//
//  XImageView.h
//  TicTacToe
//
//  Created by Jocelyn on 2/07/15.
//  Copyright (c) 2015 Jocelyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LetterImageView : UIImageView<UIGestureRecognizerDelegate>

-(void) waitiforDrag;
-(void) deactivateLetter;
-(void) backtoOriginX;
-(void) backtoOriginO;
-(void) removeSymbol;

@end
