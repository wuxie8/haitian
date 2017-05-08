//
//  CreditSesameViewController.m
//  haitian
//
//  Created by Admin on 2017/5/8.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "CreditSesameViewController.h"

@interface CreditSesameViewController ()

@end

@implementation CreditSesameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"371102199303215716", @"IDCardNumber", @"吴公胜", @"userName",  nil];

//    // 创建网络请求管理对象
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    // 申明返回的结果是json类型
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    // 申明请求的数据是json类型
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    // 如果报接受类型不一致请替换一致text/html或别的
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
//    
//    [manager POST:URL parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        // ②芝麻信用SDK提供的方法，就是这么简单，就一行代码，搞定。（APP ID由公司给你，这个是固定的，写死就行）
//        // ②这里只要传三个参数就行，app id、sign、params，芝麻信用会返回给我们一个字典，在result中
//        [[ALCreditService sharedService] queryUserAuthReq:@"APP ID" sign:responseObject[@"sign"] params:responseObject[@"param"] extParams:nil selector:@selector(result:) target:self];
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
    // Do any additional setup after loading the view.
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
