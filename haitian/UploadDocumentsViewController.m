//
//  UploadDocumentsViewController.m
//  haitian
//
//  Created by Admin on 2017/6/21.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "UploadDocumentsViewController.h"

@interface UploadDocumentsViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate>




@end

@implementation UploadDocumentsViewController
{
    NSArray *arr;
    NSArray *array;
    NSInteger integer;
    NSMutableDictionary *mutableDictionary;
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
    
    arr=@[@"身份证正面照",@"手持身份证照片",@"房产证",@"机动车驾驶证"];
    mutableDictionary=[NSMutableDictionary dictionary];
    [self getList];
    UITableView *tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    tab.delegate=self;
    tab.dataSource=self;
    
    [self.view addSubview:tab];
    // Do any additional setup after loading the view.
}
-(void)getList
{
    NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:
                        Context.currentUser.uid,@"uid",
                        nil];
    [[NetWorkManager sharedManager]postNoTipJSON:[NSString stringWithFormat:@"%@&m=userdetail&a=parpers_list",SERVERE] parameters:dic2 success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"0000"]) {
            NSArray *array1=[[responseObject objectForKey:@"data"]objectForKey:@"data"];
            NSDictionary *dictionary=[array1 firstObject];
            if (![UtilTools isBlankString:dictionary[@"idcard_front"]]) {
                UIImageView *imageView=[self.view viewWithTag:1000];
                imageView.image=[UIImage imageNamed:@"UploadedSuccess"];
            }
            if (![UtilTools isBlankString:dictionary[@"idcard"]]) {
                UIImageView *imageView=[self.view viewWithTag:1001];
                imageView.image=[UIImage imageNamed:@"UploadedSuccess"];
            }
            if (![UtilTools isBlankString:dictionary[@"house_card"]]) {
                UIImageView *imageView=[self.view viewWithTag:1002];
                imageView.image=[UIImage imageNamed:@"UploadedSuccess"];
            }
            if (![UtilTools isBlankString:dictionary[@"driving_card"]]) {
                UIImageView *imageView=[self.view viewWithTag:1003];
                imageView.image=[UIImage imageNamed:@"UploadedSuccess"];
            }
        }
        else
        {
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        
        
    }];
    
    
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
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor whiteColor];
    cell.textLabel.text=arr[indexPath.row];
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(WIDTH-200, 5, 180, cell.frame.size.height-10)];
    image.image=[UIImage imageNamed:@"UploadDocuments"];
    image.tag=1000+indexPath.row;
    image.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
    [image addGestureRecognizer:tap];
    [cell.contentView addSubview:image];
    return cell;
    
    
}
-(void)imageTap:(UITapGestureRecognizer *)tap
{
    
    UIAlertController *alertController                 = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *cancelAction                        = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *albumAction                         = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
        //设定图片的来源，设定的是设备的照片库
        
        UIImagePickerController *imagePickerController     = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType                   = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.allowsEditing                = YES;
        //绑定委托对象以便选取照片之后执行的方法
        imagePickerController.delegate                     = self;
        //显示图片拾取器
        [self presentViewController:imagePickerController animated:NO completion:nil];
    }
                                                          ];
    UIAlertAction *cameraAction                        = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *imagePickerController     = [[UIImagePickerController alloc] init];
            imagePickerController.sourceType                   = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.allowsEditing                = YES;
            imagePickerController.delegate                     = self;
            [self presentViewController:imagePickerController animated:NO completion:nil];
            
        }
        else
            [[[UIAlertView alloc] initWithTitle:nil message:@"没有相机功能" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"YES", nil] show];
    }
                                                          
                                                          ];
    [alertController addAction:cameraAction];
    [alertController addAction:cancelAction];
    [alertController addAction:albumAction];
    [self presentViewController:alertController animated:NO completion:nil];
    integer=tap.view.tag;

}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];

    UIImage *uploadImage                                     = [info objectForKey:UIImagePickerControllerOriginalImage];
    [mutableDictionary setObject:uploadImage forKey:[NSString stringWithFormat:@"%ld",(long)integer]];
    UIImageView *imageView=[self.view viewWithTag:integer];
    imageView.image=[UIImage imageNamed:@"UploadedSuccess"];
}
-(void)complete
{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       Context.currentUser.uid,@"uid",
                       nil];
    
    if ([UtilTools isBlankArray:[mutableDictionary allValues]]) {
        [MessageAlertView showErrorMessage:@"请上传证件"];
        return ;
    }
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@&m=userdetail&a=parpers_add",UploadPath]parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
//        for (UIImage *image in [mutableDictionary allValues]) {
//            //根据当前系统时间生成图片名称
//            NSDate *date = [NSDate date];
//            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//            [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
//            NSString *dateString = [formatter stringFromDate:date];
//            NSString *  _headfileName = [NSString stringWithFormat:@"%@.png",dateString];
//            NSData *     _headImageData = UIImageJPEGRepresentation(image, 0.1);
//            [formData appendPartWithFileData:_headImageData name:@"photo1" fileName:_headfileName mimeType:@"image/jpg/png/jpeg"];
//            
//        }
       
        for (NSString *string in [mutableDictionary allKeys]) {
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        NSString *dateString = [formatter stringFromDate:date];
        NSString *  _headfileName = [NSString stringWithFormat:@"%@.png",dateString];
            UIImage *image=(UIImage *)[mutableDictionary objectForKey:string];

            NSData * _headImageData = UIImageJPEGRepresentation(image, 0.1);
            NSString *nameString=[NSString stringWithFormat:@"photo%d",[string intValue]-999] ;
            DLog(@"%@",nameString);

            
        [formData appendPartWithFileData:_headImageData name:nameString fileName:_headfileName mimeType:@"image/jpg/png/jpeg"];
//            [formData appendPartWithFileData:_headImageData name:[NSString stringWithFormat:@"photot%d",[string intValue]-999] fileName:_headfileName mimeType:@"image/jpg/png/jpeg"];

            
        }
//
    } progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

        if ([resultDic[@"code"]isEqualToString:@"0000"]) {
            [MessageAlertView showSuccessMessage:@"提交成功"];
            if (self.clickBlock) {
                self.clickBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [MessageAlertView showErrorMessage:resultDic[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error);

    }];
    

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
