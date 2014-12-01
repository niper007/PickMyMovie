//
//  ChosenMovieVC.m
//  PickMyMovie
//
//  Created by Niklas Persson on 11/18/14.
//  Copyright (c) 2014 NPFLASH. All rights reserved.
//

#import "PMMovieInfoVC.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>

#define Radius 25
#define BorderWidth 2.0f

@implementation PMMovieInfoVC


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
    
    [self.imageView sd_setImageWithURL:self.selectedMovie.imageUrl];
    self.titleLabel.text = self.selectedMovie.title;
    self.releaseDateLabel.text = self.selectedMovie.releaseDate;
    self.averageVoteLabel.text =[NSString stringWithFormat:@"%d",self.selectedMovie.voteAverage];
    self.descriptionLabel.hidden = self.selectedMovie.overview == nil;
   
    if (self.selectedMovie.overview) {
        self.descriptionLabel.text = self.selectedMovie.overview;
    }
    
    
    
    [self styleAverageVoteLabel];
    

}

-(void)styleAverageVoteLabel{
    self.averageVoteLabel.layer.cornerRadius = Radius;
    self.averageVoteLabel.clipsToBounds = YES;
    self.averageVoteLabel.layer.borderWidth=BorderWidth;
    self.averageVoteLabel.layer.borderColor=[[UIColor whiteColor] CGColor];
}

@end
