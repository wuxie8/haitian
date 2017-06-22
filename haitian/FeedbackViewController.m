//
//  FeedbackViewController.m
//  haitian
//
//  Created by Admin on 2017/4/19.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "FeedbackViewController.h"
#import "TZAssetCell.h"
#import "TZTestCell.h"
#import "TZImagePickerController.h"
@interface FeedbackViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, TZImagePickerControllerDelegate>
@property(strong, nonatomic)NSMutableArray *selectedPhotos;
@end

@implementation FeedbackViewController
{
    UILabel *label;
    CGFloat _margin;
    CGFloat _itemWH;
    UICollectionView *_collectionView;
//    NSMutableArray *_selectedPhotos;//图片数据源
    UITextView *text1;
    UITextField *textField;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"意见反馈";
    
    
  text1=[[UITextView alloc]initWithFrame:CGRectMake(10, 10, WIDTH-20, 300)];
    text1.backgroundColor=[UIColor whiteColor];
    text1.delegate=self;
    
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(text1.frame)-60, 40, 40)];
    
    
    [text1 addSubview:imageView];
    
    
    NSString *textplaceholder=@"请详细描述您的问题或建议，我们将及时跟进解决。（可以添加相关问题的截图）";
    CGSize size=[UtilTools getTextHeight:textplaceholder width:WIDTH-40 font:[UIFont systemFontOfSize:12]];
    label=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, WIDTH-60, size.height)];
  
    label.text=textplaceholder;
    label.numberOfLines=0;
    label.font=[UIFont systemFontOfSize:12];
    label.textColor=kColorFromRGBHex(0xb6b6b6);
    [text1 addSubview:label];
    
    
    textField=[[UITextField alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(text1.frame)+20, WIDTH-20, 60 )];
    textField.backgroundColor=[UIColor whiteColor];
    textField.placeholder=@"请填写手机号/邮箱(选填,方便我们联系您)";
    [self.view addSubview:textField];
    
    [self.view addSubview:text1];
    
    [self configCollectionView];
    
    UIButton *but=[[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(textField.frame)+20, WIDTH-20, 40)];
    [but setTitle:@"提交" forState:UIControlStateNormal];
    but.backgroundColor=AppButtonbackgroundColor;
     but.clipsToBounds=YES;
     but.layer.cornerRadius=10;
    [but addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    
}
#pragma mark - 添加相册图片
- (void)configCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _margin = 10;
    _itemWH = (WIDTH - _margin*6) / 4 - _margin;
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(_margin, CGRectGetMaxY(text1.frame)-(_itemWH+20)-5, WIDTH- 4 * _margin, _itemWH+20) collectionViewLayout:layout];
    CGFloat rgb = 255 / 255.0;
    _collectionView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    _collectionView.contentInset = UIEdgeInsetsMake(4, 0, 0, 2);
    
    _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -2);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.alpha = 1;
    _collectionView.scrollEnabled=NO;
        [text1 addSubview:_collectionView];
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
}
#pragma mark UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.selectedPhotos.count>=3) {
        return self.selectedPhotos.count;
    }
    return self.selectedPhotos.count + 1;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    if (indexPath.row == (_selectedPhotos.count)&&_selectedPhotos.count!=3) {
        
        cell.imageView.image = [UIImage imageNamed:@"UploadPhotos"];
    } else {
         cell.imageView.image = _selectedPhotos[indexPath.row];
    }
    
    if (indexPath.row == _selectedPhotos.count) {
        [cell.btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }else{
        [cell.btn setBackgroundImage:[UIImage imageNamed:@"DeleteImage"] forState:UIControlStateNormal];
        cell.btn.tag = indexPath.row;
        [cell.btn addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedPhotos.count) [self pickPhotoButtonClick];
}

- (void)deletePhoto:(UIButton *)but
{
    [_selectedPhotos removeObjectAtIndex:but.tag];
    [_collectionView reloadData];
    
//    if (_selectedPhotos.count==0) {
//        _collectionView.alpha = 0;
//    }
}
#pragma mark Click Event

- (void)pickPhotoButtonClick {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3 delegate:self];
    
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
        
        _collectionView.alpha = 1;
        
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
// 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets{
    [_selectedPhotos addObjectsFromArray:photos];
    if (_selectedPhotos.count>3) {
        [MessageAlertView showErrorMessage:@"您最多添加3张"];
        _selectedPhotos = [[_selectedPhotos subarrayWithRange:NSMakeRange(0, 3)] mutableCopy];
    }
    
//    [self resetWidgetHeight];
    [_collectionView reloadData];
}
-(void)submit
{
   
    if ([UtilTools isBlankString:text1.text]) {
        [MessageAlertView showErrorMessage:@"请输入问题"];
        return;
    }
   
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       Context.currentUser.uid,@"user_id",
                       text1.text,@"problem",
                       nil];
    NSMutableDictionary *dic1=[NSMutableDictionary dictionaryWithDictionary:dic];
    if (![UtilTools isBlankString:textField.text]) {
        if ([textField.text containsString:@"@"]) {
            [dic1 setObject:textField.text forKey:@"email"];
        }
        else{
            [dic1 setObject:textField.text forKey:@"mobile"];

        }
    }
    
 
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@&m=feedback&a=postAdd",UploadPath]parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (UIImage *image in _selectedPhotos) {
            //根据当前系统时间生成图片名称
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            NSString *dateString = [formatter stringFromDate:date];
            NSString *  _headfileName = [NSString stringWithFormat:@"%@.png",dateString];
       NSData *     _headImageData = UIImageJPEGRepresentation(image, 1);
            [formData appendPartWithFileData:_headImageData name:@"photo" fileName:_headfileName mimeType:@"image/jpg/png/jpeg"];

        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([resultDic[@"code"]isEqualToString:@"0000"]) {
            [MessageAlertView showSuccessMessage:@"提交成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [MessageAlertView showErrorMessage:resultDic[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];

   
}
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
       label.hidden = NO;
    }else{
        label.hidden = YES;
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
        
    }
    
    return YES;    
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.view endEditing:YES];
}

#pragma mark 懒加载
-(NSMutableArray *)selectedPhotos
{
    if (_selectedPhotos==nil) {
        _selectedPhotos=[NSMutableArray array];
    }
    return _selectedPhotos;
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
