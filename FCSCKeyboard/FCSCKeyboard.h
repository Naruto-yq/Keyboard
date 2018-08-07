//
//  FCSCKeyboard.h
//  FCSCKeyboard
//
//  Created by yuqin on 2018/7/26.
//  Copyright © 2018年 yuqin. All rights reserved.
//

#import <UIKit/UIKit.h>


#define IS_TZTIphoneX 0
#define TZTHomeBarHeight  (IS_TZTIphoneX ? 34:0)

#define ScreenWidth    [UIScreen mainScreen].bounds.size.width
#define ScreenHeight   [UIScreen mainScreen].bounds.size.height

#define keyboardHeight 216


typedef NS_ENUM(NSInteger, eFCSCKeyboardType) {
    eFCSCKeyboardKeyTypeDefault = 0,
    eFCSCKeyboardKeyTypeLetter,
};

@interface FCSCKeyboard : UIView
+ (FCSCKeyboard *) shareFCSCKeyboard;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) eFCSCKeyboardType keyboardType;
@end
