//
//  FloorManager.h
//  ll
//
//  Created by Apple on 12-1-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "errorCodes.h"
#import "magpieClass.h"

@class mainSettings;

typedef enum{
    eFLOOR_STATUS_NONE,
    eFLOOR_STATUS_STOPPED,
    eFLOOR_STATUS_PAUSED,
    eFLOOR_STATUS_PLAYING,
    eFLOOR_STATUS_MAX
}eFloorStatus;

typedef enum {
    eFLOOR_MGR_EVT_NONE,
    eFLOOR_MGR_EVT_STOPPED,
    /**< @responds to the stopped skill,
        current active floor has been stopped */
    eFLOOR_MGR_EVT_GATHERED,
    /**< @responds to the gathered skill,
        all stopped birds gathered */
    eFLOOR_MGR_EVT_MAX
}eFloorMgrEvtType;

@interface FloorManager : UIView
<CAMagpieDelegate>{
    NSMutableArray  *Floors;
    CGFloat         floorHeight;  // floor height
    SEL             onFloorMgrEvt;
    id              onFloorMgrEvtTarget;
    NSUInteger      maxBirdsNumPerLine;
    mainSettings   *iSettings;
    NSUInteger      totalStoppedBirdsNum;
    NSUInteger      gatherNum;
    NSUInteger      floorsPerSpecial;  // how many floors will generate one special bird
    NSUInteger      currentSpecialIndex;
    int             SpecialList[9];
    int             lifeCount;  //how many additional lifes got remains
}

/* current active floor index */
@property(readwrite, nonatomic)    NSInteger  currentActiveFloorIndex; /* 0~12 */

/* current active floor index */
@property(readonly, retain, nonatomic)  NSMutableDictionary *iDicCurrActiveFloor;

/* max floor */
@property(readwrite, assign)    NSInteger  maxFloor;

/* initial birds number for new created floor */
@property(readwrite, assign, nonatomic)    NSUInteger initialBirdsNum;

/* total birds number */
@property(readonly, nonatomic)  NSUInteger totalBirdsNum;

/* the up most floor status */
@property(readonly, nonatomic)  eFloorStatus status;

/* delegate instance */
@property(readwrite, nonatomic, retain)  id  delegate;

/*
 * @brief create floor
 * @detail create a floor for flying birds at an index
 * @param  index (0~n), the max value of index is (maxFloor -1),
 * which is load from configuration file
 * @return none
 * @invoke mainGameView
 */
-(void) createFloor:(int)index;

/*
 * @brief start floor
 * @detail start a floor for flying birds at currentActiveFloorIndex
 * @return error codes
 */
-(int) startFloor;

/*
 * @brief stop floor
 * @detail stop a floor with flying birds at currentActiveFloorIndex,
 *          this function will cause floor controller to stop current active floor
 *          and update birds range, after floor controller done this, a preregistered
 *          function onFloorRefreshedBirdsNum will be called, then floor manager will notify
 *          uplayer to let mainGameView to determine wether game is failed, win or continue
 * @return none
 * @invoke mainGameView
 */
-(void) stopFloor;

/*
 * @brief  pauseFloor
 * @detail retreive each magpie of current active floor
 *         and stop fly one by one
 * @invoke mainGameView
 */
-(void)pauseFloor;

/*
 * @brief getStatus
 * @detail retreive the status of current floor
 * @return eFloorStatus type
 * @invoke mainGameView
 */
-(eFloorStatus) getStatus;

/*
 * @brief  setOnFloorEvents
 * @detail this function register a notify function to listen on the floor update change
 * @return none
 * @invoke mainGameView
 */
-(void) setOnFloorEvents:(SEL) aSelector
                           target:(id)aTarget;

/*
 * @brief  getTotalBirdsNum
 * @detail get total birds number of all floors
 * @return NSUInteger
 * @invoke mainGameView
 */
-(NSUInteger)getTotalBirdsNum;

/*
 * @brief  gatherStoppedBirdsForAllFloors
 * @detail gather stopped birds for all floors and remove them
 * @return none
 * @invoke mainGameView
 */
-(eErrorCodes)gatherStoppedBirdsForAllFloors;

/*
 * @brief  animateToRemoveStoppedFloors
 * @detail play an animation and remove stopped floors
 * @return none
 * @invoke [self gatherStoppedBirdsForAllFloors]
 */
-(void)animateToRemoveStoppedFloors;

/*
 * @brief get remain birds num of current floor
 * @return NSUInterger
 * @invoke mainGameView
 */
-(NSUInteger)getRemainBirdsOfCurrentFloor;
@end

@protocol FloorMgrDelegate <NSObject>
-(void) onGameFailed;

-(void) onGameWin;

/* Has all birds flied away */
-(void) onBirdsEmpty;

/* active gather skill */
-(void) activeGatherSkill;

/* increase life */
-(void) updateLife:(NSUInteger)count;

@end
