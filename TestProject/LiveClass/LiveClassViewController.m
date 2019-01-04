//
//  LiveClassViewController.m
//  test
//
//  Created by Jason Wang on 2019/1/4.
//  Copyright © 2019 cmcc. All rights reserved.
//

#import "LiveClassViewController.h"
#import "FullScreenView.h"
#import "Masonry.h"

@interface LiveClassViewController ()
@property (nonatomic, strong) FullScreenView *view;

@property (nonatomic, strong) UIViewController *messageVC;

@property (nonatomic, strong) UIViewController *aVC;

@end
@implementation LiveClassViewController
@dynamic view;

- (instancetype)init{
    self = [super init];
    if (!self) return nil;
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _messageVC = [UIViewController new];
    _messageVC.view.backgroundColor = [UIColor yellowColor];
    _aVC = [UIViewController new];
    _aVC.view.backgroundColor = [UIColor redColor];
    
    [self addSubController:_messageVC toContainer:self.view.upperContainer0 insets:UIEdgeInsetsZero];
    [self addSubController:_aVC toContainer:self.view.upperContainer1 insets:UIEdgeInsetsZero];
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setTitle:@"btn" forState:(UIControlStateNormal)];
    btn.backgroundColor = [UIColor brownColor];
    [_aVC.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.aVC.view.mas_top).offset(0);
        make.left.equalTo(self.aVC.view.mas_left).offset(0);
    }];
    
    NSLog(@"-----------viewDidLoad");
}

- (void)loadView{
    /**
     If you use Interface Builder to create your views and initialize the view controller, you must not override this method.
     You can override this method in order to create your views manually. If you choose to do so, assign the root view of your view hierarchy to the view property. The views you create should be unique instances and should not be shared with any other view controller object. Your custom implementation of this method should not call super.
     */
    self.view = [FullScreenView new];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"--------viewWillAppear");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"-------- viewDidAppear");
}

- (void)addSubController:(UIViewController *)controller toContainer:(UIView *)container insets:(UIEdgeInsets)insets{
    [self addChildViewController:controller];
    [container addSubview:controller.view];
    controller.view.translatesAutoresizingMaskIntoConstraints = NO;
    controller.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [controller.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(container).insets(insets);
    }];
    [controller didMoveToParentViewController:self];
}

@end
