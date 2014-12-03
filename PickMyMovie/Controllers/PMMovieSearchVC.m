//
//  ChooseMovieVC.m
//  PickMyMovie
//
//  Created by Niklas Persson on 11/18/14.
//  Copyright (c) 2014 NPFLASH. All rights reserved.
//

#import "PMMovieSearchVC.h"
#import "PMMovieInfoVC.h"
#import "PMApiEngine.h"
#import "PMUtility.h"
#import "PMMovieCell.h"
#import "PMSearchModel.h"
#import "PMCoreDataEngine.h"

#define MovieSearchCell @"MovieSearchCell"
#define ChosenMovieSegue @"ChosenMovie"

@interface PMMovieSearchVC () <UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate>

@property (nonatomic,strong) NSArray *movieData;
@property (nonatomic,strong) PMApiEngine *apiEngine;
@property (nonatomic,strong) PMSearchModel *selectedMovie;
@property (nonatomic,strong) PMCoreDataEngine *databaseEngine;

@end

@implementation PMMovieSearchVC

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Initiate classes
    self.apiEngine = [PMApiEngine new];
    self.databaseEngine = [PMCoreDataEngine new];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self reloadData];
}

#pragma mark Get data from API
//Get the movie data from API with a searchstring
-(void)getDataFromServerWithSearchString:(NSString *)searchString{
    
    
    
    //Show loader
    [self showLoader];
    __block PMMovieSearchVC *weakself = self;
    [self.apiEngine searchMovieWithKeyword:searchString success:^(NSArray *movieObjects) {
        weakself.movieData = movieObjects;
        [weakself hideLoader];
        
        //Reload data in Collectionview
        [weakself reloadData];
    } failure:^(NSError *error) {
        [weakself hideLoader];
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TRY_AGAIN", nil)
                                                          message:NSLocalizedString(@"ERROR", nil)
                                                         delegate:nil
                                                cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                otherButtonTitles:nil];
        
        [message show];
    }];
}


#pragma mark Collection View
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.movieData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PMMovieCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MovieSearchCell forIndexPath:indexPath];
    
    PMSearchModel *model = self.movieData[indexPath.row];
    cell.imageUrl = model.imageUrl;
    cell.button.tag = indexPath.row;
    [cell.button addTarget:self action:@selector(addMovieToList:) forControlEvents:UIControlEventTouchUpInside];
    cell.button.hidden = model.exists;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Add the selected movie to an Dictionary
    self.selectedMovie = self.movieData[indexPath.row];
    [self performSegueWithIdentifier:ChosenMovieSegue sender:nil];
    
}

#pragma mark Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    PMMovieInfoVC *vc = segue.destinationViewController;
    vc.selectedMovie = self.selectedMovie;
}

//Add movie do local Database
-(void)addMovieToList:(UIButton *)sender{
    
    PMSearchModel *model = self.movieData[sender.tag];
    [self.apiEngine getMovieWithId:model.movieId success:^(PMSearchModel *movieObject) {
        [self.apiEngine getVideoWithModel:movieObject success:^(PMSearchModel *modelWithKeys) {
            [self.databaseEngine addMovie:modelWithKeys];
            [self reloadData];
        } failure:^(NSError *error) {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TRY_AGAIN", nil)
                                                              message:NSLocalizedString(@"ERROR", nil)
                                                             delegate:nil
                                                    cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                    otherButtonTitles:nil];
            
            [message show];
        }];
    } failure:^(NSError *error) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TRY_AGAIN", nil)
                                                          message:NSLocalizedString(@"ERROR", nil)
                                                         delegate:nil
                                                cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                otherButtonTitles:nil];
        
        [message show];
    }];
    
}


#pragma mark Search
//User pressed Search Button
- (IBAction)searchBtnPressed:(id)sender {
    [self searchMovies];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self searchMovies];
    return YES;
}

-(void)searchMovies{
    [self.searchField resignFirstResponder];
    
    //Check if user wrote something
    if (self.searchField.text.length > 0) {
        [self getDataFromServerWithSearchString:self.searchField.text];
    }else{
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"EMPTY", nil)
                                                          message:NSLocalizedString(@"EMPTY_DESC", nil)
                                                         delegate:self
                                                cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                otherButtonTitles:nil];
        
        [message show];
    }
}

#pragma mark Reload Data
-(void)reloadData {
    dispatch_queue_t myQueue = dispatch_queue_create("com.niklas.pickmymovie.search.reloaddata", NULL);
    dispatch_async(myQueue, ^{
        //function call to a helper outside the scope of this view
    });
    dispatch_async(myQueue, ^{
        self.movieData = [self.apiEngine checkList];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    });
    
}

#pragma mark Loaders

-(void)showLoader{
    [PMUtility showLoaderWithView:self.view];
}

-(void)hideLoader{
    [PMUtility hideLoaderWithView:self.view];
}

@end
