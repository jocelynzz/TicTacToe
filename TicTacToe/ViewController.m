//
//  ViewController.m
//  TicTacToe
//
//  Created by Jocelyn on 2/07/15.
//  Copyright (c) 2015 Jocelyn. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "LetterImageView.h"

@interface ViewController ()

@property NSInteger winner;
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initMainBoard];
    [self initSymbolArea];
}

-(void) initMainBoard{
   
    
    //draw the tic tac main board
    UIImageView *mainBoard = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"board"]];
    [mainBoard setFrame:CGRectMake(25,75,270,270)];
    [mainBoard setTag:100];
    [self.view addSubview:mainBoard];
    
    self.grids = [[NSMutableArray alloc] initWithCapacity:9];
    self.gridRecord = [[NSMutableArray alloc] initWithCapacity:9];
    
    for(int i = 0; i < 9; i++){
        UIView * grid = [[UIView alloc] init];
        [grid setOpaque:NO];
        grid.frame = CGRectMake(25+i%3*90, 75+i/3*90, 90, 90);
        [self.grids setObject:grid atIndexedSubscript:i];
        
        [mainBoard addSubview:grid];
        
        [self.gridRecord setObject:[NSNumber numberWithInt:i] atIndexedSubscript:i];
        
         self.numofRound = 0;
    }
}

-(void) initSymbolArea{
    
    LetterImageView *x = [self newSymbolX];
    LetterImageView *o = [self newSymbolO];
    [x waitiforDrag];
    [o deactivateLetter];
    _symbolNextRound = o;
    
}

-(LetterImageView*)newSymbolX{
    LetterImageView *x = [[LetterImageView alloc]initWithImage:[UIImage imageNamed:@"X"]];
    [x setFrame:CGRectMake(40, 380, 90, 90)];
    [x setTag:101];
    [self.view addSubview:x];
    [self addPanGestureRecognizer:x];
    return x;
}

-(LetterImageView*) newSymbolO{
    
    LetterImageView *o = [[LetterImageView alloc]initWithImage:[UIImage imageNamed:@"O"]];
    [o setFrame:CGRectMake(190, 380, 90, 90)];
    [o setTag:102];
    [self.view addSubview:o];
    [self addPanGestureRecognizer:o];
    return o;
}


- (void)addPanGestureRecognizer:(UIView*)symbol{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(dragToBoard:)];
    [panGesture setMaximumNumberOfTouches:2];
    [panGesture setDelegate:self];
    [symbol addGestureRecognizer:panGesture];
    
}

- (void)dragToBoard:(UIPanGestureRecognizer *)gestureRecognizer
{
    UIView *symbol = [gestureRecognizer view];
    [[symbol superview] bringSubviewToFront:symbol];
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
            CGPoint translation = [gestureRecognizer translationInView:[symbol superview]];
            [symbol setCenter:CGPointMake([symbol center].x + translation.x, [symbol center].y + translation.y)];
            [gestureRecognizer setTranslation:CGPointZero inView:[symbol superview]];
        }
    [self checkGridStatus:gestureRecognizer];
}

//check if a grid is occupied or not
-(void) checkGridStatus:(UIPanGestureRecognizer *)gestureRecognizer{
    
    UIView *symbol = [gestureRecognizer view];
    CGFloat x = [symbol center].x;
    CGFloat y = [symbol center].y;
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        int nGrid = ((int)(x-25))/90 + ((int)(y-75))/90 *3;
        if (nGrid > 8 || nGrid < 0) {
            if (symbol.tag == 101) {
                [(LetterImageView*)symbol backtoOriginX];
            }
            else
                [(LetterImageView*)symbol backtoOriginO];
        }
        else{
            UIView *grid = [_grids objectAtIndex:nGrid];
            
            bool occupation =
            ![[_gridRecord objectAtIndex:nGrid] isEqualToNumber:[NSNumber numberWithInt:nGrid]];
            
            bool match = CGRectIntersectsRect(grid.frame, symbol.frame);
            if (match && !occupation) {
                symbol.center = [grid center];
                [self.view addSubview:symbol];
                [self playSound:@"drop"];

                int num = (int)symbol.tag;
                [self.gridRecord setObject:[NSNumber numberWithInt:num] atIndexedSubscript:nGrid];
                self.numofRound++;
                int tagOfLastSymbol = num;
                symbol.tag = nGrid+1;
                
                [self checkStatus:tagOfLastSymbol];

            }
            else if(match && occupation){
                [self playSound:@"back"];
                if (symbol.tag == 101) {
                    [(LetterImageView*)symbol backtoOriginX];
                }
                else
                    [(LetterImageView*)symbol backtoOriginO];
                
            }
            else if(!match){
                if (symbol.tag == 101) {
                    [(LetterImageView*)symbol backtoOriginX];
                }
                else
                    [(LetterImageView*)symbol backtoOriginO];
            }
        }
    }
}

-(void) checkStatus:(int)tagOfLastSymbol{
    bool win = NO;
    bool stalemate = NO;
    
    for (int i = 0; i <= 6; i = i + 3) {

        NSNumber *a1 = [_gridRecord objectAtIndex:i];
        NSNumber *a2 = [_gridRecord objectAtIndex:i+1];
        NSNumber *a3 = [_gridRecord objectAtIndex:i+2];
        
        if ([a1 isEqualToNumber:a2]&&[a2 isEqualToNumber:a3]) {
            win=YES;
        }
    }
    
    for (int i = 0; i <= 2; i++) {
        NSNumber *a1 = [_gridRecord objectAtIndex:i];
        NSNumber *a2 = [_gridRecord objectAtIndex:i+3];
        NSNumber *a3 = [_gridRecord objectAtIndex:i+6];
        if ([a1 isEqualToNumber:a2]&&[a2 isEqualToNumber:a3]) {
            win=YES;
        }
    }
    
    NSNumber *a0 = [_gridRecord objectAtIndex:0];
    NSNumber *a4 = [_gridRecord objectAtIndex:4];
    NSNumber *a8 = [_gridRecord objectAtIndex:8];
    if ([a0 isEqualToNumber:a4]&&[a4 isEqualToNumber:a8]) {
        win=YES;
    }
    
    NSNumber *a2 = [_gridRecord objectAtIndex:2];
    NSNumber *a6 = [_gridRecord objectAtIndex:6];
    if ([a2 isEqualToNumber:a4]&&[a4 isEqualToNumber:a6]) {
        win=YES;
    }
    
    
    if(win == NO && self.numofRound == 9){
        stalemate = YES;
    }
    
    if (win == YES) {
        [self showWinner:tagOfLastSymbol];

    }
    if (stalemate == YES) {
        [self showTie];
    }
    if (win == NO && stalemate == NO) {
        [self startNextRound:tagOfLastSymbol];
    }
}

-(void)startNextRound:(int)tagOfLastSymbol{

    if (tagOfLastSymbol == 101) {

        //Replenish and disable x
        LetterImageView *x = [self newSymbolX];
        [x deactivateLetter];
        
        LetterImageView *o = _symbolNextRound;
        _symbolNextRound = x;
        
        [o waitiforDrag];
    }
    else if(tagOfLastSymbol == 102) {
        //Replenish and disable o
        LetterImageView *o = [self newSymbolO];
        [o deactivateLetter];
        
        LetterImageView *x = _symbolNextRound;
        _symbolNextRound = o;     
        
        [x waitiforDrag];
    }
}

-(void) showWinner:(int)tagOfLastSymbol{
    [self playSound:@"applause"];
    NSString *winner;
    if (tagOfLastSymbol == 101) {
        winner = @"X";
    }
    else {
        winner = @"O";
    }
    
    NSString *msg = [NSString stringWithFormat:@"%@ Wins!", winner];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Game Over!" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"New Game", nil];
    alertView.alertViewStyle = UIAlertViewStyleDefault;
    alertView.delegate = self;
    [alertView show];
}

-(void) showTie{
    [self playSound:@"tie"];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"It's A Tie!" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"New Game", nil];
    alertView.alertViewStyle = UIAlertViewStyleDefault;
    alertView.delegate = self;
    [alertView show];
}

- (void) alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"New Game"]) {
        [self clearBoard];
    }
}

-(void) clearBoard{
    self.numofRound = 0;
    //Get symbol removed
    UIView *symbol = self.symbolNextRound;
    [symbol removeFromSuperview];
    
    //Get subviews in grids of the board removed
    for (int i = 0; i < 9; i++) {
        if (![[_gridRecord objectAtIndex:i] isEqualToNumber:[NSNumber numberWithInt:i]]) {
            LetterImageView *symbol = (LetterImageView*)[self.view viewWithTag:i+1];
            [symbol removeSymbol];
        }
    }

    [self performSelector:@selector(initMainBoard) withObject:self afterDelay:2.0];
    [self performSelector:@selector(initSymbolArea) withObject:self afterDelay:2.0];

}


- (void)playSound:(NSString*)soundName

{
    NSError *error;
    NSString *backgroundMusicPath = [[NSBundle mainBundle] pathForResource:soundName ofType:@"mp3"];
    NSURL *backgroundMusicURL = [NSURL fileURLWithPath:backgroundMusicPath];
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
}

- (IBAction)tapInfoButton:(id)sender {
    
    UIActionSheet *msg = [[UIActionSheet alloc]
                          initWithTitle:
                          @"1. Drag your symbol into the main board.\n"
                          "2. The player who matches column, line or diagonal with the same symbol first wins the game. \n"
                          "3. Press New Game to play again.\n"
                          delegate:nil
                          cancelButtonTitle:nil  destructiveButtonTitle:nil
                          otherButtonTitles:@"OK", nil];
    [msg showInView:self.view];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
