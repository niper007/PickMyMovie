//
//  PMSearchModel.m
//  PickMyMovie
//
//  Created by Niklas Persson on 11/25/14.
//  Copyright (c) 2014 NPFLASH. All rights reserved.
//

#import "PMSearchModel.h"

#define ImagePathTmdb @"http://image.tmdb.org/t/p/w92"
#define ImagePathTmdbBig @"http://image.tmdb.org/t/p/w500"

#define TitleJsonKey @"title"
#define ImageJsonKey @"poster_path"
#define MovieIdJsonKey @"id"
#define ReleaseDateJsonKey @"release_date"
#define OverviewJsonKey @"overview"
#define GenresJsonKey @"genres"
#define VoteAverageJsonKey @"vote_average"
#define NameJsonKey @"name"
#define KeyJsonKey @"key"

@implementation PMSearchModel

//afnetworking with json
- (id)initWithObject:(NSDictionary *)object {
    if (self = [super init]) {
        
        //        //Key from JSON content
        
        for (id key in object) {
            
            if ([key isEqual:MovieIdJsonKey]) {
                self.movieId = [object[key] intValue];
            }else if ([key isEqual:ImageJsonKey]) {
                self.image = object[key];
            }else if ([key isEqual:TitleJsonKey]) {
                self.title = object[key];
            }else if ([key isEqual:VoteAverageJsonKey]) {
                self.voteAverage = [object[key]floatValue];
            }else if ([key isEqual:ReleaseDateJsonKey]) {
                self.releaseDate = object[key];
            }else if ([key isEqual:OverviewJsonKey]) {
                self.overview = object[key];
            }else if ([key isEqual:GenresJsonKey]) {
                
                NSMutableString *string =  [NSMutableString new];
                NSArray *genreList = [object valueForKey:key];
                
                for (int i = 0; i < [genreList count]; i++) {
                    NSDictionary *dict = [genreList objectAtIndex:i];
                    [string appendString:[dict objectForKey:NameJsonKey]];
                    if (i < genreList.count - 1) {
                        [string appendString:@", "];
                    }
                }
                self.genres = string;
            }
            
        }
        
    }
    return self;
}

//Coredata
- (id)initWithContext:(NSManagedObject *)object attributes:(NSDictionary *)attributes {
    if (self = [super init]) {
        for (NSString *key in attributes) {
            
            if ([key isEqual:MovieIdKey]) {
                self.movieId = [[object valueForKey: key] intValue];
            }else if ([key isEqual:ImageKey]) {
                self.image = [object valueForKey: key];
            }else if ([key isEqual:TitleKey]) {
                self.title = [object valueForKey: key];
            }else if ([key isEqual:VoteAverageKey]) {
                self.voteAverage = [[object valueForKey: key]floatValue];
            }else if ([key isEqual:ReleaseDateKey]) {
                self.releaseDate = [object valueForKey: key];
            }else if ([key isEqual:OverviewKey]) {
                self.overview = [object valueForKey: key];
            }else if ([key isEqual:GenresKey]) {
                self.genres = [object valueForKey:key];
            }
        }
    }
    return self;
}

- (NSString *)overview {
    
    if (_overview == nil || [_overview isEqual:[NSNull null]]) {
        return @"";
    } else {
        return _overview;
    }
}

- (NSString *)genres{
    if (_genres == nil || [_genres isEqual:[NSNull null]]) {
        return @"";
    }else{
        return _genres;
    }
}

//Imagepath from API
- (NSURL *)imageUrl{
    if (self.image == nil || [self.image isEqual:[NSNull null]]) {
        return nil;
    }
    NSString *imagepath = [NSString stringWithFormat:@"%@%@",ImagePathTmdb,self.image];
    return  [NSURL URLWithString:imagepath];
}

- (NSURL *)imageUrlBig {
    if (self.image == nil || [self.image isEqual:[NSNull null]]) {
        return nil;
    }
    NSString *imagepath = [NSString stringWithFormat:@"%@%@",ImagePathTmdbBig,self.image];
    return  [NSURL URLWithString:imagepath];
}

-(NSString *)voteAverageRounded{
    if (self.voteAverage == (int)self.voteAverage) {
        return [NSString stringWithFormat:@"%d",(int)self.voteAverage];
    }else{
        NSString *voteAverage = [NSString stringWithFormat:@"%.1f",self.voteAverage];
        return voteAverage;
    }
    
}

-(void)addVideoWithKeys:(NSArray *)keys {
    
    NSMutableArray *array = [NSMutableArray new];
    for (int i = 0;  i < [keys count]; i++){
        
        NSString *key = [[keys objectAtIndex:i]objectForKey:@"key"];
        [array addObject:key];
        
    }
    
    self.videoKeys = array;
    
}


@end
