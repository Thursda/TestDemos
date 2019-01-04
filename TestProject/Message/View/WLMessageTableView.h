//
//  WLMessageTableView.h
//  WeLearn
//
//  Created by Jason on 2018/3/6.
//  Copyright © 2018年 cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLMessageEntity.h"
#import "WLBasicMessageCell.h"
#import "WLTipMessageCell.h"
#import "WLIncomingMessageCell.h"
#import "WLOutGoingMessageCell.h"

NS_ASSUME_NONNULL_BEGIN
@class WLMessageTableView;

@protocol WLMessageTableViewDataSource <UITableViewDataSource>

@optional

- (id<WLMessageEntity>)tableView:(WLMessageTableView *)tableView messageEntityAtIndexPath:(NSIndexPath *)indexPath;

- (NSAttributedString *)tableView:(WLMessageTableView *)tableview attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath;
- (NSAttributedString *)tableView:(WLMessageTableView *)tableview attributedTextForCellMidLabelAtIndexPath:(NSIndexPath *)indexPath;


- (NSInteger)tableView:(WLMessageTableView *)tableView numberOfMessagesInSection:(NSInteger)section;

- (NSString *)senderId;
- (NSString *)senderDisplayName;
- (void)tableView:(WLMessageTableView *)tableView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol WLMessageTableViewDelegate <UITableViewDelegate>

@optional
- (void)tableView:(WLMessageTableView *)tableView didTapSenderNameAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(WLMessageTableView *)tableView didTapTextBodyAtIndex:(NSIndexPath *)indexPath;
- (void)tableView:(WLMessageTableView *)tableView didTapAccessoryButtonAtIndex:(NSIndexPath *)indexPath;

@end

@interface WLMessageTableView : UITableView <WLMessageCellDelegate>

@property (weak, nonatomic, nullable) id<WLMessageTableViewDataSource> dataSource;
@property (weak, nonatomic, nullable) id<WLMessageTableViewDelegate> delegate;

@property (nonatomic, copy) NSString *basicCellIndentifier;
@property (nonatomic, copy) NSString *tipCellIndentifier;
@property (nonatomic, copy) NSString *incomingCellIndentifier;
@property (nonatomic, copy) NSString *outgoingCellIndentifier;


- (void)setMessage:(id<WLMessageEntity>)message cell:(WLMessageCell *)cell;

- (WLMessageCell *)cellForMessage:(id<WLMessageEntity>)message indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
