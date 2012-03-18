//
//  levelSelectorView.h
//  magpie
//
//  Created by Apple on 12-2-13.
//  Copyright (c) 2012年 __Yunfei.Studio__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class levelManager;
@interface levelSelectorView : UIView{
    levelManager    *lvlMgr;
}

-(void) loadViews;

-(void) backToWelcome;

-(void) goGame;
@end
