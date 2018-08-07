//
//  FCSCKeyboard.m
//  FCSCKeyboard
//
//  Created by yuqin on 2018/7/26.
//  Copyright © 2018年 yuqin. All rights reserved.
//

#import "FCSCKeyboard.h"
#import "ChangeKeyboardView.h"

#define FIT_X        [UIScreen mainScreen].bounds.size.width/320.000

#define numKeyBtnMargin    4*FIT_X
#define numKeyBtnW         (ScreenWidth - 6*numKeyBtnMargin)/5
#define numKeyBtnH         (keyboardHeight - 5*numKeyBtnMargin)/4
#define abcKeyBtnW         (ScreenWidth -11*numKeyBtnMargin)/10

static FCSCKeyboard* sharedInstance = nil;

@interface FCSCKeyboard ()
@property (nonatomic, strong) UIView *numKeyboardView;
@property (nonatomic, strong) UIView *abcKeyboardView;
@property (nonatomic, strong) NSArray *keyboardTitels;

@property (nonatomic, strong) NSMutableArray *keyboardLetters;
@property (nonatomic, strong) NSMutableArray *keyboardLabels;
@end

@implementation FCSCKeyboard
+ (FCSCKeyboard *)shareFCSCKeyboard {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FCSCKeyboard alloc] initWithFrame:CGRectMake(0, ScreenHeight - keyboardHeight, ScreenWidth, keyboardHeight)];
    });
    
    return sharedInstance;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor lightGrayColor];
        
        [self setupNumKeyboardViews];
        [self setupABCKeyboardViews];
    }
    
    return self;
}

-(void)setFrame:(CGRect)frame {
    //MARK: iPhone X适配：键盘高度增加
    frame.size.height += TZTHomeBarHeight;
    [super setFrame:frame];
}

- (NSMutableArray *)keyboardLetters {
    if (!_keyboardLetters) {
        _keyboardLetters = [NSMutableArray array];
    }
    return _keyboardLetters;
}

- (NSMutableArray *)keyboardLabels {
    if (!_keyboardLabels) {
        _keyboardLabels = [NSMutableArray array];
    }
    return _keyboardLabels;
}

- (void)setTextField:(UITextField *)textField {
    _textField = textField;
    
    [self setupInputAccessoryView];
    [_textField setInputView:self.numKeyboardView];
}

- (void)setKeyboardType:(eFCSCKeyboardType)keyboardType {
    _keyboardType = keyboardType;
    
    if (_keyboardType == eFCSCKeyboardKeyTypeLetter) {
        [self.textField setInputView:self.abcKeyboardView];
    }else {
        [self.textField setInputView:self.numKeyboardView];
    }
    
    [self.textField reloadInputViews];
}

- (void)setupInputAccessoryView {
    ChangeKeyboardView *changeKeyboardView = [[ChangeKeyboardView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    changeKeyboardView.clickAccessViewBtn = ^(eAccesViewClickType nType) {
        if (nType == eAccesViewClickType_FCSCKeyboard) {
            if (self.keyboardType == eFCSCKeyboardKeyTypeLetter) {
                [self.textField setInputView:self.abcKeyboardView];
            }else {
                [self.textField setInputView:self.numKeyboardView];
            }
            
            [self.textField reloadInputViews];
        }else if (nType == eAccesViewClickType_SysKeyboard) {
            [self.textField setInputView:nil];
            [self.textField reloadInputViews];
        }else if (nType == eAccesViewClickType_Hiden) {
            [self.textField resignFirstResponder];
        }
    };
    self.textField.inputAccessoryView = changeKeyboardView;
}

- (void)setupNumKeyboardViews {
    self.keyboardTitels = @[@"600", @"1", @"2", @"3", @"del",
                            @"300", @"4", @"5", @"6", @"下一步",
                            @"08",  @"7", @"8", @"9", @"确认",
                            @"隐藏", @"000", @"0", @"00", @"ABC",];
    
    self.numKeyboardView =[[UIView alloc]initWithFrame:self.bounds];
    [self addSubview:self.numKeyboardView];
    
    for (int i=0; i<self.keyboardTitels.count; i++) {
        CGRect frame = [self frameForNumKeyboardButton:i];
        [self.numKeyboardView addSubview:[self createKeyboardButton:frame tag:i+1]];
        [self.numKeyboardView addSubview:[self createKeyboardLabel:frame title:self.keyboardTitels[i]]];
    }
}

- (void)setupABCKeyboardViews {
    self.abcKeyboardView =[[UIView alloc]initWithFrame:self.bounds];
    
    NSArray *firstRowLetters = @[@"q", @"w", @"e", @"r", @"t", @"y", @"u", @"i", @"o", @"p"];
    [self.keyboardLetters addObjectsFromArray:firstRowLetters];
    for (int i=0; i<10; i++) {
        CGRect frame = CGRectMake(numKeyBtnMargin + (abcKeyBtnW+numKeyBtnMargin)*i, numKeyBtnMargin, abcKeyBtnW, numKeyBtnH);
        [self.abcKeyboardView addSubview:[self createKeyboardButton:frame tag:i+100]];
        UILabel *letterLabel = [self createKeyboardLabel:frame title:firstRowLetters[i]];
        [self.abcKeyboardView addSubview:letterLabel];
        [self.keyboardLabels addObject:letterLabel];
    }
    
    NSArray *secondRowLetters = @[@"a", @"s", @"d", @"f", @"g", @"h", @"j", @"k", @"l"];
    [self.keyboardLetters addObjectsFromArray:secondRowLetters];
    for (int i=0; i<9; i++) {
        CGRect frame = CGRectMake(numKeyBtnMargin+(numKeyBtnMargin + abcKeyBtnW)/2 + (abcKeyBtnW+numKeyBtnMargin)*i, numKeyBtnMargin+(numKeyBtnH+numKeyBtnMargin), abcKeyBtnW, numKeyBtnH);
        [self.abcKeyboardView addSubview:[self createKeyboardButton:frame tag:i+110]];
        UILabel *letterLabel = [self createKeyboardLabel:frame title:secondRowLetters[i]];
        [self.abcKeyboardView addSubview:letterLabel];
        [self.keyboardLabels addObject:letterLabel];
    }
    
    NSArray *thirdRowLetters = @[@"z", @"x", @"c", @"v", @"b", @"n", @"m"];
    [self.keyboardLetters addObjectsFromArray:thirdRowLetters];
    for (int i=0; i<7; i++) {
        CGRect frame = CGRectMake(numKeyBtnMargin + (abcKeyBtnW+numKeyBtnMargin)*3/2 + (abcKeyBtnW+numKeyBtnMargin)*i, numKeyBtnMargin+(numKeyBtnH+numKeyBtnMargin)*2, abcKeyBtnW, numKeyBtnH);
        [self.abcKeyboardView addSubview:[self createKeyboardButton:frame tag:i+119]];
        UILabel *letterLabel = [self createKeyboardLabel:frame title:thirdRowLetters[i]];
        [self.abcKeyboardView addSubview:letterLabel];
        [self.keyboardLabels addObject:letterLabel];
    }
    
    CGRect capitalKeyFrame = CGRectMake(numKeyBtnMargin, numKeyBtnMargin+(numKeyBtnH+numKeyBtnMargin)*2, abcKeyBtnW*3/2, numKeyBtnH);
    [self.abcKeyboardView addSubview:[self createKeyboardButton:capitalKeyFrame tag:130]];
    [self.abcKeyboardView addSubview:[self createKeyboardLabel:capitalKeyFrame title:@"↑"]];
    
    CGRect delKeyFrame = CGRectMake(ScreenWidth-abcKeyBtnW*3/2-numKeyBtnMargin, numKeyBtnMargin+(numKeyBtnH+numKeyBtnMargin)*2, abcKeyBtnW*3/2, numKeyBtnH);
    [self.abcKeyboardView addSubview:[self createKeyboardButton:delKeyFrame tag:131]];
    [self.abcKeyboardView addSubview:[self createKeyboardLabel:delKeyFrame title:@"del"]];
    
    CGFloat hideKeyWidth = 2*abcKeyBtnW + numKeyBtnMargin;
    CGFloat hideKeyY = numKeyBtnMargin*4 + numKeyBtnH*3;
    CGFloat confirmKeyWidth = (ScreenWidth - 2*hideKeyWidth - 5*numKeyBtnMargin)/2;
    
    CGRect hideKeyFrame = CGRectMake(numKeyBtnMargin, hideKeyY, hideKeyWidth, numKeyBtnH);
    [self.abcKeyboardView addSubview:[self createKeyboardButton:hideKeyFrame tag:132]];
    [self.abcKeyboardView addSubview:[self createKeyboardLabel:hideKeyFrame title:@"隐藏"]];

    CGRect nextKeyFrame = CGRectMake(numKeyBtnMargin+CGRectGetMaxX(hideKeyFrame), hideKeyY, confirmKeyWidth, numKeyBtnH);
    [self.abcKeyboardView addSubview:[self createKeyboardButton:nextKeyFrame tag:133]];
    [self.abcKeyboardView addSubview:[self createKeyboardLabel:nextKeyFrame title:@"下一步"]];
    
    CGRect confirmKeyFrame = CGRectMake(numKeyBtnMargin+CGRectGetMaxX(nextKeyFrame), hideKeyY, confirmKeyWidth, numKeyBtnH);
    [self.abcKeyboardView addSubview:[self createKeyboardButton:confirmKeyFrame tag:134]];
    [self.abcKeyboardView addSubview:[self createKeyboardLabel:confirmKeyFrame title:@"确认"]];
    
    CGRect Key123Frame = CGRectMake(numKeyBtnMargin+CGRectGetMaxX(confirmKeyFrame), hideKeyY, hideKeyWidth, numKeyBtnH);
    [self.abcKeyboardView addSubview:[self createKeyboardButton:Key123Frame tag:135]];
    [self.abcKeyboardView addSubview:[self createKeyboardLabel:Key123Frame title:@"123"]];
}

- (UIButton *)createKeyboardButton:(CGRect)frame tag:(NSInteger)tag {
    UIButton *pressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pressButton.backgroundColor = [UIColor whiteColor];
    pressButton.layer.masksToBounds = YES;
    pressButton.layer.cornerRadius = 3.0f;
    pressButton.tag = tag;
    pressButton.frame = frame;
    [pressButton addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    return pressButton;
}

- (UILabel *)createKeyboardLabel:(CGRect)frame title:(NSString *)tittle {
    UILabel *descripSecLabel = [[UILabel alloc] init];
    descripSecLabel.frame = frame;
    descripSecLabel.backgroundColor = [UIColor clearColor];
    descripSecLabel.textAlignment = NSTextAlignmentCenter;
    descripSecLabel.font = [UIFont systemFontOfSize:16*FIT_X];
    descripSecLabel.text = tittle;
    return descripSecLabel;
}

-(CGRect)frameForNumKeyboardButton:(NSInteger)index {
    CGFloat btnX = numKeyBtnMargin + (index%5) * (numKeyBtnMargin + numKeyBtnW);
    CGFloat btnY = numKeyBtnMargin + (index/5) * (numKeyBtnMargin + numKeyBtnH);
    return CGRectMake(btnX, btnY, numKeyBtnW, numKeyBtnH);
}

- (void)onClickBtn:(UIButton *)btn {
    NSString *inputText = nil;
    if (btn.tag <= 20) {
        inputText = [self handleNumKeyboardInput:btn];
    }else {
        inputText = [self handleABCKeyboardInput:btn];
    }
    
    if (inputText.length) {
        self.textField.text = [NSString stringWithFormat:@"%@%@", self.textField.text, inputText];
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:UITextFieldTextDidChangeNotification object:self.textField]];
    }
}

- (NSString *)handleNumKeyboardInput:(UIButton *)btn {
    switch (btn.tag) {
        case 5://del
        {
            [self deleteText];
        }
            break;
            
        case 10:
        {
            [self hiden];
        }
            break;
            
        case 15:
        {
            [self hiden];
        }
            break;
            
        case 16:
        {
            [self hiden];
        }
            break;
            
        case 20:
        {
            self.keyboardType = eFCSCKeyboardKeyTypeLetter;
        }
            break;
            
        default:
        {
            return ((btn.tag-1) < self.keyboardTitels.count)? self.keyboardTitels[btn.tag-1] : nil;
        }
            break;
    }
    
    return nil;
}

- (NSString *)handleABCKeyboardInput:(UIButton *)btn {
    switch (btn.tag) {
        case 135:
        {
            self.keyboardType = eFCSCKeyboardKeyTypeDefault;
        }
            break;
            
        case 130:
        {
            [self showCapitalKey:btn];
        }
            break;
            
        case 131:
        {
            [self deleteText];
        }
            break;

        case 132:
        {
            [self hiden];
        }
            break;
            
        case 133:
        {
            [self hiden];
        }
            break;
            
        case 134:
        {
            [self hiden];
        }
            break;
        default:
        {
            return ((btn.tag-100) < self.keyboardLetters.count)? self.keyboardLetters[btn.tag-100] : nil;
        }
            break;
    }
    
    return nil;
}

- (void)deleteText {
    if (self.textField.text.length) {
        self.textField.text = [self.textField.text substringToIndex:self.textField.text.length-1];
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:UITextFieldTextDidChangeNotification object:self.textField]];
    }
}

- (void)showCapitalKey:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        for (int i=0; i<self.keyboardLetters.count; i++) {
            UILabel *letteLabel = self.keyboardLabels[i];
            [self.keyboardLetters replaceObjectAtIndex:i withObject:[self.keyboardLetters[i] uppercaseString]];
            letteLabel.text = self.keyboardLetters[i];
        }
    }else {
        for (int i=0; i<self.keyboardLetters.count; i++) {
            UILabel *letteLabel = self.keyboardLabels[i];
            [self.keyboardLetters replaceObjectAtIndex:i withObject:[self.keyboardLetters[i] lowercaseString]];
            letteLabel.text = self.keyboardLetters[i];
        }
    }
}

- (void)hiden {
    [self.textField resignFirstResponder];
}
@end
