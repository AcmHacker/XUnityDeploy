
#import "XAlbumCameraController.h"
#import "XConfig.h"

//转
//http://blog.csdn.net/anyuanlzh/article/details/50748928

@implementation XAlbumCameraController

- (void)showPicker:
(UIImagePickerControllerSourceType)type
     allowsEditing:(BOOL)flag
{
    XLog(@" --- showPicker!!");
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = type;
    picker.allowsEditing = flag;
    
    [self presentViewController:picker animated:YES completion:nil];
}

// 打开相册后选择照片时的响应方法
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    XLog(@" --- imagePickerController didFinishPickingMediaWithInfo!!");
    // Grab the image and write it to disk
    UIImage *image;
    UIImage *image2;
//    image = [info objectForKey:UIImagePickerControllerEditedImage];
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIGraphicsBeginImageContext(CGSizeMake(256,256));
    [image drawInRect:CGRectMake(0, 0, 256, 256)];
    image2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 得到了image，然后用你的函数传回u3d
    NSData *imgData;
    if(UIImagePNGRepresentation(image2) == nil)
    {
        XLog(@" --- actionSheet slse!! 11 ");
        imgData= UIImageJPEGRepresentation(image, .6);
    }
    else
    {
        XLog(@" --- actionSheet slse!! 22 ");
        imgData= UIImagePNGRepresentation(image2);
    }
    
    NSString *path = [self saveWithData:imgData];
    XLog(@"path : %@", path);
    
    UnitySendMessage( "GameManager", "OnReceivePhoto", path.UTF8String);
    
    // 关闭相册
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// 打开相册后点击“取消”的响应
- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    XLog(@" --- imagePickerControllerDidCancel !!");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *) saveWithData:(NSData *)data {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *homePath = [paths objectAtIndex:0];
    NSString *filePath = [homePath stringByAppendingPathComponent:@"tmp.png"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        XLog(@"FileExists");
    }
    else {
        XLog(@"FileNotExists");
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    
    NSFileHandle* fhw=[NSFileHandle fileHandleForWritingAtPath:filePath];
    [fhw truncateFileAtOffset:0];
    
    [fhw writeData:data];
    [fhw closeFile];
    
    return filePath;
}

+(void) saveImageToPhotosAlbum:(NSString*) readAdr
{
    XLog(@"readAdr: %@", readAdr);
    UIImage* image = [UIImage imageWithContentsOfFile:readAdr];
    UIImageWriteToSavedPhotosAlbum(image,
                                   self,
                                   @selector(image:didFinishSavingWithError:contextInfo:),
                                   NULL);
}

+(void) image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    NSString* result;
    if(error)
    {
        result = @"图片保存到相册失败!";
    }
    else
    {
        result = @"图片保存到相册成功!";
    }
    XLog(@"result : %@", result);
//    UnitySendMessage( "GameManager", "OnReceivePhoto", result.UTF8String);
}
@end

extern "C"
{
    void _TakePhoto() {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            XAlbumCameraController * app = [[XAlbumCameraController alloc] init];
            UIViewController *vc = UnityGetGLViewController();
            [vc.view addSubview: app.view];
            
            [app showPicker:UIImagePickerControllerSourceTypePhotoLibrary allowsEditing:NO];
        }
        else
        {
            UnitySendMessage( "GameManager", "OnReceivePhoto", "");
        }
    }
}
