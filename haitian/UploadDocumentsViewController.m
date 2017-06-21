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
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    arr=@[@"身份证正面照",@"手持身份证照片",@"房产证",@"机动车驾驶证"];
 
    
    UITableView *tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    tab.delegate=self;
    tab.dataSource=self;
    
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
    DLog(@"%ld",tap.view.tag);
    integer=tap.view.tag;

}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];

    UIImage *uploadImage                                     = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImageView *imageView=[self.view viewWithTag:integer];
    imageView.image=[UIImage imageNamed:@"UploadedSuccess"];
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
