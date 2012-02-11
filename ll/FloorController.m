//
//  MovingBlockController.m
//  ll
//
//  Created by Apple on 12-1-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FloorController.h"
#import <QuartzCore/QuartzCore.h>

#define BG_VIEW_DEFAULT_HEIGHT      60
#define NUMBER_OF_BLOCKS_PER_LINE   9
#define BLOCK_Y_MARGIN              4
#define BLOCK_X_MARGIN              4

#define DEFAULT_ANIMATION_DURATION  0.3

@implementation FloorController
@synthesize blkAnimateDuration, blkRange, blkNum;
@synthesize floorIndex;
@synthesize floorStatus = _floorStatus;

UIImage *centerImg, *leftImg, *rightImg;

- (id)initWithFrame:(CGRect)rect{
    self = [super initWithFrame:rect];
    if (self) {
        UIImage *image;
        
        imageResources = [[NSMutableDictionary alloc] init];
        image = [UIImage imageNamed:@"block.png"];
        [imageResources setObject:image forKey:@"center"];
        image = [UIImage imageNamed:@"block_left.png"];
        [imageResources setObject:image forKey:@"left"];
        image = [UIImage imageNamed:@"block_right.png"];
        [imageResources setObject:image forKey:@"right"];
        rectangle = rect;
        singleBlkWidth = abs(rect.size.width / NUMBER_OF_BLOCKS_PER_LINE);
        blkAnimateDuration = DEFAULT_ANIMATION_DURATION;
        self.clipsToBounds = YES;
        [self loadView];
    }
    return self;
}

-(void)dealloc{
    NSLog(@"floorcontroller dealloc...");
    [blocks release];
    [blkBgView release];
    [super release];
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    NSLog(@"***********");
    if ((rectangle.size.height == 0) || (rectangle.size.width == 0)) {
        NSLog(@"error! bad frame value%@", NSStringFromCGRect(rectangle));
        return;
    }

    [self setBackgroundColor:[UIColor colorWithRed:0
                                             green:0
                                              blue:0
                                             alpha:0.3]];
//    self.layer.borderWidth = 1;
//    self.layer.borderColor = [UIColor blueColor].CGColor;
    self.layer.cornerRadius = 10;
    
    blkBgView = [[UIView alloc] init];
    blkBgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
                                UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:blkBgView];
    blocks = [[NSMutableArray alloc] init];
}

- (UIImageView*) createSingleBlock:(CGRect)frame{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];

    imageView.image = [imageResources objectForKey:@"right"];
    NSLog(@"-- image reference%d", [imageView.image retainCount]);
    return imageView;
}

- (void)refreshBlocksPositions{
    NSUInteger size;
    int i;
    UIImageView *blkView;
    CGRect blkFrame;

    size = [blocks count];
    if (0 == size) {
        return;
    }
    blkView = [blocks objectAtIndex:0];
    blkFrame = blkView.frame;
    NSLog(@"refresh block frame%@", NSStringFromCGRect(blkFrame));
    if (blkFrame.origin.x > BLOCK_X_MARGIN) {
        blkFrame.origin.x = BLOCK_X_MARGIN;
        [blkView setFrame:blkFrame];
    }
    i = 1;
    while (i < size) {
        blkView = [blocks objectAtIndex: i];
        blkFrame.origin.x += singleBlkWidth;
        [blkView setFrame:blkFrame];
        i ++;
    }
}

- (void)addMovingBlocks:(NSUInteger)num{
    CGRect blkFrame;
    CGRect blkBgFrame;
    NSUInteger i = 0;
    UIImageView *imageView;

    blkBgFrame = CGRectMake(0, 0, singleBlkWidth * num, self.bounds.size.height);
    blkBgView.frame = blkBgFrame;
    blkFrame = self.bounds;
    blkFrame.size.width = singleBlkWidth - BLOCK_X_MARGIN * 2;
    blkFrame.origin.x = BLOCK_X_MARGIN;
    blkFrame.origin.y = BLOCK_Y_MARGIN;
    blkFrame.size.height -= BLOCK_X_MARGIN * 2;
    while (i < num) {
        imageView = [self createSingleBlock:blkFrame];
        
        [blkBgView addSubview:imageView];
        [blocks addObject:imageView];
        [imageView release];
        blkFrame.origin.x += blkFrame.size.width + BLOCK_X_MARGIN * 2;
        i ++;
    }
}

-(BOOL)isBlockOnRightSide{
    CGRect blkFrame = blkBgView.frame;
    CGRect bgFrame = self.frame;

    if((blkFrame.origin.x + blkFrame.size.width) >= (bgFrame.origin.x + bgFrame.size.width - BLOCK_X_MARGIN - 1)) {
        return YES;
    }
    
    return NO;
}

-(BOOL)IsBlockOnLeftSide{
    CGRect blkFrame = blkBgView.frame;
    
    if (blkFrame.origin.x <= BLOCK_X_MARGIN + 1) {
        return YES;
    }
    
    return NO;
}

-(void)refreshBlockImage{
    NSUInteger i, count;
    UIImageView *imageView;
    UIImage     *image;
    NSString    *key;

    if (blkDir == FLOOR_BLOCK_MOVE_DIR_LEFT) {
        key = @"left";
    } else if(blkDir == FLOOR_BLOCK_MOVE_DIR_RIGHT){
        key = @"right";
    } else {
        key = @"center";
    }
    image = [imageResources objectForKey:key];

    for (i = 0, count = blocks.count; i < count; i ++) {
        imageView = [blocks objectAtIndex:i]; // no need to release imageview
        imageView.image = image;
    }
    [key release];
}
-(void)onMoveBlockTimer{
    CGPoint newCenter;

    newCenter = blkBgView.center;
    if ((YES == [self isBlockOnRightSide])
        && (blkDir == FLOOR_BLOCK_MOVE_DIR_RIGHT)){
        // change to move left
        blkDir = FLOOR_BLOCK_MOVE_DIR_LEFT;
    } else if((blkDir == FLOOR_BLOCK_MOVE_DIR_LEFT) && 
              (YES == [self IsBlockOnLeftSide])){
        // change to move right
        blkDir = FLOOR_BLOCK_MOVE_DIR_RIGHT;
    }
    if (blkDir == FLOOR_BLOCK_MOVE_DIR_RIGHT) {
        newCenter.x = blkBgView.center.x + singleBlkWidth;
        blkRange.x ++;
        blkRange.y ++;
    } else if(blkDir == FLOOR_BLOCK_MOVE_DIR_LEFT) {
        newCenter.x = blkBgView.center.x - singleBlkWidth;
        blkRange.x --;
        blkRange.y --;
    } else{
        NSLog(@"moving block unknown direction!!!");
    }

    [self refreshBlockImage];
    [blkBgView setCenter:newCenter];
}

-(void) startMoveBlocks{

    blkMovingTimer = [NSTimer scheduledTimerWithTimeInterval:blkAnimateDuration
                                target:self
                                selector:@selector(onMoveBlockTimer)
                                userInfo:nil
                                repeats:YES];
    _floorStatus = eFLOOR_STATUS_PLAYING;

}

-(int)activateFloorWithNum: (NSUInteger)num{
    blkNum = num;
    blkRange.x = 0;
    blkRange.y = blkNum - 1;
    // initialized for the first time
    blkDir = FLOOR_BLOCK_MOVE_DIR_RIGHT;

    _floorStatus = eFLOOR_STATUS_PLAYING;
    [self addMovingBlocks:num];

    [self startMoveBlocks];
    return 0;
}

-(void)deactivateFloor{
    [blkMovingTimer invalidate];
    blkDir = FLOOR_BLOCK_MOVE_DIR_NONE;
    _floorStatus = eFLOOR_STATUS_STOPPED;
    [self refreshBlockImage];
}

-(void)setOnFloorRefreshedSelector:(SEL)aSelector
                       target:(id)aTarget{
    onFloorRefreshed = aSelector;
    onFloorRefreshedTarget = aTarget;
}

-(void)onRefreshFloorTimer{
    if (onFloorRefreshed) {
        [onFloorRefreshedTarget performSelector:onFloorRefreshed];
    }
}

-(void)removeBlkByIndex:(NSUInteger)index{
    UIView *blkView;
    CGRect frame, bgFrame;

    // object at index method will not increase retain number, do not release it when exit
    blkView = [blocks objectAtIndex:index];
    frame = blkView.frame;
    bgFrame = blkBgView.frame;
    if (frame.origin.x == BLOCK_X_MARGIN) {
        bgFrame.origin.x += singleBlkWidth;
    }

    bgFrame.size.width -= singleBlkWidth;
    
    frame.size.width = 0;
    [blocks removeObject:blkView];
    [UIView transitionWithView:blkView
                      duration:0.6
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [blkView setFrame: frame];
                        [blkBgView setFrame:bgFrame];
                        [self refreshBlocksPositions];
                    } completion:^(BOOL finished) {
                        [blkView removeFromSuperview];
                    }];
}


-(void)updateRangeBylowerFloorRange: (CGPoint)lowFloorRange{
    NSUInteger size;
    BOOL       rangeChanged = NO;

    if (_floorStatus == eFLOOR_STATUS_PLAYING) {
        return;
    }

    while ((blkRange.x < lowFloorRange.x) && (blkNum > 0)) {
        [self removeBlkByIndex:0];
        blkRange.x ++;
        blkNum --;
        rangeChanged = YES ;
    }

    while ((blkRange.y > lowFloorRange.y) && (blkNum > 0)) {
        size = [blocks count];
        [self removeBlkByIndex:blkNum - 1];
        blkNum --;
        blkRange.y --;
        rangeChanged = YES;
    }

    if (nil == floorRefreshTimer) {
        floorRefreshTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                             target:self
                                                           selector:@selector(onRefreshFloorTimer)
                                                           userInfo:nil repeats:NO];
    }
}

-(void)setFloorStatus:(eFloorStatus)newStatus{
    switch (newStatus) {
        case eFLOOR_STATUS_PAUSED:
            if (_floorStatus == eFLOOR_STATUS_PLAYING) {
                [blkMovingTimer invalidate];
            }
            _floorStatus = eFLOOR_STATUS_PAUSED;
        break;
            
        case eFLOOR_STATUS_PLAYING:
            [self startMoveBlocks];
        break;

        default:
            break;
    }
}
@end
