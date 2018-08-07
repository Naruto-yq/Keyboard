//
//  ViewController.m
//  FCSCKeyboard
//
//  Created by yuqin on 2018/7/26.
//  Copyright © 2018年 yuqin. All rights reserved.
//

#import "ViewController.h"
#import "FCSCKeyboard.h"
#import "SearchTextField.h"


@interface ViewController () <UITextFieldDelegate>
@property (nonatomic, weak) SearchTextField *textField;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    SearchTextField *textField = [[SearchTextField alloc] init];
    textField.delegate = self;
    textField.frame = CGRectMake(30, 100 , ScreenWidth-60, 40);
    textField.borderStyle = UITextBorderStyleRoundedRect;
    UIImageView *searchIconView = [UIImageView new];
    searchIconView.frame = CGRectMake(5, 0, 24, 24);
    searchIconView.backgroundColor = [UIColor cyanColor];
    textField.leftView = searchIconView;
    textField.leftViewMode  = UITextFieldViewModeAlways;
    textField.placeholder = @"请输入股票期权合约代码/首字母";
//    [textField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
    [textField setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:textField];
    self.textField = textField;
}
@end
