//
//  WLDanmakuViewCell.h
//  test
//
//  Created by Jason Wang on 2018/12/17.
//  Copyright © 2018 cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WLDanmakuViewCell;

@protocol  WLDanmakuViewCellDelegate <NSObject>

- (void)didEndDisplayDanmakuViewCell:(WLDanmakuViewCell *)cell;

@end

@interface WLDanmakuViewCell : UIView
@property (nonatomic, weak) id<WLDanmakuViewCellDelegate> delegate;

@property (nonatomic, assign) CGFloat cellWidth;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) NSString *reuseIdentifier;

- (void)startAnimationFrom:(CGPoint)from to:(CGPoint)to duration:(NSTimeInterval)duration compeletion:(nullable void(^)(WLDanmakuViewCell *cell))completion;

- (CGRect)currentFrame;

- (void)pauseAnimation;

- (void)resumeAnimation;

- (void)clearAnimation;

@end

NS_ASSUME_NONNULL_END
