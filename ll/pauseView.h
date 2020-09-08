//
//  PauseViewController.h
//  ll
//
//  Created by Yunfei on 12-1-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pauseView : UIView{
    UILabel     *helpLabelStart;
    UILabel     *helpLabelSettings;
    CGRect       bgFrame;
    SEL          startSelector;
    id           startTarget;
}

-(id)initWithFrame:(CGRect)frame;
-(void)setStartSelector:(SEL)aSelector
                     target:(id) aTarget;
- (void)loadView;
@end
