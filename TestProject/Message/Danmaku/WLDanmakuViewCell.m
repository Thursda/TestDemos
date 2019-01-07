//
//  WLDanmakuViewCell.m
//  test
//
//  Created by Jason Wang on 2018/12/17.
//  Copyright © 2018 cmcc. All rights reserved.
//

#import "WLDanmakuViewCell.h"

@interface WLDanmakuViewCell ()<CAAnimationDelegate>

@property (copy, nonatomic) void (^completion)(WLDanmakuViewCell *cell);

@end

@implementation WLDanmakuViewCell

#pragma mark - Inital

- (instancetype)initWithIdentifier:(NSString *)identifier
{
    if (self = [super init]) {
        _reuseIdentifier = identifier;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _label = [UILabel new];
        _label.frame = frame;
        _label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_label];
    }
    return self;
}

- (void)startAnimationFrom:(CGPoint)from to:(CGPoint)to duration:(NSTimeInterval)duration compeletion:(void(^)(WLDanmakuViewCell *cell))completion{
    CABasicAnimation *move = [CABasicAnimation animation];
    move.keyPath = @"position";
    move.fromValue = [NSValue valueWithCGPoint:from];
    move.toValue = [NSValue valueWithCGPoint:to];
    move.duration = duration;
    move.delegate = self;
    move.removedOnCompletion = YES;
    move.fillMode = kCAFillModeBackwards;

    [self.layer addAnimation:move forKey:@"position"];
    
    move.delegate = self;
    self.completion = completion;
}

- (void)pauseAnimation{
    [self pauseAnimationLayer:self.layer];
}

- (void)resumeAnimation{
    [self resumeAnimationLayer:self.layer];
}

- (void)clearAnimation{
    [self clearAnimationLayer:self.layer];
}

- (CGRect)currentFrame{
    NSLog(@"---------x:%f", self.layer.presentationLayer.frame.origin.x);
    return self.layer.presentationLayer.frame;
}

- (void)pauseAnimationLayer:(CALayer*)layer {
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

- (void)resumeAnimationLayer:(CALayer*)layer {
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

- (void)clearAnimationLayer:(CALayer *)layer{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
    [layer removeAllAnimations];
}

#pragma mark - Delegate
- (void)animationDidStart:(CAAnimation *)anim{

}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (self.completion) {
        self.completion(self);
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didEndDisplayDanmakuViewCell:)]) {
        [self.delegate didEndDisplayDanmakuViewCell:self];
    }
}

- (void)setCellWidth:(CGFloat)cellWidth{
    if (cellWidth != _cellWidth) {
        _cellWidth = cellWidth;
        CGRect frame = self.frame;
        frame.size.width = cellWidth;
        self.frame = frame;
    }
}

@end
