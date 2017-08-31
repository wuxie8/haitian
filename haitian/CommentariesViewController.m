//
//  CommentariesViewController.m
//  haitian
//
//  Created by Admin on 2017/8/30.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "CommentariesViewController.h"
#import "AppraiseTableViewCell.h"
@interface CommentariesViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong, nonatomic)UIView*footView;

@end

@implementation CommentariesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"产品评论";
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-220)];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    [self getCommentList];
    [self.view addSubview:self.footView];
       // Do any additional setup after loading the view.
}
-(void)getCommentList{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       @"6",@"pid",
                       @"1",@"page",
                       @"10",@"page_size",
                       nil];
    [[NetWorkManager sharedManager]postNoTipJSON:@"http://app.jishiyu11.cn/index.php?g=app&m=comment&a=getList" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"0000"]) {
            NSArray *dataArray=[responseObject[@"code"] objectForKey:@"list"];
            DLog(@"%@",dataArray);

        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        
        
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
    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    return 120+[UtilTools getTextViewHeight:@"“共享男友”牌子上写着各种项目的标价，除了陪逛街、陪吃饭、陪看电影、陪去K歌，还有“拉手1元/次”“拥抱3元/次”“接吻7元/次”，甚至还有“在前男友前炫耀77元/次”。从标价中可以看出，“共享男友”不同于正常的男女恋爱，而是满足一部分没有异性朋友的需求，以无感情的近距离接触，甚至是肢体上接触，满足个人的虚荣心，或以不正当交友的方式，满足异性感官上和精神上的愉悦与享受。这其实都是很危险的。“共享男友”牌子上写着各种项目的标价，除了陪逛街、陪吃饭、陪看电影、陪去K歌，还有“拉手1元/次”“拥抱3元/次”“接吻7元/次”，甚至还有“在前男友前炫耀77元/次”。从标价中可以看出，“共享男友”不同于正常的男女恋爱，而是满足一部分没有异性朋友的需求，以无感情的近距离接触，甚至是肢体上接触，满足个人的虚荣心，或以不正当交友的方式，满足异性感官上和精神上的愉悦与享受。这其实都是很危险的。“共享男友”牌子上写着各种项目的标价，除了陪逛街、陪吃饭、陪看电影、陪去K歌，还有“拉手1元/次”“拥抱3元/次”“接吻7元/次”，甚至还有“在前男友前炫耀77元/次”。从标价中可以看出，“共享男友”不同于正常的男女恋爱，而是满足一部分没有异性朋友的需求，以无感情的近距离接触，甚至是肢体上接触，满足个人的虚荣心，或以不正当交友的方式，满足异性感官上和精神上的愉悦与享受。这其实都是很危险的。" font:[UIFont systemFontOfSize:13] width:WIDTH];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    static NSString *cell=@"cell";
    AppraiseTableViewCell *loancell=[tableView dequeueReusableCellWithIdentifier:cell];
    
    if (!loancell) {
        loancell=[[AppraiseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
        loancell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
    loancell.index=5;
    return loancell;
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
