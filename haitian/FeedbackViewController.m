//
//  FeedbackViewController.m
//  haitian
//
//  Created by Admin on 2017/4/19.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController
{
    UILabel *label;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"意见反馈";
    
    
    UITextView *text=[[UITextView alloc]initWithFrame:CGRectMake(10, 10, WIDTH-20, 400)];
    text.backgroundColor=[UIColor whiteColor];
    text.delegate=self;
    label=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, WIDTH-40, 100)];
    label.text=@"请详细描述您的问题或建议，我们将及时跟进解决。（可以添加相关问题的截图）";
    label.numberOfLines=0;
    label.font=[UIFont systemFontOfSize:12];
    label.textColor=kColorFromRGBHex(0xb6b6b6);
    [text addSubview:label];
    
    
    UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(text.frame), WIDTH-20, 30  )];
    textField.placeholder=@"请填写手机号／邮箱（选填，方便我们联系您）";
    [self.view addSubview:textField];
    
    [self.view addSubview:text];
    
    
    // Do any additional setup after loading the view.
}
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
       label.hidden = NO;
    }else{
        label.hidden = YES;
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
