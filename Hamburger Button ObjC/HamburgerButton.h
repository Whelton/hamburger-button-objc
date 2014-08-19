//
//  HamburgerButton.h
//  Hamburger Button ObjC
//
//  Created by James Whelton on 7/6/14.
//  Copyright (c) 2014 Whelton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@interface HamburgerButton : UIButton {
    
    struct CGPath *shortStroke, *outline;
    CAShapeLayer *top, *middle, *bottom;
    CGFloat menuStrokeStart, menuStrokeEnd, hamburgerStrokeStart, hamburgerStrokeEnd;
    
}

@property (nonatomic) BOOL showsMenu;

@end

@interface CALayer (ButtonAnimations)

- (void)ocb_applyAnimation:(CABasicAnimation *)animation;

@end
