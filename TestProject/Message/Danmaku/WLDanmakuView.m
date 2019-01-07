//
//  WLDanmakuView.m
//  test
//
//  Created by Jason Wang on 2018/12/17.
//  Copyright © 2018 cmcc. All rights reserved.
//

#import "WLDanmakuView.h"
#import "WLDanmakuTrackView.h"
#import "Masonry.h"

@interface WLDanmakuView()<WLDanmakuTrackViewDelegate>

@property (nonatomic, strong) NSArray<WLDanmakuTrackView *> *tracks;
@property (nonatomic, strong) NSMutableArray<WLDanmakuViewCell *> *cellCaches;
@property (nonatomic, strong) NSMutableArray<id<WLDanmakuEntity>> *danmakuQueue;

@end

@implementation WLDanmakuView

#pragma mark - Initialize
- (instancetype)initWithRowNumber:(NSUInteger)rows rowheight:(CGFloat)rowHeight margin:(CGFloat)margin{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _numberOfRows = rows;
        _rowHeght = rowHeight;
        _margin = margin;
        [self setUp];
    }
    return self;
}

- (void)setUp{
    _cellCaches = [NSMutableArray array];
    _danmakuQueue = [NSMutableArray array];
    
    NSMutableArray *tracks = [NSMutableArray arrayWithCapacity:_numberOfRows];
    for (int i = 0; i < _numberOfRows; i ++) {
        WLDanmakuTrackView *track = [WLDanmakuTrackView new];
        track.tag = i;
        track.delegate = self;
        [tracks addObject:track];
        [self addSubview:track];
    }
    _tracks = [tracks copy];
    if (_numberOfRows > 1) {
        [_tracks mas_distributeViewsAlongAxis:(MASAxisTypeVertical) withFixedSpacing:_margin leadSpacing:0 tailSpacing:0];
        [_tracks mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.mas_width);
        }];
    }else{
        WLDanmakuTrackView *track = [_tracks firstObject];
        [track mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

#pragma mark - Delegate
- (void)danmakuTrackDidBecommeFree:(WLDanmakuTrackView *)track{
    if (self.danmakuQueue.count > 0) {
        id<WLDanmakuEntity> danmaku = [self.danmakuQueue firstObject];
        WLDanmakuViewCell *cell = [self.dataSource danmakuView:self cellForDanmaku:danmaku];
        [track showCell:cell];
        [self.danmakuQueue removeObject:danmaku];
    }
}

- (void)danmakuTrack:(WLDanmakuTrackView *)track cellDidDisappear:(WLDanmakuViewCell *)cell{
    if (cell) {
        [self.cellCaches addObject:cell];
    }
}

#pragma mark - Publick Methods
- (void)showDanmakus:(NSArray<id<WLDanmakuEntity>> *)danmakus{
    NSMutableArray<WLDanmakuTrackView *> *freeTracks = [NSMutableArray new];
    for (int i = 0; i < self.tracks.count; i++) {
        WLDanmakuTrackView *track = self.tracks[i];
        if (track.isFree) {
            [freeTracks addObject:track];
        }
    }
    
    for (int i = 0; i< danmakus.count; i++) {
        id<WLDanmakuEntity> danmaku = danmakus[i];
        if (i < freeTracks.count) {
            WLDanmakuTrackView *track = freeTracks[i];
            [self showDanmaku:danmaku inTrack:track];
        }else{
            [self.danmakuQueue addObject:danmaku];
        }
    }
}

- (void)showDanmaku:(id<WLDanmakuEntity>)danmaku inTrack:(WLDanmakuTrackView *)track{
    if (danmaku && track.isFree) {
        WLDanmakuViewCell *cell = [self.dataSource danmakuView:self cellForDanmaku:danmaku];
        [track showCell:cell];
    }
}

- (WLDanmakuViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier{
    WLDanmakuViewCell *cell = nil;
    if (self.cellCaches.count) {
        cell = self.cellCaches.firstObject;
        [cell removeFromSuperview];
        [self.cellCaches removeObjectAtIndex:0];
    }
    return cell;
}

#pragma mark - Private
- (void)pause{
    for (WLDanmakuTrackView *track in self.tracks) {
        [track pause];
    }
}
- (void)resume{
    for (WLDanmakuTrackView *track in self.tracks) {
        [track resume];
    }
}
- (void)clear{
    for (WLDanmakuTrackView *track in self.tracks) {
        [track clear];
    }
    [self.danmakuQueue removeAllObjects];
//    [self.cellCaches removeAllObjects];
}


@end
