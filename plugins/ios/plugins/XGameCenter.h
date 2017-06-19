//
//  XGameCenter.h
//  kp
//
//  Created by DreamTim on 12/7/15.
//  Copyright © 2015 cmjstudio. All rights reserved.
//

#ifndef XGameCenter_h
#define XGameCenter_h
#import <GameKit/GameKit.h>

@interface XGameCenter : NSObject<GKGameCenterControllerDelegate>

+ (instancetype)shareInstance;

- (void)openGameCenter;
- (void)authorize;

//成就接口，其中value[0-100],100表示完成了此成就
-(void)addAchievementWithIdentifier:(NSString *)identifier percent:(double)value;
//排行榜分数接口
-(void)addScoreWithIdentifier:(NSString *)identifier score:(int64_t)value;
@end

#endif /* XGameCenter_h */
