//
//  DetailViewController.m
//  Film District
//
//  Created by jose1009 on 6/23/21.
//

#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"


@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *urlStringSmall = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w200/%@", self.movie[@"poster_path"]];
    NSString *urlStringLarge = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w500/%@", self.movie[@"poster_path"]];
    NSURL *urlSmall = [NSURL URLWithString:urlStringSmall];
    NSURL *urlLarge = [NSURL URLWithString:urlStringLarge];
    NSURLRequest *requestSmall = [NSURLRequest requestWithURL:urlSmall];
    NSURLRequest *requestLarge = [NSURLRequest requestWithURL:urlLarge];
    
    [self.posterView setImageWithURLRequest:requestSmall placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *smallImage) {
        
        self.posterView.alpha = 0.0;
        self.backdropView.alpha = 0.0;
        self.posterView.image = smallImage;
        self.backdropView.image = smallImage;
                
        [UIView animateWithDuration:0.35 animations:^{
            
            self.posterView.alpha = 1.0;
            self.backdropView.alpha = 1.0;
                        
        } completion:^(BOOL finished) {

            [self.posterView setImageWithURLRequest:requestLarge placeholderImage:smallImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage * largeImage) {
                                
                self.posterView.image = largeImage;
                self.backdropView.image = largeImage;
            }
                                            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            }];
        }];
    }
                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
    }];
    
    
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"overview"];
    [self.synopsisLabel sizeToFit];
    
    
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.#"];
    NSNumber *ratingNum = self.movie[@"vote_average"];
    NSString *ratingString = [fmt stringFromNumber: ratingNum];
    self.ratingLabel.text = ratingString;
    
}

@end
