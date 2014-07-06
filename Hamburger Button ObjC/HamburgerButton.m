//
//  HamburgerButton.m
//  Hamburger Button ObjC
//
//  Created by James Whelton on 7/6/14.
//  Copyright (c) 2014 Whelton. All rights reserved.
//

#import "HamburgerButton.h"

@implementation HamburgerButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        shortStroke = CGPathCreateMutable();
        CGPathMoveToPoint(shortStroke, nil, 2, 2);
        CGPathAddLineToPoint(shortStroke, nil, 28, 2);
        
        outline = CGPathCreateMutable();
        CGPathMoveToPoint(outline, nil, 10, 27);
        CGPathAddCurveToPoint(outline, nil, 12.00, 27.00, 28.02, 27.00, 40, 27);
        CGPathAddCurveToPoint(outline, nil, 55.92, 27.00, 50.47,  2.00, 27,  2);
        CGPathAddCurveToPoint(outline, nil, 13.16,  2.00,  2.00, 13.16,  2, 27);
        CGPathAddCurveToPoint(outline, nil,  2.00, 40.84, 13.16, 52.00, 27, 52);
        CGPathAddCurveToPoint(outline, nil, 40.84, 52.00, 52.00, 40.84, 52, 27);
        CGPathAddCurveToPoint(outline, nil, 52.00, 13.16, 42.39,  2.00, 27,  2);
        CGPathAddCurveToPoint(outline, nil, 13.16,  2.00,  2.00, 13.16,  2, 27);
        
        menuStrokeStart = 0.325;
        menuStrokeEnd = 0.9;
        hamburgerStrokeStart = 0.028;
        hamburgerStrokeEnd = 0.111;
        
        top = [[CAShapeLayer alloc] init];
        top.path = shortStroke;
        middle = [[CAShapeLayer alloc] init];
        middle.path = outline;
        bottom = [[CAShapeLayer alloc] init];
        bottom.path = shortStroke;
        
        
        for (CAShapeLayer *layer in @[top, middle, bottom]) {
            layer.fillColor = nil;
            layer.strokeColor = [[UIColor whiteColor] CGColor];
            layer.lineWidth = 4;
            layer.miterLimit = 4;
            layer.lineCap = kCALineCapRound;
            layer.masksToBounds = true;
            
            CGPathRef strokingPath = CGPathCreateCopyByStrokingPath(layer.path, nil, 4, kCGLineCapRound, kCGLineJoinMiter, 4);
            
            layer.bounds = CGPathGetPathBoundingBox(strokingPath);
            
            layer.actions = @{
                              @"strokeStart" : [NSNull null],
                              @"strokeEnd" : [NSNull null],
                              @"transform" : [NSNull null],
                              };
            

            [self.layer addSublayer:layer];
        }
        
        
        top.anchorPoint = CGPointMake(28.0 / 30.0, 0.5);
        top.position = CGPointMake(40, 18);
        
        middle.position = CGPointMake(27, 27);
        middle.strokeStart = hamburgerStrokeStart;
        middle.strokeEnd = hamburgerStrokeEnd;
        
        bottom.anchorPoint = CGPointMake(28.0 / 30.0, 0.5);
        bottom.position = CGPointMake(40, 36);
        
        
    }
    return self;
}



- (void)setShowsMenu:(BOOL)value {
    
    _showsMenu = value;
    
    CABasicAnimation *strokeStart = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    CABasicAnimation *strokeEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    
    if (value) {
        [strokeStart setToValue:[NSNumber numberWithFloat:menuStrokeStart]];
        strokeStart.duration = 0.5;
        strokeStart.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.25 :-0.4 :0.5 :1];
        
        [strokeEnd setToValue:[NSNumber numberWithFloat:menuStrokeEnd]];
        strokeEnd.duration = 0.6;
        strokeEnd.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.25 :-0.4 :0.5 :1];
    } else {
        [strokeStart setToValue:[NSNumber numberWithFloat:hamburgerStrokeStart]];
        strokeStart.duration = 0.5;
        strokeStart.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.25 :0 :0.5 :1.2];
        strokeStart.beginTime = CACurrentMediaTime() + 0.1;
        strokeStart.fillMode = kCAFillModeBackwards;
        
        [strokeEnd setToValue:[NSNumber numberWithFloat:hamburgerStrokeEnd]];
        strokeEnd.duration = 0.6;
        strokeEnd.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.25 :0.3 :0.5 :0.9];
    }

    
    [middle ocb_applyAnimation:strokeStart];
    [middle ocb_applyAnimation:strokeEnd];
    
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.25 :-0.8 :0.75 :1.85];
    
    CABasicAnimation *topTransform = [CABasicAnimation animationWithKeyPath:@"transform"];
    topTransform.timingFunction = timingFunction;
    topTransform.fillMode = kCAFillModeBackwards;
    
    CABasicAnimation *bottomTransform = [CABasicAnimation animationWithKeyPath:@"transform"];
    bottomTransform.timingFunction = timingFunction;
    bottomTransform.fillMode = kCAFillModeBackwards;
    
    if (value) {
        CATransform3D translation = CATransform3DMakeTranslation(-4, 0, 0);
        
        topTransform.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(translation, -0.7853975, 0, 0, 1)];
        topTransform.beginTime = CACurrentMediaTime() + 0.25;
        
        bottomTransform.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(translation, 0.7853975, 0, 0, 1)];
        bottomTransform.beginTime = CACurrentMediaTime() + 0.25;
    } else {
        topTransform.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        topTransform.beginTime = CACurrentMediaTime() + 0.05;
        
        bottomTransform.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        bottomTransform.beginTime = CACurrentMediaTime() + 0.05;
    }
    
    [top ocb_applyAnimation:topTransform];
    [bottom ocb_applyAnimation:bottomTransform];
    
}


@end


@implementation CALayer (ButtonAnimations)

- (void)ocb_applyAnimation:(CABasicAnimation *)animation {
    
    CABasicAnimation *copy = [animation copy];
    
    if (copy.fromValue == nil) {
        copy.fromValue = [self.presentationLayer valueForKey:copy.keyPath];
    }
    
    
    [self addAnimation:copy forKey:copy.keyPath];
    [self setValue:copy.toValue forKeyPath:copy.keyPath];

}

@end
