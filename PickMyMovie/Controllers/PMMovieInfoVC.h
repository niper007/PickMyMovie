//
//  ChosenMovieVC.h
//  PickMyMovie
//
//  Created by Niklas Persson on 11/18/14.
//  Copyright (c) 2014 NPFLASH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMSearchModel.h"

@interface PMMovieInfoVC : UIViewController

@property (nonatomic,strong) PMSearchModel *selectedMovie;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *averageVoteLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
- (IBAction)playButtonPressed:(id)sender;

@end
