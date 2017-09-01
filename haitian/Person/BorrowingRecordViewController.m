//
//  BorrowingRecordViewController.m
//  
//
//  Created by Admin on 2017/8/31.
//
//

#import "BorrowingRecordViewController.h"
#import "BorrowingRecordableViewCell.h"
#import "RecordMoedl.h"
@interface BorrowingRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong, nonatomic)    NSMutableArray *borrowMutableArray;
@property(strong, nonatomic)UIView *blankRecord;
@end

@implementation BorrowingRecordViewController
{
    UITableView * tab;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"借款记录";
    tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    tab.delegate=self;
    tab.dataSource=self;
    tab.backgroundColor=AppPageColor;
    [self.view addSubview:tab];
    [self getBorrowList];
    // Do any additional setup after loading the view.
}
-(void)getBorrowList{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       Context.currentUser.uid,@"uid",
                     
                       nil];
    [[NetWorkManager sharedManager]postNoTipJSON:[NSString stringWithFormat:@"%@&m=loanrecord&a=getList",SERVEREURL] parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"0000"]) {
            DLog(@"%@",responseObject);
            NSArray *array=responseObject[@"data"];
            if ([UtilTools isBlankArray:array]) {
                [self.view addSubview:self.blankRecord];
            }
            else{
                [self.blankRecord removeFromSuperview];
            for (NSDictionary *dic in  array) {
                RecordMoedl *recordMoed=[RecordMoedl new];
                [recordMoed setValuesForKeysWithDictionary:dic];
                [self.borrowMutableArray addObject:recordMoed];
            }
            [tab reloadData];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        
        
    }];

}
-(UIView *)blankRecord
{
    if (!_blankRecord) {
        _blankRecord=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        _blankRecord.backgroundColor=kColorFromRGBHex(0xf3f3f3);
        UIImageView *blankimage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH)];
        blankimage.image=[UIImage imageNamed:@"blank"];
        blankimage.contentMode=UIViewContentModeScaleAspectFit;
        blankimage.clipsToBounds=YES;
        [_blankRecord addSubview:blankimage];
        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(blankimage.frame), WIDTH-10*2, 150)];
        [button setImage:[UIImage imageNamed:@"Button"] forState:0];
        button.imageView.contentMode=UIViewContentModeScaleAspectFit;
        button.imageView.clipsToBounds=YES;
        [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        [_blankRecord addSubview:button];
    }
    return  _blankRecord;
}
-(void)click{
    
}
-(void)borrowingImmediately:(UIButton *)sender{
    DLog(@"%ld",(long)sender.tag);

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.borrowMutableArray.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordMoedl *recordModel=self.borrowMutableArray[indexPath.row];
    
    BorrowingRecordableViewCell *cell=[[BorrowingRecordableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.accessoryType =UITableViewCellAccessoryNone;
    cell.titleLabel.text=recordModel.pro_name;
    cell.amount_Label.text=[NSString stringWithFormat:@"借款金额:%@",recordModel.amount];
    cell.timeLimit_Label.text=[NSString stringWithFormat:@"借款期限:%@%@",recordModel.deadline,[recordModel.unit isEqualToString:@"1"]?@"天":@"月"];
    
    NSArray *timaArray=[recordModel.created_at componentsSeparatedByString:@" "];
    recordModel.created_at=[timaArray firstObject];
    cell.browsingTime_Label.text=[NSString stringWithFormat:@"浏览时间:%@",recordModel.created_at]
;
    cell.borrowingTime_Label.text=[NSString stringWithFormat:@"借款时间:%@",recordModel.created_at]
;
    [cell.image setImage:[UIImage imageNamed:@"iconLoading"]];
    [cell.but addTarget:self action:@selector(borrowingImmediately:) forControlEvents:UIControlEventTouchUpInside];
    cell.but.tag=1000+indexPath.row;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMG_PATH,recordModel.img]];
        UIImage * result;
        NSData * data = [NSData dataWithContentsOfURL:url];
        result = [UIImage imageWithData:data];
        dispatch_sync(dispatch_get_main_queue(), ^
                      {
                          [cell.image  setImage:result];
                          
                      });
    });

//    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMG_PATH,arr[indexPath.row]]];
//    UIImage * result;
//    NSData * data = [NSData dataWithContentsOfURL:url];
//    
//    result = [UIImage imageWithData:data];
//    
//    [cell.image setImage:result];
//    //    e.image=[UIImage imageNamed:arr[indexPath.row]];
//    cell.titleLabel.text=array[indexPath.row];
//    cell.post_hits_Label.text=amountarray[indexPath.row];
//    cell.feliv_Label.text=describearray[indexPath.row];
//    cell.backgroundColor=AppPageColor;
    return cell;
}
-(NSMutableArray *)borrowMutableArray
{
    if (!_borrowMutableArray) {
        _borrowMutableArray=[NSMutableArray array];
    }
    return  _borrowMutableArray;
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
