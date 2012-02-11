//
//  levelManager.m
//  ll
//
//  Created by Apple on 12-1-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "levelManager.h"
#import "mainSettings.h"

@implementation levelManager

@synthesize currentLevel = _currentLevel;
@synthesize currentSeason = _currentSeason;
@synthesize title = _title;
@synthesize content = _content;
@synthesize increseSpeed = _increseSpeed;
@synthesize initialSpeed = _initialSpeed;
@synthesize initialBirdsNum = _initialBirdsNum;
@synthesize fastSpeed = _fastSpeed;
@synthesize currentScore = _currentScore;

#define kTitle          @"title"
#define kContent        @"content"
#define kInitialSpeed   @"initialSpeed"
#define kIncreateSpeed  @"increateSpeed"
#define kFastSpeed      @"fastSpeed"
#define kInitBirdsNum   @"initialBirdsNum"
#define kFloorsNum      @"floorsNum"
#define kBadBirdType    @"badBirdType"
#define kGatherBirdsNum @"gatherBirdsNum"

-(NSUInteger) getCurrentInitialBlocks{
    return _initialBirdsNum.unsignedIntValue;
}

-(id) init{
    self = [super init];
    if (self) {
        settings = [[mainSettings alloc] init];
        [settings loadRecords];
    }
    return self;
}

-(void) dealloc{
    [_title release];
    [_content release];
    [_increseSpeed release];
    [_initialSpeed release];
    [_initialBirdsNum release];
    [_fastSpeed release];
    [seasonCfg release];
    [settings release];
    [super release];
}

-(void) loadConfigurations{
    NSString     *string;

    _currentSeason = settings.season.unsignedIntValue;
    _currentLevel = settings.level.unsignedIntValue;
    _fastSpeed = [seasonCfg objectForKey:kFastSpeed];
    string = [NSString stringWithFormat:@"season%d", _currentSeason];
    seasonCfg = [settings.levelCfg objectForKey:string];
    _title = [seasonCfg objectForKey:kTitle];
    _content = [seasonCfg objectForKey:kContent];
    _increseSpeed = [seasonCfg objectForKey:kIncreateSpeed];
    _initialSpeed = [seasonCfg objectForKey:kInitialSpeed];
    _initialBirdsNum = [seasonCfg objectForKey:kInitBirdsNum];
}

-(void) saveUserRecord{
    NSNumber *numSeason = [NSNumber numberWithInt:_currentSeason];
    NSNumber *numLvl = [NSNumber numberWithInt:_currentLevel];
    NSNumber *numScore = [NSNumber numberWithInt:_currentScore];

    settings.season = numSeason;
    settings.level = numLvl;
    settings.score = numScore;
    
    [settings saveRecords];
}

@end
