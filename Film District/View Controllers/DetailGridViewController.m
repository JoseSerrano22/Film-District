//
//  DetailGridViewController.m
//  Film District
//
//  Created by jose1009 on 6/24/21.
//

#import "DetailGridViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailGridViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;


@end

@implementation DetailGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *urlStringSmall = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w200/%@", self.movie[@"poster_path"]];
    NSString *urlStringLarge = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w500/%@", self.movie[@"poster_path"]];
    NSURL *urlSmall = [NSURL URLWithString:urlStringSmall];
    NSURL *urlLarge = [NSURL URLWithString:urlStringLarge];
    NSURLRequest *requestSmall = [NSURLRequest requestWithURL:urlSmall];
    NSURLRequest *requestLarge = [NSURLRequest requestWithURL:urlLarge];
    
    [self.posterView setImageWithURLRequest:requestSmall placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *smallImage) {
        
        // smallImageResponse will be nil if the smallImage is already available
        // in cache (might want to do something smarter in that case).
        self.posterView.alpha = 0.0;
        self.backdropView.alpha = 0.0;
        self.posterView.image = smallImage;
        self.backdropView.image = smallImage;
                
        [UIView animateWithDuration:0.35 animations:^{
            
            self.posterView.alpha = 1.0;
            self.backdropView.alpha = 1.0;
                        
        } completion:^(BOOL finished) {
            // The AFNetworking ImageView Category only allows one request to be sent at a time
            // per ImageView. This code must be in the completion block.
            [self.posterView setImageWithURLRequest:requestLarge placeholderImage:smallImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage * largeImage) {
                                
                self.posterView.image = largeImage;
                self.backdropView.image = largeImage;
            }
                                            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                // do something for the failure condition of the large image request
                // possibly setting the ImageView's image to a default image
            }];
        }];
    }
                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        // do something for the failure condition
        // possibly try to get the large image
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
