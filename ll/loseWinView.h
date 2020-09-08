//
//  loseWinView.h
//  ll
//
//  Created by Yunfei on 12-1-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface loseWinView : UIView{
    UIView      *pannelView;
    UIImageView *imageView;
    UILabel     *infoLabel;
    UILabel     *scoreLabel;
    UILabel     *recordLabel;
    BOOL         isSuccess;
    SEL         startGame;
    id          startGameTarget;
}

/*
 * @brief showSuccess
 * @detail this function draw a success view and show level choice
 * @return none
 * @invoke mainGameView
 */
-(void)showSuccess;

/*
 * @brief showFailed
 * @detail this function draw a faild view and show continue/back choice
 * @return none
 * @invoke mainGameView
 */
-(void)showFailed;

-(void)setStartGameSelector:(SEL)aSlector
                     target:(id)aTarget;
@end
