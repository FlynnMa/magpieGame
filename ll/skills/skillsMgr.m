//
//  skill.m
//  ll
//
//  Created by Yunfei on 12-2-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "skillsMgr.h"
#import "mainSettings.h"

@implementation skillsMgr

/* resource key definitions */
#define kStopActiveImg      @"stopActive"
#define kStopDeactiveImg    @"stopDeactive"
#define kGatherActiveImg    @"gatherActive"
#define kGatherDeactiveImg  @"gatherDeactive"

/* property synthesize */
@synthesize count, help;
@synthesize skillType = _skillType;
@synthesize activate = _activate;

/*
 * @brief initWithFrame and skilltype
 * @detail this function initialize a skill view with frame and type
 * @param frame the frame of view
 * @param type  skill type
 * @returns id
 * @invoke by mainGameView
 */
-(id)initWithFrame:(CGRect)frame
              skillType:(eSkillType) type{
    self = [super initWithFrame:frame];
    if (self) {
        settings = [[mainSettings sharedSettings] retain];
        [settings loadRecords];
        _skillType = type;
        [self loadResourcesByType];
    }
    return self;
}

/*
 * @brief setActive
 * @brief this function change the activation property,
 *        and play cresponding animations
 * @invoke by mainGameView
 */
-(void)setActivate:(BOOL)active{

    if (_activate == active) {
        return;
    }

    self.alpha = 0;
    if (active == YES) {
        self.backgroundColor = [UIColor colorWithPatternImage:activeImg];
        [UIView animateWithDuration:0.5
                         animations:^{
                             self.alpha = 1;
                         }];
    } else {
        self.backgroundColor = [UIColor colorWithPatternImage:deactiveImg];
        [UIView animateWithDuration:0.5
                         animations:^{
                             self.alpha = 1;
                         }];
    }
    _activate = active;
}

/*
 * @brief registerNotifySkill
 * @detail this function register notifycation function
 *          to listen to skill notification
 * @invoke by mainGameView
 */
-(void) registerNotifySkill:(SEL)aSelector
                     target:(id)aTarget{
    notifySkill = aSelector;
    notifySkillTarget = aTarget;
}

/*
 * @brief touchesEnded
 * @detail this funciton responds on the touchesEnd event
 * @invoke by system
 */
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if (self != [touch view]) {
        return;
    }
    
    [self perform];
}

/*
 * @brief  this function performs the skill
 * @detail this function will play a skill animation, and notify the skill owner
 * @invoke mainGameView
 */
-(void) perform{
    if (_activate == NO) {
        return;
    }
    
    // play skill animaiton
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.alpha = 0;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              self.alpha = 1;
                                          }];
                          }];
     
    if (notifySkill) {
        [notifySkillTarget performSelector:notifySkill
                                withObject:[NSNumber numberWithInt:_skillType]];
    }
     
}

/*
 * @brief loadResourcesByType
 * @detail This funciton load skill related resources about the skill
 * @invoke initialize funciton initWithFrame:skillType:
 */
-(void)loadResourcesByType{
    NSString *activeRes = nil;
    NSString *deactiveRes = nil;
    NSString *path;
    
    switch (_skillType) {
        case eSKILL_TYPE_STOP:
            activeRes = [settings.skillResources objectForKey:kStopActiveImg];

            deactiveRes = [settings.skillResources objectForKey:kStopDeactiveImg];
            break;
            
        case eSKILL_TYPE_GATHER:
            activeRes = [settings.skillResources objectForKey:kGatherActiveImg];
            deactiveRes = [settings.skillResources objectForKey:kGatherDeactiveImg];
            break;

        case eSKILL_TYPE_BLOW:
            break;
            
        case eSKILL_TYPE_FIRE:
            break;

            
        default:
            break;
    }

    if(nil != activeRes) {
        path = [[NSBundle mainBundle] pathForResource:activeRes ofType:@"png"];
        activeImg = [[UIImage alloc] initWithContentsOfFile:path];
    }

    if(nil != deactiveRes) {
        path = [[NSBundle mainBundle] pathForResource:deactiveRes ofType:@"png"];
        deactiveImg = [[UIImage alloc] initWithContentsOfFile:path];            
    }

    self.backgroundColor = [UIColor colorWithPatternImage:deactiveImg];
}

/*
 * @brief dealloc
 */
-(void)dealloc{
    NSLog(@"dealloc... skillsMgr");
    [settings release];
    [activeImg release];
    [deactiveImg release];
    [super release];
}

@end
