//
//  WLInviteAlterView.m
//  test
//
//  Created by Jason Wang on 2018/11/15.
//  Copyright © 2018 cmcc. All rights reserved.
//

#import "WLInviteAlterView.h"
#import "Masonry.h"

#ifndef kCFCoreFoundationVersionNumber_iOS_7_0
#define kCFCoreFoundationVersionNumber_iOS_7_0 847.20
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_8_0
#define kCFCoreFoundationVersionNumber_iOS_8_0 1129.15
#endif

#define MBMainThreadAssert() NSAssert([NSThread isMainThread], @"MBProgressHUD needs to be accessed on the main thread.");

CGFloat const MBProgressMaxOffset = 1000000.f;

static const CGFloat WLDefaultTitleLabelFontSize = 21;
static const CGFloat WLDefaultMessageLabelFontSize = 19;

//static const CGFloat kDefaultButtonTitleFontSize = 17;
static const CGFloat kContentMargin = 12.f;
static const CGFloat kVerticalMagin = 20.f;
static const CGFloat kButtonMargin = 20.f;

static const CGFloat kDefaultRowHeith = 50.f;

@interface WLInviteAlterView()

@property (strong, nonatomic, nullable) UIColor *contentColor;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIView *backgroundView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) UIView *buttonContainer;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

@property (copy, nullable) WLInviteAlterViewBlock cancelBlock;
@property (copy, nullable) WLInviteAlterViewBlock confirmBlock;

@end

@implementation WLInviteAlterView

#pragma mark - Class methods
+ (instancetype)showAlterAddedTo:(UIView *)view cancelBlock:(WLInviteAlterViewBlock)cancelBlock confirmBlock:(WLInviteAlterViewBlock)confirmBlock{
    WLInviteAlterView *alter = [self showAlterAddedTo:view animated:YES];
    alter.cancelBlock = cancelBlock;
    alter.confirmBlock = confirmBlock;
    return alter;
}

+ (instancetype)showAlterAddedTo:(UIView *)view animated:(BOOL)animated {
    WLInviteAlterView *hud = [[self alloc] initWithView:view];
    hud.removeFromSuperViewOnHide = YES;
    [view addSubview:hud];
    hud.titleLabel.text = @"视频对话邀请";
    hud.messageLabel.text = @"老师向您发出视频对话邀请...";
    [hud setNeedsUpdateConstraints];
    [hud showAnimated:animated];
    return hud;
}


#pragma mark - Lifecycle
- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self commonInit];
    }
    return self;
}

- (id)initWithView:(UIView *)view {
    NSAssert(view, @"View must not be nil.");
    return [self initWithFrame:view.bounds];
}

- (void)commonInit {
    // Default color, depending on the current iOS version
    BOOL isLegacy = kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_7_0;
    _contentColor = isLegacy ? [UIColor whiteColor] : [UIColor colorWithWhite:0.f alpha:0.7f];
    // Transparent background
    self.opaque = NO;
    self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.45f];
    // Make it invisible for now
    self.alpha = 0.0f;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.layer.allowsGroupOpacity = NO;
    [self setupViews];
    [self registerForNotifications];
}


#pragma mark - Show & hide
- (void)showAnimated:(BOOL)animated {
    MBMainThreadAssert();
    [self animateIn:YES withType:self.animationType completion:NULL];
}

- (void)hideAnimated:(BOOL)animated {
    MBMainThreadAssert();
    [self animateIn:NO withType:self.animationType completion:^(BOOL finished) {
        [self done];
    }];
}

- (void)dealloc {
    [self unregisterFromNotifications];
    self.confirmBlock = nil;
    self.cancelBlock = nil;
    NSLog(@"---- %@ dealloc", NSStringFromClass([self class]));
}
#pragma mark - View Hierrarchy

- (void)didMoveToSuperview {
    [self updateForCurrentOrientationAnimated:NO];
}

#pragma mark - Internal show & hide operations

- (void)animateIn:(BOOL)animatingIn withType:(MBProgressHUDAnimation)type completion:(void(^)(BOOL finished))completion {
    // Automatically determine the correct zoom animation type
    if (type == MBProgressHUDAnimationZoom) {
        type = animatingIn ? MBProgressHUDAnimationZoomIn : MBProgressHUDAnimationZoomOut;
    }
    
    CGAffineTransform small = CGAffineTransformMakeScale(0.5f, 0.5f);
    CGAffineTransform large = CGAffineTransformMakeScale(1.5f, 1.5f);
    
    // Set starting state
    UIView *contentView = self.contentView;
    if (animatingIn && contentView.alpha == 0.f && type == MBProgressHUDAnimationZoomIn) {
        contentView.transform = small;
    } else if (animatingIn && contentView.alpha == 0.f && type == MBProgressHUDAnimationZoomOut) {
        contentView.transform = large;
    }
    
    // Perform animations
    dispatch_block_t animations = ^{
        if (animatingIn) {
            contentView.transform = CGAffineTransformIdentity;
        } else if (!animatingIn && type == MBProgressHUDAnimationZoomIn) {
            contentView.transform = large;
        } else if (!animatingIn && type == MBProgressHUDAnimationZoomOut) {
            contentView.transform = small;
        }
        CGFloat alpha = animatingIn ? 1.f : 0.f;
        contentView.alpha = alpha;
        self.backgroundView.alpha = alpha;
        self.alpha = animatingIn;
    };
    self.contentView.alpha = 1;
    
    // Spring animations are nicer, but only available on iOS 7+
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000 || TARGET_OS_TV
    if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0) {
        [UIView animateWithDuration:0.3 delay:0. usingSpringWithDamping:1.f initialSpringVelocity:0.f options:UIViewAnimationOptionBeginFromCurrentState animations:animations completion:completion];
        return;
    }
#endif
    [UIView animateWithDuration:0.3 delay:0. options:UIViewAnimationOptionBeginFromCurrentState animations:animations completion:completion];
}

- (void)done {
    self.alpha = 0.0f;
    if (self.removeFromSuperViewOnHide) {
        [self removeFromSuperview];
    }
}

#pragma mark - UI

- (void)setupViews {
    UIColor *defaultColor = self.contentColor;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    backgroundView.alpha = 1.f;
    [self addSubview:backgroundView];
    _backgroundView = backgroundView;
    
    UIView *contentView = [UIView new];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.layer.cornerRadius = 5.f;
    contentView.alpha = 1.f;
    [self addSubview:contentView];
    contentView.backgroundColor = [UIColor whiteColor];
    _contentView = contentView;
    
    UILabel *label = [UILabel new];
    label.adjustsFontSizeToFitWidth = NO;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = defaultColor;
    label.font = [UIFont boldSystemFontOfSize:WLDefaultTitleLabelFontSize];
    label.numberOfLines = 0;
    _titleLabel = label;
    
    UILabel *detailsLabel = [UILabel new];
    detailsLabel.adjustsFontSizeToFitWidth = NO;
    detailsLabel.textAlignment = NSTextAlignmentCenter;
    detailsLabel.textColor = defaultColor;
    detailsLabel.numberOfLines = 0;
    detailsLabel.font = [UIFont systemFontOfSize:WLDefaultMessageLabelFontSize];
    _messageLabel = detailsLabel;
    
    UIView *buttonContainer = [UIView new];
    
    NSMutableArray *buttons = [NSMutableArray new];
    for (int i = 0; i< 2 ; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:WLDefaultMessageLabelFontSize];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = 5.0;
        
        [buttonContainer addSubview:button];
        [buttons addObject:button];
    }
    _leftButton = buttons[0];
    _rightButton = buttons[1];
    _buttonContainer = buttonContainer;
    [_leftButton setTitle:@"接受" forState:(UIControlStateNormal)];
    [_leftButton setBackgroundColor:[UIColor colorWithRed:118.0/255 green:215.0/255 blue:114.0/255 alpha:1]];//76D772
    [_rightButton setTitle:@"拒绝" forState:(UIControlStateNormal)];
    [_rightButton setBackgroundColor:[UIColor redColor]];
    [_leftButton addTarget:self action:@selector(cancelAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_rightButton addTarget:self action:@selector(confirmAction:) forControlEvents:(UIControlEventTouchUpInside)];

    for (UIView *view in @[_titleLabel, _messageLabel, _buttonContainer]) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
//        [view setContentCompressionResistancePriority:998.f forAxis:UILayoutConstraintAxisHorizontal];
//        [view setContentCompressionResistancePriority:998.f forAxis:UILayoutConstraintAxisVertical];
        [contentView addSubview:view];
    }
}

- (IBAction)cancelAction:(UIButton *)sender{
    [self hidenWithBlock:self.cancelBlock];
}

- (IBAction)confirmAction:(UIButton *)sender{
    [self hidenWithBlock:self.confirmBlock];
}

- (void)hidenWithBlock:(WLInviteAlterViewBlock)block{
    WLInviteAlterViewBlock completionBlock = block;
    if (completionBlock) {
        completionBlock();
    }
    [self hideAnimated:YES];
}

#pragma mark - Layout

- (void)updateConstraints {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(self.mas_width).multipliedBy(0.8).with.priorityMedium();
        make.width.lessThanOrEqualTo(@(400)).with.priorityHigh();
    }];
    
    NSArray *subviews = @[self.titleLabel, self.messageLabel, self.buttonContainer];
    [subviews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kContentMargin);
        make.right.equalTo(self.contentView.mas_right).offset(-kContentMargin);
        make.height.equalTo(@(kDefaultRowHeith)).with.priorityLow();
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(kVerticalMagin);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kVerticalMagin);
    }];
    
    [self.buttonContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageLabel.mas_bottom).offset(kVerticalMagin);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kVerticalMagin);
    }];
    
    NSArray *buttons = @[self.leftButton, self.rightButton];
    [buttons mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedSpacing:kButtonMargin leadSpacing:kContentMargin tailSpacing:kContentMargin];
    [buttons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.buttonContainer.mas_centerY);
        make.height.equalTo(@(44));//(self.buttonContainer.mas_height).multipliedBy(1);
    }];
    
    [super updateConstraints];
}

- (void)layoutSubviews {

    [super layoutSubviews];
}

#pragma mark - Properties
- (void)setMargin:(CGFloat)margin {
    if (margin != _margin) {
        _margin = margin;
        [self setNeedsUpdateConstraints];
    }
}

#pragma mark - Notifications
- (void)registerForNotifications {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(statusBarOrientationDidChange:)
               name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)unregisterFromNotifications {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)statusBarOrientationDidChange:(NSNotification *)notification {
    UIView *superview = self.superview;
    if (!superview) {
        return;
    } else {
        [self updateForCurrentOrientationAnimated:YES];
    }
}

- (void)updateForCurrentOrientationAnimated:(BOOL)animated {
    // Stay in sync with the superview in any case
    if (self.superview) {
        self.frame = self.superview.bounds;
    }
    
    // Not needed on iOS 8+, compile out when the deployment target allows,
    // to avoid sharedApplication problems on extension targets
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 80000
    // Only needed pre iOS 8 when added to a window
    BOOL iOS8OrLater = kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_8_0;
    if (iOS8OrLater || ![self.superview isKindOfClass:[UIWindow class]]) return;
    
    // Make extension friendly. Will not get called on extensions (iOS 8+) due to the above check.
    // This just ensures we don't get a warning about extension-unsafe API.
    Class UIApplicationClass = NSClassFromString(@"UIApplication");
    if (!UIApplicationClass || ![UIApplicationClass respondsToSelector:@selector(sharedApplication)]) return;
    
    UIApplication *application = [UIApplication performSelector:@selector(sharedApplication)];
    UIInterfaceOrientation orientation = application.statusBarOrientation;
    CGFloat radians = 0;
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        radians = orientation == UIInterfaceOrientationLandscapeLeft ? -(CGFloat)M_PI_2 : (CGFloat)M_PI_2;
        // Window coordinates differ!
        self.bounds = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.width);
    } else {
        radians = orientation == UIInterfaceOrientationPortraitUpsideDown ? (CGFloat)M_PI : 0.f;
    }
    
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.transform = CGAffineTransformMakeRotation(radians);
        }];
    } else {
        self.transform = CGAffineTransformMakeRotation(radians);
    }
#endif
}

@end
