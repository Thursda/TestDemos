//
//  WLMessageViewController.m
//  test
//
//  Created by Jason Wang on 2018/11/12.
//  Copyright © 2018 cmcc. All rights reserved.
//

#import "WLMessageViewController.h"
#import "Masonry.h"
#import "WLMessage.h"
#import "YYFPSLabel.h"
#import "WLMessageTableView.h"

@interface WLMessageViewController ()<WLMessageTableViewDataSource, WLMessageTableViewDelegate>
@property (nonatomic, strong) YYFPSLabel *fpsLabel;

@property (nonatomic, strong)  WLMessageTableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *heightCache;
@end

@implementation WLMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView = [[WLMessageTableView alloc] initWithFrame:self.view.frame style:(UITableViewStylePlain)];
    
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _heightCache = [NSMutableDictionary new];
    
    _fpsLabel = [YYFPSLabel new];
    _fpsLabel.frame = CGRectMake(10, 80, 50, 20);
    [self.view addSubview:_fpsLabel];
}


#pragma mark - DataSource

- (id<WLMessageEntity>)tableView:(WLMessageTableView *)tableView messageEntityAtIndexPath:(NSIndexPath *)indexPath{
    WLMessage *message = [_messages objectAtIndex:indexPath.row];
    return message;
}

- (NSAttributedString *)tableView:(WLMessageTableView *)tableView messageSendDateForIndexPath:(NSIndexPath *)indexPath{
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:@"2018年11月22日 星期四"];
    if (indexPath.row % 4) {
        return nil;
    }
    return string;
}
- (NSAttributedString *)tableView:(WLMessageTableView *)tableView messageContentForIndexPath:(NSIndexPath *)indexPath{
//    id<WLMessageEntity> message = [self tableView:tableView messageEntityAtIndexPath:indexPath];
//    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:message.text];
//    [content insertAttributedString:[self getAttachment] atIndex:0];

    WLMessage *message =  [self tableView:(WLMessageTableView *)tableView messageEntityAtIndexPath:indexPath];
//    if (!message.displayContent) {
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:message.text
                                                                                    attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17],
                                                                                                 NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                                                 }];
        [content insertAttributedString:[self getAttachment] atIndex:0];
    return content;
//        message.displayContent = content;
//    }
    return message.displayContent;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id<WLMessageEntity> message = [self tableView:(WLMessageTableView *)tableView messageEntityAtIndexPath:indexPath];
    WLMessageCell *cell = [self.tableView cellForMessage:message indexPath:indexPath];
    return cell;
}

#pragma mark - Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WLMessage *message = [_messages objectAtIndex:indexPath.row];
    NSNumber *number = (NSNumber *)[_heightCache objectForKey:message.messageId];
    if (number) {
        return number.floatValue;
    }
    CGFloat height = [self heightForRowAtIndexPath:indexPath];
    [_heightCache setObject:@(height) forKey:message.messageId];
    return height;
}

- (CGFloat )heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id<WLMessageEntity>message = [self tableView:_tableView messageEntityAtIndexPath:indexPath];
    CGFloat height = WLMessageCellInsets.top + WLMessageCellInsets.bottom;
    
    //------------Send Date-----------
    BOOL showSendDate = ([self tableView:self.tableView messageSendDateForIndexPath:indexPath].length > 0);
    if (showSendDate) {
        height += WLMsgCellTopLabelHeight + WLMsgCellVerticalSpacing1;
    }

    //------------SenderName-----------
    if (message.type == WLMessageTypePrivate) {
        height += WLMsgCellMidLableHeight + WLMsgCellVerticalSpacing2;
    }
    
    //------------MessageBody-----------
    NSAttributedString *content = [self tableView:self.tableView messageContentForIndexPath:indexPath];
    UIEdgeInsets textInsets;
    CGFloat labelWidth = CGRectGetWidth(self.tableView.frame) - WLMessageCellInsets.left - WLMessageCellInsets.right;
    if (message.type == WLMessageTypePublic) {
        textInsets = WLBasicMsgCellTextInsets;
        labelWidth -= (textInsets.left + textInsets.right + WLMsgCellMsgContainerRightSpacing);
    }else if (message.type == WLMessageTypeSystem){
        textInsets = WLTipMsgCellTextInsets;
        labelWidth -= (textInsets.left + textInsets.right);
    }else{
        textInsets = WLIncomingMsgCellTextInsets;
        labelWidth -= (textInsets.left + textInsets.right + WLMsgCellMsgContainerRightSpacing);
    }
    CGRect textRect = [content boundingRectWithSize:CGSizeMake(labelWidth, HUGE) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil];
    height += textInsets.top + textInsets.bottom + ceil(CGRectGetHeight(textRect)) + 1;
    //---------------------------------

    return height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    id<WLMessageEntity> message = [self tableView:(WLMessageTableView *)tableView messageEntityAtIndexPath:indexPath];
    WLMessage *message =  [self tableView:(WLMessageTableView *)tableView messageEntityAtIndexPath:indexPath];
    
    NSAttributedString *sendDateString = [self tableView:(WLMessageTableView *)tableView messageSendDateForIndexPath:indexPath];
    NSString *sendName = message.senderDisplayName;
    NSAttributedString *content = [self tableView:(WLMessageTableView *)tableView messageContentForIndexPath:indexPath];
    [(WLMessageCell *)cell setWithSenderName:sendName sendDate:sendDateString content:content];
}

- (NSAttributedString *)getAttachment{
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:@"userAvatarImage"];
    textAttachment.bounds = CGRectMake(0, 0, 17, 17);
    
    NSMutableAttributedString *string = [[NSAttributedString attributedStringWithAttachment:textAttachment] mutableCopy];
    
    
    NSAttributedString *name = [[NSAttributedString alloc] initWithString:@"老师:"
                                                               attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:18],
                                                                             NSLinkAttributeName:@"www.baidu.com",
                                                                             NSForegroundColorAttributeName: [UIColor redColor]}];
    [string appendAttributedString:name];
    return string;
}

@end
