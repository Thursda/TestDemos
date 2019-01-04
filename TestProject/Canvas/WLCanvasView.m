//
//  WLCanvasView.m
//  test
//
//  Created by Jason Wang on 2018/11/28.
//  Copyright © 2018 cmcc. All rights reserved.
//

#import "WLCanvasView.h"
@interface WLCanvasView()

@property (nonatomic, strong) UIBezierPath *drawPath;
@property (nonatomic, strong) CAShapeLayer *drawLayer;

@end

@implementation WLCanvasView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (touches.count == 1) {
        CGPoint point = [touches.anyObject locationInView:self];
        _drawPath = [UIBezierPath bezierPath];
        [_drawPath moveToPoint:point];
        _drawPath.lineWidth = 3;
        _drawPath.lineCapStyle = kCGLineCapRound;
        _drawPath.lineJoinStyle = kCGLineJoinRound;
        
        
        CAShapeLayer * slayer = [CAShapeLayer layer];
        slayer.path = _drawPath.CGPath;
//        slayer.backgroundColor = [UIColor clearColor].CGColor;
        slayer.fillColor = [UIColor clearColor].CGColor;
        slayer.lineCap = kCALineCapRound;
        slayer.lineJoin = kCALineJoinRound;
        slayer.strokeColor = [UIColor blackColor].CGColor;
        slayer.lineWidth = _drawPath.lineWidth;
        [self.layer addSublayer:slayer];
        _drawLayer = slayer;
        
        [self.layer addSublayer:_drawLayer];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (touches.count == 1) {
        CGPoint point = [touches.anyObject locationInView:self];
        [_drawPath addLineToPoint:point];
        
        _drawLayer.path = _drawPath.CGPath;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"----bezier path poing cout : %d", _drawPath.currentPoint);
}
@end
