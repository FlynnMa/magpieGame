//
//  welcome.m
//  ll
//
//  Created by Apple on 12-1-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "welcome.h"
#import "mainGameView.h"

#define WELCOME_STRING_SIZE    48

@implementation welcome

@synthesize enterView;

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
    }
    
    return self;
}

- (void) dealloc{
    NSLog(@"dealloc welcome...");
    [bgView release];
    [enterView release];
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
    UILabel *labelView;
    CGRect   viewFrame;
    CGRect   frame;
    CGSize   size;
    UIButton *button;
    CGFloat   fontSize;

    viewFrame = [bgView bounds];

    if (viewFrame.size.width >= 768) {
        fontSize = 48;
    } else {
        fontSize = 24;
    }
    /* calculate label frame */
    font = [UIFont boldSystemFontOfSize: fontSize];
    size = [@"welcome" sizeWithFont:font];
    frame.origin = CGPointMake((viewFrame.size.width - size.width) / 2,
                                    (viewFrame.size.height - size.height) / 2);
    frame.size = size;
    labelView = [[UILabel alloc] initWithFrame:frame];
    [labelView setFont:font];
    [labelView setTextColor:[UIColor whiteColor]];
    [labelView setBackgroundColor:nil];
    [labelView setText:@"welcome"];
    [bgView addSubview:labelView];
    [self setView:bgView];
    [labelView release];
    
    size = [@"play" sizeWithFont:font];
    frame = CGRectMake( (viewFrame.size.width - size.width) / 2,
                    (viewFrame.size.height / 2 - size.height) / 2,
                       size.width, size.height);
    button = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
    button.frame = frame;
    button.titleLabel.font = font;
    [button setTitle:@"play" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onStart)
     forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:button];
    [button release];
    
    size = [@"how to play" sizeWithFont:font];
    frame = CGRectMake( (viewFrame.size.width - size.width) / 2,
                       (viewFrame.size.height / 2 - size.height) / 2 + viewFrame.size.height / 2,
                       size.width, size.height);
    button = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
    button.frame = frame;
    button.titleLabel.font = font;
    [button setTitle:@"how to play" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onStart)
     forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:button];
    [button release];

}
     
-(void)onStart{
    [UIView transitionWithView:self.view.superview duration:1
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^{
                        self.view.hidden = YES;
                        [self.view.superview addSubview:enterView];
                    } completion:^(BOOL finished) {
                        [self.view removeFromSuperview];
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
