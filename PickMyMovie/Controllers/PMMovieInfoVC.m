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
#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <XCDYouTubeKit/XCDYouTubeVideoPlayerViewController.h>

#define Radius 25
#define BorderWidth 2.0f
#define VideoSegue @"Video"

@interface PMMovieInfoVC ()

@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;

@end

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
    self.averageVoteLabel.text = [self.selectedMovie voteAverageRounded];
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

- (IBAction)playButtonPressed:(id)sender {
    
    XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:@"yYiZbWyYey0"];
    [self presentMoviePlayerViewControllerAnimated:videoPlayerViewController];
    //    NSURL *url = [NSURL URLWithString:
    //                  @"https://www.youtube.com/embed/yYiZbWyYey0"];
    //
    //    _moviePlayer =  [[MPMoviePlayerController alloc]
    //                     initWithContentURL:url];
    //
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(moviePlayBackDidFinish:)
    //                                                 name:MPMoviePlayerPlaybackDidFinishNotification
    //                                               object:_moviePlayer];
    //
    //    _moviePlayer.controlStyle = MPMovieControlStyleDefault;
    //    _moviePlayer.shouldAutoplay = YES;
    //    [self.view addSubview:_moviePlayer.view];
    //    [_moviePlayer setFullscreen:YES animated:YES];
}


@end
