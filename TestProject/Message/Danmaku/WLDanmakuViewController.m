//
//  WLDanmakuViewController.m
//  test
//
//  Created by Jason Wang on 2018/12/17.
//  Copyright © 2018 cmcc. All rights reserved.
//

#import "WLDanmakuViewController.h"
#import "WLDanmakuTrackView.h"
#import "WLDanmakuView.h"

static NSDictionary *kDanmakuAttributes;

@interface WLDanmakuViewController ()<WLDanmakuViewDataSource>
@property (nonatomic, strong) WLDanmakuView *danmakuView;

@property (nonatomic, strong) NSDictionary *studentTextAttribute;
@property (nonatomic, strong) NSDictionary *teacherTextAttribute;

@end

@implementation WLDanmakuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
    
    UIFont *font = [UIFont systemFontOfSize:21];
    UIColor *foregroundColor = [UIColor whiteColor];
    UIColor *strokeColor = [UIColor lightGrayColor];
    _studentTextAttribute = @{NSFontAttributeName:font,
                           NSForegroundColorAttributeName: foregroundColor,
                           NSStrokeColorAttributeName: strokeColor,
                           NSStrokeWidthAttributeName: @(-3),
                           };
    foregroundColor = [UIColor blueColor];
    _teacherTextAttribute = @{NSFontAttributeName:font,
                              NSForegroundColorAttributeName: foregroundColor,
                              };
    
    
    [self addDanmakuView];
    [self addDebugButton];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.danmakuView clear];
}

- (void)addDanmakuView{
    self.danmakuView = [[WLDanmakuView alloc] initWithRowNumber:3 rowheight:40 margin:5];
    CGFloat height = 40 * 3 + 5 * 2;
    self.danmakuView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), height);
    self.danmakuView.dataSource = self;
    
    [self.view addSubview:self.danmakuView];
}

- (WLDanmakuViewCell *)danmakuView:(WLDanmakuView *)danmakuView cellForDanmaku:(id<WLDanmakuEntity>)danmaku{
    static int i = 0;
    i++;
    NSString *text = @"Copyright © 2018 cmcc. All rights reserved.";
    uint32_t length = arc4random_uniform((uint32_t)text.length);
    NSString *content = [NSString stringWithFormat:@"%d---%@", i, [text substringToIndex:length]];
    NSDictionary *attribute = (i % 6) ? _studentTextAttribute : _teacherTextAttribute;
    NSAttributedString *as = [[NSAttributedString alloc] initWithString:content attributes:attribute];
    
    CGFloat width = [as boundingRectWithSize:CGSizeMake(HUGE, 50) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil].size.width;
    WLDanmakuViewCell *cell = [self.danmakuView dequeueReusableCellWithIdentifier:@"TextCell"];
    if (!cell) {
        cell = [[WLDanmakuViewCell alloc] initWithFrame:CGRectMake(0, 0, width, 50)];
        NSLog(@"-----------%d++", i);
    }
    cell.label.attributedText = as;
    cell.cellWidth = width + 1;
    return cell;
}

# pragma mark - Debug
- (void)tap:(UITapGestureRecognizer *)tap{
    NSString *text = @"Copyright © 2018 cmcc. All rights reserved.";
    NSMutableArray *danmakus = [NSMutableArray new];
    for (int i = 0; i < 100; i++) {
        uint32_t length = arc4random_uniform((uint32_t)text.length);
        NSString *content = [NSString stringWithFormat:@"%d---%@", i, [text substringToIndex:length]];
        [danmakus addObject:content];
    }
    [self.danmakuView showDanmakus:danmakus];
}

- (void)addDebugButton{
    [self addButtonWithTitle:@"Clear" clickAction:@selector(clearAllDanmakus) frame:CGRectMake(10, 240, 80, 40)];
    [self addButtonWithTitle:@"Pause" clickAction:@selector(pauseDanmakus) frame:CGRectMake(100, 240, 80, 40)];
    [self addButtonWithTitle:@"Resume" clickAction:@selector(resumeDanmakus) frame:CGRectMake(190, 240, 80, 40)];

    [self addButtonWithTitle:@"Hiden" clickAction:@selector(hideDanmakus) frame:CGRectMake(10, 300, 140, 40)];
}

- (void)clearAllDanmakus{
    [self.danmakuView clear];
}
- (void)pauseDanmakus{
    [self.danmakuView pause];
}

- (void)resumeDanmakus{
    [self.danmakuView resume];
}

- (void)hideDanmakus{
    self.danmakuView.hidden = !self.danmakuView.hidden;
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
@end
