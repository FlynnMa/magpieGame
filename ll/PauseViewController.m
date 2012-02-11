//
//  PauseViewController.m
//  ll
//
//  Created by Apple on 12-1-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PauseViewController.h"

@implementation PauseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (id) initWithFrame:(CGRect)frame{
    NSLog(@"mainView init with frame,%@", NSStringFromCGRect(frame));
    self = [super init];
    if (self) {
        bgFrame = frame;
        self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    }
    
    return self;
}

-(void)setStartSelector:(SEL) aSelector
                 target:(id) aTarget{
    startTarget = aTarget;
    startSelector = aSelector;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view removeFromSuperview];
    if ([startTarget respondsToSelector:startSelector]) {
        [startTarget performSelector:startSelector];
    } else {
        NSLog(@"ERROR!the object donot responds to selector");
    }
}

#pragma mark - View lifecycle

- (void)createHelpLabels{
    UIFont *font;
    CGRect startFrame;
    CGRect settingsFrame;
    CGRect bgBounds = bgView.bounds;
    NSString *str;
    CGSize size;
    CGFloat fontSize;
    
    if (bgBounds.size.width >= 768) {
        fontSize = 48;
    } else {
        fontSize = 18;
    }
    font = [UIFont fontWithName:@"Papyrus" size:fontSize];
    str = NSLocalizedStringFromTable(@"h2start", @"infoPlist", @"");
    size = [str sizeWithFont:font];
#define LABEL_X_MARGIN    10

    startFrame = CGRectMake(LABEL_X_MARGIN, bgBounds.size.height / 3 - size.height/2, 
                            bgBounds.size.width - LABEL_X_MARGIN*2, 
                            96);
    if (bgBounds.size.width > size.width) {
        startFrame.origin.x = (bgBounds.size.width - size.width - LABEL_X_MARGIN * 2) / 2;
        startFrame.size.width = size.width;
    }
    helpLabelStart = [[UILabel alloc] initWithFrame:startFrame];
    helpLabelStart.backgroundColor = [UIColor colorWithRed:0
                                              green:0
                                              blue:0
                                              alpha:0];
    [helpLabelStart setFont:font];
    [helpLabelStart setText:str];
    helpLabelStart.lineBreakMode = UILineBreakModeWordWrap;
    helpLabelStart.numberOfLines = 0;
    helpLabelStart.textColor = [UIColor greenColor];
    helpLabelStart.textAlignment = UITextAlignmentCenter;
    [bgView addSubview:helpLabelStart];
    [str release];
    
    str = NSLocalizedStringFromTable(@"h2setting", @"infoPlist", @"");
    size = [str sizeWithFont:font];
    settingsFrame = CGRectMake(LABEL_X_MARGIN, 
                               abs(bgBounds.size.height / 3) * 2, 
                               bgBounds.size.width - LABEL_X_MARGIN * 2, 
                               size.height);
    helpLabelSettings = [[UILabel alloc] initWithFrame:settingsFrame];
    helpLabelSettings.backgroundColor = [UIColor colorWithRed:0
                                                        green:0
                                                         blue:0
                                                        alpha:0];
    [helpLabelSettings setFont:font];
    helpLabelSettings.textColor = [UIColor greenColor];
    helpLabelSettings.textAlignment = UITextAlignmentCenter;
    [helpLabelSettings setText: str];
    [bgView addSubview:helpLabelSettings];
    
    [font release];
    
}
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    bgView = [[UIView alloc] initWithFrame:bgFrame];
    bgView.backgroundColor = [UIColor colorWithRed:0
                                             green:0
                                             blue:0
                                             alpha:0.6];
    bgView.opaque = NO;
    [self createHelpLabels];
    self.view = bgView;
    
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
