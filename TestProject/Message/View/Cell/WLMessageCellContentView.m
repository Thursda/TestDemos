//
//  WLMessageCellContentView.m
//  test
//
//  Created by Jason Wang on 2018/11/23.
//  Copyright © 2018 cmcc. All rights reserved.
//

#import "WLMessageCellContentView.h"
#import "Masonry.h"

const CGFloat WLMsgCellTopLabelHeight = 16;
const CGFloat WLMsgCellMidLableHeight = 25;

const CGFloat WLMsgCellMsgLableMinimalHeight = 25;

const CGFloat WLMsgCellMsgContainerRightSpacing = 60;

const CGFloat WLMsgCellVerticalSpacing1 = 5;
const CGFloat WLMsgCellVerticalSpacing2 = 5;

const CGFloat WLMsgCellAccessoryContainerWidth = 36;

@interface WLMessageCellContentView()

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *midLabel;

@property (nonatomic, strong) UIView *messageContainer;
@property (nonatomic, strong) UIImageView *bubbleImageView;
@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) UIView *accessoryContainer;
@property (nonatomic, strong) UIButton *resendButton;
@property (nonatomic, strong) UIActivityIndicatorView *statusIndicator;

@end

@implementation WLMessageCellContentView

- (instancetype)initWithStyle:(WLMessageCellStyle)style
                     aligment:(WLMessageCellAlignment)alignment{
    self = [super init];
    if (self) {
//        _style = style;
//        _showTopLabel = NO;
//        _alignment = alignment;
//        _messageBubbleRightMargin = WLMsgCellMsgContainerRightSpacing;
        [self addAllSubview];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addAllSubview];
    }
    return self;
}

#pragma mark - LayoutSubviews
- (void)addAllSubview{
    _topLabel = [UILabel new];
    _topLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_topLabel];
    
    _midLabel = [UILabel new];
    _midLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_midLabel];

    _messageContainer = [UIView new];
    _bubbleImageView = [UIImageView new];
    _messageLabel = [UILabel new];
    _messageLabel.numberOfLines = 0;
    [self addSubview:_messageContainer];
    [_messageContainer addSubview:_bubbleImageView];
    [_messageContainer addSubview:_messageLabel];

    _accessoryContainer = [UIView new];
    _statusIndicator = [UIActivityIndicatorView new];
    _statusIndicator.hidesWhenStopped = YES;
    _resendButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:_accessoryContainer];
    [_accessoryContainer addSubview:_statusIndicator];
    [_accessoryContainer addSubview:_resendButton];
    
    _messageContainer.backgroundColor = [UIColor brownColor];
    _midLabel.backgroundColor = [UIColor grayColor];
    _accessoryContainer.backgroundColor = [UIColor purpleColor];
}

@end
