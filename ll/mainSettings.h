//
//  mainSettings.h
//  ll
//
//  Created by Apple on 12-2-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface mainSettings : NSObject{
    NSString *defaultPlistPath;
    NSString *usrPlistPath;
    NSString *levelCfgPath;
    BOOL      isLoaded;
}

@property(readwrite, retain) NSNumber   *score;
@property(readwrite, retain) NSNumber   *highScore;
@property(readwrite, retain) NSNumber   *season;
@property(readwrite, retain) NSNumber   *level;
@property(readonly, retain) NSNumber    *floorBirdsNum;
@property(readonly, retain)  NSString   *version;
@property(readonly, retain) NSString    *help;

@property(readonly, retain) NSNumber    *mainViewLabelY;
@property(readonly, retain) NSNumber    *mainViewLabelHeight;
@property(readonly, retain) NSNumber    *mainViewLabelFontSize;
@property(readonly, retain) NSNumber    *birdsBridgeNumPerLvl;
@property(readonly, retain) NSNumber    *floorNum;
@property(readonly, retain) NSDictionary *skillResources;
@property(readonly, retain) NSDictionary *magpieResources;
@property(readonly, retain) NSDictionary *magpieSpeicalResources;
@property(readonly, retain) NSDictionary *seasonCfg;

/*
 * @brief loadRecords
 * @detail load records from userRecord.plist and levelConfig.plist,
 *         if userRecord.plist does not exist, create it from userDefault.plist
 *         if userRecord.plist has different version with userDefault.plist, recreate it
 * @return none
 * @invoke floorManager, floorController, mainGameView
 */
-(BOOL) loadRecords;

/*
 * @brief  saveRecords to userRecord.plist
 * @detail save records to userRecord.plist
 * @return none
 * @invoke floorManager, floorController, mainGameView
 */
-(void) saveRecords;

/*
 * @brief   loadSeasonCfg
 * @detail  this function loads configrations according with a season
 * @param   seasonValue an int value for season
 * @returns none
 * @invoke  levelManager, levelSelectorView
 */
-(void)loadSeasonCfg:(int)seasonValue;

/*
 * @brief load the singleton instance
 * @invoke floorManger, floorController, mainGameView
 */
+(id) sharedSettings;
@end
