
//
//  RegisterViewController.m
//  BirdsProject
//
//  Created by yanm1 on 16/10/13.
//
//

#import "RegisterViewController.h"
#import "UIButton+BackgroundColor.h"


@interface RegisterViewController ()<UITextFieldDelegate>
{
    UITextField *_userNameTextField;
    UITextField *_passwordTextField;
    UITextField *_emailTextField;
    UIButton *_registerButton;
}
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Register";
    self.view.backgroundColor = MainColor;
    
    _userNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, (kkDeviceHeight - 64 - 200)/2, kkDeviceWidth - 60, 40)];
    _userNameTextField.placeholder = @"username";
    _userNameTextField.layer.borderWidth = 1;
    _userNameTextField.layer.borderColor = ButtonColor.CGColor;
    _userNameTextField.layer.cornerRadius = 3;
    _userNameTextField.layer.masksToBounds = YES;
    _userNameTextField.textAlignment = NSTextAlignmentCenter;
    _userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _userNameTextField.delegate = self;
    _userNameTextField.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:_userNameTextField];
    
    
    _emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, _userNameTextField.mj_y + _userNameTextField.mj_h + 5, kkDeviceWidth - 60, 40)];
    _emailTextField.placeholder = @"email";
    _emailTextField.layer.borderWidth = 1;
    _emailTextField.layer.borderColor = ButtonColor.CGColor;
    _emailTextField.layer.cornerRadius = 3;
    _emailTextField.layer.masksToBounds = YES;
    _emailTextField.textAlignment = NSTextAlignmentCenter;
    _emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _emailTextField.delegate = self;
    _emailTextField.returnKeyType = UIReturnKeyNext;
    _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    [self.view addSubview:_emailTextField];
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, _emailTextField.mj_y + _emailTextField.mj_h + 5, kkDeviceWidth - 60, 40)];
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
    
    
    
    _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_registerButton setBackgroundColor:ButtonColor forState:UIControlStateNormal];
    [_registerButton setTitle:@"Register" forState:UIControlStateNormal];
    _registerButton.layer.cornerRadius = 3;
    _registerButton.layer.masksToBounds = YES;
    
    _registerButton.frame = CGRectMake(30, _passwordTextField.mj_y + _passwordTextField.mj_h + 15, kkDeviceWidth - 60, 45);
    [self.view addSubview:_registerButton];
    
    [_registerButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
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
//TODO:login
- (void)loginButtonClick
{
    [self.view endEditing:YES];
    
    if (_userNameTextField.text.length < 2) {
        [SVProgressHUD showErrorWithStatus:@"username at least 2"];
        return;
    }
    if (![self isValidateEmail:_emailTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"email is incorrect"];
        return;
    }
    if (_passwordTextField.text.length < 6) {
        [SVProgressHUD showErrorWithStatus:@"Password at least 6"];
        return;
    }
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:_userNameTextField.text forKey:@"username"];
    [parameters setValue:_emailTextField.text forKey:@"email"];
    [parameters setValue:_passwordTextField.text forKey:@"password"];
    [parameters setValue:@"false" forKey:@"expert"];
    [parameters setValue:@"iOS" forKey:@"client"];
    
    NSString *loginURL = [NSString stringWithFormat:@"%@register", RootURL];
    
    [SVProgressHUD show];
    [HTTPMethod requestURL:loginURL parameters:parameters success:^(id reponse) {
        NSLog(@"%@", reponse);
        if ([reponse isKindOfClass:[NSDictionary class]]) {
            if ([reponse[@"status"] integerValue] == 1) {
                NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
                [df setBool:YES forKey:@"Login"];
                [df setValue:_userNameTextField.text forKey:@"username"];
                [df setValue:_emailTextField.text forKey:@"email"];
                [df synchronize];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:LoginNotification object:nil];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
                [SVProgressHUD dismiss];
            } else {
                [SVProgressHUD showErrorWithStatus:reponse[@"message"]];
            }
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        [SVProgressHUD dismiss];
    }];
    
}

- (BOOL)isValidateEmail:(NSString *)Email
{
    NSString *emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
    return [emailTest evaluateWithObject:Email];
}
#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _userNameTextField) {
        [_emailTextField becomeFirstResponder];
    } else if (textField == _emailTextField){
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
