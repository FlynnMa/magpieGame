//
//  mainSettings.m
//  ll
//
//  Created by Apple on 12-2-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "mainSettings.h"

@implementation mainSettings
@synthesize score, highScore, version, season, level, help;
@synthesize mainViewLabelY, mainViewLabelHeight, mainViewLabelFontSize;
@synthesize birdsBridgeNumPerLvl, floorNum, skillResources;
@synthesize levelCfg;

/* userDefault is released with software */
#define USER_DEFAULT_LIST   @"userDefault"
#define LEVEL_CFG_LIST      @"levelConfig"

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
#define kMainViewLblH       @"mainViewLabelHeight"
#define kMainViewLblY       @"mainViewLabelStartY"
#define kMainViewLnblFontS  @"mainViewLabelFontSize"
#define kMainViewLblHIphone      @"mainViewLableHeightIphone"
#define kMainViewLblYIphone       @"mainViewLabelStartYIphone"
#define kMainViewLnblFontSIphone  @"mainViewLabelFontSizeIphone"
#define kBridgeNumPerLvl    @"birdsBridgeNumPerLvl"
#define kFloorNum           @"floorNum"
#define kSkillsResources    @"skillsResources"

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
        
        levelCfgPath = [[NSBundle mainBundle] pathForResource:LEVEL_CFG_LIST ofType:@"plist"];
        [levelCfgPath retain];
        defaultPlistPath = [[NSBundle mainBundle] pathForResource:@"usrDefault"
                                                           ofType:@"plist"];
        [defaultPlistPath retain];
    }
    return self;
}

-(void) dealloc{
    [highScore release];
    [score release];
    [version release];
    [season release];
    [level release];
    [help release];
    [mainViewLabelHeight release];
    [mainViewLabelY release];
    [mainViewLabelFontSize release];
    [birdsBridgeNumPerLvl release];
    [floorNum release];
    [skillResources release];
    
    [super release];
}

-(BOOL) loadRecords{
    NSPropertyListFormat format;
    NSString *errorDesc = nil;
    NSString *defaultSettingsVersion = nil;
    NSString *usrSettingsVersion = nil;
    BOOL      isNeedRebuildRecords = NO;
    CGRect    frame = [[UIScreen mainScreen] bounds];
    BOOL      isIphone = (frame.size.width <= 320);

    if(NO == [self getFileVersion:defaultPlistPath ver:&defaultSettingsVersion]){
        NSLog(@"failed at getting default plist version!");
        return NO;
    }
    if( NO == [self getFileVersion:usrPlistPath ver:&usrSettingsVersion]){
        NSLog(@"failed at getting user plist version!");
        return NO;
    }
    if (NSOrderedSame != [usrSettingsVersion compare:defaultSettingsVersion]) {
        isNeedRebuildRecords = YES;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:usrPlistPath] == NO) {
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
    
    version = [[NSString alloc] initWithString:[temp valueForKey:kVersion]];
    highScore = [[NSNumber alloc] initWithFloat:[[temp valueForKey:kHightScore] intValue]];
    score = [NSNumber numberWithInt:[[temp valueForKey:kScore] intValue]];
    season = [NSNumber numberWithInt:[[temp valueForKey:kSeason] intValue]];
    level  = [NSNumber numberWithInt:[[temp valueForKey:kLevel] intValue]];
    help   = [[NSString alloc] initWithString:[temp valueForKey:kHelp]];
    if (YES == isIphone) {
        mainViewLabelY = [NSNumber numberWithFloat:
                          [[temp valueForKey:kMainViewLblYIphone] floatValue]];
        mainViewLabelHeight = [[NSNumber alloc] initWithFloat:
                               [[temp valueForKey:kMainViewLblHIphone] floatValue]];
        mainViewLabelFontSize = [[NSNumber alloc] initWithInt:
                                 [[temp valueForKey:kMainViewLnblFontSIphone] intValue]];
        
    } else {
        mainViewLabelY = [[NSNumber alloc] initWithFloat:
                      [[temp valueForKey:kMainViewLblY] floatValue]];
        mainViewLabelHeight = [[NSNumber alloc] initWithFloat:
                           [[temp valueForKey:kMainViewLblH] floatValue]];
        mainViewLabelFontSize = [[NSNumber alloc] initWithInt:
                             [[temp valueForKey:kMainViewLnblFontS] intValue]];
    }
    birdsBridgeNumPerLvl = [[NSNumber alloc] initWithInt:[[temp valueForKey:kBridgeNumPerLvl] intValue]];
    floorNum    = [[NSNumber alloc] initWithInt:[[temp valueForKey:kBridgeNumPerLvl] intValue]];
    skillResources = [[NSDictionary alloc] initWithDictionary:
                      [temp valueForKey:kSkillsResources]];

    plistXML = [[NSFileManager defaultManager] contentsAtPath:levelCfgPath];
    levelCfg = (NSDictionary*)[NSPropertyListSerialization
                               propertyListFromData:plistXML
                               mutabilityOption:NSPropertyListImmutable
                                                            format:&format
                               errorDescription:&errorDesc];
    [levelCfg retain];
    return YES;
}

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

    NSLog(@"create record %@, from %@", listPath, defaultListPath);
    
    plistData = [[NSFileManager defaultManager] contentsAtPath:defaultListPath];
    [plistData writeToFile:listPath atomically:YES];
 }

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
            [NSArray arrayWithObjects: highScore, score, version, season, level,
                 help, mainViewLabelY, mainViewLabelHeight,mainViewLabelFontSize,
                 birdsBridgeNumPerLvl, floorNum,nil]
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
@end
