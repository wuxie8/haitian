//
//  AddEvaluationViewController.m
//  haitian
//
//  Created by Admin on 2017/8/30.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "AddEvaluationViewController.h"
#import "ZJD_StarEvaluateView.h"

@interface AddEvaluationViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong, nonatomic)UIView*footView;

@end

@implementation AddEvaluationViewController
{
    NSArray *arr;
    UITextView *text1;
    UILabel *label;
    NSInteger score;
    NSInteger type;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"评价";
    arr=@[@"用户状态",@"描述相符"];
    type=1;
    score=5;
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-220)];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.backgroundColor=BaseColor;
    tableView.tableFooterView=self.footView;
    [self.view addSubview:tableView];
    
   

    // Do any additional setup after loading the view.
}
-(UIView *)footView{
    if (_footView==nil) {
        _footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 400)];

        
        text1=[[UITextView alloc]initWithFrame:CGRectMake(10, 10, WIDTH-20, 200)];
        text1.backgroundColor=[UIColor whiteColor];
        text1.delegate=self;
        text1.font=[UIFont systemFontOfSize:14];
        text1.returnKeyType=UIReturnKeyDone;
        NSString *textplaceholder=@"请详细描述您的问题或建议，我们将及时跟进解决。";
        CGSize size=[UtilTools getTextHeight:textplaceholder width:WIDTH-40 font:[UIFont systemFontOfSize:14]];
        label=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, WIDTH-60, size.height)];
        
        label.text=textplaceholder;
        label.numberOfLines=0;
        label.font=[UIFont systemFontOfSize:14];
        label.textColor=kColorFromRGBHex(0xb6b6b6);

        [text1 addSubview:label];
        
        [_footView addSubview:text1];
        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(text1.frame)+100, WIDTH-40, 50)];
        button.layer.cornerRadius=10;
        button.clipsToBounds=YES;
        [button addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor=AppButtonbackgroundColor;
        [button setTitle:@"提交" forState:UIControlStateNormal];
        [_footView addSubview:button];
    }
    return _footView;
}
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        label.hidden = NO;
    }else{
        label.hidden = YES;
    }
    //字数限制操作
    if (textView.text.length >= 100) {
        [MessageAlertView showErrorMessage:@"不能超过100个字"];
        textView.text = [textView.text substringToIndex:100];
        
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    
    [textField resignFirstResponder];
    
    return YES;
    
}
-(void)nextStep{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       Context.currentUser.uid,@"uid",
                       self.productModel.productID,@"pid",
                       text1.text,@"comment",
                       [NSString stringWithFormat:@"%ld",(long)score],@"score",

                       [NSString stringWithFormat:@"%ld",(long)type],@"type",

                       nil];
    [[NetWorkManager sharedManager]postNoTipJSON:@"http://app.jishiyu11.cn/index.php?g=app&m=comment&a=postAdd" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"0000"]) {
            if (self.refreshblock) {
                self.refreshblock();
            }
            [self.navigationController popViewControllerAnimated:NO];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        
        
    }];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    static NSString *cell=@"cell";
    UITableViewCell *loancell=[tableView dequeueReusableCellWithIdentifier:cell];
    
    if (!loancell) {
        loancell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
        loancell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
    
loancell.textLabel.text=arr[indexPath.row];
    
    if (indexPath.row==0) {
        for (int i=0; i<2; i++) {
            UIButton *but=[[UIButton alloc]initWithFrame:CGRectMake(120+(70+30)*i, 22, 70, 26)];
            but.tag=1000+i;
            if (i==0) {
                [but setBackgroundImage:[UIImage imageNamed:@"Lending"] forState:0];
                [but setBackgroundImage:[UIImage imageNamed:@"LendingHighted"] forState:UIControlStateSelected];
                but.selected=YES;
            }
            else{
                [but setBackgroundImage:[UIImage imageNamed:@"NotLending"] forState:0];
                [but setBackgroundImage:[UIImage imageNamed:@"NotLendingHighted"] forState:UIControlStateSelected];
                but.selected=NO;

            }
            but.imageView.contentMode=UIViewContentModeScaleAspectFit;
            but.imageView.clipsToBounds=YES;
            [but addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            [loancell.contentView addSubview:but];
        }
        
    }
    else{
        CGFloat LeftPadding = 100;
        NSInteger index = 5;
        CGFloat starWidth = 25;
        CGFloat space = 20;
        BOOL isCanTap = YES;
        
        ZJD_StarEvaluateView *starView = [[ZJD_StarEvaluateView alloc] initWithFrame:CGRectMake(LeftPadding, 22, self.view.width - LeftPadding, 26) starIndex:index starWidth:starWidth space:space defaultImage:nil lightImage:nil isCanTap:isCanTap];
        starView.starEvaluateBlock = ^(ZJD_StarEvaluateView * starView, NSInteger starIndex){
            score=starIndex;
            
        };
        [loancell.contentView addSubview:starView];
    }
    return loancell;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
        
    }
    // 不让输入表情
        if ([textView isFirstResponder]) {
                if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textView textInputMode] primaryLanguage]) {
                      return NO;
                    }
            }
    return YES;
    
}

-(void)click:(UIButton *)sender{
    UIButton *but1=(UIButton *)[self.view viewWithTag:1000];
    UIButton *but2=(UIButton *)[self.view viewWithTag:1001];

    if (sender.tag==1000) {
        but1.selected=YES;
        but2.selected=NO;
        type=1;
    }
    else{
        but2.selected=YES;
        but1.selected=NO;
        type=0;
    }
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
