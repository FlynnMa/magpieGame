//
//  loseWinView.m
//  ll
//
//  Created by Apple on 12-1-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "loseWinView.h"

@implementation loseWinView

#define INFO_PANNEL_MARGIN_X        10
#define INFO_PANNEL_HEIGHT          180

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect infoFrame, bgBounds;

        self.backgroundColor = [UIColor colorWithRed:0
                                               green:0
                                               blue:0
                                               alpha:0.4];
        
        bgBounds = [self bounds];
        infoFrame = CGRectMake(INFO_PANNEL_MARGIN_X,
                               (bgBounds.size.height - INFO_PANNEL_HEIGHT) / 2,
                               bgBounds.size.width - INFO_PANNEL_MARGIN_X * 2,
                               INFO_PANNEL_HEIGHT);
        pannelView = [[UIView alloc] initWithFrame:infoFrame];
        pannelView.backgroundColor = [UIColor colorWithRed:0
                                                     green:0
                                                      blue:0
                                                     alpha:0.8];
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
    [super dealloc];
}

-(void)showSuccess{
    NSString *str;

    isSuccess = YES;
    str = NSLocalizedStringFromTable(@"successinfo",
                                     @"infoPlist", @"");
    [infoLabel setText: str];
    [infoLabel sizeToFit];
    infoLabel.center = CGPointMake(pannelView.bounds.size.width / 2,
                                   pannelView.bounds.size.height / 2);
    [pannelView addSubview:infoLabel];
    [str release];
}

-(void)showFailed{
    NSString *str;

    isSuccess = NO;
    str = NSLocalizedStringFromTable(@"failedinfo",
                                     @"infoPlist", @"");
    [infoLabel setText: str];
    [infoLabel sizeToFit];
    infoLabel.center = CGPointMake(pannelView.bounds.size.width / 2,
                                   pannelView.bounds.size.height / 2);
    [pannelView addSubview:infoLabel];
    [str release];
}

-(void)setStartGameSelector:(SEL)aSlector
                     target:(id)aTarget{
    startGame = aSlector;
    startGameTarget = aTarget;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (NO == isSuccess) {
        if (startGame) {
            [self removeFromSuperview];
            [startGameTarget performSelector:startGame];
        }
    }
}
@end
