//
//  TFHotfix.h
//  TFHotfix
//
//  Created by Gary on 3/18/16.
//  Copyright © 2016 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>

static BOOL isSandBox;

@interface BBHotfix : NSObject

+ (void)fixOnSandBox:(BOOL)sandBox;

+ (BOOL)sandBox;

+ (BBHotfix *)sharedInstance;
/**
 *  传入AppKey 并自动执行已下载到本地的patch脚本
 *
 *  @param appKey
 */
- (void)startWithAppKey:(NSString *)appKey;
/**
 *  检查是否有patch更新，并下载执行
 */
- (void)sync;



@end
