//
//  HamburgerButton.m
//  Hamburger Button ObjC
//
//  Created by James Whelton on 7/6/14.
//  Copyright (c) 2014 Whelton. All rights reserved.
//

#import "HamburgerButton.h"

@interface HamburgerButton ()

@property (nonatomic, assign) CGFloat scaleFactor;
@property (nonatomic, assign) CGFloat smallerSide;

@end

@implementation HamburgerButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup];
}

- (void)setup
{
    self.smallerSide = MIN(self.bounds.size.width, self.bounds.size.height);
    self.scaleFactor = self.smallerSide / 55.0f;
    
    shortStroke = CGPathCreateMutable();
    CGPathMoveToPoint(shortStroke, nil, 2 * self.scaleFactor, 2 * self.scaleFactor);
    CGPathAddLineToPoint(shortStroke, nil, 28 * self.scaleFactor, 2 * self.scaleFactor);
    
    outline = CGPathCreateMutable();
    CGPathMoveToPoint(outline, nil, 10 * self.scaleFactor, 27 * self.scaleFactor);
    CGPathAddCurveToPoint(outline, nil, 12.00f * self.scaleFactor, 27.00f * self.scaleFactor, 28.02f * self.scaleFactor, 27.00f * self.scaleFactor, 40.0f * self.scaleFactor, 27.0f * self.scaleFactor);
    CGPathAddCurveToPoint(outline, nil, 55.92f * self.scaleFactor, 27.00f * self.scaleFactor, 50.47f * self.scaleFactor,  2.00f * self.scaleFactor, 27.0f * self.scaleFactor,  2.0f * self.scaleFactor);
    CGPathAddCurveToPoint(outline, nil, 13.16f * self.scaleFactor,  2.00f * self.scaleFactor,  2.00f * self.scaleFactor, 13.16f * self.scaleFactor,  2.0f * self.scaleFactor, 27.0f * self.scaleFactor);
    CGPathAddCurveToPoint(outline, nil,  2.00f * self.scaleFactor, 40.84f * self.scaleFactor, 13.16f * self.scaleFactor, 52.00f * self.scaleFactor, 27.0f * self.scaleFactor, 52.0f * self.scaleFactor);
    CGPathAddCurveToPoint(outline, nil, 40.84f * self.scaleFactor, 52.00f * self.scaleFactor, 52.00f * self.scaleFactor, 40.84f * self.scaleFactor, 52.0f * self.scaleFactor, 27.0f * self.scaleFactor);
    CGPathAddCurveToPoint(outline, nil, 52.00f * self.scaleFactor, 13.16f * self.scaleFactor, 42.39f * self.scaleFactor,  2.00f * self.scaleFactor, 27.0f * self.scaleFactor,  2.0f * self.scaleFactor);
    CGPathAddCurveToPoint(outline, nil, 13.16f * self.scaleFactor,  2.00f * self.scaleFactor,  2.00f * self.scaleFactor, 13.16f * self.scaleFactor,  2.0f * self.scaleFactor, 27.0f * self.scaleFactor);
    
    menuStrokeStart = 0.325f;
    menuStrokeEnd = 0.9f;
    hamburgerStrokeStart = 0.028f;
    hamburgerStrokeEnd = 0.111f;
    
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
        
        CGPathRelease(strokingPath);
    }
    
    const CGFloat hCenter = self.bounds.size.width / 2;
    const CGFloat vCenter = self.bounds.size.height / 2;
    const CGFloat vOffset = self.smallerSide / 6;
    top.anchorPoint = CGPointMake(0.5f, 0.5f);
    top.position = CGPointMake(hCenter, vCenter - vOffset);
    
    middle.strokeStart = hamburgerStrokeStart;
    middle.strokeEnd = hamburgerStrokeEnd;
    middle.position = CGPointMake(hCenter, vCenter);
    
    bottom.anchorPoint = CGPointMake(0.5f, 0.5f);
    bottom.position = CGPointMake(hCenter, vCenter + vOffset);
}

- (void)setShowsMenu:(BOOL)value {
    
    _showsMenu = value;
    
    CABasicAnimation *strokeStart = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    CABasicAnimation *strokeEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    
    if (value) {
        [strokeStart setToValue:[NSNumber numberWithFloat:menuStrokeStart]];
        strokeStart.duration = 0.5;
        strokeStart.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.25f :-0.4f :0.5f :1.0f];
        
        [strokeEnd setToValue:[NSNumber numberWithFloat:menuStrokeEnd]];
        strokeEnd.duration = 0.6;
        strokeEnd.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.25f :-0.4f :0.5f :1.0f];
    } else {
        [strokeStart setToValue:[NSNumber numberWithFloat:hamburgerStrokeStart]];
        strokeStart.duration = 0.5;
        strokeStart.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.25f :0 :0.5f :1.2f];
        strokeStart.beginTime = CACurrentMediaTime() + 0.1;
        strokeStart.fillMode = kCAFillModeBackwards;
        
        [strokeEnd setToValue:[NSNumber numberWithFloat:hamburgerStrokeEnd]];
        strokeEnd.duration = 0.6;
        strokeEnd.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.25f :0.3f :0.5f :0.9f];
    }

    
    [middle ocb_applyAnimation:strokeStart];
    [middle ocb_applyAnimation:strokeEnd];
    
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.25f :-0.8f :0.75f :1.85f];
    
    CABasicAnimation *topTransform = [CABasicAnimation animationWithKeyPath:@"transform"];
    topTransform.timingFunction = timingFunction;
    topTransform.fillMode = kCAFillModeBackwards;
    
    CABasicAnimation *bottomTransform = [CABasicAnimation animationWithKeyPath:@"transform"];
    bottomTransform.timingFunction = timingFunction;
    bottomTransform.fillMode = kCAFillModeBackwards;
    
    if (value) {

        const CGFloat angle = 0.7853975f;
        const CGFloat vOffset = self.smallerSide / 6;
        
        CATransform3D topTransformation = CATransform3DMakeTranslation(0, vOffset, 0);
        topTransformation = CATransform3DRotate(topTransformation, -angle, 0, 0, 1);
        topTransform.toValue = [NSValue valueWithCATransform3D:topTransformation];
        topTransform.beginTime = CACurrentMediaTime() + 0.25;
        
        CATransform3D bottomTransformation = CATransform3DMakeTranslation(0, -vOffset, 0);
        bottomTransformation = CATransform3DRotate(bottomTransformation, angle, 0, 0, 1);
        bottomTransform.toValue = [NSValue valueWithCATransform3D:bottomTransformation];
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
