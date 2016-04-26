//
//  SyncHotfix.m
//  BBHotfix
//
//  Created by Gary on 3/18/16.
//  Copyright © 2016 Gary. All rights reserved.
//

#import "SyncHotfix.h"
#import "BBHotfix.h"

@implementation SyncHotfix {
    NSString *_appKey;
    NSString *_version;
}

- (instancetype)initWithAppKey:(NSString *)appKey {
    self = [super init];
    if (self) {
        _appKey = appKey;
        _version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    }
    return self;
}

- (BBRequestMethod)requestMethod {
    return BBRequestMethodPost;
}

- (BBRequestSerializerType)requestSerializerType {
    return BBRequestSerializerTypeJSON;
}

- (NSString *)requestUrl {
    if ([BBHotfix sandBox]) {
        return @"http://stg2.v5time.net/hotfix/hotfix/sync";
    }
    return @"http://hotfix.timeface.cn/hotfix/hotfix/sync";
}

- (id)requestArgument {
    return @{@"appkey": _appKey,
             @"version": _version,
             @"platform":@"1"};
}

@end
