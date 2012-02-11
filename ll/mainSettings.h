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
}

@property(readwrite, retain) NSNumber   *score;
@property(readwrite, retain) NSNumber   *highScore;
@property(readwrite, retain) NSNumber   *season;
@property(readwrite, retain) NSNumber   *level;
@property(readonly, retain)  NSString   *version;
@property(readonly, retain) NSString    *help;

@property(readonly, retain) NSNumber    *mainViewLabelY;
@property(readonly, retain) NSNumber    *mainViewLabelHeight;
@property(readonly, retain) NSNumber    *mainViewLabelFontSize;
@property(readonly, retain) NSNumber    *birdsBridgeNumPerLvl;
@property(readonly, retain) NSNumber    *floorNum;
@property(readonly, retain) NSDictionary *skillResources;
@property(readonly, retain) NSDictionary *levelCfg;

/* load all records from file system */
-(BOOL) loadRecords;

/* create all records, this is normally called at the first time when application
 * starts
 */
-(void) createRecords;

/* save all records to filesystem */
-(void) saveRecords;

/* get plist file version */
-(BOOL) getFileVersion:(NSString*)file
                   ver:(NSString**)str;
@end
