//
//  XAnalytics.mm
//  Unity-iPhone
//
//  Created by HQ on 14-1-7.
//
//

#import "XAnalytics.h"
#import "XConfig.h"
#import <FirebaseCore/FIRApp.h>

@implementation XAnalytics

XCLASS_INSTANCE(XAnalytics)

extern "C"
{
    //初始化
    void _InitAnalytics()
    {
        [FIRApp configure];
    }
}

@end
