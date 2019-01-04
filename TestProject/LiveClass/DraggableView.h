//
//  DraggableView.h
//  test
//
//  Created by Jason Wang on 2019/1/4.
//  Copyright © 2019 cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DraggableView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                     animator:(UIDynamicAnimator *)animator;
@end

NS_ASSUME_NONNULL_END
