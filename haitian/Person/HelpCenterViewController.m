//
//  HelpCenterViewController.m
//  haitian
//
//  Created by Admin on 2017/4/19.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "HelpCenterViewController.h"
#import "XDMultTableView.h"
@interface HelpCenterViewController ()<XDMultTableViewDatasource,XDMultTableViewDelegate>
@property(nonatomic, readwrite, strong)XDMultTableView *tableView;
@property(strong, nonatomic)UIView *headView;
@end

@implementation HelpCenterViewController
{
    NSArray *arr;
    NSArray *arr1;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"帮助中心";
     self.automaticallyAdjustsScrollViewInsets = NO;
 arr=@[@"申请一笔贷款需要多长时间？",@"如何申请贷款？",@"如何申请贷款成功率",@"贷款后如何还款",@"订单提交后可以修改吗？怎么取消订单？",@"为什么审核失败？"];
     arr1=@[@"从申请、审核到最终放款，大约需要一个星期的时间。",@"您可以通过搜索贷款产品，我们建议您先完善个人信息，完善个人信息有利于我们为您精准推荐贷款产品，您可以按需选择，并根据此贷款产品的要求填完资料并提交申请。",@"（1）您可以选择为您推介的产品，然后申请可有效提高成功率。\n（2) 数据表明：申请多个产品，可大幅提高贷款成功率。",@"根据贷款产品所属机构不同，还款方式也可能不同。有些机构会从您申请放款银行卡中按期扣收 ，有些机构会要求您在该机构的注册账号中按期储值进行还款。机构放款前会与您确认，请关注确认信息。",@"请金额、分期期数等订单信息一经提交无法修改，请您确认订单并核实无误后进行下单。",@"若您填写的个人资料不完整不真实、上传的照片模糊、有遮挡物等均会导致审核失败。"];
    _tableView = [[XDMultTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    _tableView.openSectionArray = [NSArray arrayWithObjects:@1,@2, nil];
    _tableView.delegate = self;
    _tableView.datasource = self;
    _tableView.tableViewHeader=self.headView;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];

    // Do any additional setup after loading the view.
}
-(UIView *)headView
{
    if (_headView==nil) {
        _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 20, 20)];
        image.image=[UIImage imageNamed:@"CommonProblems"];
        [_headView addSubview:image];
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image.frame)+10, 10, 100, 20)];
        lab.text=@"猜你想问";
        lab.textColor=AppButtonbackgroundColor;
        [_headView addSubview:lab];
    }
    return _headView;
}
#pragma mark - datasource
- (NSInteger)mTableView:(XDMultTableView *)mTableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (XDMultTableViewCell *)mTableView:(XDMultTableView *)mTableView
              cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [mTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text=arr1[indexPath.section];
    cell.textLabel.font=[UIFont systemFontOfSize:12];
    cell.textLabel.numberOfLines=0;
    cell.backgroundColor=kColorFromRGBHex(0xb6b6b6);
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(XDMultTableView *)mTableView{
    return 6;
}

-(NSString *)mTableView:(XDMultTableView *)mTableView titleForHeaderInSection:(NSInteger)section{
    return arr[section];
}

#pragma mark - delegate
- (CGFloat)mTableView:(XDMultTableView *)mTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UtilTools getTextHeight:arr1[indexPath.section] width:WIDTH/2 font:[UIFont systemFontOfSize:12]].height;
}

- (CGFloat)mTableView:(XDMultTableView *)mTableView heightForHeaderInSection:(NSInteger)section{
    return 60;
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
