//
//  WLBasicMessageCell.h
//  test
//
//  Created by Jason Wang on 2018/11/23.
//  Copyright © 2018 cmcc. All rights reserved.
//

#import "WLMessageCell.h"

NS_ASSUME_NONNULL_BEGIN

/**
 用于显示直播中的基本文本消息，包含发送状态指示
 */
@interface WLBasicMessageCell : WLMessageCell

- (void)setWithMessageText:(NSAttributedString *)text dateString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
