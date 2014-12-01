//
//  PMMovieCell.h
//  PickMyMovie
//
//  Created by Niklas Persson on 11/25/14.
//  Copyright (c) 2014 NPFLASH. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PMMovieCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSURL *imageUrl;
@property (strong, nonatomic) IBOutlet UIButton *button;

@end
