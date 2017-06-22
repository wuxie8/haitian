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
    
    arr=@[@"亲属／配偶姓名",@"手机号码",@"紧急联系人",@"手机号码"];
    
    UITableView *tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    tab.delegate=self;
    tab.dataSource=self;
    
    [self.view addSubview:tab];
    // Do any additional setup after loading the view.
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
    label.text=@"sdjns";
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
        // remove the transform animation if the animation finished and wasn't interrupted
//        UITextField *textField=(UITextField *)[self.view viewWithTag:1002];
//        textField.text=tel;
        DLog(@"%@",person.name1);
        DLog(@"%@",person.tel);
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
