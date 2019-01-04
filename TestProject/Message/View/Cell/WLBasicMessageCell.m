//
//  WLBasicMessageCell.m
//  test
//
//  Created by Jason Wang on 2018/11/23.
//  Copyright © 2018 cmcc. All rights reserved.
//

#import "WLBasicMessageCell.h"
#import "Masonry.h"

@implementation WLBasicMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    [self addTapGesture];
    return self;
}

- (void)addTapGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapCell:)];
    [self.contentView addGestureRecognizer:tap];
}

- (void)didTapCell:(UITapGestureRecognizer *)tap{
    CGPoint point = [tap locationInView:self];
    if (CGRectContainsPoint(self.contentContainer.messageLabel.frame, point)){
        if (self.delegate && [self.delegate respondsToSelector:@selector(messageCellDidTapTextBody:)]) {
            [self.delegate messageCellDidTapTextBody:self];
        }
    }else if (CGRectContainsPoint(self.contentContainer.resendButton.frame, point)){
        if (self.delegate && [self.delegate respondsToSelector:@selector(messageCelldidTapAccessoryButton:)]) {
            [self.delegate messageCelldidTapAccessoryButton:self];
        }
    }
}

- (void)setWithMessageText:(NSAttributedString *)text dateString:(NSString *)string{
    BOOL shouldShowDate = string && string.length > 0;
//    self.contentContainer.showTopLabel = shouldShowDate;
    [self setShowTopLabel:shouldShowDate];
    if (shouldShowDate) {
        self.contentContainer.topLabel.text = string;
    }
    self.contentContainer.messageLabel.attributedText = text;
}

- (void)layoutAndSetupSubviews{
    [super layoutAndSetupSubviews];
    self.midLabel.hidden = YES;
    [self.midLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(0));
    }];
    [self.messageContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentContainer.mas_left);
        make.right.equalTo(self.contentContainer.mas_right).offset(-WLMsgCellMsgContainerRightSpacing);
        make.top.equalTo(self.midLabel.mas_top);
        make.bottom.equalTo(self.contentContainer.mas_bottom);
    }];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.messageContainer).insets(WLBasicMsgCellTextInsets);
    }];
    
    self.topLabel.backgroundColor = [UIColor yellowColor];
}

@end
