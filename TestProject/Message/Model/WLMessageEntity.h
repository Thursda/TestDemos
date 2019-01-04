//
//  WLMessageEntity.h
//  WeLearn
//
//  Created by Jason Wang on 2018/11/12.
//  Copyright © 2018 cmcc. All rights reserved.
//

#ifndef WLMessageEntity_h
#define WLMessageEntity_h

typedef NS_ENUM(NSUInteger, WLMessageState) {
    WLMessageStateSending,
    WLMessageStateFailed,
    WLMessageStateSuccess,
};

typedef NS_ENUM(NSUInteger, WLMessageType) {
    WLMessageTypePublic,
    WLMessageTypePrivate,
    WLMessageTypeSystem,
};

@protocol WLMessageEntity<NSObject>

@optional
- (NSString *)text;

@required
- (NSString *)senderDisplayName;
- (NSString *)receiverDisplayName;

- (NSDate *)sendDate;

- (NSString *)receiverId;
- (NSString *)messageId;

- (BOOL)isSendBySelf;

- (WLMessageState )status;

- (WLMessageType)type;



@end

#endif /* WLMessageEntity_h */
