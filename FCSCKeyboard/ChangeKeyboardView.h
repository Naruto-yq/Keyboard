//
//  ChangeKeyboardView.h
//  FCSCKeyboard
//
//  Created by yuqin on 2018/7/26.
//  Copyright © 2018年 yuqin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, eAccesViewClickType) {
    eAccesViewClickType_FCSCKeyboard = 100,
    eAccesViewClickType_SysKeyboard,
    eAccesViewClickType_Hiden,
};

typedef void (^ClickAccessViewBtn) (eAccesViewClickType nType);

@interface ChangeKeyboardView : UIView
@property (nonatomic, copy)ClickAccessViewBtn clickAccessViewBtn;
@end
