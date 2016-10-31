//
//  MyViewController.m
//  BirdsProject
//
//  Created by yanm1 on 16/10/12.
//
//

#import "MyViewController.h"
#import "SetingViewController.h"
#import "ProfileViewController.h"
#import "MyBirdCell.h"
#import "BirdsDetailView.h"
#import "MyBirzamTableViewController.h"

@interface MyViewController ()
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (copy, nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) BirdsDetailView *birdView;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:LoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:LogoutNotification object:nil];
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    if ([df boolForKey:@"Login"]) {
        _nameLabel.text = [df valueForKey:@"username"];
    }
    [self downloadData];
}
- (void)login
{
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    _nameLabel.text = [df valueForKey:@"username"];
    [self downloadData];
}
- (void)logout
{
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    _nameLabel.text = @"My Birzam";
    [df setBool:NO forKey:@"Login"];
    [df setValue:nil forKey:@"username"];
    [df setValue:nil forKey:@"email"];
    [df synchronize];
}
- (IBAction)setButtonClick:(id)sender {
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    
    SetingViewController *setVC = [[SetingViewController alloc] init];
    setVC.isLogin = [df boolForKey:@"Login"];
    setVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setVC animated:YES];
}
- (IBAction)headerClick:(id)sender {
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    if (![df boolForKey:@"Login"]) {
        return;
    }
    ProfileViewController *pvc = [[ProfileViewController alloc] init];
    pvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pvc animated:YES];
    
}
- (IBAction)birzamBtnClick:(id)sender {
    MyBirzamTableViewController *mtbc = [[MyBirzamTableViewController alloc] init];
    mtbc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mtbc animated:YES];
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (BirdsDetailView *)birdView
{
    if (!_birdView) {
        _birdView = [[BirdsDetailView alloc] init];
        UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
        [window addSubview:_birdView];
    }
    return _birdView;
}
- (void)downloadData
{
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    if (![df boolForKey:@"Login"]) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@erpert_request_query", RootURL];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:[df valueForKey:@"email"]  forKey:@"email"];
    [parameters setValue:@"pending" forKey:@"status"];
    
    [SVProgressHUD show];
    [HTTPMethod requestURL:url parameters:parameters success:^(id reponse) {
        
        NSLog(@"%@", reponse);
        [SVProgressHUD dismiss];
        
        
        if ([reponse isKindOfClass:[NSDictionary class]]) {
            
            if ([reponse[@"record_list"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in reponse[@"record_list"]) {
                    if ([dic[@"latitude"] isKindOfClass:[NSNull class]] || [dic[@"longitude"] isKindOfClass:[NSNull class]]) {
                        continue;
                    }
                    [self.dataArray addObject:dic];
                }
                _countLabel.text = [NSString stringWithFormat:@"%@", @(self.dataArray.count)];
                [self.tableView reloadData];
            }
        }

    } failure:^(NSError *error) {
        
        NSLog(@"%@", error);
        [SVProgressHUD dismiss];
    }];
    
    
};
#pragma mark - tableView delegate
#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyBirdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyBirdCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyBirdCell" owner:self options:nil] firstObject];
    }
    [cell reloadCellWithDictionary:self.dataArray[indexPath.row]];
        
    // Configure the cell...
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.birdView.hidden = NO;
    self.birdView.dict = self.dataArray[indexPath.row];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
