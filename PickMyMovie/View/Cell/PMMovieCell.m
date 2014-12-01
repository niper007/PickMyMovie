//
//  PMMovieCell.m
//  PickMyMovie
//
//  Created by Niklas Persson on 11/25/14.
//  Copyright (c) 2014 NPFLASH. All rights reserved.
//

#import "PMMovieCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation PMMovieCell

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.imageView sd_setImageWithURL:self.imageUrl];
   
}

@end
