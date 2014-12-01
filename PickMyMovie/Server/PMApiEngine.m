//
//  CallToServerEngine.m
//  PickMyMovie
//
//  Created by Niklas Persson on 11/19/14.
//  Copyright (c) 2014 NPFLASH. All rights reserved.
//

#import "PMApiEngine.h"
#import "PMCoreDataEngine.h"

#define SearchUrl @"http://api.themoviedb.org/3/search/movie"
#define MovieUrl @"http://api.themoviedb.org/3/movie/"
#define API_KEY_DEV @"07818be4aa5cd458ed604c904737e592"
#define Results @"results"
#define Query @"query"
#define ApiKey @"api_key"

@interface PMApiEngine ()

@property (nonatomic,strong) PMNetworkingEngine *getDataFromServer;
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic,strong) PMCoreDataEngine *databaseEngine;

@end

@implementation PMApiEngine

- (id)init {
    if (self = [super init]) {
        
        self.getDataFromServer = [PMNetworkingEngine new];
        self.databaseEngine = [PMCoreDataEngine new];
        
    }
    return self;
}


//Search for movie with keyword
- (void)searchMovieWithKeyword:(NSString *)keyword success:(listBlock)successBlock failure:(failureBlock)failureBlock {
    
    NSDictionary *parameters = @{Query: keyword, ApiKey: API_KEY_DEV};
    
    [self.getDataFromServer get:SearchUrl parameters:parameters success:^(id responseObject) {
        dispatch_queue_t myQueue = dispatch_queue_create("com.niklas.pickmymovie.search.keywords", NULL);
        dispatch_async(myQueue, ^{
            //function call to a helper outside the scope of this view
        });
        dispatch_async(myQueue, ^{
           
            NSDictionary *results = responseObject[Results];
            self.list = [NSMutableArray new];
            for (NSDictionary *movie in results) {
                PMSearchModel *model = [[PMSearchModel alloc] initWithObject:movie];
                [self.list addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (successBlock) {
                    successBlock([self checkList]);
                }
            });
        });
        
    } failure:failureBlock];
}

//Get movie with the movieID
-(void)getMovieWithId:(int)movieId success:(movieBlock)successBlock failure:(failureBlock)failureBlock {
    
    NSDictionary *parameters = @{ApiKey: API_KEY_DEV};
    
    NSString *movieUrl = [NSString stringWithFormat:@"%@%d",MovieUrl,movieId];
    [self.getDataFromServer get:movieUrl parameters:parameters success:^(id responseObject) {
        
        PMSearchModel *model = [[PMSearchModel alloc]initWithObject:responseObject];
        
        if (successBlock) {
            successBlock(model);
        }
        
    } failure:failureBlock];
    
}

//Check if movie is in database
- (NSMutableArray *)checkList {
    
    NSMutableArray *sortedList = [NSMutableArray new];
    
    
    for (int i = 0; i < [self.list count]; i++) {
        
        PMSearchModel *model = self.list[i];
        
        //Check for image
        if (model.imageUrl == nil) {
            continue;
        }
        
        //Check existence in database
        PMSearchModel *specificModel = [self.databaseEngine movieWithId:model.movieId];
        model.exists = (specificModel != nil);
        
        //Add movie to array
        [sortedList addObject:model];
        
    }
    
    //Replace values in list
    self.list = sortedList;
    
    return self.list;
}

@end
