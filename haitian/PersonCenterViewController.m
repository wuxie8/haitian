//
//  PersonCenterViewController.m
//  haitian
//
//  Created by Admin on 2017/4/12.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "PersonCenterViewController.h"

@interface PersonCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong, nonatomic)UIView *headView;
@end

@implementation PersonCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"个人中心";
    self.view.backgroundColor=[UIColor whiteColor];
    UITableView *tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    tab.delegate=self;
    tab.dataSource=self;
    [self.view addSubview:tab];
    // Do any additional setup after loading the view.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return  6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text=@"个人资料";
    return cell;
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
