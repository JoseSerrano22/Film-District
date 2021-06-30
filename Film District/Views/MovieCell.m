//
//  MovieCell.m
//  Film District
//
//  Created by jose1009 on 6/23/21.
//

#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"

@implementation MovieCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMovie:(Movie *)movie {
    // Since we're replacing the default setter, we have to set the underlying private storage _movie ourselves.
    // _movie was an automatically declared variable with the @propery declaration.
    // You need to do this any time you create a custom setter.
    _movie = movie;

    self.titleLabel.text = self.movie.title;
    self.synopsisLabel.text = self.movie.synopsis;

    self.posterView.image = nil;
    if (self.movie.smallPosterURL != nil) {
        [self.posterView setImageWithURL:self.movie.smallPosterURL];
    }
}

@end
