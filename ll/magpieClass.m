//
//  magpieClass.m
//  magpieBridge
//
//  Created by Apple on 12-2-19.
//  Copyright (c) 2012年 __Yunfei.Studio__. All rights reserved.
//

#import "magpieClass.h"
#import "mainSettings.h"

@implementation magpieClass

@synthesize iLayer    = _iLayer;
@synthesize iBirdKind = _iBirdKind;
@synthesize startX    = _startX;
@synthesize endX      = _endX;
@synthesize delegate  = _delegate;
@synthesize flyDestination  = _flyDestination;
@synthesize type      = _type;

static const CGPoint passPoint[10] = {
    {384, 373},
    {428, 411},
    {428, 203},
    {384, 490},
    {330, 313},
    {336, 305},
    {345, 350},
    {310, 330},
    {280, 428},
    {500, 300}
};

static const CFTimeInterval flyDurations[] ={
    0.9,1.0,1.1,1.2,1.3,1.4
};

/*
 * @brief:  create a calayer mapie object
 * @invoke: FloorManager
 */
- (id) initWithFrame:(CGRect)frame
       TimerDuration:(NSTimeInterval)Duration
         magpieIndex:(NSUInteger)magpieIndex{
    self = [super init];
    if (self) {
        mainSettings        *iSettings;
        NSArray             *iArray;
        NSString            *aKey;
        NSUInteger          count;
        iSettings = [mainSettings sharedSettings];
        _iLayer = [CALayer layer];

        [_iLayer retain];
        [_iLayer setBorderColor:[UIColor brownColor].CGColor];
        [_iLayer setFrame:frame];
        _startX = _iLayer.position.x;
        /* just set a default value for endx, will be updated later */
        _endX   = _startX + _iLayer.bounds.size.width * (iSettings.floorBirdsNum.intValue - 1);
        flyDir = eMAGPIE_FLY_DIR_RIGHT;
        timerDuration = Duration;
        [_iLayer setName:kMagpie];
        // if it is a speical one
        if (magpieIndex >= 4) {
            iImagesResources = iSettings.magpieSpeicalResources;
            magpieIndex -= 4;
            _type = magpieIndex + eMAGPIE_TYPE_LOVE;
        } else {
            iImagesResources = iSettings.magpieResources;
            _type = eMAGPIE_TYPE_NORMAL;
        }
        iArray = [iImagesResources allKeys];
        count = [iArray count];
        if (count > 0) {
            NSString *iImageName, *path;

            aKey = [iArray objectAtIndex:magpieIndex];
            iImageName = [iImagesResources objectForKey:aKey];
            path = [[NSBundle mainBundle] pathForResource:iImageName ofType:@"png"];
            iMagpieImage = [[UIImage alloc] initWithContentsOfFile:path];
        }
        [iImagesResources retain];
    }

    return self;
}

/*
 * @brief dealloc magpie
 */
-(void)dealloc{

//    NSLog(@"dealloc magpie ...");
    if (iFlyTimer) {
        [iFlyTimer invalidate];
    }

    [iMagpieImage release];
    [_iLayer release];
    [iImagesResources release];
    [super release];
}

/*
 * @brief:     start fly the magpie
 * @detail:    this function will start a timer with a
 *              pre-initialized timer duration
 * @invoke:    FloorManager
 */
-(void)startFly{

    iFlyTimer = [NSTimer scheduledTimerWithTimeInterval:timerDuration
                                                 target:self
                                               selector:@selector(onFlyTimer)
                                               userInfo:nil
                                                repeats:YES];
}

/*
 * @brief:   stop magpie fly
 * @detail:  this function will invalidate the fly timer
 * @invoke:  FloorManager
 */
-(void)stopFly{
    
    if (iMagpieImage) {
        _iLayer.contents = (id)[iMagpieImage CGImage];        
    }
    [iFlyTimer invalidate];
    iFlyTimer = nil;
}

/* @brief on response for fly timer
 * @detail judge direction first and 
 * @invoke self fly timer
 */
-(void)onFlyTimer{
    CGRect   frame;
    CGPoint  position = _iLayer.position;
//    NSString *key;
    
    switch (flyDir) {
        case eMAGPIE_FLY_DIR_RIGHT:
            /* if reached the right, change direction to left */
            if (position.x >= _endX) {
                flyDir = eMAGPIE_FLY_DIR_LEFT;
            }
            break;

        case eMAGPIE_FLY_DIR_LEFT:
            /* if reached the left, change direction to right*/
            if (position.x <= _startX) {
                flyDir = eMAGPIE_FLY_DIR_RIGHT;
            }
            break;
            
        default:
            NSLog(@"magpie on fly, do not know direction!!!");
            return;
    }
    
    frame = _iLayer.frame;
    if (eMAGPIE_FLY_DIR_RIGHT == flyDir) {
        position.x += frame.size.width;
//        key = @"right";
    } else {
        position.x -= frame.size.width;
//        key = @"left";
    }
//    UIImage *image = [iImagesResources objectForKey:key];

    _iLayer.contents = (id)[iMagpieImage CGImage];
    [_iLayer removeAnimationForKey:@"position"];
    CABasicAnimation  *iAnimation = nil;
    
    iAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    iAnimation.timingFunction = [CAMediaTimingFunction functionWithName:
                                 kCAMediaTimingFunctionLinear];
    [iAnimation setToValue:[NSValue valueWithCGPoint:position]];
    [iAnimation setDuration:timerDuration];
    [iAnimation setRemovedOnCompletion:YES];
    iAnimation.autoreverses = NO;

    [_iLayer setPosition:position];
    [_iLayer addAnimation:iAnimation forKey:@"position"];
}

-(void)setFlyDestination:(CGPoint)Destination
        throughPointIndex:(NSUInteger)index{
    [_iLayer removeAnimationForKey:@"flyAway"];
    _flyDestination = Destination;
//    CGRect    superBounds = _iLayer.superlayer.bounds;
    CGPoint   midPoint = passPoint[index];
    CGPoint   startPoint = _iLayer.position;
    CGMutablePathRef flyPath = CGPathCreateMutable();
    CGPathMoveToPoint(flyPath, NULL, startPoint.x, startPoint.y);
//    midPoint.x = (startPoint.x - midPoint.x)/3 + midPoint.x;
//    midPoint.y = (startPoint.y - midPoint.y)/3 + midPoint.y;
//    midPoint = passPoint[index];
    CGPathAddCurveToPoint(flyPath,NULL,
                          abs(startPoint.x + midPoint.x)/2,
                          startPoint.y,
                          midPoint.x,
                          abs(startPoint.y + midPoint.y) / 2,
                          midPoint.x, midPoint.y
                          );
    CGPathAddCurveToPoint(flyPath, NULL,
                          _flyDestination.x,
                          midPoint.y,
                          midPoint.x,
                          _flyDestination.y,
                          _flyDestination.x, _flyDestination.y);
    
    CAKeyframeAnimation  *flyAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    flyAnim.path = flyPath;
    flyAnim.duration = flyDurations[rand()%6];
    flyAnim.delegate = self;
    flyAnim.removedOnCompletion = NO;
    flyAnim.fillMode = kCAFillModeForwards;
    flyAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    CGPathRelease(flyPath);

    [_iLayer addAnimation:flyAnim forKey:@"flyAway"];
}

-(void) onStopAndKeep{

}

-(void) animationDidStart:(CAAnimation *)anim{
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if(YES == flag) {
        _iLayer.position = _flyDestination;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(flyToPositionDidStop:)]) {
        [_delegate flyToPositionDidStop:self];
    }
}
@end
