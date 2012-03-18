//
//  MovingBlockController.h
//  ll
//
//  Created by Apple on 12-1-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "errorCodes.h"

typedef enum {
    FLOOR_BLOCK_MOVE_DIR_NONE,
    FLOOR_BLOCK_MOVE_DIR_RIGHT,
    FLOOR_BLOCK_MOVE_DIR_LEFT,
    FLOOR_BLOCK_MOVE_MAX
}FloorBlockMoveDir;

@interface FloorController : UIView{
    UIView              *blkBgView;
    NSMutableDictionary *imageResources;
    NSMutableArray      *blocks;
    CGRect              rectangle;
    FloorBlockMoveDir   blkDir;
    CGFloat             singleBlkWidth;
    NSTimer             *blkMovingTimer;
    // refresh block counts after "updateRangeBylowerFloorRange" is called
    NSTimer             *floorRefreshTimer;
    SEL                 onFloorRefreshed;
    id                  onFloorRefreshedTarget;
}

@property (readonly, nonatomic)    CGPoint  birdsRange;
@property (readwrite, nonatomic)NSTimeInterval birdsAnimateDuration;
@property (assign)NSUInteger birdsNum;
@property (assign )NSUInteger floorIndex;


-(id)initWithFrame:(CGRect)rect;
-(void)loadView;
-(void)createBirds:(NSUInteger)num;
-(void)onMoveBirdsTimer;
-(void)setOnFloorRefreshedSelector:(SEL)aSelector
                        target:(id) aTarget;
-(void)updateRangeBylowerFloorRange: (CGPoint)lowFloorRange;

@end
