//
//  loseWinView.m
//  ll
//
//  Created by Apple on 12-1-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "loseWinView.h"
#import <QuartzCore/QuartzCore.h>
#import "utilsButtonClass.h"
#import "viewTags.h"

@interface loseWinView()
- (void)backToWelcome;
@end
@implementation loseWinView

#define INFO_PANNEL_MARGIN_X        10
#define INFO_PANNEL_HEIGHT          180

/*
 * @brief showSuccess
 * @detail this function draw a success view and show level choice
 * @return none
 * @invoke mainGameView
 */
-(void)showSuccess{
    NSString *str;
    CGRect    frame, pannelBounds = pannelView.bounds;
    CGFloat   height, width;

    isSuccess = YES;

    str = NSLocalizedStringFromTable(@"successinfo",
                                      @"infoPlist", @"");
    height = pannelBounds.size.height / 4;
    width  = (pannelBounds.size.width * 2)/ 3;
    frame = CGRectMake((pannelBounds.size.width - width) / 2,
                       (pannelBounds.size.height / 2 - height) / 2,
                       width, height);
    utilsButtonClass  *buttonContinue = [[utilsButtonClass alloc] initWithFrame:frame];
    str = NSLocalizedStringFromTable(@"winLoseContinueButton",
                                     @"infoPlist", @"");
    [buttonContinue setTitle:str forState:UIControlStateNormal];
    [buttonContinue addTarget:self action:@selector(startGame)
             forControlEvents:UIControlEventTouchUpInside];
    [pannelView addSubview:buttonContinue];
    [buttonContinue release];
    
    frame.origin.y += pannelBounds.size.height / 2;
    utilsButtonClass *buttonBack = [[utilsButtonClass alloc] initWithFrame:frame];
    str = NSLocalizedStringFromTable(@"winLoseBackButton", @"infoPlist", nil);
    [buttonBack setTitle:str forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(backToWelcome)
         forControlEvents:UIControlEventTouchUpInside];
    [pannelView addSubview:buttonBack];
    [buttonBack release];

}

-(void) startGame{
    if (startGame) {
        [self removeFromSuperview];
        [startGameTarget performSelector:startGame];
    }
}
/*
 * @brief showFailed
 * @detail this function draw a faild view and show continue/back choice
 * @return none
 * @invoke mainGameView
 */
-(void)showFailed{
    NSString *str;
    CGRect    frame, pannelBounds = pannelView.bounds;
    CGFloat   height, width;

    isSuccess = NO;

    height = pannelBounds.size.height / 4;
    width  = (pannelBounds.size.width * 2)/ 3;
    frame = CGRectMake((pannelBounds.size.width - width) / 2,
                       (pannelBounds.size.height / 2 - height) / 2,
                       width, height);
    utilsButtonClass  *buttonContinue = [[utilsButtonClass alloc] initWithFrame:frame];
    str = NSLocalizedStringFromTable(@"winLoseContinueButton",
                                     @"infoPlist", @"");
    [buttonContinue setTitle:str forState:UIControlStateNormal];
    [buttonContinue addTarget:self action:@selector(startGame)
             forControlEvents:UIControlEventTouchUpInside];
    [pannelView addSubview:buttonContinue];
    [buttonContinue release];
    
    frame.origin.y += pannelBounds.size.height / 2;
    utilsButtonClass *buttonBack = [[utilsButtonClass alloc] initWithFrame:frame];
    str = NSLocalizedStringFromTable(@"winLoseBackButton", @"infoPlist", nil);
    [buttonBack setTitle:str forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(backToWelcome)
         forControlEvents:UIControlEventTouchUpInside];
    [pannelView addSubview:buttonBack];
    [buttonBack release];
}

/*
 * @brief setStartGameSelector
 * @detail this function set a start game selector which
 *          is to be called by mainGameView to start or restart game
 * @return none
 * @invoke mainGameView
 */
-(void)setStartGameSelector:(SEL)aSlector
                     target:(id)aTarget{
    startGame = aSlector;
    startGameTarget = aTarget;
}

/* @brief  backToWelcome
 * @detail this function responds to backButton's notification, back to welcome view
 * @return none
 * @invode system
 */
- (void)backToWelcome{
    CGRect   origFrame = self.frame;
    UIView  *rootView = [self.window.subviews objectAtIndex:0];
    UIView  *welcomeView = [rootView viewWithTag:magepieBridgeViewTagWelcome];
    UIView  *gameView = [rootView viewWithTag:magepieBridgeViewTagMainGame];

    if (nil == welcomeView) {
        return;
    }
    
    if (nil == gameView) {
        rootView = self.superview;
        gameView = [rootView viewWithTag:magepieBridgeViewTagMainGame];
    }
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationCurveEaseIn
                     animations:^{
                         [self setHidden:YES];
                         [gameView setHidden:YES];
                         [welcomeView setFrame:origFrame];
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         [gameView removeFromSuperview];
                     }];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect infoFrame, bgBounds;
        CGFloat marginX, marginY;

        self.backgroundColor = [UIColor colorWithRed:0
                                               green:0
                                                blue:0
                                               alpha:0.4];

        bgBounds = [self bounds];
        marginX = bgBounds.size.width / 20;
        marginY = bgBounds.size.height / 3;
        infoFrame = CGRectMake(marginX,
                               marginY,
                               bgBounds.size.width - marginX * 2,
                               marginY);
        pannelView = [[UIView alloc] initWithFrame:infoFrame];
        pannelView.layer.cornerRadius = 10.0;
        pannelView.layer.borderColor = [UIColor orangeColor].CGColor;
        pannelView.layer.shadowOffset = CGSizeMake(1.0f, 2.0f);
        pannelView.layer.shadowOpacity = 1.5f;
        pannelView.layer.shadowColor = [UIColor brownColor].CGColor;
        pannelView.layer.shadowRadius = 2.5f;

        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.anchorPoint = CGPointMake(0.0f, 0.0f);
        gradient.position = CGPointMake(0.0f, 0.0f);
        gradient.bounds = pannelView.layer.bounds;
        gradient.cornerRadius = 10.0;
        gradient.colors = [NSArray arrayWithObjects:
                           (id)[UIColor colorWithRed:0.82f
                                               green:0.82f
                                                blue:0.1f
                                               alpha:0.5].CGColor,
                           (id)[UIColor colorWithRed:0.52f
                                               green:0.52f
                                                blue:0.02f
                                               alpha:1.0].CGColor,
                           nil];
        [pannelView.layer addSublayer:gradient];
        [self addSubview:pannelView];
        
        infoLabel = [[UILabel alloc] init];
    }
    return self;
}

-(void)dealloc{
    NSLog(@"loseWinView dealloc...");
    [imageView release];
    [infoLabel release];
    [scoreLabel release];
    [recordLabel release];
    [pannelView release];
    [super dealloc];
}

@end
