//
//  OtherContactsViewController.m
//  haitian
//
//  Created by Admin on 2017/6/21.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "OtherContactsViewController.h"
#import "AddressVC.h"
@interface OtherContactsViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation OtherContactsViewController
{
    NSArray *arr;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(complete)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = backItem;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getList];
    arr=@[@"亲属／配偶姓名",@"手机号码",@"紧急联系人",@"手机号码"];
    
    UITableView *tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    tab.delegate=self;
    tab.dataSource=self;
    
    [self.view addSubview:tab];
    // Do any additional setup after loading the view.
}
-(void)getList
{
    NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:
                        Context.currentUser.uid,@"uid",
                        nil];
    [[NetWorkManager sharedManager]postJSON:[NSString stringWithFormat:@"%@&m=userdetail&a=other_list",SERVERE] parameters:dic2 success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"0000"]) {
            NSArray *array1=[[responseObject objectForKey:@"data"]objectForKey:@"data"];
            NSDictionary *dictionary=[array1 firstObject];
            if (![UtilTools isBlankString:dictionary[@"kinsfolk_name"]]) {
                UILabel *label=[self.view viewWithTag:100];
                label.text=dictionary[@"kinsfolk_name"];
            }
            if (![UtilTools isBlankString:dictionary[@"kinsfolk_mobile"]]) {
                UILabel *label=[self.view viewWithTag:101];
                label.text=dictionary[@"kinsfolk_mobile"];
            }
            if (![UtilTools isBlankString:dictionary[@"urgency_name"]]) {
                UILabel *label=[self.view viewWithTag:102];
                label.text=dictionary[@"urgency_name"];
            }
            if (![UtilTools isBlankString:dictionary[@"urgency_mobile"]]) {
                UILabel *label=[self.view viewWithTag:103];
                label.text=dictionary[@"urgency_mobile"];
            }
                   }
        else
        {
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        
        
    }];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor whiteColor];
    cell.textLabel.text=arr[indexPath.row];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH-100, 10, 100, cell.frame.size.height-20)];
    label.tag=100+indexPath.row;
    label.font=[UIFont systemFontOfSize:14];
    [cell.contentView addSubview:label];

    switch (indexPath.row) {
        case 0:
             case 2:
        {
            UIButton *but=[[UIButton alloc]initWithFrame:CGRectMake(WIDTH-200, 10, 80, cell.frame.size.height-20)];
            [but setTitle:@"快捷导入" forState:UIControlStateNormal];
            [but addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
            but.tag=1000+indexPath.row;
            [but setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [but.layer setMasksToBounds:YES];
            [but.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
            //边框宽度
            [but.layer setBorderWidth:1.0];
            but.layer.borderColor=[UIColor blueColor].CGColor;
            [cell.contentView addSubview:but];

        }
            break;
            
        default:
            break;
    }

    return cell;
}
-(void)butClick:(UIButton *)click
{
    AddressVC *address=[[AddressVC alloc]init];
    [address setClickBlock:^(PersonModel *person){

        if (click.tag==1000) {
                    UILabel *label=(UILabel *)[self.view viewWithTag:100];
            label.text=person.name1;
             UILabel *label1=(UILabel *)[self.view viewWithTag:101];
            label1.text=person.tel;
        }
        else{
            UILabel *label=(UILabel *)[self.view viewWithTag:102];
            label.text=person.name1;
            UILabel *label1=(UILabel *)[self.view viewWithTag:103];
            label1.text=person.tel;

        }

    }];
    [self.navigationController pushViewController:address animated:YES];
  


}
-(void)complete
{
    NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:
                        Context.currentUser.uid,@"uid",
                        [(UILabel *) [self.view viewWithTag:100] text],@"kinsfolk_name",
                        [(UILabel *) [self.view viewWithTag:101] text],@"kinsfolk_mobile",
                        [(UILabel *) [self.view viewWithTag:102] text],@"urgency_name",
                        [(UILabel *) [self.view viewWithTag:103] text],@"urgency_mobile",
                        
                        nil];
    [[NetWorkManager sharedManager]postJSON:[NSString stringWithFormat:@"%@&m=userdetail&a=other_add",SERVERE] parameters:dic2 success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"]isEqualToString:@"0000"]) {
            [MessageAlertView showSuccessMessage:@"上传成功"];
            if (self.clickBlock) {
                self.clickBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];

        }
        else
        {
            [MessageAlertView showErrorMessage:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        
        
    }];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
