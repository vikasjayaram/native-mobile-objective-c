// Application.m
//
// Copyright (c) 2014 Auth0 (http://auth0.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "Application.h"

#import <Lock/Lock.h>
#import <SimpleKeychain/A0SimpleKeychain.h>
//#import "../Pods/Lock-Facebook/LockFacebook/A0FacebookAuthenticator.h"

@implementation Application

#pragma mark Singleton Method

+ (Application*)sharedInstance {
    static Application *sharedApplication = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedApplication = [[self alloc] init];
    });
    return sharedApplication;
}

- (id)init {
    self = [super init];
    if (self) {
        _store = [A0SimpleKeychain keychainWithService:@"Auth0"];
        _lock = [A0Lock newLock];
//        [_lock registerAuthenticators:@[
//                                        [A0FacebookAuthenticator newAuthenticatorWithPermissions:@[@"public_profile", @"email"]],
//                                        ]];
    }
    return self;
}

@end
