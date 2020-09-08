//
//  levelManager.m
//  ll
//
//  Created by Yunfei on 12-1-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "levelManager.h"
#import "mainSettings.h"

/*! This file implements data managment on level manager*/
@implementation levelManager

/*! current level */
@synthesize currentLevel = _currentLevel;

/*! current season */
@synthesize currentSeason = _currentSeason;

/*! increate spead duration in seconds */
@synthesize increseSpeed = _increseSpeed;

/*! initial speed */
@synthesize initialSpeed = _initialSpeed;

/*! initial birds number */
@synthesize initialBirdsNum = _initialBirdsNum;

/*! the fast speed */
@synthesize fastSpeed = _fastSpeed;

/*! current score */
@synthesize currentScore = _currentScore;

@synthesize floorsPerSpecial = _floorsPerSpecial;

/*! key strings defintions */
#define kInitialSpeed       @"initialSpeed"
#define kIncreateSpeed      @"increateSpeed"
#define kFastSpeed          @"fastSpeed"
#define kInitBirdsNum       @"initialBirdsNum"
#define kFloorsNum          @"floorsNum"
#define kBadBirdType        @"badBirdType"
#define kGatherBirdsNum     @"gatherBirdsNum"
#define kFloorsPerSpecial   @"floorsToGenrateSpecial"

/*
 * @brief   loadConfigurations
 * @detail  load configuations about level managers
 * @invoke  mainGameView
 */
-(void) loadConfigurations{
    _currentSeason = settings.season.unsignedIntValue;
    _currentLevel = settings.level.unsignedIntValue;
    _fastSpeed = [seasonCfg objectForKey:kFastSpeed];
    [settings loadSeasonCfg:_currentSeason];
    seasonCfg = settings.seasonCfg;
    _increseSpeed = [seasonCfg objectForKey:kIncreateSpeed];
    _initialSpeed = [seasonCfg objectForKey:kInitialSpeed];
    _initialBirdsNum = [seasonCfg objectForKey:kInitBirdsNum];
    _floorsPerSpecial = [seasonCfg objectForKey:kFloorsPerSpecial];
}

/*
 * @brief saveUserRecord
 * @detail save season, level, score records
 * @invoke mainGameView
 */
-(void) saveUserRecord{
    NSNumber *numSeason = [NSNumber numberWithInt:_currentSeason];
    NSNumber *numLvl = [NSNumber numberWithInt:_currentLevel];
    NSNumber *numScore = [NSNumber numberWithInt:_currentScore];

    settings.season = numSeason;
    settings.level = numLvl;
    settings.score = numScore;
    
    [settings saveRecords];
}

-(id) init{
    self = [super init];
    if (self) {
        settings = [[mainSettings sharedSettings] retain];
        NSLog(@"levelManager load records...");
        [settings loadRecords];
        NSLog(@"\t--success!");
    }
    return self;
}

-(void) dealloc{
    NSLog(@"level manager dealloc...");
    if (settings) {
        [settings release];
        settings = nil;
    }
    [super release];
}

@end
