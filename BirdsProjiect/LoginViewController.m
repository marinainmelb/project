//
//  LoginViewController.m
//  BirdsProject
//
//  Created by yanm1 on 16/10/12.
//
//

#import "LoginViewController.h"
#import "UIView+MJExtension.h"
#import "HTTPMethod.h"
#import "SVProgressHUD.h"
#import "UIButton+BackgroundColor.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    UITextField *_userNameTextField;
    UITextField *_passwordTextField;
    UIButton *_loginButton;
    
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Login";
    self.view.backgroundColor = MainColor;
    
    _userNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, (kkDeviceHeight - 64 - 200)/2, kkDeviceWidth - 60, 40)];
    _userNameTextField.placeholder = @"email";
    _userNameTextField.layer.borderWidth = 1;
    _userNameTextField.layer.borderColor = ButtonColor.CGColor;
    _userNameTextField.layer.cornerRadius = 3;
    _userNameTextField.layer.masksToBounds = YES;
    _userNameTextField.textAlignment = NSTextAlignmentCenter;
    _userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _userNameTextField.delegate = self;
    _userNameTextField.returnKeyType = UIReturnKeyNext;
    _userNameTextField.keyboardType = UIKeyboardTypeEmailAddress;
    [self.view addSubview:_userNameTextField];
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, _userNameTextField.mj_y + _userNameTextField.mj_h + 5, kkDeviceWidth - 60, 40)];
    _passwordTextField.delegate = self;
    _passwordTextField.placeholder = @"password";
    _passwordTextField.layer.borderWidth = 1;
    _passwordTextField.layer.borderColor = ButtonColor.CGColor;
    _passwordTextField.layer.cornerRadius = 3;
    _passwordTextField.layer.masksToBounds = YES;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.textAlignment = NSTextAlignmentCenter;
    _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordTextField.returnKeyType = UIReturnKeyGo;
    [self.view addSubview:_passwordTextField];

    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginButton setBackgroundColor:ButtonColor forState:UIControlStateNormal];
    [_loginButton setTitle:@"Login" forState:UIControlStateNormal];
    _loginButton.layer.cornerRadius = 3;
    _loginButton.layer.masksToBounds = YES;
    
    _loginButton.frame = CGRectMake(30, _passwordTextField.mj_y + _passwordTextField.mj_h + 15, kkDeviceWidth - 60, 45);
    [self.view addSubview:_loginButton];
    
    [_loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat height = MIN((kkDeviceHeight - 64 -200) / 2, 160);
    CGFloat y = (kkDeviceHeight - 64 -200) / 4 - height/2;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kkDeviceWidth / 2 - height / 2, y, height, height)];
    imageView.image = [UIImage imageNamed:@"bird.png"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.layer.cornerRadius = height / 2 ;
    imageView.layer.masksToBounds = YES;
    imageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:imageView];
}
//TODO:点击登录
- (void)loginButtonClick
{
    [self.view endEditing:YES];
    
    if (_userNameTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"email can not be nil"];
        return;
    }
    if (_passwordTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"password can not be nil"];
        return;
    }
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:_userNameTextField.text forKey:@"email"];
    [parameters setValue:_passwordTextField.text forKey:@"password"];
    [parameters setValue:@"iOS" forKey:@"client"];
    
    NSString *loginURL = [NSString stringWithFormat:@"%@login", RootURL];
    
    [SVProgressHUD show];
    
    [HTTPMethod requestURL:loginURL parameters:parameters success:^(id reponse) {
        if ([reponse isKindOfClass:[NSDictionary class]]) {
            if ([reponse[@"status"] integerValue] == 1) {
                NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
                [df setBool:YES forKey:@"Login"];
                [df setValue:reponse[@"username"] forKey:@"username"];
                [df setValue:_userNameTextField.text forKey:@"email"];
                [df synchronize];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:LoginNotification object:nil];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
        
        NSLog(@"%@", reponse);
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        [SVProgressHUD dismiss];
    }];
    
}
#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _userNameTextField) {
        [_passwordTextField becomeFirstResponder];
    } else {
        [_passwordTextField resignFirstResponder];
        [self loginButtonClick];
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
