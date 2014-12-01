//
//  CoreDataEngine.h
//  PickMyMovie
//
//  Created by Niklas Persson on 11/22/14.
//  Copyright (c) 2014 NPFLASH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMSearchModel.h"

@interface PMCoreDataEngine : NSObject

-(NSMutableArray *)getAllMovies;
-(void)addMovie:(PMSearchModel *)model;
-(PMSearchModel *)movieWithId:(int)movieId;
-(void)removeMovieWithId:(int)movieId;
-(NSDictionary *)movieAttributes;

@end
