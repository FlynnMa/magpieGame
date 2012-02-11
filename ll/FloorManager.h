//
//  FloorManager.h
//  ll
//
//  Created by Apple on 12-1-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "errorCodes.h"

@class FloorController;

@interface FloorManager : UIView{
    NSMutableArray  *Floors;
    CGFloat         floorHeight;  // floor height
    NSUInteger      level;
    SEL             onFloorUpdated;
    id              onFloorUpdatedTarget;
}

@property(readwrite, assign)    NSInteger  currentActiveFloorIndex; /* 0~12 */
@property(readonly, retain, nonatomic)  FloorController *currentActiveFloor;
@property(readwrite, assign)    NSInteger  maxFloor;
@property(readwrite, assign)    NSUInteger blockNum;
@property(readwrite, assign)    NSUInteger gatherNum;
@property(readonly, nonatomic)  NSUInteger totalBirdsNum;

// activate current floor
-(int)activateFloor;
// deactivate current floor
-(void)deactivateFloor;
// activate next floor
-(void)activateNextFloor;
// update current block range, to align with previous one
-(void)updateCurrentBlkRangeAccordingPrevious;
// to listen to the floor controller about the change of current block
-(void)onFloorRefreshed;

// set a listener by main view to get the floor updated notification
-(void)setOnFloorUpdatedSelector:(SEL) aSelector
                          target:(id)aTarget;

//get remain blocks of current floor
-(NSUInteger)getRemainBlocksOfCurrentFloor;

-(NSUInteger)getTotalBirdsNum;

-(eErrorCodes)gatherStoppedFloor;
@end
