//
//  BBHotfix.m
//  BBHotfix
//
//  Created by Gary on 3/18/16.
//  Copyright © 2016 Gary. All rights reserved.
//

#import "BBHotfix.h"
#import <JSPatch/JPEngine.h>
#import <AFNetworking/AFNetworking.h>
#import "RegisterApp.h"
#import "SyncHotfix.h"

NSString * const kBBFixFileName       = @"fixfile";
NSString * const kBBFixRegisterAppURL = @"";
NSString * const kBBFixSyncURL        = @"";

@implementation BBHotfix {
    /// fix 文件本地存储目录，同一时间只允许存在一个fix文件
    NSURL *_localFilePath;
    NSString *_appKey;
    NSString *_version;
}

+ (void)fixOnSandBox:(BOOL)sandBox {
    isSandBox = sandBox;
}

+ (BOOL)sandBox {
    return isSandBox;
}


+ (BBHotfix *)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        BOOL isDir = YES;
        NSError *error = nil;
        NSString *diskCachePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"cn.timeface.file/repairtool"];
        BOOL directoryExists = [[NSFileManager defaultManager] fileExistsAtPath:diskCachePath isDirectory:&isDir];
        if (!directoryExists) {
            [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:diskCachePath]
                                     withIntermediateDirectories:YES
                                                      attributes:nil
                                                           error:&error];
        }
        _localFilePath = [NSURL fileURLWithPath:[diskCachePath stringByAppendingPathComponent:kBBFixFileName]];
        [JPEngine startEngine];
    }
    return self;
}

- (void)startWithAppKey:(NSString *)appKey {
    //注册app，并执行本地脚本
    _appKey = appKey;
    RegisterApp *registerApp = [[RegisterApp alloc] initWithAppKey:appKey];
    [registerApp startWithCompletionBlockWithSuccess:^(__kindof BBBaseRequest *request) {
        [JPEngine startEngine];
        [self evaluateLoacalScript];
    } failure:^(__kindof BBBaseRequest *request) {
    }];
}

- (void)sync {
    SyncHotfix *syncHotfix = [[SyncHotfix alloc] initWithAppKey:_appKey];
    [syncHotfix startWithCompletionBlockWithSuccess:^(__kindof BBBaseRequest *request) {
        if ([request.responseObject objectForKey:@"fileUrl"] && [[request.responseObject objectForKey:@"fileUrl"] count] > 0) {
            NSString *fileUrl = [[request.responseObject objectForKey:@"fileUrl"] objectAtIndex:0];
            if (fileUrl.length) {
                [self downloadFixFile:fileUrl];
            }
        }
        else {
            [self removeLocalScript];
        }
    } failure:^(__kindof BBBaseRequest *request) {
        
    }];}

#pragma mark - Download fix file from server

- (void)downloadFixFile:(NSString *)fileUrl {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:fileUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    __weak __typeof(self) weakSelf = self;
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request
                                                                     progress:nil
                                                                  destination:^NSURL *(NSURL *targetPath, NSURLResponse *response)
                                              {
                                                  [[NSFileManager defaultManager] removeItemAtURL:_localFilePath error:nil];
                                                  return _localFilePath;
                                              }
                                                            completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error)
                                              {
                                                  NSLog(@"File downloaded to: %@", filePath);
                                                  __typeof(&*weakSelf) strongSelf = weakSelf;
                                                  if (strongSelf) {
                                                      [strongSelf evaluateLoacalScript];
                                                  }
                                              }];
    [downloadTask resume];
}

- (void)removeLocalScript {
    [[NSFileManager defaultManager] removeItemAtURL:_localFilePath error:nil];
    [JPEngine evaluateScript:@"defineClass('BBHotfix', {defaultMethod: function() {},});"];
}

- (void)evaluateLoacalScript {
    NSError *error = nil;
    NSString *script = [NSString stringWithContentsOfURL:_localFilePath
                                                encoding:NSUTF8StringEncoding
                                                   error:&error];
    if (!error) {
        [JPEngine evaluateScript:script];
    }
}

- (void)defaultMethod {
    
}

@end
