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

@end

@implementation DetailGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/original";
    
    
    NSString *posterURLString = self.movie[@"poster_path" ];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString: posterURLString];
    
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    [self.posterView setImageWithURL:posterURL];
    
    [self.backdropView setImageWithURL:posterURL];
    
    
//    NSString *backdropURLString = self.movie[@"backdrop_path"];
//    NSString *fullBackdropURLString = [baseURLString stringByAppendingString: backdropURLString];
//
//    NSURL *backdropURL = [NSURL URLWithString:fullBackdropURLString];
//    [self.posterView setImageWithURL:backdropURL];
    
    
    
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"overview"];
    
//    [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
