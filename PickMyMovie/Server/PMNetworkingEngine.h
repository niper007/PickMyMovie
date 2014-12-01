//
//  GetDataFromServer.h
//  PickMyMovie
//
//  Created by Niklas Persson on 11/19/14.
//  Copyright (c) 2014 NPFLASH. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^successBlock)(id responseObject);
typedef void(^failureBlock)(NSError *error);

@interface PMNetworkingEngine : NSObject

- (void)get:(NSString *)url parameters:(NSDictionary *)parameters success:(successBlock)successBlock failure:(failureBlock)failureBlock;

@end
