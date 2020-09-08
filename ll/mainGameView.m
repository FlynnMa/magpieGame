//
//  MainViewController.m
//  magpieBridge
//
//  Created by Yunfei on 12-1-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "mainGameView.h"
#import "FloorController.h"
#import "pauseView.h"
#import "FloorManager.h"
#import "loseWinView.h"
#import "levelManager.h"
#import <QuartzCore/QuartzCore.h>
#import "mainSettings.h"
#import "skillsMgr.h"
#import "viewTags.h"

#define LABEL_VIEW_SECOND_COLUMN_START     380

#define LABEL_VIEW_GAP_Y     4  // label view's gap
#define LABEL_VIEW_GAP_X     4  // label view's gap
#define LABEL_VIEW_FONT_SIZE 48  // label view default font size

#define kStopSkill             @"stopSkill"
#define kGatherSkill           @"gatherSkill"

@implementation mainGameView

const NSUInteger addScores[3] = {1, 4, 8};

/*
 * @brief    initialize mainGameView
 * @detail   initialize lable, game content, tools area's height and positons
 * @calledby  fgameAppDelegate
 */
- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        levelMgr = [[levelManager alloc] init];
        settings = [[mainSettings sharedSettings] retain];       
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

        self.tag = magepieBridgeViewTagMainGame;
        [self setTag: magepieBridgeViewTagMainGame];
        [self loadView];
    }

    return self;
}

/*
 * @brief    initialize views
 * @detail   set background color, load label views, create game, and pause game at last
 * @calledby  initWithFrame
 */
- (void)loadView
{
    [self setBackgroundColor:
      [UIColor colorWithPatternImage:
        [UIImage imageNamed:@"background-day.png"]]];
    [self createAllLabelViews];
    [self createGame];
    [self pauseGame];
    NSLog(@"frame:%@\nbunds%@\n", NSStringFromCGRect(self.frame),
          NSStringFromCGRect(self.bounds));
}

/*
 * @brief    create game invirment
 * @detail   create game play frame(floormgr), create basic skills views 
 * @calledby loadView
 */
-(void)createGame{
    CGRect playFrame;
    
    NSLog(@"creating game...");
    playFrame = self.bounds;
    playFrame.origin.y = labelContentHeight;
    playFrame.size.height = FloorMgrContentHeight;
    floorMgr = [[FloorManager alloc] initWithFrame:playFrame];
    gatherSkillBirdsNum = 6;
    [self addSubview:floorMgr];
    floorMgr.initialBirdsNum = levelMgr.initialBirdsNum.unsignedIntValue;
    floorMgr.currentActiveFloorIndex = 0;
    floorMgr.delegate = self;
    
    CGRect stopSkillFrame = CGRectMake(0, 
                                       playFrame.origin.y + playFrame.size.height + 4,
                                       ToolsMgrContentHeigh - 8, ToolsMgrContentHeigh - 8);
    
    skillsMgr *stopSkill = [[skillsMgr alloc] initWithFrame:stopSkillFrame
                                                  skillType:eSKILL_TYPE_STOP];
    [stopSkill setActivate:YES];
    [stopSkill registerNotifySkill:@selector(performSkills:) target:self];
    [self addSubview: stopSkill];
    [skills setObject: stopSkill forKey:kStopSkill];
    [stopSkill release];
    
    CGRect gatherSkillFrame = stopSkillFrame;
    gatherSkillFrame.origin.x = playFrame.size.width - gatherSkillFrame.size.width;
    
    skillsMgr *gatherSkill = [[skillsMgr alloc] initWithFrame:gatherSkillFrame
                                                    skillType:eSKILL_TYPE_GATHER];
    [gatherSkill setActivate:NO];
    [gatherSkill registerNotifySkill:@selector(performSkills:) target:self];
    [self addSubview:gatherSkill];
    [skills setObject:gatherSkill forKey:kGatherSkill];
    [gatherSkill release];
}

/*
 * @brief    pause game
 * @detail   pause the game, set floor paused, and create a pause view,
 *           set startGame selector
 * @calledby loadView, touchesBegan on floorMgr view
 */
-(void) pauseGame{
    pauseView   *iPauseView;
    NSLog(@"pause game ...");
    
    [floorMgr pauseFloor];
    iPauseView = [[pauseView alloc] initWithFrame:self.bounds];
    [iPauseView loadView];
    [iPauseView setStartSelector:@selector(startGame) target:self];
    [self addSubview:iPauseView];
    [iPauseView release];
}

/*
 * @brief    start game
 * @detail   start the game, set floor paused, and create a pause view,
 *           set startGame selector
 * @calledby loadView, touchesBegan on floorMgr view
 */
-(void)startGame{
    NSLog(@"start game...");
    [floorMgr setOnFloorEvents:@selector(onFloorMgrEvents:)
                                 target:self];
    [floorMgr startFloor];
}

/*
 * @brief    restart game
 * @detail   restart the game, create Game and start
 * @calledby loseWin selector
 */
-(void)restartGame{
    NSLog(@"restart game...");
    
    [self createGame];
    [self startGame];
}

/*
 * @brief    destroy game
 * @detail   destroy the game, destroy all skills remove floorMgr
 * @calledby onFloorUpdated
 */
-(void)destroyGame{
    skillsMgr *aSkill;
    NSEnumerator *enumerator = [skills keyEnumerator];
    
    NSLog(@"destroy game...");
    
    // remove all skills
    for (NSString *aKey in enumerator) {
        aSkill = [skills valueForKey:aKey];
        [aSkill removeFromSuperview];
    }
    
    [skills removeAllObjects];
    [floorMgr removeFromSuperview];
    [floorMgr release];
    floorMgr = nil;
}

/*
 * @brief    stop game
 * @detail   stop the floorMgr
 * @invoke   onFloorUpdated
 */
-(void) stopGame{
    
    // deactive floor manager first
    [floorMgr setOnFloorEvents:nil target:nil];
    [floorMgr stopFloor];
}

/*
 * @brief   onFloorMgrEvents
 * @detail  
 * @invoke  floorManager
 */
-(void) onFloorMgrEvents:(NSNumber*)evt{
    NSLog(@"mainGameView on events%@", evt);
    switch (evt.intValue) {        
        case eFLOOR_MGR_EVT_GATHERED:
            [[skills objectForKey:kGatherSkill] setActivate:NO];
            [[skills objectForKey:kStopSkill] setActivate:YES];
            [floorMgr setCurrentActiveFloorIndex:0];
            floorMgr.initialBirdsNum = 3;
            [floorMgr startFloor];
            break;

        default:
            break;
    }
}

- (void)dealloc{

    NSLog(@"mainGameView dealloc...");
    [labelBgView release];
    [scoreLabel release];
    [levelLabel release];
    [durationLabel release];
    [floorLabel release];
    [levelMgr release];
    [settings release];
    [skills release];

    [super release];
    [super dealloc];
}

/*
 * @brief    createAllLabelViews
 * @detail   create all labels
 * @calledby self
 */
- (void) createAllLabelViews{
    CGRect bgFrame;
    CGRect frame = {0,0,0,0};
    UILabel *labelView;
    NSString *str;
    UIFont   *font;
    CGSize    size;
    CGFloat   fontSize;

    bgFrame = [self frame];
    if (bgFrame.size.width >= 700) {
        fontSize = 42;
    } else {
        fontSize = labelHeight;
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
    str = NSLocalizedStringFromTable(@"season", @"infoPlist", @"");
    size = [str sizeWithFont:font];
    frame = CGRectMake(0,
                       0,
                       size.width + LABEL_VIEW_GAP_X, 
                       size.height + LABEL_VIEW_GAP_Y);

    labelView = createLabelView(frame, font);
    [labelView setText:str];
    [labelView release];

    // create score number
    str = @"0";
    size = [str sizeWithFont:font];
    frame.origin.x += frame.size.width + LABEL_VIEW_GAP_X;
    frame.size.width = size.width + LABEL_VIEW_GAP_X;
    scoreLabel = createLabelView(frame, font);
    [scoreLabel setText:str];

    // create day label
    str = NSLocalizedStringFromTable(@"day", @"infoPlist", @"");
    size = [str sizeWithFont:font];
    frame.origin.x = bgFrame.size.width - size.width - 20;
    frame.size.width = size.width + LABEL_VIEW_GAP_X;
    labelView =  createLabelView(frame, font);
    [labelView setText:str];
    [labelView release];
    
    // create day number
    str = [NSString stringWithFormat:@"%d", levelMgr.currentSeason];
    size = [str sizeWithFont:font];
    frame.origin.x += frame.size.width;
    frame.size.width = size.width + LABEL_VIEW_GAP_X;
    levelLabel = createLabelView(frame, font);
    [levelLabel setText:str];

    [self addSubview:labelBgView];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if (floorMgr != [touch view]) {
        return;
    }

    [self pauseGame];
}

/*
 * @brief    performSkills
 * @detail   perform skills received from skills manager
 * @calledby skillsMgr
 */
-(void)performSkills:(NSNumber*)skillId{

    switch (skillId.intValue) {
        case eSKILL_TYPE_STOP:
            [floorMgr stopFloor];
            break;

        case eSKILL_TYPE_GATHER:
            [floorMgr gatherStoppedBirdsForAllFloors];
            [[skills objectForKey:kGatherSkill] setActivate:NO];
            [[skills objectForKey:kStopSkill] setActivate:NO];
            break;

        default:
            break;
    }
}

-(void) onGameWin{
    loseWinView *winView;
    winView = [[loseWinView alloc] initWithFrame:self.frame];
    [winView showSuccess];
    [winView setStartGameSelector:@selector(restartGame) target:self];
    [self stopGame];
    winView.alpha = 0;
    [self.superview addSubview:winView];
    [UIView transitionWithView:self
                      duration:0.6
                       options:UIViewAnimationOptionCurveEaseIn
                    animations:^{
                        winView.alpha = 1.0f;
                    } completion:^(BOOL finished) {
                        [self destroyGame];
                    }];
    [winView release];
}

-(void) onGameFailed{
    loseWinView *loseView;
    
    loseView = [[loseWinView alloc] initWithFrame:self.frame];
    [loseView showFailed];
    [loseView setStartGameSelector:@selector(restartGame) target:self];
    [self stopGame];
    loseView.alpha = 0;
    [self.superview addSubview:loseView];
    [UIView transitionWithView:self.superview
                      duration:0.3
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        [loseView setAlpha:1.0f];
                    } completion:^(BOOL finished) {
                        [self destroyGame];
                    }];
    [loseView release];
}

-(void) activeGatherSkill{

    [[skills objectForKey:kGatherSkill] setActivate:YES];
}

-(void) onBirdsEmpty{

    [[skills objectForKey:kGatherSkill] setActivate:NO];
    [[skills objectForKey:kStopSkill] setActivate:YES];
}

-(void)updateLife:(NSUInteger)count{
    NSUInteger i;

    for (UIImageView *imgView in lifeArray) {
        [imgView removeFromSuperview];
    }
    [lifeArray removeAllObjects];
    for (i = 0; i < count; i ++) {
        UIImageView *iImageView = [[UIImageView alloc] initWithImage:
                                   [UIImage imageNamed:@"magpieLove.png"]];
        [iImageView sizeToFit];
        CGFloat xPosition, yPosition;
        CGRect  bounds = iImageView.bounds;
        CGRect  scoreFrame = scoreLabel.frame;

        xPosition = scoreFrame.origin.x + bounds.size.width / 2 + bounds.size.width * i;
        yPosition = scoreFrame.origin.y + bounds.size.height + 5;
        iImageView.center = CGPointMake(xPosition, yPosition);
        [self addSubview:iImageView];
        [lifeArray addObject:iImageView];
        [iImageView release];
    }
}

@end
