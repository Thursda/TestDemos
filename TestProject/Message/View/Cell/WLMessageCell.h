//
//  WLMessageCell.h
//  WeLearn
//
//  Created by Jason Wang on 2018/11/12.
//  Copyright © 2018 cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLMessageEntity.h"
#import "WLMessageCellContentView.h"

//-------------字体大小-----------------
extern const CGFloat kWLMsgCellTopLabelFontSize; // 发送时间字体大小
extern const CGFloat kWLMsgCellMidLabelFontSize; // 气泡样子中用户名字体大小
extern const CGFloat kWLMsgCellMsgLabelFontSize; //消息体字体大小
extern const CGFloat kWLMsgCellMsgLabelLineSpace; //消息体行间距

NS_ASSUME_NONNULL_BEGIN

@class WLMessageCell;
@protocol WLMessageCellDelegate <NSObject>
- (void)messageCellDidTapSenderText:(WLMessageCell *)cell;
- (void)messageCellDidTapTextBody:(WLMessageCell *)cell;
- (void)messageCelldidTapAccessoryButton:(WLMessageCell *)cell;

@end

@interface WLMessageCell : UITableViewCell

@property (nonatomic, readonly) UILabel *topLabel;
@property (nonatomic, readonly) UILabel *midLabel;

@property (nonatomic, readonly) UIView *messageContainer;
@property (nonatomic, readonly) UIImageView *bubbleImageView;
@property (nonatomic, readonly) UILabel *messageLabel;

@property (nonatomic, readonly) UIView *accessoryContainer;
@property (nonatomic, readonly) UIButton *resendButton;
@property (nonatomic, readonly) UIActivityIndicatorView *statusIndicator;

@property (nonatomic, strong) WLMessageCellContentView *contentContainer;

@property (nonatomic, strong)id<WLMessageCellDelegate> delegate;

+ (NSString *)cellReuseIdentifier;

- (void)layoutAndSetupSubviews;

- (void)setWithMessage:(id<WLMessageEntity>)message dateString:(NSString *)string;
- (void)setState:(WLMessageState)state;

- (void)setWithSenderName:(NSString *)string sendDate:(NSAttributedString *)date content:(NSAttributedString *)content;

- (void)setShowTopLabel:(BOOL)showTopLabel;

@end

NS_ASSUME_NONNULL_END
