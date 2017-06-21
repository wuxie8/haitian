//
//  WebViewController.m
//  haitian
//
//  Created by Admin on 2017/6/14.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"支付宝";
  UIWebView *  _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _webView.dataDetectorTypes = UIDataDetectorTypeAll;
    _webView.delegate = self;
    [self.view addSubview:_webView];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://oauth.taobao.com/authorize?response_type=token&client_id=23901088&state=1212&view=web"]];
    [_webView loadRequest:request];
    // Do any additional setup after loading the view.
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ( [[request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] containsString:@"access_token"]) {
        NSArray* array = [[request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] componentsSeparatedByString:@"&"];
        NSRange range = [array[0] rangeOfString:@"access_token="]; //现获取要截取的字符串位置
    __unused    NSString * result = [array[0] substringFromIndex:range.location+range.length]; //截取字符串
    }
    // click event
    if ([request.URL.host isEqualToString:@"call_close"])
    {// notify click close
        
        
        return NO;
    }
    
    if ([request.URL.host isEqualToString:@"on_click"])
    {
        NSString *URL_String = [request.URL.path substringFromIndex:1];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL_String]];
        
        
        return NO;
    }
    
    return YES;
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
