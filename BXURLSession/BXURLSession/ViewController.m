//
//  ViewController.m
//  BXURLSession
//
//  Created by bx_1512 on 16/1/13.
//  Copyright © 2016年 bx_1512. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *backgroundDownBtn;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
@property (weak, nonatomic) IBOutlet UIButton *sysDelegateFetchBtn;
@property (weak, nonatomic) IBOutlet UIButton *cusDelegateFetchBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *logStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *downloadIV;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.completionHandlerDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    self.progressView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  创建默认的 session
 */
- (void)initDefaultSession{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
}

/**
 *  创建使用系统代理的 session
 */
-(void)initDelegateFreeDefaultSession{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // iOS 默认缓存目录是相对于 ~/Library/Caches
    NSString *cachePath = @"/MyCacheDirectory";
    
    NSArray *myPathList = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *myPath = [myPathList objectAtIndex:0];
    
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *fullCachePath = [[myPath stringByAppendingPathComponent:bundleIdentifier] stringByAppendingPathComponent:cachePath];
    NSLog(@"Cache path: %@\n", fullCachePath);

    NSURLCache *myCache = [[NSURLCache alloc] initWithMemoryCapacity: 16384 diskCapacity: 268435456 diskPath: cachePath];
    defaultConfigObject.URLCache = myCache;
    defaultConfigObject.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    
    // 无代理，系统默认提供一个 completionBlock
    self.defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
}

/**
 *  创建后台 session
 */
-(NSURLSession *)createBackgroundSession {
    static NSURLSession *backgroundSession = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"xbx.BXURLSession.BGSession"];
        backgroundSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    });
    return backgroundSession;
}

#pragma mark - ----action
- (IBAction)sysDelegateFetch:(UIButton *)sender {
    [self initDelegateFreeDefaultSession];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [[self.defaultSession dataTaskWithURL: [NSURL URLWithString: @"https://www.baidu.com/"]
                        completionHandler:^(NSData *data, NSURLResponse *response,
                                            NSError *error) {
                            if (!error) {
                                NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                if (httpResp.statusCode == 200) {
                                    // 状态码 = 200 响应成功
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                        self.logStatusLabel.text = @"Got response status code 200";
                                    });
                                } else {
                                    // 处理其他状态码
                                    NSLog(@"Got response %@ with error %@.\n", response, error);
                                }
                            } else {
                                // 处理错误
                                NSLog(@"Got response %@ with error %@.\n", response, error);
                            }
                        }] resume];
}

- (IBAction)customDelegateFetch:(UIButton *)sender {
    [self initDefaultSession];
    NSURL *url = [NSURL URLWithString: @"https://www.baidu.com/"];
    NSURLSessionDataTask *dataTask = [self.defaultSession dataTaskWithURL: url];
    [dataTask resume];
}

- (IBAction)downLoad:(UIButton *)sender {
    [self initDefaultSession];
    self.progressView.hidden = NO;
    [self.downloadBtn setUserInteractionEnabled:NO];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSURL *url = [NSURL URLWithString: @"http://imgchr.com/images/p2303442368.jpg"];
    self.downloadTask = [self.defaultSession downloadTaskWithURL: url];
    
    [self.downloadTask resume];
}

- (IBAction)cancelDownload:(UIButton *)sender {
    if(self.downloadTask) {
        [self.downloadTask cancel];
        self.downloadTask = nil;
        [self.progressView setProgress:0.01 animated:YES];
        self.progressView.hidden = YES;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

- (IBAction)backgroundDown:(UIButton *)sender {
    self.progressView.hidden = NO;
    [self.backgroundDownBtn setUserInteractionEnabled:NO];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSURL *url = [NSURL URLWithString: @"http://imgchr.com/images/p2303442368.jpg"];
    NSURLSession *BGSession = [self createBackgroundSession];
    self.downloadTask = [BGSession downloadTaskWithURL: url];
    [self.downloadTask resume];
}

#pragma mark - ----public API
- (void)addCompletionHandler: (CompletionHandlerType)handler
                  forSession: (NSString *)identifier {
    if ([self.completionHandlerDictionary objectForKey: identifier]) {
        NSLog(@"Error: Got multiple handlers for a single session identifier.  This should not happen.\n");
    }
    
    [ self.completionHandlerDictionary setObject:handler forKey: identifier];
}

- (void)callCompletionHandlerForSession: (NSString *)identifier {
    CompletionHandlerType handler = [self.completionHandlerDictionary objectForKey: identifier];
    
    if (handler) {
        [self.completionHandlerDictionary removeObjectForKey: identifier];
        NSLog(@"Calling completion handler.\n");
        handler();
    }
}

#pragma mark - ----NSURLSession Delegate
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error {
    NSLog(@"didComplete with error %@.\n", error);
    self.logStatusLabel.text = @"Did Complete.";
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data{
    NSLog(@"didReceiveData %@.\n", data);
}

-(void)URLSession:(NSURLSession *)session
     downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    self.progressView.hidden = YES;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    //下载后保存文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *URLs = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsDirectory = URLs[0];
    NSURL *destinationPath = [documentsDirectory URLByAppendingPathComponent:[location lastPathComponent]];
    NSError *error;
    NSLog(@"%@",destinationPath);
    // 删除之前存在的文件，并把临时文件移到目的文件夹
    [fileManager removeItemAtURL:destinationPath error:NULL];
    BOOL success = [fileManager copyItemAtURL:location toURL:destinationPath error:&error];
    
    if (success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithContentsOfFile:[destinationPath path]];
            self.downloadIV.image = image;
            self.downloadIV.contentMode = UIViewContentModeScaleAspectFill;
            self.downloadIV.hidden = NO;
        });
    } else {
        NSLog(@"Couldn't copy the downloaded file");
    }
}

-(void)URLSession:(NSURLSession *)session
     downloadTask:(NSURLSessionDownloadTask *)downloadTask
     didWriteData:(int64_t)bytesWritten
totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    // 实时更新进度条
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.progressView setProgress:
         (double)totalBytesWritten /
         (double)totalBytesExpectedToWrite animated:YES];
    });
}

-(void)URLSession:(NSURLSession *)session
     downloadTask:(NSURLSessionDownloadTask *)downloadTask
didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes {
    NSLog(@"Session %@ download task %@ resumed at offset %lld bytes out of an expected %lld bytes.\n",
          session, downloadTask, fileOffset, expectedTotalBytes);
}

-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    NSLog(@"Background URL session %@ finished events.\n", session);
    if (session.configuration.identifier) {
        [self callCompletionHandlerForSession: session.configuration.identifier];
    }
}

@end
