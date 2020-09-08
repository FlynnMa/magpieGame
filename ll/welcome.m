//
//  welcome.m
//  magpieBridge
//
//  Created by Yunfei on 12-1-23.
//  Copyright (c) 2012年 __yunfei.studio__. All rights reserved.
//

#import "viewTags.h"
#import "welcome.h"
#import "mainGameView.h"
#import "levelSelectorView.h"
#import <QuartzCore/QuartzCore.h>

#define WELCOME_STRING_SIZE    48

@implementation welcome

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithFrame: (CGRect)frame{
    self = [super init];
    if (self) {
        bgView = [[UIView alloc] initWithFrame:frame];
        [bgView setBackgroundColor:[UIColor blackColor]];
        self.view.tag = magepieBridgeViewTagWelcome;
    }
    
    return self;
}

- (void) dealloc{
    NSLog(@"dealloc welcome...");
    [bgView release];
    [super release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    UIFont  *font;
    CGRect   viewFrame;
    CGRect   frame;
    CGSize   size;
    UIButton *button;
    CGFloat   fontSize;
    NSString  *str;
    CGFloat   xMargin;
    

    UIButton* (^createButtonView)(CGRect, UIFont*) = ^(CGRect rect, UIFont *aFont){
        UIButton *aButton = nil;
        aButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
        aButton.layer.frame = rect;
        aButton.layer.shadowOffset = CGSizeMake(0, 3);
        aButton.layer.shadowRadius = 5.0;
        aButton.layer.shadowColor = [UIColor whiteColor].CGColor;
        aButton.layer.shadowOpacity = 0.8;
        aButton.titleLabel.font = aFont;
        aButton.titleLabel.textAlignment = UITextAlignmentCenter;
        
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        anim.duration = 0.3;
        anim.repeatCount = 1;
        anim.autoreverses = YES;
        anim.removedOnCompletion = YES;
        anim.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 0.8)];
        anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.2)];
        [aButton.layer addAnimation:anim forKey:nil];
        [bgView addSubview:aButton];
        
        return aButton;
    };
    viewFrame = [bgView bounds];

    if (viewFrame.size.width >= 768) {
        fontSize = 48;
        xMargin = 48;
    } else {
        fontSize = 24;
        xMargin  = 24;
    }
    /* calculate label frame */
    font = [UIFont boldSystemFontOfSize: fontSize];
    
    str = NSLocalizedStringFromTable(@"newGame", @"infoPlist", @"");
    size = [str sizeWithFont:font];
    frame = CGRectMake(xMargin,
                    (viewFrame.size.height / 2 - size.height) / 2,
                       viewFrame.size.width - xMargin * 2, size.height);
    button = createButtonView(frame, font);
    [button setTitle:str forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onStart)
     forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.textAlignment = UITextAlignmentCenter;
    [bgView addSubview:button];
    [button release];
    
    str = NSLocalizedStringFromTable(@"continue", @"infoPlist", @"");
    size = [str sizeWithFont:font];
    frame = CGRectMake( xMargin,
                       (viewFrame.size.height - size.height) / 2,
                       viewFrame.size.width - xMargin * 2,
                       size.height);
    button = createButtonView(frame, font);
    [button setTitle:str forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onStart)
     forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:button];
    [button release];
    
    str = NSLocalizedStringFromTable(@"howToPlay", @"infoPlist", @"");
    size = [str sizeWithFont:font];
    frame = CGRectMake( xMargin,
                       (viewFrame.size.height / 2 - size.height) / 2 + viewFrame.size.height / 2,
                       viewFrame.size.width - xMargin * 2,
                       size.height);
    button = createButtonView(frame, font);
    [button setTitle:str forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onStart)
     forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:button];
    [button release];
    
    [self setView:bgView];

}
     
-(void)onStart{
    CGRect   inFrame = self.view.frame;
    CGRect   leftFrame  = inFrame;
    CGRect   rightFrame = inFrame;

    leftFrame.origin.x -= inFrame.size.width;
    rightFrame.origin.x += inFrame.size.width;
    mainGameView *gameView = [[mainGameView alloc] initWithFrame:rightFrame];
    [self.view.superview addSubview:gameView];
    [UIView animateWithDuration:.3
                          delay:0
                        options:UIViewAnimationCurveEaseIn
                     animations:^{
                         [self.view setFrame:leftFrame];
                         [gameView setFrame:inFrame];
                     } completion:^(BOOL finished) {
                         [gameView release];
                     }];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
