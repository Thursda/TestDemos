//
//  WLOutGoingMessageCell.m
//  test
//
//  Created by Jason Wang on 2018/11/23.
//  Copyright © 2018 cmcc. All rights reserved.
//

#import "WLOutGoingMessageCell.h"
#import "Masonry.h"

@implementation WLOutGoingMessageCell

- (void)layoutAndSetupSubviews{
    [super layoutAndSetupSubviews];
    [self.messageContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentContainer.mas_left).offset(WLMsgCellMsgContainerRightSpacing);
        make.right.equalTo(self.contentContainer.mas_right);
        make.top.equalTo(self.contentContainer.midLabel.mas_bottom).offset(WLMsgCellVerticalSpacing2);
        make.bottom.equalTo(self.contentContainer.mas_bottom);
    }];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.messageContainer).insets(WLOutgoingMsgCellTextInsets);
    }];
    //-------------------------------
    [self.accessoryContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.messageContainer.mas_left);
        make.centerY.equalTo(self.messageContainer.mas_centerY).offset(0);
        make.width.equalTo(@(WLMsgCellAccessoryContainerWidth));
        make.height.equalTo(self.accessoryContainer.mas_width);
    }];

    self.midLabel.textAlignment = NSTextAlignmentRight;
    
    self.topLabel.backgroundColor = [UIColor purpleColor];
}

@end
