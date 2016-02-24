//
//  ReachabilityViewController.m
//  aaa
//
//  Created by JoKy_Li on 16/2/24.
//  Copyright © 2016年 IVT. All rights reserved.
//

#import "ReachabilityViewController.h"
#import <RealReachability.h>

@interface ReachabilityViewController ()

@end

@implementation ReachabilityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self testReachability];
    
}
- (void)testReachability
{
    [GLobalRealReachability startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkChanged:) name:kRealReachabilityChangedNotification object:nil];
}

- (void)netWorkChanged:(NSNotification *)noti
{
    RealReachability *reachability = (RealReachability *)noti.object;
    //查询当前实际网络连接状态
    ReachabilityStatus status =[reachability currentReachabilityStatus];
    NSLog(@"currentStatus:%@",@(status));
    
    //触发实时网络状态查询
    [GLobalRealReachability reachabilityWithBlock:^(ReachabilityStatus status) {
        switch (status) {
            case NotReachable:
            {
                NSLog(@"NotReachable");
                break;
            }
            case ReachableViaWiFi:
            {
                NSLog(@"ReachableViaWiFi");
                break;
            }
            case ReachableViaWWAN:
            {
                NSLog(@"ReachableViaWWAN");
                break;
            }
            default:
                break;
        }
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
