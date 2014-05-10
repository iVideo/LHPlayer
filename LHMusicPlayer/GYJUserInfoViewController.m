//
//  LHUserInfoViewController.m
//  LHMusicPlayer
//
//  Created by 郭亚娟 on 14-5-1.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "GYJUserInfoViewController.h"
#import "GYJAFJSONRequestOperation.h"
#import "GYJCameraViewController.h"
#import "GYJCameraCantainer.h"
#import "GYJUserHeaderView.h"
#import "GYJCameraDelegate.h"
#import "GYJUserManager.h"
#import "GYJJSON.h"

@interface GYJUserInfoViewController ()<GYJTakePhotoDelegate>

@property (nonatomic, strong) GYJUserHeaderView *userHeader;
@property (nonatomic, strong) UIButton *logoutButton;

@end

@implementation GYJUserInfoViewController

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
    
    self.title = @"个人主页";
    
    [self addLeftButtonTitle:@"返回" target:self action:@selector(doBack)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect frame = [self viewVisibleFrameWithTabbar:YES naviBar:YES];
    self.userHeader = [[GYJUserHeaderView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(frame), CGRectGetWidth(frame), 150)];
    [self.view addSubview:_userHeader];
        
    __weak typeof(self) weakSelf = self;
    _userHeader.userEditBlock = ^{

    #warning userInfo
    };
    
    [_userHeader.editUserAvatorBtn addAction:^(UIButton *btn) {
       GYJCameraCantainer *container = nil;
        @autoreleasepool {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                GYJCameraViewController *cameraViewController = [[GYJCameraViewController alloc] init];
                cameraViewController.photoDelegate = weakSelf;
                container = [[GYJCameraCantainer alloc] initWithCameraController:cameraViewController];
            } else {
                GYJPhotoPickerController *photoPickerController = [[GYJPhotoPickerController alloc] init];
                photoPickerController.photoDelegate = weakSelf;
                container = [[GYJCameraCantainer alloc] initWithPhotoPickerController:photoPickerController];
            }
        }
        [weakSelf presentViewController:container animated:YES completion:NULL];
    }];
    
    [self updateUserHeader];
    
    self.logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_logoutButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_logoutButton setBackgroundImage:[[UIImage imageNamed:@"Btn_normal"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [_logoutButton setBackgroundImage:[[UIImage imageNamed:@"Btn_highlight"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    [_logoutButton.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [_logoutButton setTitle:@"登出" forState:UIControlStateNormal];
    [_logoutButton addTarget:self action:@selector(userLogoutAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_logoutButton];
    [_logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(self.view.mas_width).offset(-50);
        make.height.equalTo(@40);
        make.bottom.equalTo(self.view.mas_bottom).offset(-45);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserHeader) name:NTESIMUserInfoChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doBack) name:NTESIMUserLogoutNotification object:nil];
    
}
- (void)userLogoutAction{
    GYJAlert *alert = [[GYJAlert alloc] initAlertWithTitle:@"确认要退出登录吗？" message:nil cancelTitle:@"否" completeBlock:^(GYJAlert *alert, NSInteger buttonIndex) {
        if (buttonIndex) {
            [[GYJUserManager defaultManager] logoutLoginUser];

        }
    } otherTitle:@"是", nil];
    [alert show];
}

- (void)updateUserHeader{
    if ([GYJUserManager defaultManager].isLoginUser) {
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_LOGIN_INFO];
        if (verifiedString(dic[@"username"])) {
            [_userHeader.userMailLabel setText:[dic objectForKey:@"username"]];
        }
        if (verifiedString(dic[@"avator"])) {
            [_userHeader.userAvatar setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"avator"]] placeholderImage:nil];
        }
        if (verifiedString(dic[@"nickname"])) {
            [_userHeader.userNameLabel setText:[dic objectForKey:@"nickname"]];
        }
    }
}


- (void)takePhoto:(UIImage *)photoImage{
    NSData *imageData;
    imageData = UIImagePNGRepresentation(photoImage);
    if (!imageData) {
        imageData = UIImageJPEGRepresentation(photoImage,0.75);
    }
    [self uploadUserImageData:imageData];
}

- (void)uploadUserImageData:(NSData *)imageData{
    [SVProgressHUD showWithStatus:@"正在提交"];
    __weak typeof(self) weakSelf = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:API_163_USER_IMAGEUPLOAD_URL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData
                                    name:@"img"
                                fileName:@"file"
                                mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [operation.responseString objectFromJSONString];
        if (verifiedNSDictionary(dic) && [dic[@"state"] integerValue] == 0) {
            [weakSelf postNewHeadUrlToSever:dic[@"img"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"提交失败"];
    }];
}

//将新的头像url更新至服务器
- (void)postNewHeadUrlToSever:(NSString *)headUrl{
    NSString *userId = [[GYJUserManager defaultManager] currentUser].userid;
    NSDictionary *postDic = @{@"passport" : userId, @"head" : headUrl};
    NSString *postJson = [postDic JSONString];
    NSData *postData = [[postJson dataUsingEncoding:NSUTF8StringEncoding] AES128EncryptWithKey:EncryptKey];
    NSString *postString = [postData base64EncodedString];
    
    GYJAFJSONRequestOperation* operation = [[GYJAFJSONRequestOperation alloc] initWithRequestUrl:API_163_POST_HEAD_URL postBodyString:postString];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [operation.responseData objectFromJSONData];
        if(verifiedNSDictionary(dic)&&[dic[@"code"] intValue] == 1){
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            [[[GYJUserManager defaultManager] currentUser] updateUserInfoWith:@{@"head":headUrl}];
        } else {
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showSuccessWithStatus:@"提交成功"];
    }];
    [operation start];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)doBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NTESIMUserInfoChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NTESIMUserLogoutNotification object:nil];
}
@end
