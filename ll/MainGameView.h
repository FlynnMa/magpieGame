//
//  MainViewController.h
//  ll
//
//  Created by Apple on 12-1-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FloorController, PauseViewController, FloorManager, levelManager;
@class loseWinView, mainSettings;
@class skillsMgr;

@interface mainGameView : UIView{ 
    UIView      *bgView;
    NSUInteger   score;
    UILabel     *scoreLabel;
    NSUInteger   level;
    UIView      *labelBgView;
    UILabel     *levelLabel;
    NSUInteger   duration;
    UILabel     *durationLabel;
    NSUInteger   floorNum;
    UILabel     *floorLabel;
    NSMutableArray *Floors;
    CGFloat         labelsStartY;  // start point of label views(score, level, duration, season, etc)
    CGFloat         labelHeight;   // height of label view
    CGFloat         labelFontSize; // size of label font
    CGFloat         floorHeight;   // floor height
    CGRect          frameRect;     // frame rectangle
    
    CGFloat         labelContentHeight;   // total height of label area
    CGFloat         FloorMgrContentHeight; // total height of floor manager area
    CGFloat         ToolsMgrContentHeigh;  // total height of tools manager area, about double heights of a single floor height
    PauseViewController *pauseCtl;
    FloorManager        *floorMgr;
    levelManager        *levelMgr;
    mainSettings        *settings;
    NSMutableDictionary *skills;
}

-(id) initWithFrame:(CGRect)frame;
-(void) createAllLabelViews;
-(void) startGame;
-(void) stopGame;
-(void) onFloorRefreshed;
-(void) performSkills:(NSNumber*)skillId;
-(void) stopFlyingBirds;
- (void)loadView;
@end
