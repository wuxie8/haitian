//
//  SetUpViewController.m
//  haitian
//
//  Created by Admin on 2017/5/31.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "SetUpViewController.h"
#import "AboutUsViewController.h"
#import "ForgotPasswordViewController.h"
#import "LoginViewController.h"
#import <JPUSHService.h>
@interface SetUpViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SetUpViewController
{
    NSArray *arr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"设置";
   arr=@[@"关于我们",@"修改密码",@"安全退出"];
    UITableView *tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    tab.delegate=self;
    tab.dataSource=self;
    tab.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:tab];
    // Do any additional setup after loading the view.
}
//几个  section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arr.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return  60;
}
//对应的section有多少row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text=arr[indexPath.section];
    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;

    return  cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    switch (indexPath.section) {
        case 0:
            [self.navigationController pushViewController:[AboutUsViewController new] animated:YES];

            break;
        case 1:
            [self.navigationController pushViewController:[ForgotPasswordViewController new] animated:YES];
            
            break;
        case 2:
        {
            [self.navigationController pushViewController:[LoginViewController new] animated:YES];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kIsLogin"];
            Context.currentUser = nil;
            //用户信息归档
            [NSKeyedArchiver archiveRootObject:Context.currentUser toFile:DOCUMENT_FOLDER(@"loginedUser")];
            
            [JPUSHService setAlias:@"" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];

        }
            break;
        default:
            break;
    }
}
- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    
    
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
