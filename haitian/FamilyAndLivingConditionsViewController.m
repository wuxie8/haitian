//
//  FamilyAndLivingConditionsViewController.m
//  haitian
//
//  Created by Admin on 2017/6/21.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "FamilyAndLivingConditionsViewController.h"
#import "YLSOPickerView.h"
#import "LZCityPickerController.h"
static NSString *const family = @"婚姻情况";
@interface FamilyAndLivingConditionsViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation FamilyAndLivingConditionsViewController
{
    NSArray *arr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    arr=@[@"婚姻情况",@"所在城市",@"居住详细地址",@"户籍所在地"];

    UITableView *tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    tab.delegate=self;
    tab.dataSource=self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getValue:) name:family object:nil];

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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor whiteColor];
    cell.textLabel.text=arr[indexPath.row];
    UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(WIDTH-300, 0, 250, cell.frame.size.height)];
    textField.textAlignment=NSTextAlignmentRight;
    textField.placeholder=@"请选择";
    textField.delegate=self;
    textField.tag=1000+indexPath.row;
    [cell.contentView addSubview:textField];
    return cell;
    
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSArray *arr1=@[@"已婚",@"未婚",@"离异"];

    [self.view endEditing:YES];
    if (textField.tag-1000==0)        {
        YLSOPickerView *picker = [[YLSOPickerView alloc]init];
            picker.array=arr1;
            picker.title=family;
            
            
            [picker show];
            return NO;
    }
    else{
    
        {
            
            [LZCityPickerController showPickerInViewController:self selectBlock:^(NSString *address, NSString *province, NSString *city, NSString *area) {
                UITextField *text=[self.view viewWithTag:textField.tag];
                text.text=address;
                
                
                
            }];
            
            return NO;}
    }
            
    
    return YES;
}
-(void)getValue:(NSNotification *)notification
{
    
    
    UITextField *text=[self.view viewWithTag:1000+[arr indexOfObject:notification.name]];
    text.text=notification.object;
    
    //    [self.dic setObject:notification.object forKey:@"10"];
    
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
