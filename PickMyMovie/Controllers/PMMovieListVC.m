//
//  MyListVC.m
//  PickMyMovie
//
//  Created by Niklas Persson on 11/22/14.
//  Copyright (c) 2014 NPFLASH. All rights reserved.
//

#import "PMMovieListVC.h"
#import "PMCoreDataEngine.h"
#import "PMMovieCell.h"
#import "PMMovieInfoVC.h"
#import <QuartzCore/QuartzCore.h>

#define MovieListCell @"MovieListCell"
#define ChosenListMovieSegue @"ChooseListMovie"


@interface PMMovieListVC () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) PMCoreDataEngine *coreDataEngine;
@property (nonatomic,strong) PMSearchModel *selectedMovie;
@property (nonatomic,strong) NSArray *movieData;
@property (nonatomic,readwrite) BOOL editState;

@end

@implementation PMMovieListVC

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.coreDataEngine = [PMCoreDataEngine new];
    [self styleButton];
    [self reloadData];
    
    //Make sure edit is shown first
    self.editState = YES;
    self.contentLabel.text = NSLocalizedString(@"NO_DATA", nil);
    [self editContent];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self reloadData];
}

-(void)styleButton{
    self.randomBtn.layer.cornerRadius = 10;
    self.randomBtn.clipsToBounds = YES;
    self.randomBtn.layer.borderWidth=2.0f;
    self.randomBtn.layer.borderColor=[[UIColor whiteColor] CGColor];
}

#pragma mark Collection View
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.movieData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PMMovieCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MovieListCell forIndexPath:indexPath];
    PMSearchModel *model = self.movieData[indexPath.row];
    cell.imageUrl = model.imageUrl;
    cell.button.tag = indexPath.row;
    [cell.button addTarget:self action:@selector(removeMovieFromList:) forControlEvents:UIControlEventTouchUpInside];
    cell.button.hidden = self.editState;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //Add the selected movie to an Dictionary
    self.selectedMovie = self.movieData[indexPath.row];
    [self performSegueWithIdentifier:ChosenListMovieSegue sender:nil];
    
}

#pragma mark Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    PMMovieInfoVC *vc = segue.destinationViewController;
    vc.selectedMovie = self.selectedMovie;
}

#pragma mark Remove movie
//Remove movie from local database
-(void)removeMovieFromList:(UIButton *)sender {
    PMSearchModel *model = self.movieData[sender.tag];
    [self.coreDataEngine removeMovieWithId:model.movieId];
    [self reloadData];
}

#pragma mark Randomize movie
//Randomize a movie
- (IBAction)randomizeMoviePressed:(id)sender {
    
    int i = arc4random() % [self.movieData count];
    PMSearchModel *model = self.movieData[i];
    
    NSString * string = [NSString stringWithFormat:@"%@ : %@",NSLocalizedString(@"WATCH_MOVIE", nil),model.title];
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SELECTED_MOVIE", nil)
                                                      message:string
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"OK",nil)
                                            otherButtonTitles:nil];
    
    [message show];
    
}

#pragma mark Reload data

-(void)reloadData {
    dispatch_queue_t myQueue = dispatch_queue_create("com.niklas.pickmymovie.mylist.reloaddata", NULL);
    dispatch_async(myQueue, ^{
        //function call to a helper outside the scope of this view
    });
    dispatch_async(myQueue, ^{
        self.movieData = [self.coreDataEngine getAllMovies];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.randomBtn.hidden = [self.movieData count] == 0;
            self.contentLabel.hidden = [self.movieData count]>0;
           [self.collectionView reloadData];
        });
    });
    
    
   
    
}

#pragma mark Edit content
-(void)editContent {
    
    if (self.editState) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"EDIT", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(editPressed:)];
        self.navigationItem.rightBarButtonItem = item;
    }else{
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"DONE", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(editPressed:)];
        self.navigationItem.rightBarButtonItem = item;
        
        
    }
    
}

//User pressed edit button
-(void)editPressed:(UIButton *)sender {
    
    //Check editstate
    self.editState = !self.editState;
    [self editContent];
    [self reloadData];

}

@end
