//
//  FloorManager.m
//  ll
//
//  Created by Yunfei on 12-1-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FloorManager.h"
#import "loseWinView.h"
#import "magpieClass.h"
#import "mainSettings.h"
#import "levelManager.h"

static void createRadomList(int *pBuf, int length){
    int i,j;
    int remainNum, index;
    unsigned int aSeed;
    
    /*invalidate all index*/
    for(i = 0; i < length; i ++){
        pBuf[i] = -1;
    }
    
    /* seed */
    aSeed = rand();
    srand(aSeed+(unsigned int)&length);
    for(i = 0; i < length; i ++){
        /* remain num of index */
        remainNum = length - i;
        /* a new index generated */
        index = rand() % remainNum;
        index ++;
        /* add index to table */
        for(j = 0; j < length; j ++){
            if(pBuf[j] == -1){
                index --;
            }
            if(index == 0){
                break;
            }
        }
        pBuf[j] = i;
    }
}

static void swapAddrValue(int *pValue1, int *pValue2){
    NSUInteger tmp;
    
    tmp = *pValue1;
    *pValue1 = *pValue2;
    *pValue2 = tmp;
}

static void createSpecialList(int *pList){

    createRadomList(pList, 3);
    createRadomList(&pList[3], 3);
    createRadomList(&pList[6], 3);
    swapAddrValue(&pList[2], &pList[4]);
    swapAddrValue(&pList[4], &pList[7]);
}
@implementation FloorManager

@synthesize currentActiveFloorIndex = _currentActiveFloorIndex;
@synthesize maxFloor = _maxFloor;
@synthesize initialBirdsNum = _initialBirdsNum;
@synthesize iDicCurrActiveFloor = _iDicCurrActiveFloor;
@synthesize totalBirdsNum = _totalBirdsNum;
@synthesize status = _status;
@synthesize delegate = _delegate;
#define FLOOR_NUM 13

#define kFloorIndex                 @"floorIndex"
#define kFloorStatus                @"floorStatus"
#define kFloorPositionY             @"positionY"
#define kFloorBirdsStartIndex       @"birdsStartIndex"
#define kFloorBirdsEndIndex         @"birdsEndIndex"
#define kFloorBirdsFlySpeed         @"birdsFlyDuration"
#define kFloorBirdsArray            @"birdsArray"

const NSTimeInterval FloorDurations[FLOOR_NUM] = {
    0.15,    0.14,
    0.13,   0.12,
    0.11,    0.09,
    0.09,   0.09,
    0.09,    0.09,
    0.09,   0.09,
    0.09
};

/*
 * @brief create floor
 * @detail create a floor for flying birds at an index
 * @param  index (0~n), the max value of index is (maxFloor -1),
 * which is load from configuration file
 * @return none
 * @invoke mainGameView
 */
-(void) createFloor:(int)index{
    NSMutableDictionary     *iDicFloor = [[NSMutableDictionary alloc] init];
    NSUInteger               positionY = self.bounds.size.height - 1 - floorHeight * (index + 1);
    eFloorStatus             status = eFLOOR_STATUS_NONE;

    [iDicFloor setObject:[NSNumber numberWithInt:index] forKey:kFloorIndex];
    [iDicFloor setObject:[NSNumber numberWithInt:positionY] forKey:kFloorPositionY];
    [iDicFloor setObject:[NSNumber numberWithInt:status] forKey:kFloorStatus];
    [iDicFloor setObject:[NSNumber numberWithFloat:FloorDurations[index]]
                  forKey:kFloorBirdsFlySpeed];

    [Floors addObject:iDicFloor];
    [iDicFloor release];
}

-(void) flyMagpiesInActiveFloor:(BOOL)isFly{
    NSMutableDictionary    *iDicFloor;
    NSMutableArray         *magpieArray;
    magpieClass            *aMagpie;

    iDicFloor = [Floors objectAtIndex:_currentActiveFloorIndex];
    magpieArray = [iDicFloor objectForKey:kFloorBirdsArray];
    for (aMagpie in magpieArray) {
        if(YES == isFly) {
            [aMagpie startFly];
        } else {
            [aMagpie stopFly];
        }
    }
}

/*
 * @brief start floor
 * @detail start a floor for flying birds at currentActiveFloorIndex
 * @return error codes
 */
-(int) startFloor{
    NSUInteger  count;
    NSMutableDictionary *iDicFloor;
    NSUInteger          birdWidth, birdHeight;
    NSUInteger          xMargin;
    CGRect              frame;
    CGFloat             positionY;
    NSMutableArray     *magpieArrary;
    NSTimeInterval      flyDuration;
    int                 magpieList[12];
    NSUInteger          magpieIndex;

    NSLog(@"start floor %d...", _currentActiveFloorIndex);
    count = [Floors count];
    if (_currentActiveFloorIndex >= count) {
        NSLog(@"fatail error:start floor does not exist at index %d", _currentActiveFloorIndex);
        return 1;
    }

    iDicFloor = [Floors objectAtIndex:_currentActiveFloorIndex];
    magpieArrary = [iDicFloor objectForKey:kFloorBirdsArray];
    /* if already have birds created */
    if (nil != magpieArrary) {
        /* play the floor, fly birds */
        [iDicFloor setValue:[NSNumber numberWithInt:eFLOOR_STATUS_PLAYING]
                      forKey:kFloorStatus];
        [self flyMagpiesInActiveFloor:YES];
        return SUCCESS;
    }
    
    magpieArrary = [[NSMutableArray alloc] init];
    NSLog(@"floormanager bounds %@", NSStringFromCGRect(self.bounds));
    birdWidth     = abs(self.bounds.size.width / maxBirdsNumPerLine);
    birdHeight    = floorHeight;
    xMargin = (self.bounds.size.width - birdWidth * maxBirdsNumPerLine) / 2;
    positionY   = [[iDicFloor objectForKey:kFloorPositionY] floatValue];
    frame = CGRectMake(xMargin, positionY, birdWidth, birdHeight);
    flyDuration = FloorDurations[_currentActiveFloorIndex];
    createRadomList(magpieList, 4);
    if ((_currentActiveFloorIndex > 0)
        && (0 == (_currentActiveFloorIndex % floorsPerSpecial))) {
        magpieList[rand()%4] = SpecialList[currentSpecialIndex++] + 4;
    }
    for (int i = 0; i < _initialBirdsNum; i ++) {
        magpieIndex = magpieList[i];
        magpieClass *aMagpie = [[magpieClass alloc] initWithFrame:frame
                                TimerDuration:flyDuration
                                magpieIndex:magpieIndex];

        aMagpie.startX = aMagpie.iLayer.position.x;
        aMagpie.endX   = self.bounds.size.width -
            ((_initialBirdsNum - i) * birdWidth - birdWidth / 2 + xMargin) - 1;
        [aMagpie setDelegate:self];
        frame.origin.x += birdWidth;
        [magpieArrary addObject:aMagpie];
        [self.layer addSublayer:aMagpie.iLayer];
        [aMagpie release];
    }

    /* save the magpie arrary */
    [iDicFloor setObject:magpieArrary forKey:kFloorBirdsArray];

    /* play the floor, fly birds */
    [self flyMagpiesInActiveFloor:YES];
    [iDicFloor setObject:[NSNumber numberWithInt:eFLOOR_STATUS_PLAYING]
                  forKey:kFloorStatus];

    [magpieArrary release];
    return SUCCESS;
}

/*
 * @brief stop floor
 * @detail stop a floor with flying birds at currentActiveFloorIndex
 * @return none
 * @invoke mainGameView
 */
-(void) stopFloor{
    NSMutableDictionary *iDicCurrFloor, *iDicPrevFloor;
    eFloorStatus         floorStatus;
    NSMutableArray      *iArrayCurrMagpie, *iArrayPrevMapie;
    NSMutableArray      *iArrayRemoveLater;
    CGFloat              start, end;
    NSUInteger           count;
    magpieClass         *aMagpie;
    CGPoint              position;

    NSLog(@"====stopFloor%d", _currentActiveFloorIndex);
    /* retreive current floor */
    iDicCurrFloor = [Floors objectAtIndex:_currentActiveFloorIndex];
    iArrayCurrMagpie = [iDicCurrFloor objectForKey:kFloorBirdsArray];
    for (aMagpie in iArrayCurrMagpie) {
        [aMagpie stopFly];
    }

    /* get current floor status */
    floorStatus = [[iDicCurrFloor objectForKey:kFloorStatus] intValue];
    if(eFLOOR_STATUS_STOPPED == floorStatus) {
        NSLog(@"fatal error: try to stop floor at stop status!");
        return;
    }

    /* stop current floor status */
    [self flyMagpiesInActiveFloor:NO];
    [iDicCurrFloor setObject:[NSNumber numberWithInt:eFLOOR_STATUS_STOPPED]
                      forKey:kFloorStatus];

    if (_currentActiveFloorIndex == 0) {
        [self setCurrentActiveFloorIndex:_currentActiveFloorIndex + 1];
        [self startFloor];
        return;
    }

    /* retreive previous floor */
    iDicPrevFloor = [Floors objectAtIndex:(_currentActiveFloorIndex - 1)];

    /* update current birds
     according with previous floor birds range */
    iArrayPrevMapie  = [iDicPrevFloor objectForKey:kFloorBirdsArray];
    count = [iArrayPrevMapie count];
    aMagpie = [iArrayPrevMapie objectAtIndex:0];
    start   = aMagpie.iLayer.position.x;
    aMagpie = [iArrayPrevMapie objectAtIndex:(count - 1)];
    end     = aMagpie.iLayer.position.x;
    iArrayRemoveLater = [NSMutableArray array];
    for (aMagpie in iArrayCurrMagpie) {
        position = aMagpie.iLayer.position;
        /* if magpie out of range, fly away it */
        if ((position.x < start) || 
            (position.x > end)) {
            [aMagpie setFlyDestination:CGPointMake(768, 0)
                     throughPointIndex:(rand()%10)];
            [iArrayRemoveLater addObject:aMagpie];
            _initialBirdsNum --;
        } else {
            [aMagpie onStopAndKeep];
        }
    }

    for(aMagpie in iArrayRemoveLater){
        [iArrayCurrMagpie removeObject:aMagpie];
    }

    /* check for game failed */
    if (_initialBirdsNum <= 0) {
        if (_delegate && [_delegate respondsToSelector:@selector(onGameFailed)]) {
            [_delegate onGameFailed];
        }
        return;
    }

    /* check for game win */
    if (_currentActiveFloorIndex >= _maxFloor) {
        if (_delegate && [_delegate respondsToSelector:@selector(onGameWin)]) {
            [_delegate onGameWin];
        }
        return;
    }

    totalStoppedBirdsNum += _initialBirdsNum;
    if ((totalStoppedBirdsNum >= gatherNum) 
        && (_delegate && [_delegate respondsToSelector:@selector(activeGatherSkill)])){
        [_delegate activeGatherSkill];
    }

    [self setCurrentActiveFloorIndex:_currentActiveFloorIndex + 1];
    [self startFloor];
}

/*
 * @brief  pauseFloor
 * @detail retreive each magpie of current active floor
 *         and stop fly one by one
 * @invoke mainGameView
 */
-(void)pauseFloor{
    NSMutableDictionary *iDicCurrFloor;
    NSMutableArray      *iArrayMagpie;
    magpieClass         *aMagpie;
    
    iDicCurrFloor = [Floors objectAtIndex:_currentActiveFloorIndex];
    iArrayMagpie = [iDicCurrFloor objectForKey:kFloorBirdsArray];
    for (aMagpie in iArrayMagpie) {
        [aMagpie stopFly];
    }
}
/*
 * @brief getStatus
 * @detail retreive the status of current active floor
 * @return eFloorStatus type
 * @invoke mainGameView
 */
-(eFloorStatus) getStatus{
    NSMutableDictionary *iDicCurrFloor;
    
    iDicCurrFloor = [Floors objectAtIndex:_currentActiveFloorIndex];

    return [[iDicCurrFloor objectForKey:kFloorStatus] intValue];
}

/*
 * @brief  setOnFloorEvents
 * @detail this function register a notify function to listen on the floor update change
 * @return none
 * @invoke mainGameView
 */
-(void) setOnFloorEvents:(SEL) aSelector
                          target:(id)aTarget{
    onFloorMgrEvt = aSelector;
    onFloorMgrEvtTarget = aTarget;
}

/*
 * @brief  getTotalBirdsNum
 * @detail get total birds number of all floors
 * @return NSUInteger
 * @invoke self
 */
-(NSUInteger)getTotalBirdsNum{
    NSUInteger i;
    NSUInteger totalBirds = 0;
    NSUInteger totalFloors = 0;
    NSMutableDictionary *iDicCurrFloor = nil;
    NSArray             *iArrayMagpie  = nil;
    
    for (i = 0; i < _currentActiveFloorIndex; i ++) {
        iDicCurrFloor = [Floors objectAtIndex:i];
        
        iArrayMagpie = [iDicCurrFloor objectForKey:kFloorBirdsArray];
        totalBirds += [iArrayMagpie count];
        totalFloors ++;
    }
    return totalBirds;
}

/*
 * @brief  animateToRemoveStoppedFloors
 * @detail play an animation and remove stopped floors
 * @return none
 * @invoke [self gatherStoppedBirdsForAllFloors]
 */
-(void)animateToRemoveStoppedFloors{
    NSMutableDictionary    *iDicFloor;
    NSMutableArray         *iArrayMagpie;
    magpieClass            *aMagpie;
    CGPoint                 flyDestination[6] = {
                                CGPointMake(0, 40),
                                CGPointMake(0, 750),
                                CGPointMake(760, 40),
                                CGPointMake(350, 750),
                                CGPointMake(350, 40),
                                CGPointMake(760, 750)
                            };
    int                     randBuf[6];
    int                     throughPointList[10];
    int                     i = 0, throughIndex = 0;

    iDicFloor = [Floors objectAtIndex: _currentActiveFloorIndex];
    iArrayMagpie = [iDicFloor objectForKey:kFloorBirdsArray];
    for (aMagpie in iArrayMagpie) {
        [aMagpie stopFly];
        [aMagpie.iLayer removeFromSuperlayer];
    }
    [Floors removeObject:iDicFloor];

    createRadomList(randBuf, 6);
    createRadomList(throughPointList, 10);
    for (iDicFloor in Floors) {
        iArrayMagpie = [iDicFloor objectForKey:kFloorBirdsArray];
        for (aMagpie in iArrayMagpie) {
            [aMagpie setFlyDestination:flyDestination[randBuf[i++]]
                    throughPointIndex:throughPointList[throughIndex++]];
            if (throughIndex >= 10) {
                throughIndex = 0;
                createRadomList(throughPointList, 10);
            }
            if (i >= 6) {
                i = 0;
                createRadomList(randBuf, 6);
            }
        }
    }
    
}

/*
 * @brief  setCurrentActiveFloorIndex
 * @detail set current active floor index
 * @return none
 * @invoke mainGameView
 */
-(void)setCurrentActiveFloorIndex:(NSInteger)activeFloorIndex{
    
    NSLog(@"setCurrentActiveFloor%d", (long)activeFloorIndex);
    if ((0 != _currentActiveFloorIndex) && \
        (_currentActiveFloorIndex >= [Floors count])) {
        return;
    }

    _currentActiveFloorIndex = activeFloorIndex;
    [self createFloor:_currentActiveFloorIndex];
}

/*
 * @brief  gatherStoppedBirdsForAllFloors
 * @detail gather stopped birds for all floors and remove them
 * @return none
 * @invoke mainGameView
 */
-(eErrorCodes)gatherStoppedBirdsForAllFloors{
    
    if ([self getTotalBirdsNum] < gatherNum) {
        return EEMPTY;
    }

    // start animate to remove all stopped floors
    [self animateToRemoveStoppedFloors];
    _currentActiveFloorIndex = 0;
    totalStoppedBirdsNum = 0;
    return SUCCESS;
}

/*
 * @brief get remain birds num of current floor
 * @return NSUInterger
 * @invoke mainGameView
 */
-(NSUInteger)getRemainBirdsOfCurrentFloor {
    NSMutableDictionary  *iDicFloor;
    NSMutableArray       *iArrayMapie;
    
    iDicFloor = [Floors objectAtIndex:_currentActiveFloorIndex];
    iArrayMapie = [iDicFloor objectForKey:kFloorBirdsArray];
    return iArrayMapie.count;
}

-(void)flyToPositionDidStop:(magpieClass *)aMagpie{
    NSMutableDictionary *iDicFloor;
    NSMutableArray      *iArrayMagpie;
    magpieClass         *theMagpie;
    bool                bFound = NO;

    [aMagpie.iLayer removeFromSuperlayer];
    for (iDicFloor in Floors) {
        iArrayMagpie = [iDicFloor objectForKey:kFloorBirdsArray];
        for (theMagpie in iArrayMagpie) {
            if (theMagpie == aMagpie) {
                bFound = YES;
                break;
            }
        }
        if (YES == bFound) {
            break;
        }
    }
    
    if (YES == bFound) {
        [iArrayMagpie removeObject:theMagpie];
        if ([iArrayMagpie count] == 0) {
            [iDicFloor removeObjectForKey:kFloorBirdsArray];
            [Floors removeObject:iDicFloor];
        }
    }

    if ([Floors count] == 0) {
        if (_delegate && [_delegate respondsToSelector:@selector(onBirdsEmpty)]) {
            [_delegate onBirdsEmpty];
        }
        [self setCurrentActiveFloorIndex:0];
        [self startFloor];
    }

}

/*
 * @brief  touchesBegan
 * @detail transfer touchesBegan events to parent view
 * @return none
 * @invoke system
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"floor manager touches began...");
    [super touchesBegan:touches withEvent:event];
}

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    NSLog(@"floormananger frame is %@", NSStringFromCGRect(frame));
    if (self) {
        levelManager    *lvlMgr = [[levelManager alloc] init];
        [lvlMgr loadConfigurations];
        floorHeight = frame.size.height / FLOOR_NUM;
        Floors      = [[NSMutableArray alloc] init];
        // should load data from persistant storage
        _currentActiveFloorIndex = 0;
        _maxFloor = FLOOR_NUM - 1;
        iSettings = [[mainSettings sharedSettings] retain];
        [iSettings loadRecords];
        maxBirdsNumPerLine = iSettings.floorBirdsNum.unsignedIntValue;
        gatherNum= 6;
        floorsPerSpecial = lvlMgr.floorsPerSpecial.intValue;
        createSpecialList(SpecialList);
        [lvlMgr release];
    }
    return self;
}

-(void) dealloc{
    NSLog(@"dealloc floor manager...");

    [iSettings release];
    [Floors removeAllObjects];
    [Floors release];
    [super release];
}

@end
