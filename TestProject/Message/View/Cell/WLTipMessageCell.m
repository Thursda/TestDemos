//
//  WLTipMessageCell.m
//  test
//
//  Created by Jason Wang on 2018/11/23.
//  Copyright © 2018 cmcc. All rights reserved.
//

#import "WLTipMessageCell.h"
#import "Masonry.h"

@implementation WLTipMessageCell

- (void)layoutAndSetupSubviews{
    [super layoutAndSetupSubviews];
    
    self.midLabel.hidden = YES;
    [self.midLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(0));
    }];
    [self.messageContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentContainer.mas_left);
        make.right.equalTo(self.contentContainer.mas_right);
        make.top.equalTo(self.midLabel.mas_top);
        make.bottom.equalTo(self.contentContainer.mas_bottom);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.messageContainer).insets(WLTipMsgCellTextInsets);
    }];
    
    self.topLabel.backgroundColor = [UIColor orangeColor];

}

@end
