//
//  skill.h
//  ll
//
//  Created by Yunfei on 12-2-5.
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

/*
 * @brief initWithFrame and skilltype
 * @detail this function initialize a skill view with frame and type
 * @param frame the frame of view
 * @param type  skill type
 * @returns id
 * @invoke by mainGameView
 */
-(id)initWithFrame:(CGRect)frame
         skillType:(eSkillType) type;

/*!
 * @brief setActive will play an relative activation animation
 *        and change the property
 * @invoke mainGameView
 */
@property (readwrite, nonatomic) BOOL activate;

// how many times can this skill be used in future
@property NSInteger count;

// what kind of skill it is
@property eSkillType skillType;

// a help string to show how this skill been used
@property(retain, readonly) NSString *help;

/*
 * @brief registerNotifySkill
 * @detail this function register notifycation function
 *          to listen to skill notification
 * @invoke by mainGameView
 */
-(void) registerNotifySkill:(SEL)aSelector
                     target:(id)aTarget;

/*
 * @brief  this function performs the skill
 * @detail this function will play a skill animation, and notify the skill owner
 * @invoke mainGameView
 */
-(void) perform;

/*
 * @brief loadResourcesByType
 * @detail This funciton load skill related resources about the skill
 * @invoke initialize funciton initWithFrame:skillType:
 */
-(void)loadResourcesByType;

@end
