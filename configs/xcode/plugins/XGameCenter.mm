//
//  XGameCenter.m
//  kp
//
//  Created by DreamTim on 12/7/15.
//  Copyright © 2015 cmjstudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XGameCenter.h"
#import "XConfig.h"
#import "UnityAppController.h"

@implementation XGameCenter

+ (instancetype)shareInstance {
    static XGameCenter *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[XGameCenter alloc] init];
    });
    return _instance;
}

#pragma mark - GKGameCenterViewController代理方法
-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 私有方法
- (void) openViewController:(UIViewController *)controller {
    UIViewController* viewController = GetAppController().rootViewController;
    [viewController presentViewController:controller animated:YES completion:nil];
}
#pragma mark 自己的方法
- (void)openGameCenter {
    if (![GKLocalPlayer localPlayer].isAuthenticated) {
        XLog(@"未获得用户授权.");
        return;
    }
    //Game Center视图控制器
    GKGameCenterViewController *gameCenterController=[[GKGameCenterViewController alloc]init];
    //设置代理
    gameCenterController.gameCenterDelegate=self;
    //显示
    [self openViewController:gameCenterController];
}

//检查是否经过认证，如果没经过认证则弹出Game Center登录界面
-(void)authorize {
    //创建一个本地用户
    GKLocalPlayer *localPlayer= [GKLocalPlayer localPlayer];
    //检查用于授权，如果没有登录则让用户登录到GameCenter(注意此事件设置之后或点击登录界面的取消按钮都会被调用)
    [localPlayer setAuthenticateHandler:^(UIViewController * controller, NSError *error) {
        if ([[GKLocalPlayer localPlayer] isAuthenticated]) {
            XLog(@"已授权.");
        } else {
            //注意：在设置中找到Game Center，设置其允许沙盒，否则controller为nil
            if (controller != nil) {
                //登录
                [self openViewController:controller];
            }
            else {
                XLog(@"在设置中找到Game Center，设置其允许沙盒");
            }
        }
    }];
}

//设置percent成就完成度，100代表获得此成就
-(void)addAchievementWithIdentifier:(NSString *)identifier percent:(double)value{
    if (![GKLocalPlayer localPlayer].isAuthenticated) {
        XLog(@"未获得用户授权.");
        return;
    }
    
    //创建成就
    GKAchievement *achievement = [[GKAchievement alloc]initWithIdentifier:identifier];
    achievement.percentComplete = value;
    
    //保存成就到Game Center服务器,注意保存是异步的,并且支持离线提交
    [GKAchievement reportAchievements:@[achievement] withCompletionHandler:^(NSError *error) {
        if(error){
            XLog(@"保存成就过程中发生错误,错误信息:%@",error.localizedDescription);
            return ;
        }
        XLog(@"添加成就成功.");
    }];
}

//排行榜
-(void)addScoreWithIdentifier:(NSString *)identifier score:(int64_t)value{
    if (![GKLocalPlayer localPlayer].isAuthenticated) {
        XLog(@"未获得用户授权.");
        return;
    }
    //创建积分对象
    GKScore *score = [[GKScore alloc]initWithLeaderboardIdentifier:identifier];
    //设置得分
    score.value=value;
    //提交积分到Game Center服务器端,注意保存是异步的,并且支持离线提交
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
        if(error){
            XLog(@"保存积分过程中发生错误,错误信息:%@",error.localizedDescription);
            return ;
        }
        XLog(@"添加积分成功.");
    }];
}

extern "C"
{
    //初始化
    void _InitGameCenter()
    {
        [[XGameCenter shareInstance] authorize];
    }
    
    //打开游戏中心
    void _OpenGameCenter()
    {
        [[XGameCenter shareInstance] openGameCenter];
    }
    
    //添加排行榜数据
    void _AddGameCenterScore(const char* id, int value)
    {
        [[XGameCenter shareInstance] addScoreWithIdentifier:PSTRING(id) score:value];
    }
    
    //添加成就
    void _AddGameCenterAchievement(const char* id, double percent)
    {
        [[XGameCenter shareInstance] addAchievementWithIdentifier:PSTRING(id) percent:percent];
    }
}
@end