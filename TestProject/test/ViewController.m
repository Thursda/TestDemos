//
//  ViewController.m
//  test
//
//  Created by Jason Wang on 2018/10/31.
//  Copyright © 2018 cmcc. All rights reserved.
//

#import "ViewController.h"
#import "WLMessage.h"
#import "WLMessageViewController.h"
#import "LiveClassViewController.h"
#import "WLInviteAlterView.h"
#import "WLCanvasView.h"
#import "WLDanmakuViewController.h"

@interface ViewController (){
    NSMutableArray *array;
    NSMutableArray *attributeStringArray;
}
@property (nonatomic, strong) UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    UILabel *label = [UILabel new];
    //    label.frame = self.view.frame;
    //    label.numberOfLines = 0;
    //    [self.view addSubview:label];
    //    _label = label;
    WLCanvasView *canvas = [[WLCanvasView alloc] initWithFrame:self.view.bounds];
    canvas.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:canvas];
    
    array = [NSMutableArray new];
    attributeStringArray = [NSMutableArray new];
    NSLog(@"-----------1:%@", [NSDate date]);
    UIColor *foregroundColor = [UIColor whiteColor];
    UIColor *backgroudColor = [UIColor darkGrayColor];
    UIFont *font = [UIFont systemFontOfSize:15];
    NSDictionary *attributes = @{NSFontAttributeName:font,
                                 NSForegroundColorAttributeName: foregroundColor,
                                 NSBackgroundColorAttributeName: backgroudColor,
                                 };
    
    for (int i = 0; i < 2000; i ++) {
        WLMessage *message = [self randomMessage];
        message.messageId = [NSString stringWithFormat:@"%d", i];
        message.isSendBySelf = i % 5;
        message.type = arc4random() % (WLMessageTypeSystem + 1);
        message.status = arc4random() % (WLMessageStateSuccess + 1);
        [array addObject:message];
        //        [attributeStringArray addObject:as];
    }
    NSLog(@"-----------2:%@", [NSDate date]);
    
    //    [self showStrings];
    
    [self addDebugButton];
    
    if (@available(iOS 11.0, *)) {
        NSLog(@"1-------view insets:%f, %f, %f", self.view.safeAreaInsets.bottom, self.view.window.safeAreaInsets.bottom,self.navigationController.view.safeAreaInsets.bottom);
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (@available(iOS 11.0, *)) {
        NSLog(@"2-------view insets:%f, %f, %f", self.view.safeAreaInsets.bottom, self.view.window.safeAreaInsets.bottom,self.navigationController.view.safeAreaInsets.bottom);
    }
}

- (void)viewDidAppear:(BOOL)animated{
    if (@available(iOS 11.0, *)) {
        NSLog(@"-------view insets:%f, %f, %f", self.view.safeAreaInsets.bottom, self.view.window.safeAreaInsets.bottom,self.navigationController.view.safeAreaInsets.bottom);
    }
}


- (WLMessage *)randomMessage{
    NSString *sendName = [self creatStringOfWordsCount:1];
    NSUInteger contentWordCount = arc4random() % 100;
    NSString *content = [self creatStringOfWordsCount:contentWordCount];
    
    WLMessage *message = [WLMessage new];
    message.text = content;
    message.senderDisplayName = sendName;
    
    return message;
}

- (void)addDebugButton{
    [self addButtonWithTitle:@"聊天" clickAction:@selector(showMesssageController) frame:CGRectMake(10, 40, 140, 40)];
    [self addButtonWithTitle:@"横屏" clickAction:@selector(showFullScreen) frame:CGRectMake(10, 100, 140, 40)];
    
    [self addButtonWithTitle:@"Alert" clickAction:@selector(showAlert) frame:CGRectMake(10, 160, 140, 40)];
    
    [self addButtonWithTitle:@"Danmaku" clickAction:@selector(showDanmaku) frame:CGRectMake(10, 220, 140, 40)];
}

- (UIButton *)addButtonWithTitle:(NSString *)title clickAction:(SEL)action frame:(CGRect)frame{
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = frame;
    button.backgroundColor = [UIColor grayColor];
    [button addTarget:self action:action forControlEvents:(UIControlEventTouchUpInside)];
    [button setTitle:title forState:(UIControlStateNormal)];
    [self.view addSubview:button];
    return button;
}

- (void)showMesssageController{
    WLMessageViewController *vc = [WLMessageViewController new];
    vc.messages = [array copy];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showFullScreen{
    LiveClassViewController *vc = [LiveClassViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showAlert{
    [WLInviteAlterView showAlterAddedTo:self.view.window cancelBlock:^{
        NSLog(@"------calcel");
    } confirmBlock:^{
        NSLog(@"--------confirm");
    }];
}

- (void)showDanmaku{
    WLDanmakuViewController *vc = [WLDanmakuViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showStrings{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:.3 repeats:NO block:^(NSTimer * _Nonnull timer) {
        NSUInteger index = arc4random() % self->attributeStringArray.count;
        NSMutableAttributedString *string = [[self->attributeStringArray objectAtIndex:index] mutableCopy];
        [string insertAttributedString:[self getAttachment] atIndex:0];
        self.label.attributedText = string;
    }];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:(NSRunLoopCommonModes)];
}

- (NSString *)creatStringOfWordsCount:(NSUInteger)count{
    NSMutableArray<NSString *> *words = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count ; i++) {
        [words addObject:[[self class] getRandomWord]];
    }
    NSString *str = [words componentsJoinedByString:@" "];
    return str;
}

// ---------------------------------------------------------------
+ (NSString *)getRandomWord{
    NSArray *words = [self stringArray];
    NSUInteger index = arc4random() % words.count;
    return [words objectAtIndex:index];
}

+ (NSArray *)stringArray{
    static NSArray *stringArray;
    if (!stringArray) {
        NSLog(@"----alloc");
        NSString *str = @"1 first four methods also return by reference the effective range and the longest effective range of the attributes. These ranges allow you to determine the extent of attributes. Conceptually, each character in an attributed string has its own collection of attributes; however, it’s often useful to know when the attributes and values are the same over a series of characters. This allows a routine to progress through an attributed string in chunks larger than a single character. In retrieving the effective range, an attributed string simply looks up information in its attribute mapping, essentially the dictionary of attributes that apply at the index requested. In retrieving the longest effective range, the attributed string continues checking characters past this basic range as long as the attribute values are the same. This extra comparison increases the execution time for these methods but guarantees a precise maximal range for the attributes requested 😁 ✡︎ ▽🕹 📺🖥 😊🧐 🤨 😟 😔∀∁ ⊊≥";
        stringArray = [str componentsSeparatedByString:@" "];
    }
    return stringArray;
}

- (UIColor *)randomColor{
    CGFloat red =  (arc4random() % 255) / 255.0;
    CGFloat green = (arc4random() % 255) / 255.0;
    CGFloat blue = (arc4random() % 255) / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
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
