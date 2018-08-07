//
//  ChangeKeyboardView.m
//  FCSCKeyboard
//
//  Created by yuqin on 2018/7/26.
//  Copyright © 2018年 yuqin. All rights reserved.
//

#import "ChangeKeyboardView.h"

@interface ChangeKeyboardView ()
@property (nonatomic, weak) UIButton *FCSCKeyboardBtn;
@property (nonatomic, weak) UIButton *sysKeyboardBtn;
@property (nonatomic, weak) UIButton *hideKeyboardBtn;
@end

@implementation ChangeKeyboardView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    
    return self;
}

- (void)setupSubviews {
    CGFloat btnW = 80;
    
    UIButton *FCSCKeyboardBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, btnW, self.bounds.size.height)];
    FCSCKeyboardBtn.selected = YES;
    [FCSCKeyboardBtn setTitle:@"经典键盘" forState:UIControlStateNormal];
    [FCSCKeyboardBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [FCSCKeyboardBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    FCSCKeyboardBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [FCSCKeyboardBtn addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:FCSCKeyboardBtn];
    self.FCSCKeyboardBtn = FCSCKeyboardBtn;
    
    UIButton *sysKeyboardBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(FCSCKeyboardBtn.frame)+ 30, 0, btnW, self.bounds.size.height)];
    [sysKeyboardBtn setTitle:@"系统键盘" forState:UIControlStateNormal];
    [sysKeyboardBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [sysKeyboardBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    sysKeyboardBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [sysKeyboardBtn addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sysKeyboardBtn];
    self.sysKeyboardBtn = sysKeyboardBtn;
    
    UIButton *hideKeyboardBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width-btnW/2-20, 10, btnW/2, self.bounds.size.height-20)];
    hideKeyboardBtn.backgroundColor = [UIColor lightGrayColor];
    [hideKeyboardBtn addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:hideKeyboardBtn];
    self.hideKeyboardBtn = hideKeyboardBtn;
}

- (void)onClickBtn:(UIButton *)btn {
    NSInteger nType = 0;
    if (btn == self.FCSCKeyboardBtn) {
        nType = eAccesViewClickType_FCSCKeyboard;
        self.FCSCKeyboardBtn.selected = YES;
        self.sysKeyboardBtn.selected = NO;
    }else if (btn == self.sysKeyboardBtn) {
        nType = eAccesViewClickType_SysKeyboard;
        self.FCSCKeyboardBtn.selected = NO;
        self.sysKeyboardBtn.selected = YES;
    }else if (btn == self.hideKeyboardBtn) {
        nType = eAccesViewClickType_Hiden;
    }
    
    if (self.clickAccessViewBtn) {
        self.clickAccessViewBtn(nType);
    }
}
@end
