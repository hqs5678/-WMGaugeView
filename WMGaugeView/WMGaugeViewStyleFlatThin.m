//
//  WMGaugeViewStyleFlatThin.m
//  WMGaugeView
//
//  Created by Markezana, William on 25/10/15.
//  Copyright © 2015 Will™. All rights reserved.
//

#import "WMGaugeViewStyleFlatThin.h"

#define kNeedleWidth        0.022
#define kNeedleHeight       0.34
#define kNeedleScrewRadius  10
#define kLineWidth          0.4
#define kCenterX            0.5
#define kCenterY            0.5

#define kNeedleColor        CGRGB(0, 0, 255)
#define kNeedleScrewColor   CGRGB(68, 84, 105)

@interface WMGaugeViewStyleFlatThin ()

@property (nonatomic) CAShapeLayer *needleLayer;

@end

@implementation WMGaugeViewStyleFlatThin

- (void)drawNeedleOnLayer:(CALayer*)layer inRect:(CGRect)rect withColor:(UIColor *)color
{
    _needleLayer = [CAShapeLayer layer];
    UIBezierPath *needlePath = [UIBezierPath bezierPath];
    [needlePath moveToPoint:CGPointMake(FULLSCALE(kCenterX - kNeedleWidth, kCenterY))];
    [needlePath addLineToPoint:CGPointMake(FULLSCALE(kCenterX + kNeedleWidth, kCenterY))];
    [needlePath addLineToPoint:CGPointMake(FULLSCALE(kCenterX, kCenterY - kNeedleHeight))];
    [needlePath closePath];
    
    _needleLayer.path = needlePath.CGPath;
    _needleLayer.backgroundColor = [[UIColor clearColor] CGColor];
    CGColorRef needleColor;
    if (color) {
        needleColor = color.CGColor;
    }
    else{
        needleColor = kNeedleColor;
    }
    _needleLayer.fillColor = needleColor;
    _needleLayer.strokeColor = needleColor;
    _needleLayer.lineWidth = kLineWidth;
    
    // Needle shadow
    _needleLayer.shadowColor = [[UIColor blackColor] CGColor];
    _needleLayer.shadowOffset = CGSizeMake(-2.0, -2.0);
    _needleLayer.shadowOpacity = 0.2;
    _needleLayer.shadowRadius = 1.2;
    
    [layer addSublayer:_needleLayer];
    
    // Screw drawing
    CAShapeLayer *screwLayer = [CAShapeLayer layer];
    CGFloat wh = rect.size.width * kNeedleWidth * 2 + 5;
    screwLayer.bounds = CGRectMake(FULLSCALE(kCenterX - kNeedleScrewRadius, kCenterY - kNeedleScrewRadius),  wh, wh);
    screwLayer.position = CGPointMake(FULLSCALE(kCenterX, kCenterY));
    screwLayer.path = [UIBezierPath bezierPathWithOvalInRect:screwLayer.bounds].CGPath;
    screwLayer.fillColor = kNeedleScrewColor;
    
    // Screw shadow
    screwLayer.shadowColor = [[UIColor blackColor] CGColor];
    screwLayer.shadowOffset = CGSizeMake(0.0, 0.0);
    screwLayer.shadowOpacity = 0.2;
    screwLayer.shadowRadius = 2.0;
    
    [layer addSublayer:screwLayer];
}

- (void)drawFaceWithContext:(CGContextRef)context inRect:(CGRect)rect
{
#define EXTERNAL_RING_RADIUS    0.24
#define INTERNAL_RING_RADIUS    0.1
    
    // External circle
    CGContextAddEllipseInRect(context, CGRectMake(kCenterX - EXTERNAL_RING_RADIUS, kCenterY - EXTERNAL_RING_RADIUS, EXTERNAL_RING_RADIUS * 2.0, EXTERNAL_RING_RADIUS * 2.0));
    CGContextSetFillColorWithColor(context, CGRGB(255, 104, 97));
    CGContextFillPath(context);
    
    // Inner circle
    CGContextAddEllipseInRect(context, CGRectMake(kCenterX - INTERNAL_RING_RADIUS, kCenterY - INTERNAL_RING_RADIUS, INTERNAL_RING_RADIUS * 2.0, INTERNAL_RING_RADIUS * 2.0));
    CGContextSetFillColorWithColor(context, CGRGB(242, 99, 92));
    CGContextFillPath(context);
}

- (BOOL)needleLayer:(CALayer*)layer willMoveAnimated:(BOOL)animated duration:(NSTimeInterval)duration animation:(CAKeyframeAnimation*)animation
{
    layer.transform = [[animation.values objectAtIndex:0] CATransform3DValue];
    CGAffineTransform affineTransform1 = [layer affineTransform];
    layer.transform = [[animation.values objectAtIndex:1] CATransform3DValue];
    CGAffineTransform affineTransform2 = [layer affineTransform];
    layer.transform = [[animation.values lastObject] CATransform3DValue];
    CGAffineTransform affineTransform3 = [layer affineTransform];
    
    _needleLayer.shadowOffset = CGSizeApplyAffineTransform(CGSizeMake(-2.0, -2.0), affineTransform3);
    
    [layer addAnimation:animation forKey:kCATransition];
    
    CAKeyframeAnimation * animationShadowOffset = [CAKeyframeAnimation animationWithKeyPath:@"shadowOffset"];
    animationShadowOffset.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationShadowOffset.removedOnCompletion = YES;
    animationShadowOffset.duration = animated ? duration : 0.0;
    animationShadowOffset.values = @[[NSValue valueWithCGSize:CGSizeApplyAffineTransform(CGSizeMake(-2.0, -2.0), affineTransform1)],
                                     [NSValue valueWithCGSize:CGSizeApplyAffineTransform(CGSizeMake(-2.0, -2.0), affineTransform2)],
                                     [NSValue valueWithCGSize:CGSizeApplyAffineTransform(CGSizeMake(-2.0, -2.0), affineTransform3)]];
    [_needleLayer addAnimation:animationShadowOffset forKey:kCATransition];
    
    return YES;
}

@end
