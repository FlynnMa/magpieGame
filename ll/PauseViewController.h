//
//  PauseViewController.h
//  ll
//
//  Created by Apple on 12-1-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PauseViewController : UIViewController{
    UIView      *bgView;
    UILabel     *helpLabelStart;
    UILabel     *helpLabelSettings;
    CGRect       bgFrame;
    SEL          startSelector;
    id           startTarget;
}

-(id)initWithFrame:(CGRect)frame;
-(void)setStartSelector:(SEL)aSelector
                     target:(id) aTarget;
@end
