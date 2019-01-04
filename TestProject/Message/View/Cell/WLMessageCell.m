//
//  WLMessageCell.m
//  WeLearn
//
//  Created by Jason Wang on 2018/11/12.
//  Copyright © 2018 cmcc. All rights reserved.
//

#import "WLMessageCell.h"
#import "Masonry.h"

const CGFloat kWLMsgCellTopLabelFontSize   = 14; // 发送时间字体大小
const CGFloat kWLMsgCellMidLabelFontSize   = 15; // 气泡样子中用户名字体大小
const CGFloat kWLMsgCellMsgLabelFontSize   = 17; //消息体字体大小
const CGFloat kWLMsgCellMsgLabelLineSpace  = 4; //消息体行间距

@interface WLMessageCell()

@property (nonatomic, assign) UIEdgeInsets cellInsets;

@end

@implementation WLMessageCell

+ (NSString *)cellReuseIdentifier{
    return NSStringFromClass([self class]);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    [self layoutAndSetupSubviews];
    return self;
}

#pragma mark - Interface
- (void)setWithMessage:(id<WLMessageEntity>)message dateString:(NSString *)string{
    //override by subclass
}

- (void)setState:(WLMessageState)state{
    //override by subclass
}

- (void)setWithSenderName:(NSString *)string sendDate:(NSAttributedString *)date content:(NSAttributedString *)content{
    NSAssert(content.length > 0, @"----------");
    BOOL shouldShowDate = date && date.length > 0;
    [self setShowTopLabel:shouldShowDate];
    if (shouldShowDate) {
        _contentContainer.topLabel.attributedText = date;
    }
    
    if (self.contentContainer.midLabel) {
        self.contentContainer.midLabel.text = string;
    }
    
    _contentContainer.messageLabel.attributedText = content;
}

- (void)prepareForReuse{
    [super prepareForReuse];
//    _contentContainer.showTopLabel = NO;
//    _contentContainer.midLabel.text = @"";
//    _contentContainer.messageLabel.attributedText = [[NSAttributedString alloc] initWithString:@""];
}

#pragma mark - Layout
- (void)layoutAndSetupSubviews{
    self.contentContainer = [WLMessageCellContentView new];
    [self.contentView addSubview:self.contentContainer];
    [self.contentContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(WLMessageCellInsets);
    }];
    
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.equalTo(self.contentContainer).insets(UIEdgeInsetsZero);
        make.height.equalTo(@(WLMsgCellTopLabelHeight));
    }];
    
    [self.midLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentContainer);
        make.height.equalTo(@(WLMsgCellMidLableHeight));
        make.top.equalTo(self.topLabel.mas_top).offset(WLMsgCellTopLabelHeight + WLMsgCellVerticalSpacing1);
    }];
    
    [self.messageContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentContainer.mas_left);
        make.right.equalTo(self.contentContainer.mas_right).offset(-WLMsgCellMsgContainerRightSpacing);
        make.top.equalTo(self.contentContainer.midLabel.mas_bottom).offset(WLMsgCellVerticalSpacing2);
        make.bottom.equalTo(self.contentContainer.mas_bottom);
    }];
    
    [self.bubbleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.messageContainer).insets(UIEdgeInsetsZero);
    }];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.messageContainer).insets(WLIncomingMsgCellTextInsets);
    }];
    
    //-------------------------------
    [self.accessoryContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.messageContainer.mas_right);
        make.centerY.equalTo(self.messageContainer.mas_centerY).offset(0);
        make.width.equalTo(@(WLMsgCellAccessoryContainerWidth));
        make.height.equalTo(self.accessoryContainer.mas_width);
    }];
    
    [self.statusIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.accessoryContainer).insets(UIEdgeInsetsZero);
    }];
    [self.resendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.accessoryContainer).insets(UIEdgeInsetsZero);
    }];
}

- (void)setShowTopLabel:(BOOL)showTopLabel{
    self.topLabel.hidden = !showTopLabel;
    CGFloat topOffset = showTopLabel ? (WLMsgCellTopLabelHeight + WLMsgCellVerticalSpacing1) : 0;
    [self.midLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topLabel.mas_top).offset(topOffset);
    }];
}


#pragma mark - Getter
- (UILabel *)topLabel{
    return _contentContainer.topLabel;
}

- (UILabel *)midLabel{
    return _contentContainer.midLabel;
}

- (UIView *)messageContainer{
    return _contentContainer.messageContainer;
}

- (UIImageView *)bubbleImageView{
    return _contentContainer.bubbleImageView;
}

- (UILabel *)messageLabel{
    return _contentContainer.messageLabel;
}

- (UIView *)accessoryContainer{
    return _contentContainer.statusIndicator;
}

- (UIActivityIndicatorView *)statusIndicator{
    return _contentContainer.statusIndicator;
}

- (UIButton *)resendButton{
    return _contentContainer.resendButton;
}
@end
