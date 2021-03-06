//
//  MoviesGridViewController.m
//  Film District
//
//  Created by jose1009 on 6/24/21.
//

#import "MoviesGridViewController.h"
#import "MovieCollectionCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailGridViewController.h"

@interface MoviesGridViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *movies; //value for movies in api

@property (nonatomic,strong) UIRefreshControl *refreshControl; //refresh

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation MoviesGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.activityIndicator startAnimating]; // load symbol animate
    
    [self fetchMovies];
    
    self.refreshControl = [[UIRefreshControl alloc] init]; //init
    self.refreshControl.tintColor = UIColor.whiteColor;
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged]; //action
    [self.collectionView insertSubview:self.refreshControl atIndex:0];
    
    
    //for the collection make it nice in the app
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*) self.collectionView.collectionViewLayout;
    
    
    CGFloat postersPerLine = 2;
    CGFloat itemWidth = self.collectionView.frame.size.width / postersPerLine;
    CGFloat itemHeight = itemWidth *1.5;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
}



- (void)fetchMovies {
    
    
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/upcoming?api_key=9b137635c1a0dc36dc66b234b6c2ce3b&language=en-US"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               
               UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Network Error" message:@"Try Again" preferredStyle:(UIAlertControllerStyleAlert)];
               
               // create a cancel action
               UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                   // handle cancel response here. Doing nothing will dismiss the view.
               }];
               
               // add the cancel action to the alertController
               [alert addAction:cancelAction];
               
               // create an OK action
               UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               }];
               
               [alert addAction:okAction];
               
               [self presentViewController:alert animated:YES completion:^{
               }];
               
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
               self.movies = dataDictionary[@"results"]; //recolect results
               
               [self.collectionView reloadData];
               
               [self.refreshControl endRefreshing]; //strop refresh symbol
               [self.activityIndicator stopAnimating]; //load symbol stop
           }
       }];
    [task resume];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    MovieCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    
    
    NSDictionary *movie = self.movies[indexPath.item];
    
    
    NSString *urlStringSmall = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w200/%@", movie[@"poster_path"]];
    NSString *urlStringLarge = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w500/%@", movie[@"poster_path"]];
    NSURL *urlSmall = [NSURL URLWithString:urlStringSmall];
    NSURL *urlLarge = [NSURL URLWithString:urlStringLarge];
    NSURLRequest *requestSmall = [NSURLRequest requestWithURL:urlSmall];
    NSURLRequest *requestLarge = [NSURLRequest requestWithURL:urlLarge];
    
    [cell.posterView setImageWithURLRequest:requestSmall placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *smallImage) {
        

        cell.posterView.alpha = 0.0;
        cell.posterView.image = smallImage;
                
        [UIView animateWithDuration:0.3 animations:^{
            
            cell.posterView.alpha = 1.0;
                        
        } completion:^(BOOL finished) {

            [cell.posterView setImageWithURLRequest:requestLarge placeholderImage:smallImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage * largeImage) {
                                
                cell.posterView.image = largeImage;
            }
                                            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {

            }];
        }];
    }
                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
    }];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  self.movies.count;
}






#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    
    UICollectionViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:(tappedCell)];
    
    NSDictionary *movie = self.movies[indexPath.row];
    
    DetailGridViewController *detailGridViewController = [segue destinationViewController];
    detailGridViewController.movie = movie;
}






@end
