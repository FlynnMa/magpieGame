//
//  skill.m
//  ll
//
//  Created by Apple on 12-2-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "skillsMgr.h"
#import "mainSettings.h"

@implementation skillsMgr

#define kStopActiveImg      @"stopActive"
#define kStopDeactiveImg    @"stopDeactive"
#define kGatherActiveImg    @"gatherActive"
#define kGatherDeactiveImg  @"gatherDeactive"

@synthesize count, help;
@synthesize skillType = _skillType;
@dynamic activate;

-(id)initWithFrame:(CGRect)frame
              skillType:(eSkillType) type{
    self = [self initWithFrame:frame];
    if (self) {
        settings = [[mainSettings alloc] init];
        [settings loadRecords];
        _skillType = type;
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    
    return self;
}

-(void)dealloc{
    NSLog(@"dealloc... skillsMgr");
    [settings release];
    [activeImg release];
    [deactiveImg release];
    [super release];
}

-(void)setActivate:(BOOL)active{
    
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
    activate = active;
}

-(BOOL)getActivate{
    return  activate;
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if (self != [touch view]) {
        return;
    }
    
    [self perform];
}

-(void) perform{
    if (activate == NO) {
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

-(void) registerNotifySkill:(SEL)aSelector
                     target:(id)aTarget{
    notifySkill = aSelector;
    notifySkillTarget = aTarget;
}

-(void)loadResourcesByType{
    NSString *activeRes;
    NSString *deactiveRes;
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
}
@end
