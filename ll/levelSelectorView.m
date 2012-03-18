//
//  levelSelectorView.m
//  ll
//
//  Created by Apple on 12-2-13.
//  Copyright (c) 2012年 __Yunfei.Studio__. All rights reserved.
//

#import "viewTags.h"
#import <QuartzCore/QuartzCore.h>
#import "levelSelectorView.h"
#import "levelManager.h"
#import "welcome.h"
#import "mainGameView.h"

@implementation levelSelectorView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        lvlMgr = [[levelManager alloc] init];
        [lvlMgr loadConfigurations];
        self.tag = magepieBridgeViewTagLevelSelector;
    }
    return self;
}

-(void)dealloc{
    NSLog(@"dealloc levelSelectorView...");
    [lvlMgr release];
    [super release];
}

-(void)loadViews{
    CGRect   bounds = self.bounds;
    CGRect   frame = self.bounds;
    CGSize   size;
    NSString *str;

    UIFont  *font = [UIFont fontWithName:@"Papyrus" size:32];
    
    UILabel  *seasonView = nil;
    str = [NSString stringWithFormat:@"season%d", lvlMgr.currentSeason];
    NSString *seasonStr = NSLocalizedStringFromTable(str, @"infoPlist", @"");
    size = [seasonStr sizeWithFont:font
                          forWidth:bounds.size.width
                     lineBreakMode:UILineBreakModeWordWrap];
    frame.origin.y = 100;
    frame.size.height = size.height;
    seasonView = [[UILabel alloc] initWithFrame:frame];
    [seasonView setText:seasonStr];
    [seasonView setFont:font];
    seasonView.textAlignment = UITextAlignmentCenter;
    [self addSubview:seasonView];
    [seasonView release];

    UILabel *titleView = nil;
    str = [NSString stringWithFormat:@"season%dTitle", lvlMgr.currentSeason];
    NSString *titleStr = NSLocalizedStringFromTable(str, @"infoPlist", @"");
    size = [titleStr sizeWithFont:font
                             forWidth:bounds.size.width
                        lineBreakMode:UILineBreakModeWordWrap];
    frame.origin.y = frame.origin.y + frame.size.height;
    frame.size.height = size.height;
    titleView = [[UILabel alloc] initWithFrame: frame];
    [titleView setText:titleStr];
    [titleView setFont:font];
    titleView.textAlignment = UITextAlignmentCenter;
    [self addSubview:titleView];
    [titleView release];

    str = [NSString stringWithFormat:@"season%d-snapshort.jpg",lvlMgr.currentSeason];
    UIImage *image = [UIImage imageNamed:str];
    
    UIImageView *seasonImg = [[UIImageView alloc] initWithImage:image];
    frame.origin.y = frame.origin.y + frame.size.height;
    frame.size.height = seasonImg.frame.size.height;
    frame.size.width = self.frame.size.width;
    [seasonImg sizeToFit];
    [seasonImg setFrame:frame];
    seasonImg.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:seasonImg];
    [seasonImg release];
    
    font = [UIFont fontWithName:@"Noteworthy" size:22];
    UILabel *descView = nil;
    str = [NSString stringWithFormat:@"season%dDesc", lvlMgr.currentSeason];
    NSString *descStr = NSLocalizedStringFromTable(str, @"infoPlist", @"");
    size = [descStr sizeWithFont:font];
    frame.origin.y = frame.origin.y + frame.size.height;
    frame.size.height = size.height;
    descView = [[UILabel alloc] initWithFrame:frame];
    [descView setText:descStr];
    [descView setFont:font];
    descView.textAlignment = UITextAlignmentCenter;
    [self addSubview:descView];
    [descView release];
    
    image = [UIImage imageNamed:@"day1.jpg"];
    
    UIImageView *dayImg = [[UIImageView alloc] initWithImage:image];
    frame.size.width = self.frame.size.width;
    frame.origin.y = frame.origin.y + frame.size.height;
    frame.size.height = dayImg.frame.size.height;
    [dayImg sizeToFit];
    [dayImg setFrame:frame];
    dayImg.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:dayImg];
    [dayImg release];

    UIButton* (^createButtonView)(CGRect, UIFont*) = ^(CGRect rect, UIFont *aFont){
        UIButton *aButton = nil;
        aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        aButton.layer.frame = rect;
        aButton.layer.shadowOffset = CGSizeMake(0, 3);
        aButton.layer.shadowRadius = 5.0;
        aButton.layer.shadowColor = [UIColor blackColor].CGColor;
        aButton.layer.shadowOpacity = 0.8;
        aButton.titleLabel.font = aFont;
        aButton.titleLabel.textAlignment = UITextAlignmentCenter;

        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        anim.duration = 0.4;
        anim.repeatCount = 1;
        anim.autoreverses = YES;
        anim.removedOnCompletion = YES;
        anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.2)];
        [aButton.layer addAnimation:anim forKey:nil];
        [self addSubview:aButton];

        return aButton;
    };

    str = @"back";
    size = [str sizeWithFont:font];
    frame.origin.y = self.frame.size.height - frame.size.height - 20;
    frame.size.width = size.width * 2;
    frame.size.height = size.height;
    UIButton *returnButton = createButtonView(frame, font);
    [returnButton setTitle:str forState:UIControlStateNormal];
    [returnButton addTarget:self action:@selector(backToWelcome)
     forControlEvents:UIControlEventTouchUpInside];
    
    str = @"go";
    frame.origin.x = bounds.size.width - frame.size.width;
    UIButton *goButton = createButtonView(frame, font);
    [goButton setTitle:str forState:UIControlStateNormal];
    [goButton addTarget:self action:@selector(goGame)
       forControlEvents:UIControlEventTouchDown];
    
}

-(void) backToWelcome{
    CGRect   origFrame = self.frame;
    origFrame.origin.x -= self.frame.size.width;
    UIView  *welcomeView = [self.superview viewWithTag:magepieBridgeViewTagWelcome];

    welcomeView.frame = origFrame;
    welcomeView.hidden = NO;
    [self.superview addSubview:welcomeView];
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationCurveEaseIn
                     animations:^{
                         CGRect   outFrame = self.frame;
                         CGRect   inFrame = self.frame;

                         outFrame.origin.x += outFrame.size.width;
                         [self setFrame:outFrame];
                         [welcomeView setFrame:inFrame];
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

-(void) goGame{
    CGRect        centerFrame = self.frame;
    CGRect        rightFrame = centerFrame;

    rightFrame.origin.x += centerFrame.size.width;
    mainGameView *gameView = [[mainGameView alloc] initWithFrame:rightFrame];

    [self.superview addSubview:gameView];
    [UIView  animateWithDuration:0.4
                           delay:0
                         options:UIViewAnimationCurveEaseOut
                      animations:^{
                          self.frame = rightFrame;
                          gameView.frame = centerFrame;
                      } completion:^(BOOL finished) {
                          [self removeFromSuperview];
                          [gameView release];
                      }];
}

@end
