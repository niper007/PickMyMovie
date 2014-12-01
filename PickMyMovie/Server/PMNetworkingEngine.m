//
//  GetDataFromServer.m
//  PickMyMovie
//
//  Created by Niklas Persson on 11/19/14.
//  Copyright (c) 2014 NPFLASH. All rights reserved.
//

#import "PMNetworkingEngine.h"
#import <AFNetworking/AFNetworking.h>

@implementation PMNetworkingEngine

- (id)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)get:(NSString *)url parameters:(NSDictionary *)parameters success:(successBlock)successBlock failure:(failureBlock)failureBlock {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];

}

@end