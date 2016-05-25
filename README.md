# Auth0 + iOS + API Seed

This is the seed project you need to use if you're going to create an app that will use Auth0, iOS with Objective C and an API that you're going to be developing. That API can be in any language.

## Configuring the example

You must set your Auht0 `ClientId` and `Tenant` in this sample so that it works. For that, just open the `basic-sample/Info.plist` file and replace the `{CLIENT_ID}` and `{TENANT}` fields with your account information.

## Running the example

In order to run the project, you need to have `XCode` installed.
Once you have that, just clone the project and run the following:

1. `pod install`
2. `open basic-sample.xcworkspace`

# Update User profile

* Create a Network interface with base url `https://{tenant}.auth.com`
* Have look at the AFAuth0NetworkApi for implementation method name updateUser.
```
- (void) updateUser: (NSDictionary *) userMetaData success: (void(^)(NSURLSessionDataTask *task, id response)) success failure: (void(^) (NSURLSessionDataTask *task, NSError *error)) failure {
        A0SimpleKeychain *keychain = [[Application sharedInstance] store];
        A0UserProfile *profile = [NSKeyedUnarchiver unarchiveObjectWithData:[keychain dataForKey:@"profile"]];
        NSString *token = [keychain stringForKey:@"id_token"];
        NSString * path = [NSString stringWithFormat:@"/api/v2/users/%@", profile.userId];
        NSString* encodedUrl = [path stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        NSString *authorization = [NSString stringWithFormat:@"Bearer %@",token];
        [self.requestSerializer setValue:authorization forHTTPHeaderField:@"Authorization"];
        [self PATCH:encodedUrl parameters:userMetaData success:^(NSURLSessionDataTask * task, id responseObject) {
            success(task, responseObject);
        } failure:^(NSURLSessionDataTask * task, NSError * error) {
            failure(task, error);
        }];
}
```
* Sample user_metadata payload

```
    NSDictionary *dict = @{@"user_metadata": @{
                            @"firstName" : @"Vikas",
                            @"lastName" : @"Jayaram",
                            @"team" : @"DSE"
                    }};
```
* Sample function call
```
- (void)callAPI:(id)sender {
    NSDictionary *dict = @{@"user_metadata": @{
        @"firstName" : @"Vikas",
        @"lastName" : @"Kannurpatti Jayaram",
        @"team" : @"DSE"
    }};
    [[AFAuth0NetworkApi sharedClient] updateUser:dict success:^(NSURLSessionDataTask *task, id response) {
        NSLog(@"response %@", response);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error %@", error);
    }];
}
```
Enjoy your iOS app now :).
