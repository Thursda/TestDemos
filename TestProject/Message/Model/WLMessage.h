//
//  WLMessage.h
//  test
//
//  Created by Jason Wang on 2018/11/12.
//  Copyright © 2018 cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLMessageEntity.h"
NS_ASSUME_NONNULL_BEGIN

@interface WLMessage : NSObject <WLMessageEntity>

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSAttributedString *displayContent;

@property (nonatomic, strong) NSString *senderDisplayName;
@property (nonatomic, strong) NSString *receiverDisplayName;

@property (nonatomic, strong) NSString *receiverId;
@property (nonatomic, strong) NSString *messageId;

@property (nonatomic, assign) BOOL isSendBySelf;
@property (nonatomic, assign) WLMessageState status;
@property (nonatomic, assign) WLMessageType type;

@end

NS_ASSUME_NONNULL_END
