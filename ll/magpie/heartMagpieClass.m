//
//  heartMagpieClass.m
//  magpieBridge
//
//  Created by Yunfei Ma on 12-3-8.
//  Copyright (c) 2012年 yunfei. All rights reserved.
//

#import "heartMagpieClass.h"
#import <QuartzCore/QuartzCore.h>

@implementation heartMagpieClass
         
@synthesize iLayer    = _iLayer;

-(void) onStopAndKeep{
    UIImage *iImageLove = [UIImage imageNamed:@"magpieLove.png"];
    _iLayer.contents = (id)[iImageLove CGImage];
    
    CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulseAnimation.duration = 1.2;
    pulseAnimation.toValue = [NSNumber numberWithFloat:3.0];

    CABasicAnimation *fadeAnimation;
    fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.duration = 1.2;
    fadeAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    fadeAnimation.toValue = [NSNumber numberWithFloat:0.0];

    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithObjects:pulseAnimation, fadeAnimation, nil];
    group.duration = 1.2;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.autoreverses = NO;
    
    [_iLayer addAnimation:group forKey:nil];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
}
@end
