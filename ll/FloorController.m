//
//  FloorController.m
//  ll
//
//  Created by Apple on 12-1-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FloorController.h"
#import <QuartzCore/QuartzCore.h>

/*
 * definitions
 */
#define NUMBER_OF_BIRDS_PER_LINE   9
#define BIRDS_Y_MARGIN              4
#define BIRDS_X_MARGIN              4

#define DEFAULT_ANIMATION_DURATION  0.3

@implementation FloorController;

/* properties */
@synthesize birdsAnimateDuration = _birdsAnimateDuration;
@synthesize birdsNum;
@synthesize floorIndex;
@synthesize floorStatus = _floorStatus;
@synthesize birdsRange = _birdsRange;

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
        singleBlkWidth = abs(rect.size.width / NUMBER_OF_BIRDS_PER_LINE);
        _birdsAnimateDuration = DEFAULT_ANIMATION_DURATION;
        self.clipsToBounds = YES;
        [self loadView];
    }
    return self;
}

-(void)dealloc{

    NSLog(@"-- floorcontroller dealloc...");
    [blocks release];
    [blkBgView release];
    [imageResources release];
    [super release];
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    self.layer.cornerRadius = 10;

    blkBgView = [[UIView alloc] init];
    blkBgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
                                UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:blkBgView];
    blocks = [[NSMutableArray alloc] init];
}

- (UIImageView*) createSingleBird:(CGRect)frame{
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:frame] autorelease];

    NSLog(@"-- image reference%d", [imageView.image retainCount]);
    imageView.image = [imageResources objectForKey:@"right"];
    NSLog(@"-- image reference%d", [imageView.image retainCount]);
    return imageView;
}

- (void)refreshBirdsPositions{
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
    if (blkFrame.origin.x > BIRDS_X_MARGIN) {
        blkFrame.origin.x = BIRDS_X_MARGIN;
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

- (void)createBirds:(NSUInteger)num{
    CGRect blkFrame;
    CGRect blkBgFrame;
    NSUInteger i = 0;
    UIImageView *imageView;

    birdsNum = num;
    _birdsRange.x = 0;
    _birdsRange.y = birdsNum - 1;
    // initialized for the first time
    blkDir = FLOOR_BLOCK_MOVE_DIR_RIGHT;

    blkBgFrame = CGRectMake(0, 0, singleBlkWidth * num, self.bounds.size.height);
    blkBgView.frame = blkBgFrame;
    blkFrame = self.bounds;
    blkFrame.size.width = singleBlkWidth - BIRDS_X_MARGIN * 2;
    blkFrame.origin.x = BIRDS_X_MARGIN;
    blkFrame.origin.y = BIRDS_Y_MARGIN;
    blkFrame.size.height -= BIRDS_X_MARGIN * 2;
    while (i < num) {
        imageView = [self createSingleBird:blkFrame];

        [blkBgView addSubview:imageView];
        [blocks addObject:imageView];
        NSLog(@"retain count %d", [imageView retainCount]);
        blkFrame.origin.x += blkFrame.size.width + BIRDS_X_MARGIN * 2;
        i ++;
    }
}

-(BOOL)isBirdsOnRightSide{
    CGRect blkFrame = blkBgView.frame;
    CGRect bgFrame = self.frame;

    if((blkFrame.origin.x + blkFrame.size.width) >= (bgFrame.origin.x + bgFrame.size.width - BIRDS_X_MARGIN - 1)) {
        return YES;
    }
    
    return NO;
}

-(BOOL)IsBirdsOnLeftSide{
    CGRect blkFrame = blkBgView.frame;
    
    if (blkFrame.origin.x <= BIRDS_X_MARGIN + 1) {
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
}

-(void)onMoveBirdsTimer{
    CGPoint newCenter;

    newCenter = blkBgView.center;
    if ((YES == [self isBirdsOnRightSide])
        && (blkDir == FLOOR_BLOCK_MOVE_DIR_RIGHT)){
        // change to move left
        blkDir = FLOOR_BLOCK_MOVE_DIR_LEFT;
    } else if((blkDir == FLOOR_BLOCK_MOVE_DIR_LEFT) && 
              (YES == [self IsBirdsOnLeftSide])){
        // change to move right
        blkDir = FLOOR_BLOCK_MOVE_DIR_RIGHT;
    }
    if (blkDir == FLOOR_BLOCK_MOVE_DIR_RIGHT) {
        newCenter.x = blkBgView.center.x + singleBlkWidth;
        _birdsRange.x ++;
        _birdsRange.y ++;
    } else if(blkDir == FLOOR_BLOCK_MOVE_DIR_LEFT) {
        newCenter.x = blkBgView.center.x - singleBlkWidth;
        _birdsRange.x --;
        _birdsRange.y --;
    } else{
        NSLog(@"moving block unknown direction!!!");
    }

    [self refreshBlockImage];
    [blkBgView setCenter:newCenter];
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

-(void)removeBirdByIndex:(NSUInteger)index{
    UIView *blkView;
    CGRect frame, bgFrame;

    // object at index method will not increase retain number, do not release it when exit
    blkView = [blocks objectAtIndex:index];
    frame = blkView.frame;
    bgFrame = blkBgView.frame;
    if (frame.origin.x == BIRDS_X_MARGIN) {
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
                        [self refreshBirdsPositions];
                    } completion:^(BOOL finished) {
                        [blkView removeFromSuperview];
                    }];
}


-(void)updateRangeBylowerFloorRange: (CGPoint)lowFloorRange{

    if (_floorStatus == eFLOOR_STATUS_PLAYING) {
        return;
    }

    while ((_birdsRange.x < lowFloorRange.x) && (birdsNum > 0)) {
        [self removeBirdByIndex:0];
        _birdsRange.x ++;
        birdsNum --;
    }

    while ((_birdsRange.y > lowFloorRange.y) && (birdsNum > 0)) {
        [self removeBirdByIndex:birdsNum - 1];
        birdsNum --;
        _birdsRange.y --;
    }

    if (nil == floorRefreshTimer) {
        floorRefreshTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                             target:self
                                                           selector:@selector(onRefreshFloorTimer)
                                                           userInfo:nil repeats:NO];
    }
}

-(void)setFloorStatus:(eFloorStatus)newStatus{
    NSLog(@"setFloorStatus %d origin %d", newStatus, _floorStatus);
    if (newStatus == _floorStatus) {
        return;
    }

    switch (newStatus) {
        case eFLOOR_STATUS_PAUSED:
            if (_floorStatus == eFLOOR_STATUS_PLAYING) {
                [blkMovingTimer invalidate];
            }
            _floorStatus = eFLOOR_STATUS_PAUSED;
        break;
            
        case eFLOOR_STATUS_PLAYING:
            blkMovingTimer = [NSTimer scheduledTimerWithTimeInterval:_birdsAnimateDuration
                                                              target:self
                                                            selector:@selector(onMoveBirdsTimer)
                                                            userInfo:nil
                                                             repeats:YES];
            _floorStatus = eFLOOR_STATUS_PLAYING;
        break;
            
        case eFLOOR_STATUS_STOPPED:
            blkDir = FLOOR_BLOCK_MOVE_DIR_NONE;
            _floorStatus = eFLOOR_STATUS_STOPPED;
            [blkMovingTimer invalidate];
            [self refreshBlockImage];
            break;

        default:
            break;
    }
    NSLog(@"setFloorStatus %d - %d", newStatus, _floorStatus);
}
@end
