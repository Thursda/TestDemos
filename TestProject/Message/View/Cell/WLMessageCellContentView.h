//
//  WLMessageCellContentView.h
//  test
//
//  Created by Jason Wang on 2018/11/23.
//  Copyright © 2018 cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define WLMessageCellInsets UIEdgeInsetsMake(5, 10, 5, 10)

#define WLBasicMsgCellTextInsets UIEdgeInsetsZero
#define WLTipMsgCellTextInsets UIEdgeInsetsZero
#define WLIncomingMsgCellTextInsets UIEdgeInsetsZero
#define WLOutgoingMsgCellTextInsets UIEdgeInsetsZero

extern const CGFloat WLMsgCellTopLabelHeight;
extern const CGFloat WLMsgCellMidLableHeight;
extern const CGFloat WLMsgCellMsgContainerRightSpacing;

extern const CGFloat WLMsgCellVerticalSpacing1;
extern const CGFloat WLMsgCellVerticalSpacing2;

extern const CGFloat WLMsgCellAccessoryContainerWidth;

typedef NS_ENUM(NSUInteger, WLMessageCellStyle) {
    WLMessageCellStyleText,     // 基本样式，显示一行包含用户名的富文本
    WLMessageCellStyleTip,      // 系统消息样式
    WLMessageCellStyleBubble,    // 气泡样式，目前不含用户头像
};

typedef NS_ENUM(NSUInteger, WLMessageCellAlignment) {
    WLMessageCellAlignmentLeft,
    WLMessageCellAlignmentRight,
};

@interface WLMessageCellContentView : UIView

@property (nonatomic, readonly) UILabel *topLabel;
@property (nonatomic, readonly) UILabel *midLabel;

@property (nonatomic, readonly) UIView *messageContainer;
@property (nonatomic, readonly) UIImageView *bubbleImageView;
@property (nonatomic, readonly) UILabel *messageLabel;

@property (nonatomic, readonly) UIView *accessoryContainer;
@property (nonatomic, readonly) UIButton *resendButton;
@property (nonatomic, readonly) UIActivityIndicatorView *statusIndicator;

@end

NS_ASSUME_NONNULL_END
