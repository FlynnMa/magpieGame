//
//  MainViewController.m
//  ll
//
//  Created by Apple on 12-1-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "mainGameView.h"
#import "FloorController.h"
#import "PauseViewController.h"
#import "FloorManager.h"
#import "loseWinView.h"
#import "levelManager.h"
#import <QuartzCore/QuartzCore.h>
#import "mainSettings.h"
#import "skillsMgr.h"

#define LABEL_VIEW_SECOND_COLUMN_START     380

#define LABEL_VIEW_GAP_Y     4  // label view's gap
#define LABEL_VIEW_GAP_X     4  // label view's gap
#define LABEL_VIEW_FONT_SIZE 48  // label view default font size

#define kStopSkill             @"stopSkill"
#define kGatherSkill           @"gatherSkill"

@implementation mainGameView

const NSUInteger addScores[3] = {1, 4, 8};

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        levelMgr = [[levelManager alloc] init];
        settings = [[mainSettings alloc] init];        
        skills = [[NSMutableDictionary alloc] init];
        self.frame = frame;
        [levelMgr loadConfigurations];
        [settings loadRecords];
        labelHeight = settings.mainViewLabelHeight.intValue;
        labelsStartY = settings.mainViewLabelY.floatValue;
        labelFontSize = settings.mainViewLabelFontSize.floatValue;
        floorNum = settings.floorNum.unsignedIntegerValue;
        labelContentHeight = labelHeight * 2 + LABEL_VIEW_GAP_Y * 3;
        floorHeight = abs((frame.size.height - labelContentHeight) / (floorNum + 2));
        FloorMgrContentHeight =  floorHeight * floorNum;
        ToolsMgrContentHeigh = frame.size.height - labelContentHeight - FloorMgrContentHeight;

        [self loadView];
    }

    return self;
}

- (void)dealloc{

    [labelBgView release];
    [bgView release];
    [scoreLabel release];
    [levelLabel release];
    [durationLabel release];
    [floorLabel release];
    [pauseCtl release];
    [levelMgr release];
    [settings release];
    [skills release];
    [super release];
}

- (void) createAllLabelViews{
    CGRect bgFrame;
    CGRect frame = {0,0,0,0};
    UILabel *labelView;
    CGFloat  startY;
    NSString *str;
    UIFont   *font;
    CGSize    size;
    CGFloat   fontSize, secondClumeStart;

    bgFrame = [bgView frame];
    startY = labelsStartY;
    if (bgFrame.size.width >= 700) {
        fontSize = 48;
        secondClumeStart = LABEL_VIEW_SECOND_COLUMN_START;
    } else {
        fontSize = labelHeight;
        secondClumeStart = 160;
    }
    font = [UIFont fontWithName:@"Noteworthy" size:fontSize];

    frame = CGRectMake(0,
                       labelsStartY,
                       bgFrame.size.width,
                       labelContentHeight);
    labelBgView = [[UIView alloc] initWithFrame:frame];

    UILabel* (^createLabelView)(CGRect, UIFont*) = ^(CGRect rect, UIFont *aFont){
        UILabel *aLabel;

        aLabel = [[UILabel alloc] initWithFrame:rect];
        [aLabel setTextColor:[UIColor greenColor]];
        [aLabel setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
        [aLabel setFont:aFont];
        [aLabel setOpaque:NO];
        [aLabel setClearsContextBeforeDrawing:NO];
        [labelBgView addSubview:aLabel];
        return aLabel;
    };

    // create score label
    str = NSLocalizedStringFromTable(@"score", @"infoPlist", @"");
    size = [str sizeWithFont:font];
    frame = CGRectMake(0,
                       startY,
                       size.width + LABEL_VIEW_GAP_X, 
                       labelFontSize + LABEL_VIEW_GAP_Y);

    labelView = createLabelView(frame, font);
    [labelView setText:str];
    [labelView release];

    // create score number
    str = @"000000";
    size = [str sizeWithFont:font];
    frame.origin.x += frame.size.width + LABEL_VIEW_GAP_X;
    frame.size.width = size.width + LABEL_VIEW_GAP_X;
    scoreLabel = createLabelView(frame, font);
    [scoreLabel setText:str];

    // create duration label
    str = NSLocalizedStringFromTable(@"season", @"infoPlist", @"");
    size = [str sizeWithFont:font];
    frame.origin.x = secondClumeStart;
    frame.size.width = size.width + LABEL_VIEW_GAP_X;
    labelView =  createLabelView(frame, font);
    [labelView setText:str];
    [labelView release];
    
    // create level number
    str = [NSString stringWithFormat:@"%d", levelMgr.currentSeason];
    size = [str sizeWithFont:font];
    frame.origin.x += frame.size.width;
    frame.size.width = size.width + LABEL_VIEW_GAP_X;
    levelLabel = createLabelView(frame, font);
    [levelLabel setText:str];
    
    // create duration label
    str = NSLocalizedStringFromTable(@"duration", @"infoPlist", @"");
    size = [str sizeWithFont:font];
    frame = CGRectMake(0, startY + frame.size.height + LABEL_VIEW_GAP_Y,
                       size.width, size.height);
    labelView = createLabelView(frame, font);
    [labelView setText:str];
    [labelView release];
    
    // create duration number
    str = @"00:00";
    size = [str sizeWithFont:font];
    frame.origin.x += frame.size.width + LABEL_VIEW_GAP_X;
    frame.size.width = size.width;
    durationLabel = createLabelView(frame, font);
    [durationLabel setText:str];
    
    // create level label
    str = NSLocalizedStringFromTable(@"level", @"infoPlist", @"");
    size = [str sizeWithFont:font];
    frame.origin.x = secondClumeStart;
    frame.size.width = size.width;
    labelView = createLabelView(frame, font);
    [labelView setText:str];
    [labelView release];
    
    // create level number
    str = [NSString stringWithFormat:@"%d", levelMgr.currentLevel];
    size = [str sizeWithFont:font];
    frame.origin.x += frame.size.width + LABEL_VIEW_GAP_X;
    frame.size.width = size.width + LABEL_VIEW_GAP_X;
    floorLabel = createLabelView(frame, font);
    [floorLabel setText:str];
    
    [bgView addSubview:labelBgView];

}

-(void)startGame{
    CGRect playFrame;

    playFrame = bgView.bounds;
    playFrame.origin.y = labelContentHeight;
    playFrame.size.height = FloorMgrContentHeight;
    NSLog(@"playFrame view%@", NSStringFromCGRect(playFrame));
    floorMgr = [[FloorManager alloc] initWithFrame:playFrame];
    floorMgr.gatherNum = 6; // will read from configure file in future
    [bgView addSubview:floorMgr];
    floorMgr.blockNum = [levelMgr getCurrentInitialBlocks];
    [floorMgr setOnFloorUpdatedSelector:@selector(onFloorRefreshed)
                                 target:self];
    [floorMgr activateFloor];
    
    CGRect stopSkillFrame = CGRectMake(0, 
                                       playFrame.origin.y + playFrame.size.height + 4,
                                       ToolsMgrContentHeigh - 8, ToolsMgrContentHeigh - 8);
    skillsMgr *stopSkill = [[skillsMgr alloc] initWithFrame:stopSkillFrame
                            skillType:eSKILL_TYPE_STOP];
    [stopSkill loadResourcesByType];
    [stopSkill setActivate:YES];
    [stopSkill registerNotifySkill:@selector(performSkills:) target:self];
    [bgView addSubview:stopSkill];
    [skills setObject:stopSkill forKey:kStopSkill];
    [stopSkill release];

    CGRect gatherSkillFrame = stopSkillFrame;
    gatherSkillFrame.origin.x += stopSkillFrame.size.width;
    skillsMgr *gatherSkill = [[skillsMgr alloc] initWithFrame:gatherSkillFrame
                                                    skillType:eSKILL_TYPE_GATHER];
    [gatherSkill loadResourcesByType];
    [gatherSkill setActivate:NO];
    [gatherSkill registerNotifySkill:@selector(performSkills:) target:self];
    [bgView addSubview:gatherSkill];
    [skills setObject:gatherSkill forKey:kGatherSkill];
    [gatherSkill release];
}

-(void) stopGame{
    skillsMgr *aSkill;
    NSEnumerator *enumerator = [skills keyEnumerator];

    for (NSString *aKey in enumerator) {
        aSkill = [skills valueForKey:aKey];
        [aSkill removeFromSuperview];
    }
    
    [skills removeAllObjects];
    
    [floorMgr removeFromSuperview];
}

-(void)onFloorRefreshed{
    NSUInteger remainBlocks;
    NSString   *str;

    remainBlocks = [floorMgr getRemainBlocksOfCurrentFloor];
    if (remainBlocks > 0) {
        if([floorMgr getTotalBirdsNum] >= floorMgr.gatherNum) {
            [[skills objectForKey:kGatherSkill] setActivate:YES];
        }
        score += addScores[remainBlocks - 1];
        str = [[NSString alloc] initWithFormat:@"%06d", score];
        [scoreLabel setText:str];
        [str release];
        if (floorMgr.currentActiveFloorIndex == floorMgr.maxFloor) {
            loseWinView *winView;
            winView = [[loseWinView alloc] initWithFrame:bgView.bounds];
            [winView showSuccess];
            [self stopGame];
            [UIView transitionWithView:bgView
                              duration:0.6
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                [bgView addSubview:winView];
                            } completion:^(BOOL finished) {
                                [floorMgr release];
                                floorMgr = nil;
                            }];
            [winView release];
        } else {
            [floorMgr activateNextFloor];
        }
    } else {
        loseWinView *loseView;
    
        loseView = [[loseWinView alloc] initWithFrame:self.frame];
        [loseView showFailed];
        [loseView setStartGameSelector:@selector(startGame) target:self];
        [self stopGame];
        [UIView transitionWithView:self.superview
                          duration:0.6
                           options:UIViewAnimationOptionTransitionFlipFromBottom
                        animations:^{
                            [self.superview addSubview:loseView];
                        } completion:^(BOOL finished) {
                            [floorMgr release];
                            floorMgr = nil;
                        }];
        [loseView release];
    }
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    bgView = [[UIView alloc] initWithFrame:self.bounds];
    [bgView setBackgroundColor:[UIColor grayColor]];
    [self createAllLabelViews];
    [self addSubview:bgView];
    pauseCtl = [[PauseViewController alloc] initWithFrame:bgView.bounds];
    [pauseCtl setStartSelector:@selector(startGame) target:self];
    [self addSubview:pauseCtl.view];

    NSLog(@"frame:%@\nbunds%@\n", NSStringFromCGRect(self.frame),
          NSStringFromCGRect(self.bounds));
}

-(void)performSkills:(NSNumber*)skillId{

    NSLog(@"performing skills for %@", skillId);
    switch (skillId.intValue) {
        case eSKILL_TYPE_STOP:
            [self stopFlyingBirds];
            break;

        case eSKILL_TYPE_GATHER:
            [floorMgr gatherStoppedFloor];
            [[skills objectForKey:kGatherSkill] setActivate:NO];
            break;

        default:
            break;
    }
}

-(void)stopFlyingBirds{
    if((nil == floorMgr) || (eFLOOR_STATUS_PLAYING != [floorMgr currentActiveFloor].floorStatus)){
        NSLog(@"ERROR -- touches on block has been ended animation");
        return;
    }
    
    [floorMgr deactivateFloor];
}

-(void)gatherStoppedBirds{
    [floorMgr gatherStoppedFloor];
}

@end
