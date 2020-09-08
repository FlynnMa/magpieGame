//
//  pauseView.m
//  ll
//
//  Created by Yunfei on 12-1-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "pauseView.h"
#import "viewTags.h"

@implementation pauseView

-(void) dealloc{

    NSLog(@"pause view dealloc ...");

    [helpLabelStart release];
    [helpLabelSettings release];
    [super dealloc];
}

- (id) initWithFrame:(CGRect)frame{
    NSLog(@"mainView init with frame,%@", NSStringFromCGRect(frame));
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.tag = magepieBridgeViewTagPause;
    }
    
    return self;
}

-(void)setStartSelector:(SEL) aSelector
                 target:(id) aTarget{
    startTarget = aTarget;
    startSelector = aSelector;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if (self != [touch view]) {
        return;
    }

    [self removeFromSuperview];
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
    CGRect bgBounds = self.bounds;
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
                            bgBounds.size.width - LABEL_X_MARGIN * 2, 
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
    [self addSubview:helpLabelStart];
    
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
    [self addSubview:helpLabelSettings];

}
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    self.backgroundColor = [UIColor colorWithRed:0
                                             green:0
                                             blue:0
                                             alpha:0.6];
    self.opaque = NO;
    [self createHelpLabels];
    
}

@end
