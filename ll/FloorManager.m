//
//  FloorManager.m
//  ll
//
//  Created by Apple on 12-1-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FloorManager.h"
#import "FloorController.h"
#import "loseWinView.h"

@implementation FloorManager

@synthesize currentActiveFloorIndex, maxFloor, blockNum;
@synthesize gatherNum, currentActiveFloor;
@synthesize totalBirdsNum;
#define FLOOR_NUM 13

const NSTimeInterval FloorDurations[FLOOR_NUM] = {
    0.35,    0.33,
    0.31,   0.29,
    0.27,    0.25,
    0.23,   0.21,
    0.19,    0.17,
    0.13,   0.11,
    0.09
};

-(void) createFloor:(int)index{
    FloorController *floorCtl;
    CGRect frame;
    
    frame = CGRectMake(0, self.bounds.size.height - 1 - floorHeight * (index + 1),
                       self.bounds.size.width, floorHeight);
    floorCtl = [[FloorController alloc] initWithFrame:frame];
    floorCtl.floorIndex = index;
    [Floors addObject:floorCtl];
    [self addSubview:floorCtl];
    [floorCtl release];
}

-(int) activateFloor{
    FloorController *floorCtl;
    NSUInteger  count;

    count = [Floors count];
    if (count < currentActiveFloorIndex) {
        NSLog(@"wrong index");
        return 1;
    }
    
    floorCtl = [Floors objectAtIndex:currentActiveFloorIndex];
    [floorCtl setOnFloorRefreshedSelector:@selector(onFloorRefreshed) target:self];
    floorCtl.blkAnimateDuration = FloorDurations[currentActiveFloorIndex];
    [floorCtl activateFloorWithNum:blockNum];
    currentActiveFloor = floorCtl;
    return 0;
}

-(void) deactivateFloor{
    // stop current floor
    FloorController *floorCtl;
    floorCtl = [Floors objectAtIndex:currentActiveFloorIndex];
    if (floorCtl.floorStatus == eFLOOR_STATUS_PLAYING) {
        [floorCtl deactivateFloor];
    }
    [self updateCurrentBlkRangeAccordingPrevious];
}

-(void) activateNextFloor{
    
    if (currentActiveFloorIndex >= maxFloor) {
        // passed current level, start next
        // under construction
        return;
    }
    
    currentActiveFloorIndex ++;
    [self createFloor:currentActiveFloorIndex];
    [self activateFloor];
}

-(void) setOnFloorUpdatedSelector:(SEL) aSelector
                          target:(id)aTarget{
    onFloorUpdated = aSelector;
    onFloorUpdatedTarget = aTarget;
}

-(void) onFloorRefreshed{
    FloorController *floorCtl;
    
    floorCtl = [Floors objectAtIndex:currentActiveFloorIndex];
    blockNum = floorCtl.blkNum;
    if (onFloorUpdated) {
        [onFloorUpdatedTarget performSelector:onFloorUpdated];
    }
}

-(void) updateCurrentBlkRangeAccordingPrevious{
    FloorController *currFloorCtl, *prevFloorCtl;
    
    if (currentActiveFloorIndex == 0) {
        if (onFloorUpdated) {
            [onFloorUpdatedTarget performSelector:onFloorUpdated];
        }
        return;
    }
    currFloorCtl = [Floors objectAtIndex: currentActiveFloorIndex];
    prevFloorCtl = [Floors objectAtIndex: (currentActiveFloorIndex - 1)];
    [currFloorCtl updateRangeBylowerFloorRange:prevFloorCtl.blkRange];
}

-(NSUInteger) getRemainBlocksOfCurrentFloor{
    FloorController *floorCtl;
    
    floorCtl = [Floors objectAtIndex:currentActiveFloorIndex];
    return floorCtl.blkNum;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    NSLog(@"floormananger frame is %@", NSStringFromCGRect(frame));
    if (self) {
//        [self setBackgroundColor:[UIColor blueColor]];
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Aquarius.png"]];
        floorHeight = frame.size.height / FLOOR_NUM;
        Floors = [[NSMutableArray alloc]  init];
        // should load data from persistant storage
        level = 0;
        currentActiveFloorIndex = 0;
        maxFloor = FLOOR_NUM - 1;
        [self createFloor:0];
    }
    return self;
}

-(void) dealloc{
    NSLog(@"dealloc floor manager...");
    [Floors removeAllObjects];
    [Floors release];
}

-(void)animateToRemoveStoppedFloors{
    // pause current playing floor
    currentActiveFloor = [Floors objectAtIndex:currentActiveFloorIndex];
    [currentActiveFloor setFloorStatus:eFLOOR_STATUS_PAUSED];
    
    void (^remove_afloor)(void) = ^(void){
        CGRect rect;
        FloorController *fl;
        int i , num;
        
        num = [Floors count];
        fl = [Floors objectAtIndex:0];
        rect = fl.frame;
        rect.origin.y += rect.size.height;
        rect.size.height = 0;
        [fl setFrame: rect];
        for (i = 1; i < num; i ++) {
            CGPoint center;
            
            fl = [Floors objectAtIndex:i];
            rect = fl.bounds;
            center = fl.center;
            center.y += fl.bounds.size.height;
            [fl setCenter:center];
        }
        
    };
    
    // play effects to move
    [UIView animateWithDuration:0.1
                     animations:
                     remove_afloor
                     completion:^(BOOL finished) {
                         FloorController *fCtl;
                         int count;
                         
                         fCtl = [Floors objectAtIndex:0];
                         NSLog(@"fctl** remain count%d", [fCtl retainCount]);
                         [fCtl removeFromSuperview];
                         NSLog(@"fctl** remain count%d", [fCtl retainCount]);
                         [Floors removeObject:fCtl];
                         currentActiveFloorIndex --;
                         
                         count = [Floors count];
                         if (count > 1) {
                             [self animateToRemoveStoppedFloors];
                         } else {
                             [currentActiveFloor setFloorStatus:eFLOOR_STATUS_PLAYING];
                         }
                     }];
    
}

-(NSUInteger)getTotalBirdsNum{
    NSUInteger num;
    NSUInteger i;
    FloorController *aFloor;
    NSUInteger totalBirds = 0;
    NSUInteger totalFloors = 0;
    
    num = [Floors count];
    for (i = 0; i < currentActiveFloorIndex; i ++) {
        aFloor = [Floors objectAtIndex:i];
        NSLog(@"aFloor -- retain count%d", [aFloor retainCount]);
        
        // following codes are for test temply
        aFloor = [Floors objectAtIndex:i];
        NSLog(@"aFloor -- retain count%d", [aFloor retainCount]);
        
        totalBirds += aFloor.blkNum;
        totalFloors ++;
    }
    return totalBirds;
}

-(eErrorCodes)gatherStoppedFloor{
    
    if ([self getTotalBirdsNum] < self.gatherNum) {
        return EEMPTY;
    }
    
    // start animate to remove all stopped floors
    [self animateToRemoveStoppedFloors];
    return SUCCESS;
}

@end
