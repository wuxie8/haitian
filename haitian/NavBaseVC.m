//
//  NavBaseVC.m
//  xiaoyixiu
//
//  Created by 柯南 on 16/6/13.
//  Copyright © 2016年 柯南. All rights reserved.
//

#import "NavBaseVC.h"

@interface NavBaseVC ()

@end

@implementation NavBaseVC

- (void)setTitle:(NSString *)title
{
    self.navigationItem.title = title;
     self.view.backgroundColor=BaseColor;
}

#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}
#endif

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self]; //移除通知
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[self.navigationController viewControllers] count] == 1) {
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.leftBarButtonItem = nil;
    }
    else
    {
        UIButton *backButton = [[UIButton alloc] init];
        backButton.frame = CGRectMake(0, 0, 25, 34);
        [backButton setImage:[UIImage imageNamed:@"Back"] forState:UIControlStateNormal];
        [backButton addTarget: self action: @selector(backAction) forControlEvents: UIControlEventTouchUpInside];
        [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = backItem;
    }
    
    self.upSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(backAction)];
    [self.upSwipe setDirection: UISwipeGestureRecognizerDirectionRight];
    [self.upSwipe setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:self.upSwipe];
}

- (void)backAction
{
    if ([self.navigationController.viewControllers count]>1) {
 
        [self.navigationController popViewControllerAnimated:NO];
    }
}

@end
