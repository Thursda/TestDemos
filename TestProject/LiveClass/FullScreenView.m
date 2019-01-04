//
//  FullScreenView.m
//  test
//
//  Created by Jason Wang on 2019/1/4.
//  Copyright © 2019 cmcc. All rights reserved.
//

#import "FullScreenView.h"
#import "Masonry.h"
#import "UIView+Layout.h"

static const NSTimeInterval kAnimationDuration = 0.3;

@interface FullScreenView()

@property (nonatomic, strong) UIView *upperContainer0;
@property (nonatomic, strong) UIView *upperContainer1;
@property (nonatomic, strong) UIView *lowerContainer;

@property (nonatomic, strong) UIView *buttonsContainer;
@property (nonatomic, strong) NSArray<UIButton *> *buttons;

@property (nonatomic, assign) CGPoint initCenter;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecoginzer0;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecoginzer1;

@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic, strong) UICollisionBehavior *collisionBehavior;
@property (nonatomic, strong) UIDynamicItemBehavior *anchoredBehavior;
@property (nonatomic, strong) UIDynamicItemBehavior *disableRotationBehavior;
@property (nonatomic, strong) UISnapBehavior *snapBehavior;

@end

@implementation FullScreenView

#pragma mark - Initialize
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addContainers];
        [self addRightButtons];
        [self addGesture];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)addContainers{
    NSMutableArray *containers = [NSMutableArray new];
    for (int i = 0; i < 3; i ++) {
        UIView *view = [UIView new];
        [self addSubview:view];
        [containers addObject:view];
        view.backgroundColor = [self randomColor];
    }
    _lowerContainer = containers[0];
    _upperContainer0 = containers[1];
    _upperContainer1 = containers[2];
    
    [_lowerContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsZero);
    }];
    
    //    NSArray *upperContainers = @[_upperContainer0, _upperContainer1];
    //    [upperContainers mas_distributeViewsAlongAxis:(MASAxisTypeVertical)
    //                                                       withFixedSpacing:8 leadSpacing:80 tailSpacing:12];
    //    [upperContainers mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(@10);
    //        make.width.equalTo(self.upperContainer0.mas_height).multipliedBy(3.0 / 4);
    //    }];
    //    _upperContainer1.hidden = YES;
    [_upperContainer0 setFrame:CGRectMake(0, 80, 100, 100)];
    
    [_upperContainer1 setFrame:CGRectMake(0, 200, 100, 100)];
}

- (void)addRightButtons{
    _buttonsContainer = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:_buttonsContainer];
    [_buttonsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).offset(0);
        make.width.equalTo(@44.0);
        make.height.equalTo(@206.0);
        if (@available(iOS 11.0, *)) {
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(-20);
        } else {
            make.right.equalTo(self.mas_right).offset(-20);
        }
    }];
    
    NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0; i < 4; i++) {
        UIButton *button  = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.buttonsContainer addSubview:button];
        [buttons addObject:button];
        button.backgroundColor = [self randomColor];
    }
    self.buttons = [buttons copy];
    [_buttons mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedItemLength:44 leadSpacing:0 tailSpacing:0];
    [_buttons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.width.equalTo(@44);
    }];
}
#pragma mark - Lazy Getter
- (UIDynamicAnimator *)dynamicAnimator{
    if (!_dynamicAnimator) {
        _dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    }
    return _dynamicAnimator;
}
- (UICollisionBehavior *)collisionBehavior{
    if (!_collisionBehavior) {
        _collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[]];
        _collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    }
    return _collisionBehavior;
}
- (UIDynamicItemBehavior *)anchoredBehavior{
    if (!_anchoredBehavior) {
        _anchoredBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[]];
        _anchoredBehavior.anchored = YES;
    }
    return _anchoredBehavior;
}
- (UIDynamicItemBehavior *)disableRotationBehavior{
    if (!_disableRotationBehavior) {
        _disableRotationBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[_upperContainer0, _upperContainer1]];
        _disableRotationBehavior.allowsRotation = NO;
    }
    return _disableRotationBehavior;
}

-(void)addGesture{
    _panGestureRecoginzer0 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    _panGestureRecoginzer1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    
    [self.upperContainer0 addGestureRecognizer:_panGestureRecoginzer0];
    [self.upperContainer1 addGestureRecognizer:_panGestureRecoginzer1];
}

#pragma mark - UIPanGestureRecognizer

- (void)handlePan:(UIPanGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateEnded ||
        g.state == UIGestureRecognizerStateCancelled) {
        [self stopDragging];
    }else {
        [self dragView:g.view toPoint:[g locationInView:self]];
    }
}

- (void)dragView:(UIView *)view toPoint:(CGPoint)point{
    UIView *anotherView = (view == _upperContainer0) ? _upperContainer1 : _upperContainer0;
    
    [self.anchoredBehavior removeItem:view];
    [self.collisionBehavior addItem:view];
    if (!_upperContainer1.isHidden) {
        //        [self.anchoredBehavior addItem:anotherView];
        [self.collisionBehavior addItem:anotherView];
    }
    self.snapBehavior = [[UISnapBehavior alloc] initWithItem:view snapToPoint:point];
    
    [self.dynamicAnimator removeAllBehaviors];
    [self.dynamicAnimator addBehavior:self.disableRotationBehavior];
    [self.dynamicAnimator addBehavior:self.anchoredBehavior];
    [self.dynamicAnimator addBehavior:self.collisionBehavior];
    [self.dynamicAnimator addBehavior:self.snapBehavior];
}

- (void)stopDragging {
    [self.dynamicAnimator removeAllBehaviors];
    //    [self.dynamicAnimator removeBehavior:self.snapBehavior];
    self.snapBehavior = nil;
    self.disableRotationBehavior = nil;
    self.anchoredBehavior = nil;
    self.collisionBehavior = nil;
}

- (void)setUpperContainer1Hidden:(BOOL)hidden{
    self.upperContainer1.hidden = hidden;
    if (hidden) {
        [self.collisionBehavior removeItem:self.upperContainer1];
    }else{
        NSArray *upperContainers = @[_upperContainer0, _upperContainer1];
        [upperContainers mas_distributeViewsAlongAxis:(MASAxisTypeVertical)
                                     withFixedSpacing:8 leadSpacing:80 tailSpacing:12];
        [upperContainers mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.width.equalTo(self.upperContainer0.mas_height).multipliedBy(3.0 / 4);
        }];
        [self.collisionBehavior addItem:self.upperContainer1];
    }
}

- (void)exchangeUpperAndLowerContainerAnimation:(BOOL)animation compeletion:(void(^)(void))compeltionBlock{
    CGFloat top = _upperContainer0.origin.y;
    CGFloat left = _upperContainer0.origin.x;
    [_lowerContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(top);
        make.left.equalTo(self.mas_left).offset(left);
        make.width.equalTo(self.mas_width).multipliedBy(1.0 / 4);
        make.height.equalTo(self.lowerContainer.mas_width).multipliedBy(3.0 / 4);
    }];
    
    [_upperContainer0 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsZero);
    }];
    
    if (animation) {
        self.userInteractionEnabled = NO;
        [UIView animateWithDuration:kAnimationDuration animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self exchangeUpperAndLowerContainer];
            if (compeltionBlock){
                compeltionBlock();
            }
            self.userInteractionEnabled = YES;
        }];
    }else{
        [self layoutIfNeeded];
        [self exchangeUpperAndLowerContainer];
        self.userInteractionEnabled = YES;
    }
}

- (void)exchangeUpperAndLowerContainer{
    UIView *temp = _upperContainer0;
    _upperContainer0 = _lowerContainer;
    _lowerContainer = temp;
    [self insertSubview:_lowerContainer atIndex:0];
    [self bringSubviewToFront:_buttonsContainer];
    
    [_lowerContainer removeGestureRecognizer:_panGestureRecoginzer0];
    [_upperContainer0 addGestureRecognizer:_panGestureRecoginzer0];
}



- (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@end
