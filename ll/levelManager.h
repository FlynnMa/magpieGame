//
//  levelManager.h
//  ll
//
//  Created by Apple on 12-1-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class mainSettings;

@interface levelManager : NSObject{
    NSUInteger initialBlocks;
    NSDictionary *seasonCfg;
    mainSettings *settings;
}

@property NSUInteger currentScore;
@property NSUInteger currentSeason;
@property NSUInteger currentLevel;
@property(readonly, retain, nonatomic) NSString     *title;
@property(readonly, retain, nonatomic) NSString     *content;
@property(readonly, retain, nonatomic) NSNumber     *initialSpeed;
@property(readonly, retain, nonatomic) NSNumber     *increseSpeed;
@property(readonly, retain, nonatomic) NSNumber     *fastSpeed;
@property(readonly, retain, nonatomic) NSNumber     *initialBirdsNum;

-(NSUInteger)getCurrentInitialBlocks;

-(void) loadConfigurations;
@end
