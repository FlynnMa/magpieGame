//
//  magpieClass.h
//  magpieBridge
//
//  Created by yunfei on 12-2-19.
//  Copyright (c) 2012年 __Yunfei.Studio__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
    eMAGPIE_FLY_DIR_RIGHT,
    eMAGPIE_FLY_DIR_LEFT,
    eMAGPIE_FLY_DIR_MAX
}eMagpieFlyDir;

typedef enum {
    eMAGPIE_TYPE_NORMAL,
    eMAGPIE_TYPE_LOVE,
    eMAGPIE_TYPE_ENEGY,
    eMAGPIE_TYPE_START,
    eMAGPIE_TYPE_MAX
}eMagpieType;

#define kMagpieboy                @"DickFace"
#define kMagpieGirl               @"DickFinder"
#define kMagpieWoman              @"DickBender"
#define kMagpieMan                @"DickTator"

#define kMagpieFather             @"DickBurns"
#define kMagpieMather             @"DickBush"

#define kMagpie                   @"DickMagpie"

#define MagpieResourceNums        4

@class mainSettings;
@interface magpieClass : NSObject{
    NSDictionary *iImagesResources;
    eMagpieFlyDir       flyDir;
    NSTimeInterval      timerDuration;
    NSTimer             *iFlyTimer;
    UIImage             *iMagpieImage;
}

@property  (retain, nonatomic, readonly)    CALayer    *iLayer;
@property  (retain, nonatomic, readwrite)   NSString   *iBirdKind;
@property  (readwrite, nonatomic)           CGFloat     startX;
@property  (readwrite, nonatomic)           CGFloat     endX;
@property  (retain)                         id          delegate;
@property  (readwrite, nonatomic)           CGPoint     flyDestination;
@property  (readwrite, nonatomic)           eMagpieType type;
/*
 * @brief:  create a calayer mapie object
 * @invoke: FloorManager
 */
- (id) initWithFrame:(CGRect)frame
       TimerDuration:(NSTimeInterval)Duration
         magpieIndex:(NSUInteger)magpieIndex;

/*
 * @brief:     start fly the magpie
 * @detail:    this function will start a timer with a
 *              pre-initialized timer duration
 * @invoke:    FloorManager
 */
-(void)startFly;

/*
 * @brief:   stop magpie fly
 * @detail:  this function will invalidate the fly timer
 * @invoke:  FloorManager
 */
-(void)stopFly;

/* @brief on response for fly timer
 * @detail judge direction first and 
 * @invoke self fly timer
 */
-(void)onFlyTimer;

/*
 * @brief  set fly destination when fly away this 'magpie bird'
 * @invoke FloorManager
 */
-(void)setFlyDestination:(CGPoint)Destination
        throughPointIndex:(NSUInteger)index;

/*
 * @brief this function is invoked by floor mananger when stopped succeful
 *        and will keep this magpie
 * @invoke FloorManager
 */
-(void) onStopAndKeep;
@end

@protocol CAMagpieDelegate <NSObject>

-(void)flyToPositionDidStop: (magpieClass*)aMagpie;

@end