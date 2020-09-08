//
//  utilsButtonClass.m
//  magpieBridge
//
//  Created by Yunfei on 12-3-1.
//  Copyright (c) 2012年 __Yunfei.Studio__. All rights reserved.
//

#import "utilsButtonClass.h"

@interface utilsButtonClass ()
- (void)initLayers;
- (void)initFont;
- (void)initBorder;
- (void)addNormalLayer;
- (void)addHighlightLayer;
@end

@implementation utilsButtonClass
#pragma mark -
#pragma mark Initialization


- (void)awakeFromNib {
    [self initLayers];
}


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initLayers];
        [self initFont];
    }
    return self;
}


- (void)initLayers {
    [self initBorder];
    [self addNormalLayer];
    [self addHighlightLayer];
}

- (void)initFont {
    UIFont *font = [UIFont boldSystemFontOfSize:42.0f];
    self.titleLabel.font = font;
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}


- (void)initBorder {
    CALayer *layer = self.layer;
    layer.cornerRadius = 10.0f;
    layer.masksToBounds = YES;
    layer.borderWidth = 2.0f;
    layer.borderColor = [UIColor orangeColor].CGColor;
}


- (void)addNormalLayer {
    layerNormal = [CAGradientLayer layer];
    layerNormal.frame = self.layer.bounds;
    layerNormal.colors = [NSArray arrayWithObjects:
                         (id)[UIColor colorWithWhite:1.0f alpha:0.6f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
//                          (id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.9].CGColor,
//                         (id)[UIColor colorWithWhite:0.1f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.6f].CGColor,
                         nil];
    layerNormal.locations = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:0.0f],
//                            [NSNumber numberWithFloat:0.3f],
                            [NSNumber numberWithFloat:0.5f],
//                            [NSNumber numberWithFloat:0.8f],
                            [NSNumber numberWithFloat:1.0f],
                            nil];
    [self.layer addSublayer:layerNormal];
}


#pragma mark -
#pragma mark Highlight button while touched


- (void)addHighlightLayer {
    layerHighlight = [CALayer layer];
    layerHighlight.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"buttonBg.png"]].CGColor;//[UIColor cyanColor].CGColor;
    layerHighlight.frame = self.layer.bounds;
    layerHighlight.hidden = NO;
    [self.layer insertSublayer:layerHighlight below:layerNormal];
}


- (void)setHighlighted:(BOOL)highlight {
    layerHighlight.hidden = highlight;
    [super setHighlighted:highlight];
}
@end
