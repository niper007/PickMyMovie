//
//  PickMyMovieTests.m
//  PickMyMovieTests
//
//  Created by Niklas Persson on 11/12/14.
//  Copyright (c) 2014 NPFLASH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import "PMApiEngine.h"
#import "PMSearchModel.h"

@interface PickMyMovieTests : XCTestCase

@property (nonatomic,strong) PMApiEngine *callToServerEngine;

@property (nonatomic,strong) XCTestExpectation *expection;
@property (nonatomic,strong) NSArray *responseMovies;
@property (nonatomic,strong) NSError *responseError;

@end

@implementation PickMyMovieTests

- (void)setUp
{
    [super setUp];
    
    self.callToServerEngine = [PMApiEngine new];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_1_searchMovieRushHour
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        // Stub it with our "wsresponse.json" stub file
        NSString* fixture = OHPathForFileInBundle(@"SearchRushHour.json",nil);
        return [OHHTTPStubsResponse responseWithFileAtPath:fixture
                                                statusCode:200 headers:@{@"Content-Type":@"text/json"}];
    }];
    
    NSString *keyword = @"Rush hour";
    
    //
    self.expection = [self expectationWithDescription:@"search rush hour request"];
    [self.callToServerEngine searchMovieWithKeyword:keyword success:^(NSArray *movieObjects) {
        self.responseMovies = movieObjects;
        [self.expection fulfill];
    } failure:^(NSError *error) {
        self.responseError = error;
        [self.expection fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0f handler:^(NSError *error) {
        XCTAssertNil(self.responseError);
        XCTAssertNotNil(self.responseMovies);
        XCTAssertEqual([self.responseMovies count], 18);
        
        for (int i = 0; i < self.responseMovies.count; i++) {
            PMSearchModel *model = self.responseMovies[i];
            XCTAssertNotNil(model);
            switch (i) {
                case 0:
                    XCTAssertEqualObjects(model.title, @"Rush");
                    XCTAssertEqualObjects(model.image, @"/cjEepHZOZAwmK6nAj5jis6HV75E.jpg");
                    XCTAssertEqual(model.movieId, 96721);
                    XCTAssertEqualObjects(model.releaseDate, @"2013-09-27");
                    XCTAssertEqual(model.voteAverage, 8);
                    
                    break;
                default:
                    break;
            }
        }
        
    }];
}


@end
