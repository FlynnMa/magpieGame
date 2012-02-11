//
//  loseWinView.h
//  ll
//
//  Created by Apple on 12-1-27.
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

-(void)showSuccess;
-(void)showFailed;

-(void)setStartGameSelector:(SEL)aSlector
                     target:(id)aTarget;
@end
