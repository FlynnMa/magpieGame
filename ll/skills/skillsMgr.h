//
//  skill.h
//  ll
//
//  Created by Apple on 12-2-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum skillType {
    eSKILL_TYPE_STOP = 0,            // stop flying birds
    eSKILL_TYPE_GATHER = 1,          // gather birds to build the bridge
    eSKILL_TYPE_INFECTION = 2,       // an infection skill can poisen a bird to die
    eSKILL_TYPE_BLOW = 3,            // an blow skill can blow a bird away
    eSKILL_TYPE_FIRE = 4             // a fire skill can defreeze a freezon bird
}eSkillType;

@class mainSettings;

@interface skillsMgr : UIView{
    BOOL activate;
    UIImage *activeImg;
    UIImage *deactiveImg;
    mainSettings *settings;
    
    SEL notifySkill;
    id  notifySkillTarget;
}

-(id)initWithFrame:(CGRect)frame
         skillType:(eSkillType) type;

// whether this skill is activated
@property BOOL activate;

// how many times can this skill be used in future
@property NSInteger count;

// what kind of skill it is
@property eSkillType skillType;

// a help string to show how this skill been used
@property(retain, readonly) NSString *help;

// perform this skill once
-(void) perform;

-(void)loadResourcesByType;

-(void) registerNotifySkill:(SEL)aSelector
                     target:(id)aTarget;
@end
