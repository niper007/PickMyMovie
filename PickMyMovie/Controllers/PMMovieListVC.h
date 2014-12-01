//
//  MyListVC.h
//  PickMyMovie
//
//  Created by Niklas Persson on 11/22/14.
//  Copyright (c) 2014 NPFLASH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMMovieListVC : UIViewController

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIButton *randomBtn;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

- (IBAction)randomizeMoviePressed:(id)sender;

@end
