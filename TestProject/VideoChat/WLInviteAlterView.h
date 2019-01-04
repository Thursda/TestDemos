//
//  WLInviteAlterView.h
//  test
//
//  Created by Jason Wang on 2018/11/15.
//  Copyright © 2018 cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MBProgressHUDAnimation) {
    /// Opacity animation
    MBProgressHUDAnimationFade,
    /// Opacity + scale animation (zoom in when appearing zoom out when disappearing)
    MBProgressHUDAnimationZoom,
    /// Opacity + scale animation (zoom out style)
    MBProgressHUDAnimationZoomOut,
    /// Opacity + scale animation (zoom in style)
    MBProgressHUDAnimationZoomIn
};

typedef void (^WLInviteAlterViewBlock)(void);

@class MBBackgroundView;

@interface WLInviteAlterView : UIView

+ (instancetype)showAlterAddedTo:(UIView *)view
                     cancelBlock:(WLInviteAlterViewBlock)cancelBlock
                    confirmBlock:(WLInviteAlterViewBlock)confirmBlock;

@property (assign, nonatomic) MBProgressHUDAnimation animationType UI_APPEARANCE_SELECTOR;

@property (assign, nonatomic) BOOL removeFromSuperViewOnHide;

@property (assign, nonatomic) CGFloat margin UI_APPEARANCE_SELECTOR;

@end

NS_ASSUME_NONNULL_END
