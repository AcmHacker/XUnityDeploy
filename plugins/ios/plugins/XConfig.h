//
//  XConfig.h
//  Unity-iPhone
//
//  Created by DreamTim on 5/23/14.
//
//

#ifndef Unity_iPhone_XConfig_h
#define Unity_iPhone_XConfig_h

#define ALog(format, ...) NSLog((@"%s [L%d] " format), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

//#ifndef RELEASE
//#define XLog(format, ...) ALog(format, ##__VA_ARGS__)
//#else
//#define XLog(...)
//#endif
#ifndef RELEASE
#define XLog(format, ...)
#else
#define XLog(...)
#endif

#define PSTRING(str) [NSString stringWithUTF8String:str]
#define PSTRING2(value) [NSString stringWithFormat:@"%@", value]

//注册class
#define XREGIST_CLASS(ClassNameInstance)	\
@implementation XPlatform (XPlatformImpl)  \
- (void) initCreate  \
{ \
    ClassNameInstance; \
} \
@end \

//定义shareInstance
#define XSHARE_INSTANCE()  \
+ (instancetype)shareInstance;

//定义init(这个可以不用c#层调用，就可以init)
#define XCALL_INIT(ClassName) \
static ClassName* _instance = [ClassName shareInstance];

//类单例的宏
#define XCLASS_INSTANCE(ClassName) \
+ (instancetype)shareInstance \
{ \
    static ClassName *_kshareInstance = nil; \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _kshareInstance = [[ClassName alloc] init]; \
        [_kshareInstance initCreate]; \
    }); \
    return _kshareInstance; \
}

#endif
