//
//  CommentariesViewController.m
//  haitian
//
//  Created by Admin on 2017/8/30.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "CommentariesViewController.h"
#import "AppraiseTableViewCell.h"
#import "CommentModel.h"
@interface CommentariesViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong, nonatomic)UIView*footView;
@property(strong, nonatomic)    NSMutableArray *commentMutableArray;

@end

@implementation CommentariesViewController
{
    NSUInteger page_total;
    NSUInteger page;

}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [_tableView.mj_header beginRefreshing];
//
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"产品评论";
    page=1;
  _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-210-50-64)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.commentMutableArray =nil;
        page=1;
        // 进入刷新状态后会自动调用这个block
        [self getCommentList];
    }];
    [_tableView.mj_header beginRefreshing];
_tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    if (page<page_total) {
        page++;
        [self getCommentList];

    }
    else{
        [MessageAlertView showErrorMessage:@"没有更多评论"];
    }
    DLog(@"%lu",(unsigned long)page);


}];
    [_tableView.mj_header beginRefreshing];
    // 马上进入刷新状态
    [self.view addSubview:_tableView];
    [self.view addSubview:self.footView];
       // Do any additional setup after loading the view.
}
-(void)getCommentList{

    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       self.productModel.productID,@"pid",
                    [NSString stringWithFormat:@"%lu",(unsigned long)page],@"page",
                       @"10",@"page_size",
                       nil];
    [[NetWorkManager sharedManager]postNoTipJSON:@"http://app.jishiyu11.cn/index.php?g=app&m=comment&a=getList" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];

        if ([responseObject[@"code"] isEqualToString:@"0000"]) {
            NSArray *dataArray=[responseObject[@"data"] objectForKey:@"list"];
            DLog(@"%@",dataArray);
            for (NSDictionary *dic in dataArray) {
                CommentModel  *comment=[CommentModel new];
                [comment setValuesForKeysWithDictionary:dic];
                [self.commentMutableArray addObject:comment ];
            }
          page_total =[[responseObject[@"data"] objectForKey:@"page_total"] integerValue];
            DLog(@"%lu",(unsigned long)page_total);

            [_tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];

        
    }];

    
}
-(UIView *)footView{
    if (_footView==nil) {
        _footView=[[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-64-50-250, WIDTH, 50)];
        
        
        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
        [button addTarget:self action:@selector(writingEvaluation) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor=AppButtonbackgroundColor;
        [button setTitle:@"我要评价" forState:UIControlStateNormal];
        [_footView addSubview:button];
    }
    return _footView;
}
-(void)writingEvaluation{
    if (self.backblock) {
        self.backblock();
    }

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentMutableArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommentModel *comment=self.commentMutableArray[indexPath.row];
    
    return 120+    [UtilTools getTextViewHeight:comment.comment font:[UIFont systemFontOfSize:13] width:WIDTH];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    CommentModel *comment=self.commentMutableArray[indexPath.row];

    static NSString *cell=@"cell";
    AppraiseTableViewCell *loancell=[tableView dequeueReusableCellWithIdentifier:cell];
    
    if (!loancell) {
        loancell=[[AppraiseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
        loancell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
    [loancell setCommentModel:comment];
    return loancell;
}
-(NSMutableArray *)commentMutableArray
{
    if (!_commentMutableArray) {
        _commentMutableArray=[NSMutableArray array];
    }
    return  _commentMutableArray;
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
