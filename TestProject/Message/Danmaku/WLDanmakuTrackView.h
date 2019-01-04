//
//  WLDanmakuTrackView.h
//  test
//
//  Created by Jason Wang on 2018/12/17.
//  Copyright © 2018 cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLDanmakuViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WLDanmakuViewState) {
    WLDanmakuViewStatePlaying,
    WLDanmakuViewStatePause,
    WLDanmakuViewStateStop,
};

@class WLDanmakuTrackView;

@protocol WLDanmakuTrackViewDelegate <NSObject>

- (void)danmakuTrackDidBecommeFree:(WLDanmakuTrackView *)track;

- (void)danmakuTrack:(WLDanmakuTrackView *)track cellDidDisappear:(WLDanmakuViewCell *)cell;

@end

@interface WLDanmakuTrackView : UIView

@property (nonatomic, strong) NSMutableArray<WLDanmakuViewCell *> *visibleCells;
@property (nonatomic, strong) WLDanmakuViewCell *_Nullable lastCell;

@property (nonatomic, weak) id<WLDanmakuTrackViewDelegate> delegate;

@property (nonatomic, assign, getter=isFree) BOOL free;
@property (nonatomic, readonly) WLDanmakuViewState state;

- (void)showCell:(WLDanmakuViewCell *)cell;

- (void)pause;
- (void)resume;
- (void)clear;

@end

NS_ASSUME_NONNULL_END
