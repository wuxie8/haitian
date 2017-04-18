//
//  CertificationViewController.m
//  haitian
//
//  Created by Admin on 2017/4/18.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "CertificationViewController.h"

@interface CertificationViewController ()

@end

@implementation CertificationViewController
{
    int integer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"资料提交";
    integer=1;
    UIImageView *iamge=[[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 20)];
    iamge.image=[UIImage imageNamed:@"LoadSupermarket"];
    iamge.highlightedImage=[UIImage imageNamed:@"LoadSupermarketHeight"];
    [self.view addSubview:iamge];
    
    UIImageView *iamge2=[[UIImageView alloc]initWithFrame:CGRectMake(100, 300, 100, 20)];
    iamge2.image=[UIImage imageNamed:@"LoadSupermarket"];
    iamge2.highlightedImage=[UIImage imageNamed:@"LoadSupermarketHeight"];
    [self.view addSubview:iamge2];
    
    UIButton *but=[[UIButton alloc]initWithFrame:CGRectMake(100, 500, 100, 100)];
    but.backgroundColor=[UIColor redColor];
    [but addTarget:self action:@selector(setHetght) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    // Do any additional setup after loading the view.
}
-(void)setHetght
{
    integer=integer<self.view.subviews.count?integer:(int)self.view.subviews.count;
    for (int i =0; i<integer; i++) {
        UIImageView *image=self.view.subviews[i];
        image.highlighted=YES;
    }
    integer++;
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
