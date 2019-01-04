//
//  FullScreenView.h
//  test
//
//  Created by Jason Wang on 2019/1/4.
//  Copyright © 2019 cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FullScreenView : UIView

@property (nonatomic, strong, readonly) UIView *upperContainer0;

@property (nonatomic, strong, readonly) UIView *upperContainer1;

@property (nonatomic, strong, readonly) UIView *lowerContainer;

@property (nonatomic, strong, readonly) NSArray<UIButton *> *buttons;


/**
 交换upperContainer和lowerContainer的位置大小等
 
 @param animation YES 为使用动画，NO不使用
 */
- (void)exchangeUpperAndLowerContainerAnimation:(BOOL)animation compeletion:(void(^)(void))compeltionBlock;

@end

NS_ASSUME_NONNULL_END
