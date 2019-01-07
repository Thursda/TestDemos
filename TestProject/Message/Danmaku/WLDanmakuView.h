//
//  WLDanmakuView.h
//  test
//
//  Created by Jason Wang on 2018/12/17.
//  Copyright © 2018 cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLDanmakuViewCell.h"

/**
 * 弹幕运动模式：
 * 1.等速：所有弹幕从“开始出现”到“开始隐藏”时间相同，
 * 2.等时：所有弹幕从“开始出现”到“完全隐藏”的时间相同，较长的弹幕运动速度较快
 */

NS_ASSUME_NONNULL_BEGIN
@interface WLDanmakuViewConfigure : NSObject

@property (nonatomic, assign) NSUInteger numberOfRows;
@property (nonatomic, assign) CGFloat rowHeght;

// 弹幕从"开始出现"到"完全消失"的动画持续时间
@property (nonatomic, assign) NSTimeInterval animationDuration;

@end

@class WLDanmakuView;

@protocol WLDanmakuEntity <NSObject>

- (NSString *)cellIdentifier;

@end

@protocol WLDanmakuViewDataSource <NSObject>

- (WLDanmakuViewCell *)danmakuView:(WLDanmakuView *)danmakuView cellForDanmaku:(id<WLDanmakuEntity>)danmaku;

@end

@interface WLDanmakuView : UIView

@property (nonatomic, strong) id<WLDanmakuViewDataSource> dataSource;

@property (nonatomic, assign) NSUInteger numberOfRows;
@property (nonatomic, assign) CGFloat rowHeght;
@property (nonatomic, assign) CGFloat margin;

// 弹幕从"开始出现"到"完全消失"的动画持续时间
@property (nonatomic, assign) NSTimeInterval animationDuration;

- (instancetype)initWithRowNumber:(NSUInteger)rows rowheight:(CGFloat)rowHeight margin:(CGFloat)margin;

- (WLDanmakuViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

- (void)showDanmakus:(NSArray<id<WLDanmakuEntity>> *)danmakus;

//未完成，仅仅clear可用
- (void)pause;
- (void)resume;
- (void)clear;

@end

NS_ASSUME_NONNULL_END
