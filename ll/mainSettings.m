//
//  mainSettings.m
//  ll
//
//  Created by Yunfei on 12-2-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "mainSettings.h"

static mainSettings *shardSettings = nil;
@implementation mainSettings
@synthesize score = _score, highScore = _highScore, version = _version;
@synthesize season = _season;
@synthesize level = _level;
@synthesize help = _help;
@synthesize mainViewLabelY = _mainViewLabelY;
@synthesize mainViewLabelHeight = _mainViewLabelHeight;
@synthesize mainViewLabelFontSize = _mainViewLabelFontSize;
@synthesize birdsBridgeNumPerLvl = _birdsBridgeNumPerLvl;
@synthesize floorNum = _floorNum;
@synthesize skillResources = _skillResources;
@synthesize seasonCfg = _seasonCfg;
@synthesize floorBirdsNum = _floorBirdsNum;
@synthesize magpieResources = _magpieResources;
@synthesize magpieSpeicalResources = _magpieSpeicalResources;

/* userDefault is released with software */
#define USER_DEFAULT_LIST   @"userDefault"

/* userRecord data are firstly generated from 'userDefault'
 * and then be used to save user data
 */
#define USER_RECORD_LIST    @"userRecord.plist"

#define kHightScore         @"highScore"
#define kScore              @"score"
#define kSeason             @"season"
#define kLevel              @"level"
#define kVersion            @"version"
#define kHelp               @"help"
#define kFloorBirdsNum      @"floorBirdsNum"          /*birds number in each floor */
#define kMainViewLblH       @"mainViewLabelHeight"
#define kMainViewLblY       @"mainViewLabelStartY"
#define kMainViewLnblFontS  @"mainViewLabelFontSize"
#define kMainViewLblHIphone       @"mainViewLableHeightIphone"
#define kMainViewLblYIphone       @"mainViewLabelStartYIphone"
#define kMainViewLnblFontSIphone  @"mainViewLabelFontSizeIphone"
#define kBridgeNumPerLvl    @"birdsBridgeNumPerLvl"
#define kFloorNum           @"floorNum"
#define kSkillsResources    @"skillsResources"
#define kMagpieResources    @"magpieResources"
#define kMagpieSpecialResources   @"magpieSpecialResources"

-(BOOL) getFileVersion:(NSString*)file
                   ver:(NSString**)str{
    NSPropertyListFormat format;
    NSString *errorDesc = nil;
    NSString *verStr = nil;

    if (![[NSFileManager defaultManager] fileExistsAtPath:file]) {
        return NO;
    }
    
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:file];
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                          propertyListFromData:plistXML
                                          mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                          format:&format
                                          errorDescription:&errorDesc];
    if (!temp) {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    verStr = [[NSString alloc] initWithString:[temp valueForKey:kVersion]];
    *str = verStr;

    return YES;
}


-(void) createRecords{
    NSString *rootPath = nil;
    NSString *defaultListPath = nil;
    NSString *listPath = nil;
    NSData   *plistData = nil;
    NSArray  *dirs = nil;
    
    dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                               NSUserDirectory, YES);
    
    rootPath = [dirs objectAtIndex:0];
    defaultListPath = [[NSBundle mainBundle] pathForResource:@"usrDefault"
                                                      ofType:@"plist"];
    listPath = [rootPath stringByAppendingPathComponent:USER_RECORD_LIST];

//    NSLog(@"create record %@, from %@", listPath, defaultListPath);
    
    plistData = [[NSFileManager defaultManager] contentsAtPath:defaultListPath];
    [plistData writeToFile:listPath atomically:YES];
 }

/*
 * @brief loadRecords
 * @detail load records from userRecord.plist and levelConfig.plist,
 *         if userRecord.plist does not exist, create it from userDefault.plist
 *         if userRecord.plist has different version with userDefault.plist, recreate it
 * @return none
 * @invoke floorManager, floorController, mainGameView
 */
-(BOOL) loadRecords{
    NSPropertyListFormat format;
    NSString *errorDesc = nil;
    NSString *defaultSettingsVersion = nil;
    NSString *usrSettingsVersion = nil;
    BOOL      isNeedRebuildRecords = NO;
    CGRect    frame = [[UIScreen mainScreen] bounds];
    BOOL      isIphone = (frame.size.width <= 320);
    
    if (isLoaded) {
        return YES;
    }
    if(NO == [self getFileVersion:defaultPlistPath ver:&defaultSettingsVersion]){
        NSLog(@"failed at getting default plist version!");
        return NO;
    }
    if( NO == [self getFileVersion:usrPlistPath ver:&usrSettingsVersion]){
        NSLog(@"failed at getting user plist version!");
        isNeedRebuildRecords = YES;
    }
    else if (NSOrderedSame != [usrSettingsVersion compare:defaultSettingsVersion]) {
        isNeedRebuildRecords = YES;
    }
    else if ([[NSFileManager defaultManager] fileExistsAtPath:usrPlistPath] == NO) {
        isNeedRebuildRecords = YES;
    }
    
    if (YES == isNeedRebuildRecords) {
        [self createRecords];
    }
    
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:usrPlistPath];
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                          propertyListFromData:plistXML
                                          mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                          format:&format
                                          errorDescription:&errorDesc];
    if (!temp) {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    
    _version = [[NSString alloc] initWithString:[temp valueForKey:kVersion]];
    _highScore = [[NSNumber alloc] initWithFloat:[[temp valueForKey:kHightScore] intValue]];
    _score = [NSNumber numberWithInt:[[temp valueForKey:kScore] intValue]];
    _season = [NSNumber numberWithInt:[[temp valueForKey:kSeason] intValue]];
    _level  = [NSNumber numberWithInt:[[temp valueForKey:kLevel] intValue]];
    _help   = [[NSString alloc] initWithString:[temp valueForKey:kHelp]];
    if (YES == isIphone) {
        _mainViewLabelY = [NSNumber numberWithFloat:
                          [[temp valueForKey:kMainViewLblYIphone] floatValue]];
        _mainViewLabelHeight = [[NSNumber alloc] initWithFloat:
                               [[temp valueForKey:kMainViewLblHIphone] floatValue]];
        _mainViewLabelFontSize = [[NSNumber alloc] initWithInt:
                                 [[temp valueForKey:kMainViewLnblFontSIphone] intValue]];
        
    } else {
        _mainViewLabelY = [[NSNumber alloc] initWithFloat:
                          [[temp valueForKey:kMainViewLblY] floatValue]];
        _mainViewLabelHeight = [[NSNumber alloc] initWithFloat:
                               [[temp valueForKey:kMainViewLblH] floatValue]];
        _mainViewLabelFontSize = [[NSNumber alloc] initWithInt:
                                 [[temp valueForKey:kMainViewLnblFontS] intValue]];
    }
    _birdsBridgeNumPerLvl = [[NSNumber alloc] initWithInt:[[temp valueForKey:kBridgeNumPerLvl] intValue]];
    _floorNum    = [[NSNumber alloc] initWithInt:[[temp valueForKey:kBridgeNumPerLvl] intValue]];
    _floorBirdsNum = [[NSNumber alloc] initWithInt:[[temp valueForKey:kFloorBirdsNum] intValue]];
    _skillResources = [[NSDictionary alloc] initWithDictionary:
                      [temp valueForKey:kSkillsResources]];
    _magpieResources = [[NSDictionary alloc] initWithDictionary:
                       [temp valueForKey:kMagpieResources]];
    _magpieSpeicalResources = [[NSDictionary alloc] initWithDictionary:
                               [temp valueForKey:kMagpieSpecialResources]];

    isLoaded = YES;
    return YES;
}

/*
 * @brief  saveRecords to userRecord.plist
 * @detail save records to userRecord.plist
 * @return none
 * @invoke floorManager, floorController, mainGameView
 */
-(void) saveRecords{
    NSString *rootPath = nil;
    NSString *listPath = nil;
    NSArray  *dirs = nil;
    NSDictionary *dic = nil;
    NSData       *listData = nil;
    NSString    *err = nil;

    dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                               NSUserDirectory, YES);
    rootPath = [dirs objectAtIndex:0];
    listPath = [rootPath stringByAppendingPathComponent:USER_RECORD_LIST];

    dic = [NSDictionary dictionaryWithObjects:
            [NSArray arrayWithObjects: _highScore, _score, _version, _season, _level,
                 _help, _mainViewLabelY, _mainViewLabelHeight, _mainViewLabelFontSize,
                 _birdsBridgeNumPerLvl, _floorNum,nil]
                                      forKeys:
            [NSArray arrayWithObjects:kHightScore, kScore, kVersion,
                kSeason, kLevel, kHelp, kMainViewLblY, kMainViewLblH,
                kMainViewLnblFontS, kBridgeNumPerLvl, kFloorNum, nil]];
    listData = [NSPropertyListSerialization dataFromPropertyList:dic
                                            format:NSPropertyListXMLFormat_v1_0
                                            errorDescription:&err];
    if (nil != listData) {
        [listData writeToFile:listPath atomically:YES];
    } else {
        NSLog(@"serialization of record failed:%@", err);
    }

}

/*
 * @brief   loadSeasonCfg
 * @detail  this function loads configrations according with a season
 * @param   seasonValue an int value for season
 * @returns none
 * @invoke  levelManager, levelSelectorView
 */
-(void)loadSeasonCfg:(int)seasonValue{
    NSPropertyListFormat format;
    NSString *errorDesc = nil;
    NSString *defaultSettingsVersion = nil;
    NSString *usrSettingsVersion = nil;
    
    if (nil != _seasonCfg) {
        return;
    }

    if(NO == [self getFileVersion:defaultPlistPath ver:&defaultSettingsVersion]){
        NSLog(@"failed at getting default plist version!");
        return;
    }
    if( NO == [self getFileVersion:usrPlistPath ver:&usrSettingsVersion]){
        NSLog(@"failed at getting user plist version! %@", usrPlistPath);
        return;
    }
    
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:usrPlistPath];
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                          propertyListFromData:plistXML
                                          mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                          format:&format
                                          errorDescription:&errorDesc];
    if (!temp) {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    
    NSString *seasonStr = [NSString stringWithFormat:@"season%d",seasonValue];
    _seasonCfg = [[NSDictionary alloc] initWithDictionary:
                [temp valueForKey:seasonStr]];

}
#pragma mark Singleton Methods
/*
 * @brief load the singleton instance
 * @invoke floorManger, floorController, mainGameView
 */
+(id) sharedSettings {
    @synchronized(self) {
        if (nil == shardSettings) {
            NSLog(@"** create shared settings...");
            shardSettings = [[mainSettings alloc] init];
        }
    }

//    NSLog(@"** retain shared settings...%d", [shardSettings retainCount]);
    return shardSettings;
}

+ (id)allocWithZone:(NSZone *)zone
{	
    @synchronized(self) {
		
        if (shardSettings == nil) {
			
            shardSettings = [super allocWithZone:zone];			
            return shardSettings;  // assignment and return on first allocation
        }
    }
	
    return nil; //on subsequent allocation attempts return nil	
}

#pragma mark -
#pragma mark Custom Methods

-(oneway void) release{
    NSLog(@"release mainSettings... %lu", (unsigned long)[self retainCount]);
    [super release];
    NSLog(@"\t--retain: %lu", (unsigned long)[self retainCount]);
}
-(id) init{
    self = [super init];
    if (self) {
        NSArray  *dirs = nil;
        NSString *rootPath = nil;
        
        dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                   NSUserDirectory, YES);
        
        rootPath = [dirs objectAtIndex:0];
        usrPlistPath = [rootPath stringByAppendingPathComponent:USER_RECORD_LIST];
        [usrPlistPath retain];
        
        defaultPlistPath = [[NSBundle mainBundle] pathForResource:@"usrDefault"
                                                           ofType:@"plist"];
        [defaultPlistPath retain];
    }
    return self;
}

-(void) dealloc{
    
    NSLog(@"dealloc mainSettings...");
    shardSettings = nil;
    [_score release];
    [_highScore release];
    [_version release];
    [_season release];
    [_level release];
    [_help  release];
    [_mainViewLabelY release];
    [_mainViewLabelHeight release];
    [_mainViewLabelFontSize release];
    [_birdsBridgeNumPerLvl release];
    [_floorNum release];
    [_skillResources release];
    [_seasonCfg release];
    [_floorBirdsNum release];
    [_magpieResources release];
    
    [super dealloc];
}

@end
