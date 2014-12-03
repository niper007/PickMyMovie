//
//  CallToServerEngine.h
//  PickMyMovie
//
//  Created by Niklas Persson on 11/19/14.
//  Copyright (c) 2014 NPFLASH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMSearchModel.h"
#import "PMNetworkingEngine.h"

typedef void(^listBlock)(NSArray *movieObject);
typedef void(^movieBlock)(PMSearchModel *model);
typedef void(^videoBlock)(PMSearchModel *model);

@interface PMApiEngine : NSObject

- (void)searchMovieWithKeyword:(NSString *)keyword success:(listBlock)successBlock failure:(failureBlock)failureBlock;
- (NSMutableArray *)checkList;
-(void)getMovieWithId:(int)movieId success:(movieBlock)successBlock failure:(failureBlock)failureBlock;
-(void)getVideoWithModel:(PMSearchModel *)model success:(videoBlock)successBlock failure:(failureBlock)failureBlock;
@end
