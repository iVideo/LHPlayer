//
//  LHUserLoginViewController.m
//  LHMusicPlayer
//
//  Created by 郭亚娟 on 14-5-1.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "GYJUserLoginViewController.h"

@interface GYJUserLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *userNameField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UIView *inputContentView;
@property (nonatomic, strong) UIButton *logginBtn;
@end

@implementation GYJUserLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"登录";
    
    [self addRightButtonWithTitle:@"返回" target:self action:@selector(doBack)];
    [self setUpContent];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginSuccess) name:NTESIMUserLoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginError) name:NTESIMUserLoginFailedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)doBack{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)setUpContent{
    self.inputContentView = [UIView new];
    [self.view addSubview:_inputContentView];

    self.logginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_logginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_logginBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [_logginBtn setBackgroundColor:[UIColor colorWithHexString:@"839BBE"]];
    [_logginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_logginBtn setTitleColor:[UIColor colorWithHexString:@"A0A0A0"] forState:UIControlStateHighlighted];
    [_logginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [_inputContentView addSubview:_logginBtn];
    
    UITextField *userNameField = [UITextField new];
    userNameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    userNameField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    userNameField.leftViewMode = UITextFieldViewModeAlways;
    userNameField.keyboardType = UIKeyboardTypeEmailAddress;
    userNameField.autocorrectionType = UITextAutocorrectionTypeNo;
    userNameField.font = [UIFont systemFontOfSize:13];
    userNameField.returnKeyType = UIReturnKeyNext;
    userNameField.delegate = self;
    userNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    userNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    userNameField.placeholder = @"请输入登录帐号";
    userNameField.backgroundColor = [UIColor whiteColor];
    self.userNameField = userNameField;
    _userNameField.borderStyle = UITextBorderStyleNone;
    [_inputContentView addSubview:_userNameField];
    
    UITextField *passwordField = [UITextField new];
    passwordField.backgroundColor = [UIColor whiteColor];
    passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    passwordField.font = [UIFont systemFontOfSize:13];
    passwordField.returnKeyType = UIReturnKeyDone;
    passwordField.delegate = self;
    passwordField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    passwordField.leftViewMode = UITextFieldViewModeAlways;
    passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordField.placeholder = @"请输入密码";
    passwordField.secureTextEntry = YES;
    self.passwordField = passwordField;
    [_inputContentView addSubview:_passwordField];
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    _inputContentView.left = [self.view left];
    _inputContentView.top = self.customNaviBar.bottom + 50;
    
    _userNameField.top = 0;
    _userNameField.size = CGSizeMake([self.view width], 50);
    _userNameField.left = [self.view left];
    
    _passwordField.size = CGSizeMake([self.view width], 50);
    _passwordField.top = _userNameField.bottom + 0.5;
    _passwordField.centerX = [self.view width] * 0.5;

    
    _logginBtn.size = CGSizeMake([self.view width], 50);
    _logginBtn.centerX = [self.view width] * 0.5;
    _logginBtn.top = _passwordField.bottom;
    
    _inputContentView.size = CGSizeMake([self.view width], _userNameField.height + _passwordField.height + _logginBtn.height);
}
#pragma mark - KeyBoard Show&Hidden
- (void)keyBoardWillShow:(NSNotification *)noti{
    if ([noti.name isEqualToString:UIKeyboardWillShowNotification]) {
        NSDictionary *info = [noti userInfo];
        NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        CGFloat keyboardTop = keyboardRect.origin.y;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
            keyboardTop -= 20;
        }
        
        _inputContentView.bottom = keyboardTop;
    }
    
}
- (void)keyBoardWillHidden:(NSNotification *)noti{
    if ([noti.name isEqualToString:UIKeyboardWillHideNotification]) {
        _inputContentView.top = self.customNaviBar.bottom + 50;
    }
}

- (void)userLoginSuccess{
    [self doBack];
}


- (void)userLoginError{
        __weak typeof(self) weakSelf = self;
        GYJAlert *alert = [[GYJAlert alloc] initAlertWithTitle:nil message:@"登录失败" cancelTitle:@"返回" completeBlock:^(GYJAlert *alert, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                [weakSelf doBack];
            } else {
                [weakSelf.userNameField setText:nil];
                [weakSelf.passwordField setText:nil];
                [weakSelf.userNameField becomeFirstResponder];
            }
        } otherTitle:@"重新登录", nil];
        [alert show];
}


- (void)login{
    __weak typeof(self) weakSelf = self;
    if (!verifiedString(self.userNameField.text)) {
        if (![_userNameField isFirstResponder]) {
            [self.userNameField becomeFirstResponder];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.userNameField shake];
        });
        return;
    }
    if (!verifiedString(self.passwordField.text)) {
        if (![_passwordField isFirstResponder]) {
            [self.passwordField becomeFirstResponder];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.passwordField shake];
        });
        return;
    }
    [self.view endEditing:YES];
    [[GYJUserManager defaultManager] loginNeteaseWithUsername:weakSelf.userNameField.text password:weakSelf.passwordField.text];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField == self.userNameField)
	{
		[self.passwordField becomeFirstResponder];
	}
	else if (textField == self.passwordField)
	{
        [self.view endEditing:YES];
		[self login];
	}
	return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NTESIMUserLoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NTESIMUserLoginFailedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


@end
