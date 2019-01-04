//
//  WLDanmakuTrackView.m
//  test
//
//  Created by Jason Wang on 2018/12/17.
//  Copyright © 2018 cmcc. All rights reserved.
//

#import "WLDanmakuTrackView.h"


static const CGFloat kMargin = 40;

@interface WLDanmakuTrackView()<WLDanmakuViewCellDelegate>
@property (nonatomic, readonly) CGFloat width;
@property (nonatomic, readonly) CGFloat height;

@property (nonatomic, strong) NSTimer *becommeFreeTimer;

@property (nonatomic, assign) WLDanmakuViewState state;

@end

@implementation WLDanmakuTrackView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.visibleCells = [NSMutableArray new];
        self.free = YES;
    }
    return self;
}

- (void)showCell:(WLDanmakuViewCell *)cell{
    [self addSubview:cell];
    cell.frame = CGRectMake(self.width, 0, cell.cellWidth, self.height);
    self.lastCell = cell;
    [self.visibleCells addObject:cell];
    self.free = NO;
    
    [self startAnimationForCell:cell];
}

- (void)startAnimationForCell:(WLDanmakuViewCell *)cell{
    CGPoint fromPoint = CGPointMake(self.width + CGRectGetWidth(cell.frame)/2, CGRectGetHeight(cell.frame)/2);
    CGPoint toPoint = CGPointMake(CGRectGetWidth(cell.frame)/2-CGRectGetWidth(cell.frame),  CGRectGetHeight(cell.frame)/2);
    CGFloat duration = 5;
    //1.等速：所有弹幕从“开始出现”到“开始隐藏”时间相同，
    CGFloat velocity = self.width / 3.0;//4s 字幕的origin从左到右
    duration = (fromPoint.x - toPoint.x) / velocity;
    
    // 2.等时：所有弹幕从“开始出现”到“完全隐藏”的时间相同，较长的弹幕运动速度较快。此情况下会出现弹幕重叠的情况。
    // CGFloat velocity = (fromPoint.x - toPoint.x) / duration;
    //-------------------

    NSTimeInterval fullDisplayInterval = (cell.cellWidth + kMargin) / velocity;
    [self startCountBecommeFreeTimer:fullDisplayInterval];
    
    cell.delegate = self;
    [cell startAnimationFrom:fromPoint to:toPoint duration:duration compeletion:nil];
//    __weak typeof(self) weakSelf = self;
//    [cell startAnimationFrom:fromPoint to:toPoint duration:duration compeletion:^(WLDanmakuViewCell * _Nonnull cell) {
//        __strong typeof(self) strongSelf = self;
//        if (cell == strongSelf.lastCell) {
//            strongSelf.lastCell = nil;
//        }
//        [cell removeFromSuperview];
//        [weakSelf.visibleCells removeObject:cell];
//    }];
}

- (void)startCountBecommeFreeTimer:(NSTimeInterval)interval{
    [self invalidateTimer:self.becommeFreeTimer];
    self.becommeFreeTimer = [NSTimer timerWithTimeInterval:interval target:self selector:@selector(changeToFree) userInfo:@(YES) repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.becommeFreeTimer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer:(NSTimer *)timer{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

- (void)changeToFree{
    _free = YES;
    [self invalidateTimer:self.becommeFreeTimer];
    if (self.delegate && [self.delegate respondsToSelector:@selector(danmakuTrackDidBecommeFree:)]) {
        [self.delegate danmakuTrackDidBecommeFree:self];
    }
}

- (void)dealloc{
    [self invalidateTimer:self.becommeFreeTimer];
}


#pragma mark - Delegate
- (void)didEndDisplayDanmakuViewCell:(WLDanmakuViewCell *)cell{
    if (self.delegate && [self.delegate respondsToSelector:@selector(danmakuTrack:cellDidDisappear:)]) {
        [self.delegate danmakuTrack:self cellDidDisappear:cell];
    }
}

#pragma mark - Change Control
- (void)pause{
    if (self.state != WLDanmakuViewStatePlaying) {
        return;
    }
    NSEnumerator *enumerator = [self.visibleCells reverseObjectEnumerator];
    WLDanmakuViewCell *cell = nil;
    while (cell = [enumerator nextObject]){
        [cell pauseAnimation];
    }
    [self invalidateTimer:self.becommeFreeTimer];
    self.state = WLDanmakuViewStatePause;
}

- (void)resume{
    if (self.state != WLDanmakuViewStatePause) {
        return;
    }
    NSEnumerator *enumerator = [self.visibleCells reverseObjectEnumerator];
    WLDanmakuViewCell *cell = nil;
    while (cell = [enumerator nextObject]){
        [cell resumeAnimation];
    }
//Recount the timer of last cell if needed
    if (!self.isFree) {
        CGFloat currentX = self.lastCell.layer.presentationLayer.frame.origin.x;
        CGFloat remainWidth = CGRectGetWidth(self.lastCell.frame) - (self.width - currentX) + kMargin;
        CGFloat velocity = self.width / 3.0;//4s 字幕的origin从左到右
        NSTimeInterval duration = remainWidth / velocity;
        [self startCountBecommeFreeTimer:duration];
    }
    self.state = WLDanmakuViewStatePlaying;
}

- (void)clear{
    NSEnumerator *animatingEnumerator = [self.visibleCells reverseObjectEnumerator];
    WLDanmakuViewCell *animatingCell = nil;
    while (animatingCell = [animatingEnumerator nextObject]){
        [animatingCell resumeAnimation];
        [animatingCell removeFromSuperview];
        
    }
    [self.visibleCells removeAllObjects];
    [self invalidateTimer:self.becommeFreeTimer];
    self.free = YES;
    
    self.state = WLDanmakuViewStatePlaying;
}

#pragma mark - Getter
- (CGFloat)width{
    return CGRectGetWidth(self.frame);
}

- (CGFloat)height{
    return CGRectGetHeight(self.frame);
}

@end
