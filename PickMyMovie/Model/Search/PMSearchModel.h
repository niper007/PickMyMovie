//
//  PMSearchModel.h
//  PickMyMovie
//
//  Created by Niklas Persson on 11/25/14.
//  Copyright (c) 2014 NPFLASH. All rights reserved.
//

#import <Foundation/Foundation.h>


#define TitleKey @"title"
#define ImageKey @"image"
#define MovieIdKey @"movieId"
#define ReleaseDateKey @"releaseDate"
#define OverviewKey @"overview"
#define GenresKey @"genres"
#define VoteAverageKey @"voteAverage"




@interface PMSearchModel : NSObject

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *image;

@property (nonatomic,readwrite) int movieId;
@property (nonatomic,strong) NSURL *imageUrl;
@property (nonatomic, readwrite) BOOL exists;
@property (nonatomic,readwrite) int voteAverage;
@property (nonatomic,strong) NSString *releaseDate;
@property (nonatomic,strong) NSString *overview;
@property (nonatomic,strong) NSString *genres;

- (id)initWithObject:(NSDictionary *)object;
- (id)initWithContext:(NSManagedObject *)object attributes:(NSDictionary *)attributes;

@end
