//
//  CoreDataTests.m
//  PickMyMovie
//
//  Created by Niklas Persson on 12/2/14.
//  Copyright (c) 2014 NPFLASH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "PMCoreDataEngine.h"
#import "PMSearchModel.h"

@interface CoreDataTests : XCTestCase

@property (nonatomic,strong)PMCoreDataEngine *databaseEngine;
@end

@implementation CoreDataTests

- (void)setUp {
    [super setUp];
    self.databaseEngine = [PMCoreDataEngine new];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//Add the movie!!!!
-(void)test_1_addMovie{
    NSDictionary *dict = @{@"original_title" : @"Rush",
                           @"poster_path" : @"/cjEepHZOZAwmK6nAj5jis6HV75E.jpg",
                           @"release_date" : @"2013-09-27",
                           @"id" : @(96721),
                           @"title" : @"Rush",
                           @"vote_average" : @(8),
                           @"backdrop_path" : @"/w41zFKYTsq4wf5QnQJWMXuzWl2F.jpg",
                           @"overview" : @"A biography of Formula 1 champion driver Niki Lauda and the 1976 crash that almost claimed his life. Mere weeks after the accident, he got behind the wheel to challenge his rival, James Hunt.",
                           @"genres" : @[
                                   @{
                                       @"id" : @(28),
                                       @"name" : @"Action"
                                       },
                                   @{
                                       @"id" : @(18),
                                       @"name" : @"Drama"
                                       },
                                   @{
                                       @"id" : @(9805),
                                       @"name" : @"Sport"
                                       }
                                   ]};
    
    PMSearchModel *model = [[PMSearchModel alloc]initWithObject:dict];
    
    [self.databaseEngine addMovie:model];
    PMSearchModel *responseModel = [self.databaseEngine movieWithId: model.movieId];
    
    XCTAssertNotNil(responseModel);
    XCTAssertEqualObjects(responseModel.title, @"Rush");
    XCTAssertEqualObjects(responseModel.image, @"/cjEepHZOZAwmK6nAj5jis6HV75E.jpg");
    XCTAssertEqual(responseModel.movieId, 96721);
    XCTAssertEqualObjects(responseModel.releaseDate, @"2013-09-27");
    XCTAssertEqualObjects([responseModel voteAverageRounded], @"8");
    XCTAssertEqualObjects(responseModel.overview, @"A biography of Formula 1 champion driver Niki Lauda and the 1976 crash that almost claimed his life. Mere weeks after the accident, he got behind the wheel to challenge his rival, James Hunt.");
    XCTAssertEqualObjects(responseModel.genres, @"Action, Drama, Sport");
}

//Remove movie after adding it
-(void)test_2_removeMovie{
    PMSearchModel *model = [self.databaseEngine movieWithId:96721];
    if (model == nil) {
        return;
    }
    XCTAssertNotNil(model);
    
    [self.databaseEngine removeMovieWithId:96721];
    PMSearchModel *responseModel = [self.databaseEngine movieWithId:96721];
    XCTAssertNil(responseModel);
}




@end
