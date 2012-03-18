//
//  MainViewController.h
//  magpieBridge
//
//  Created by Apple on 12-1-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FloorController.h"
#import "FloorManager.h"

@class FloorController, pauseView, FloorManager, levelManager;
@class loseWinView, mainSettings;
@class skillsMgr;

@interface mainGameView : UIView <FloorMgrDelegate>{ 
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
    NSUInteger      stoppedBirdsNum;      // birds number
    NSUInteger      gatherSkillBirdsNum;       // number to activate gather skill
    
    CGFloat         labelContentHeight;   // total height of label area
    CGFloat         FloorMgrContentHeight; // total height of floor manager area
    CGFloat         ToolsMgrContentHeigh;  // total height of tools manager area, about double heights of a single floor height
    FloorManager        *floorMgr;
    levelManager        *levelMgr;
    mainSettings        *settings;
    NSMutableDictionary *skills;
    NSMutableArray      *lifeArray;
}

/*
 * @brief    initialize mainGameView
 * @detail   initialize lable, game content, tools area's height and positons
 * @calledby  fgameAppDelegate
 */
-(id) initWithFrame:(CGRect)frame;

/*
 * @brief    initialize views
 * @detail   set background color, load label views, create game, and pause game at last
 * @calledby [self initWithFrame]
 */
- (void)loadView;

/*
 * @brief    create game invirment
 * @detail   create game play frame(floormgr), create basic skills views 
 * @calledby [self loadView]
 */
-(void) createGame;

/*
 * @brief    pause game
 * @detail   pause the game, set floor paused, and create a pause view,
 *           set startGame selector
 * @calledby loadView, touchesBegan on floorMgr view
 */
-(void) pauseGame;

/*
 * @brief    start game
 * @detail   start the game, set floor paused, and create a pause view,
 *           set startGame selector
 * @calledby loadView, touchesBegan on floorMgr view
 */
-(void) startGame;

/*
 * @brief    restart game
 * @detail   restart the game, create Game and start
 * @calledby loseWin selector
 */
-(void)restartGame;

/*
 * @brief    destroy game
 * @detail   destroy the game, destroy all skills remove floorMgr
 * @calledby onFloorRefreshedEnd
 */
-(void)destroyGame;

/*
 * @brief    createAllLabelViews
 * @detail   create all labels
 * @calledby self
 */
-(void) createAllLabelViews;

/*
 * @brief    stop game
 * @detail   stop the floorMgr
 * @calledby [self onFloorUpdated]
 */
-(void) stopGame;

/*
 * @brief    onFloorMgrEvents
 * @detail   events from floor manager, a stop skill may cause the floor stopped,
 *           will judge whether move to next floor, win, or lose; a gather events
 *           will reactive the stop skill
 * @calledby floorManager
 */
-(void) onFloorMgrEvents:(NSNumber*)evt;

/*
 * @brief    performSkills
 * @detail   perform skills received from skills manager
 * @calledby skillsMgr
 */
-(void) performSkills:(NSNumber*)skillId;
@end
