//
//  ChooseMovieVC.h
//  PickMyMovie
//
//  Created by Niklas Persson on 11/18/14.
//  Copyright (c) 2014 NPFLASH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMMovieSearchVC : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *searchField;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)searchBtnPressed:(id)sender;

@end
