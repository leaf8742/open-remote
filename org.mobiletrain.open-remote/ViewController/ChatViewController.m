//
//  ChatViewController.m
//  org.mobiletrain.open-remote
//
//  Created by qianfeng on 15/10/14.
//
//

#import "ChatViewController.h"
#import "MessageListStore.h"
#import "Model.h"
#import "SendMessageStore.h"
#import "EMMessage.h"
#import "EMChatText.h"
#import "EMTextMessageBody.h"
#import "EaseMob.h"
#import "NSDate+Category.h"
#import "SRRefreshView.h"
#import "EMChatViewCell.h"
#import "MessageModelManager.h"

#define KPageCount 20

@interface ChatViewController ()<UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate>
{
    UIMenuController *_menuController;
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    NSIndexPath *_longPressIndexPath;
    
    NSInteger _recordingCount;
    
    dispatch_queue_t _messageQueue;
    
//    NSMutableArray *_messages;
    BOOL _isScrollToBottom;
}

@property (strong, nonatomic) SRRefreshView *slimeView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) EMConversation *conversation;//会话管理者

@property (strong, nonatomic) NSMutableArray *messages;

@property (strong, nonatomic) NSDate *chatTagDate;

@end

@implementation ChatViewController

- (void)registerBecomeActive{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)didBecomeActive{
//    [self reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerBecomeActive];

    _messages = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllMessages:) name:@"RemoveAllMessages" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitGroup) name:@"ExitGroup" object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:@"applicationDidEnterBackground" object:nil];
    
    _messageQueue = dispatch_queue_create("easemob.com", NULL);
    _isScrollToBottom = YES;
    
    
    
    [self setupBarButtonItem];

    [self.view addSubview:self.tableView];
    [self.view addSubview:self.textField];
    [self.tableView addSubview:self.slimeView];
    
    

    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden)];
    [self.view addGestureRecognizer:tap];
    
    _conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:_groupId conversationType:eConversationTypeGroupChat];
    [_conversation markAllMessagesAsRead:YES];
    
    //通过会话管理者获取已收发消息
    long long timestamp = [[NSDate date] timeIntervalSince1970] * 1000 + 1;
    [self loadMoreMessagesFrom:timestamp count:KPageCount append:NO];
//    [self loadMessages];
    
//    GroupModel *group = [GroupListModel groupWithIdentity:_groupId];
    
//    _dataSource = group.messages;
    
//    [_dataSource addObserver:self forKeyPath:@"messageData" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)loadMessages
{
    MessageListStore *mlStore = [[MessageListStore alloc] init];
    mlStore.groupId = _groupId;
    mlStore.page = [[NSNumber alloc] initWithInt:KPageCount];
    
    [mlStore requestWithSuccess:^{
        NSLog(@"message list store success");
    } failure:^(NSError *error) {
        NSLog(@"message list store fail");
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self.tableView reloadData];
}

- (void)loadMoreMessagesFrom:(long long)timestamp count:(NSInteger)count append:(BOOL)append
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(_messageQueue, ^{
        NSArray *messages = [weakSelf.conversation loadNumbersOfMessages:count before:timestamp];
        if ([messages count] > 0) {
            NSInteger currentCount = 0;
            if (append)
            {
                [weakSelf.messages insertObjects:messages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [messages count])]];
                NSArray *formated = [weakSelf formatMessages:messages];
                id model = [weakSelf.dataSource firstObject];
                if ([model isKindOfClass:[NSString class]])
                {
                    NSString *timestamp = model;
                    [formated enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id model, NSUInteger idx, BOOL *stop) {
                        if ([model isKindOfClass:[NSString class]] && [timestamp isEqualToString:model])
                        {
                            [weakSelf.dataSource removeObjectAtIndex:0];
                            *stop = YES;
                        }
                    }];
                }
                currentCount = [weakSelf.dataSource count];
                [weakSelf.dataSource insertObjects:formated atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [formated count])]];
                
                EMMessage *latest = [weakSelf.messages lastObject];
                weakSelf.chatTagDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)latest.timestamp];
            }
            else
            {
                weakSelf.messages = [messages mutableCopy];
                weakSelf.dataSource = [[weakSelf formatMessages:messages] mutableCopy];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                
                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[weakSelf.dataSource count] - currentCount - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            });
        }
    });
}

- (NSArray *)formatMessages:(NSArray *)messagesArray
{
    NSMutableArray *formatArray = [[NSMutableArray alloc] init];
    if ([messagesArray count] > 0) {
        for (EMMessage *message in messagesArray) {
            NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp];
            NSTimeInterval tempDate = [createDate timeIntervalSinceDate:self.chatTagDate];
            if (tempDate > 60 || tempDate < -60 || (self.chatTagDate == nil)) {
//                [formatArray addObject:[createDate formattedTime]];
                self.chatTagDate = createDate;
            }
            
            MessageModel *model = [MessageModelManager modelWithMessage:message];
            
            if (model) {
                [formatArray addObject:model];
            }
        }
    }
    
    return formatArray;
}

// 点击背景隐藏
-(void)keyBoardHidden
{
    [self.textField endEditing:YES];
}

- (void)removeAllMessages:(id)sender
{}

#pragma mark - getter
- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (SRRefreshView *)slimeView
{
    if (_slimeView == nil) {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
    }
    
    return _slimeView;
}

- (UITextField *)textField
{
    if (_textField == nil) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-40, self.view.frame.size.width, 40)];
        _textField.placeholder = @"发送群聊信息";
        _textField.backgroundColor = [UIColor lightGrayColor];
        _textField.borderStyle = UITextBorderStyleLine;
        _textField.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        
        _textField.delegate = self;
    }
    
    return _textField;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.textField.frame.size.height) style:UITableViewStylePlain];
        // - self.textField.frame.size.height
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.delegate = self;
        _tableView.dataSource = self;

        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        lpgr.minimumPressDuration = .5;
        [_tableView addGestureRecognizer:lpgr];
    }
    
    return _tableView;
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
}

#pragma mark - slimeRefresh delegate
//加载更多
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    _chatTagDate = nil;
    EMMessage *firstMessage = [self.messages firstObject];
    if (firstMessage)
    {
        [self loadMoreMessagesFrom:firstMessage.timestamp count:KPageCount append:YES];
    }
    [_slimeView endRefresh];
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    //发送信息
    if (![textField.text isEqualToString:@""]) {
        
        [self sendTextMessage:textField.text];
    }
    textField.text = @"";
    return YES;
}

-(void)sendTextMessage:(NSString *)textMessage
{
//    MessageModel *tempMessage = [[MessageModel alloc] init];
    NSDictionary *ext = nil;
    EMMessage *tempMessage = [self sendTextMessageWithString:textMessage
                                                            toUsername:_groupId
                                                           messageType:eMessageTypeGroupChat
                                                     requireEncryption:NO
                                                                   ext:ext];
    
    
    [self addMessage:tempMessage];
}

-(EMMessage *)sendTextMessageWithString:(NSString *)str
                             toUsername:(NSString *)username
                            messageType:(EMMessageType)type
                      requireEncryption:(BOOL)requireEncryption
                                    ext:(NSDictionary *)ext
{
    EMChatText *text = [[EMChatText alloc] initWithText:str];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:text];
    return [self sendMessage:username
                 messageBody:body
                 messageType:type
           requireEncryption:requireEncryption
                         ext:ext];
}

-(EMMessage *)sendMessage:(NSString *)username
              messageBody:(id<IEMMessageBody>)body
              messageType:(EMMessageType)type
        requireEncryption:(BOOL)requireEncryption
                      ext:(NSDictionary *)ext
{
    EMMessage *retureMsg = [[EMMessage alloc] initWithReceiver:username
                                                        bodies:@[body]];
    retureMsg.requireEncryption = requireEncryption;
    retureMsg.messageType = type;
    retureMsg.ext = ext;
    
    EMMessage *message = [[EaseMob sharedInstance].chatManager
                          asyncSendMessage:retureMsg
                          progress:nil];
    
    return message;
}

-(void)addMessage:(EMMessage *)message
{
    [_messages addObject:message];
    __weak ChatViewController *weakSelf = self;
    dispatch_async(_messageQueue, ^{
        
        NSArray *messages = [weakSelf formatMessage:message];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.dataSource addObjectsFromArray:messages];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[weakSelf.dataSource count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        });
    });
}

-(NSMutableArray *)formatMessage:(EMMessage *)message
{
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp];
    NSTimeInterval tempDate = [createDate timeIntervalSinceDate:self.chatTagDate];
    if (tempDate > 60 || tempDate < -60 || (self.chatTagDate == nil)) {
//        [ret addObject:[createDate formattedTime]];
        self.chatTagDate = createDate;
    }
    

    MessageModel *model = [MessageModelManager modelWithMessage:message];
    
    if (model) {
        [ret addObject:model];
    }
    
    return ret;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.dataSource count]) {
        id obj = [self.dataSource objectAtIndex:indexPath.row];
        MessageModel *model = (MessageModel *)obj;
        NSString *cellIdentifier = [EMChatViewCell cellIdentifierForMessageModel:model];
        EMChatViewCell *cell = (EMChatViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[EMChatViewCell alloc] initWithMessageModel:model reuseIdentifier:cellIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.messageModel = model;
        
        return cell;
   
    }
    
    return nil;
}

#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;

}



#pragma mark- 导航Item
- (void)setupBarButtonItem
{

    //用户列表
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"用户列表" style:UIBarButtonItemStylePlain target:self action:@selector(onUserList:)];
    //设备列表
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"设备列表" style:UIBarButtonItemStylePlain target:self action:@selector(onDeviceList:)];
    
    self.navigationItem.rightBarButtonItems = @[item1,item2];
}

- (void)onUserList:(id)sender
{}

- (void)onDeviceList:(id)sender
{}

//- (void)reloadData{
//    _chatTagDate = nil;
//    self.dataSource = [[self formatMessages:self.messages] mutableCopy];
//    [self.tableView reloadData];
//    
//    //回到前台时
//    if (!self.isInvisible)
//    {
//        NSMutableArray *unreadMessages = [NSMutableArray array];
//        for (EMMessage *message in self.messages)
//        {
//            if ([self shouldAckMessage:message read:NO])
//            {
//                [unreadMessages addObject:message];
//            }
//        }
//        if ([unreadMessages count])
//        {
//            [self sendHasReadResponseForMessages:unreadMessages];
//        }
//        
//        [_conversation markAllMessagesAsRead:YES];
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
