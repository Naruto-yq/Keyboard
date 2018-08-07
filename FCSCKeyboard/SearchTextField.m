//
//  SearchTextField.m
//  FCSCKeyboard
//
//  Created by yuqin on 2018/7/30.
//  Copyright © 2018年 yuqin. All rights reserved.
//

#import "SearchTextField.h"
#import "FCSCKeyboard.h"

@implementation SearchTextField
- (instancetype)init {
    if (self = [super init]) {
        [FCSCKeyboard shareFCSCKeyboard].textField = self;
    }
    return self;
}
@end
