//
//  WLMessageTableView.m
//  WeLearn
//
//  Created by Jason on 2018/3/6.
//  Copyright © 2018年 cmcc. All rights reserved.
//

#import "WLMessageTableView.h"

@interface WLMessageTableView()

@end

@implementation WLMessageTableView
@dynamic dataSource;
@dynamic delegate;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
}

- (void)setup{
    self.backgroundColor = [UIColor whiteColor];
    self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;//UIScrollViewKeyboardDismissModeInteractive;
    self.alwaysBounceVertical = YES;
    self.bounces = YES;
    
    self.basicCellIndentifier = [WLBasicMessageCell cellReuseIdentifier];
    self.tipCellIndentifier = [WLTipMessageCell cellReuseIdentifier];
    self.incomingCellIndentifier = [WLIncomingMessageCell cellReuseIdentifier];
    self.outgoingCellIndentifier = [WLOutGoingMessageCell cellReuseIdentifier];
    
    [self registerClass:[WLBasicMessageCell class] forCellReuseIdentifier:self.basicCellIndentifier];
    [self registerClass:[WLTipMessageCell class] forCellReuseIdentifier:self.tipCellIndentifier];
    [self registerClass:[WLIncomingMessageCell class] forCellReuseIdentifier:self.incomingCellIndentifier];
    [self registerClass:[WLOutGoingMessageCell class] forCellReuseIdentifier:self.outgoingCellIndentifier];
}

#pragma mark Interface
- (WLMessageCell *)cellForMessage:(id<WLMessageEntity>)message indexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier = [self reuseIdentifierOfMessage:message];
    WLMessageCell *cell = [self dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    return cell ;
}

- (NSString *)reuseIdentifierOfMessage:(id<WLMessageEntity>)message{
    NSString *reuseIdentifier;
    WLMessageType type = [message type];
    switch (type) {
        case WLMessageTypePublic:
            reuseIdentifier = self.basicCellIndentifier;
            break;
        case WLMessageTypePrivate:
            reuseIdentifier = [message isSendBySelf] ? self.incomingCellIndentifier : self.outgoingCellIndentifier;
            break;
        case WLMessageTypeSystem:
            reuseIdentifier = self.tipCellIndentifier;
            break;
    }
    return reuseIdentifier;
}


#pragma mark - Cell delegate
- (void)messageCellDidTapSenderText:(WLMessageCell *)cell{
    NSIndexPath *indexPath = [self indexPathForCell:cell];
    if (indexPath == nil) {
        return;
    }
    [self.delegate tableView:self didTapSenderNameAtIndexPath:indexPath];
}

- (void)messageCelldidTapAccessoryButton:(WLMessageCell *)cell{
    NSIndexPath *indexPath = [self indexPathForCell:cell];
    if (indexPath == nil) {
        return;
    }
    [self.delegate tableView:self didTapAccessoryButtonAtIndex:indexPath];
}
- (void)messageCellDidTapTextBody:(WLMessageCell *)cell{
    NSIndexPath *indexPath = [self indexPathForCell:cell];
    if (indexPath == nil) {
        return;
    }
    [self.delegate tableView:self didTapTextBodyAtIndex:indexPath];
}

@end
