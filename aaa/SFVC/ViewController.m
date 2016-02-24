//
//  ViewController.m
//  aaa
//
//  Created by JoKy_Li on 16/2/2.
//  Copyright © 2016年 IVT. All rights reserved.
//

#import "ViewController.h"
#import <MBProgressHUD.h>
#import <AFNetworking.h>
#import <SafariServices/SafariServices.h>
#import "ReachabilityViewController.h"
@interface ViewController ()<SFSafariViewControllerDelegate>

- (IBAction)showSFSafari:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self testPod];
}

//SafariViewController
- (void)testSFSafariVC
{
    NSURL *url = [NSURL URLWithString:@"https://www.invasivecode.com"];
    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
    safariVC.delegate = self;
    [self presentViewController:safariVC animated:YES completion:nil];
    //[self showViewController:safariVC sender:nil];
}

//-(void)safariViewControllerDidFinish:(SFSafariViewController *)controller
//{
//    NSLog(@"DidFinish");
//    [controller dismissViewControllerAnimated:true completion:nil];
//}

- (void)testPod
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // 原本需要拼接get访问URL ? & =
    //NSDictionary *dict = @{@"format": @"json"};
    
    // 网络访问是异步的,回调是主线程的,因此程序员不用管在主线程更新UI的事情
    [manager GET:@"http://192.168.4.51/api/weather/getByCityName?cityName=%E5%8C%97%E4%BA%AC" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // NSLog(@"%@",responseObject);
        NSError *parseError = nil;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&parseError];
        
        NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", str);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showSFSafari:(id)sender {
    [self testSFSafariVC];
    //[self.navigationController pushViewController:[[ReachabilityViewController alloc]init] animated:YES];
}

@end
