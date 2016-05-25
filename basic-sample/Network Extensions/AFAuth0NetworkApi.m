//
//  AFAuth0NetworkApi.m
//  basic-sample
//
//  Created by Vikas Kannurpatti Jayaram on 25/05/2016.
//  Copyright © 2016 Auth0. All rights reserved.
//

#import "AFAuth0NetworkApi.h"
#import "Application.h"
#import <SimpleKeychain/A0SimpleKeychain.h>
#import <Lock/Lock.h>


static NSString * const AFAFAuth0NetworkApiBaseURLString = @"https://vjayaram.au.auth0.com";

@implementation AFAuth0NetworkApi

+ (instancetype)sharedClient {
    static AFAuth0NetworkApi *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFAuth0NetworkApi alloc] initWithBaseURL:[NSURL URLWithString:AFAFAuth0NetworkApiBaseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    
    return _sharedClient;
}

- (instancetype) initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    return self;
}

- (void) updateUser: (NSDictionary *) userMetaData success: (void(^)(NSURLSessionDataTask *task, id response)) success failure: (void(^) (NSURLSessionDataTask *task, NSError *error)) failure {
    A0SimpleKeychain *keychain = [[Application sharedInstance] store];
    A0UserProfile *profile = [NSKeyedUnarchiver unarchiveObjectWithData:[keychain dataForKey:@"profile"]];
    NSString *token = [keychain stringForKey:@"id_token"];
    NSString * path = [NSString stringWithFormat:@"/api/v2/users/%@", profile.userId];
    NSString* encodedUrl = [path stringByAddingPercentEscapesUsingEncoding:
                            NSUTF8StringEncoding];
    NSString *authorization = [NSString stringWithFormat:@"Bearer %@",token];
    [self.requestSerializer setValue:authorization forHTTPHeaderField:@"Authorization"];
    [self PATCH:encodedUrl parameters:userMetaData success:^(NSURLSessionDataTask * task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        failure(task, error);
    }];
}
@end
