//
//  MoviesViewController.m
//  Film Districtlvfhkiuhdeicgkkeujggbrjvcguvbljficlburlglgdntcgikdnfelulbbdjkjnukkrlvfncudvjuunldluikbtjhnknjtfv//
//  Created by jose1009 on 6/23/21.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailViewController.h"
#import "Movie.h"
#import "MovieApiManager.h"


@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *movies; //value for movies in api
@property (nonatomic,strong)  UIRefreshControl *refreshControl; //refresh

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.activityIndicator startAnimating]; // load symbol animate
    
    
    
    [self fetchMovies]; // function of the api
    
    self.refreshControl = [[UIRefreshControl alloc] init]; //init
    self.refreshControl.tintColor = UIColor.whiteColor;
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged]; //action
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}



- (void)fetchMovies {
    //
    //
    //    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=9b137635c1a0dc36dc66b234b6c2ce3b&language=en-US"];
    //    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    //    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    //    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    //        if (error != nil) {
    
    //
    //        }
    //        else {
    //            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    //
    //            NSArray *dictionaries = dataDictionary[@"results"];
    //            for (NSDictionary *dictionary in dictionaries) {
    //                Movie *movie = [[Movie alloc] initWithDictionary:dictionary];
    //                [self.movies addObject:movie];
    //                [self.tableView reloadData];
    //            }
    //
    //        }
    
    MovieApiManager *manager = [MovieApiManager new];
    [manager fetchNowPlaying:^(NSArray *movies, NSError *error) {
        
        if(movies){
            
            self.movies = movies;
            [self.tableView reloadData];
            
        }else{
            
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
                // handle response here.
            }];
            
            // add the OK action to the alert controller
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }
        
    }];
    
    [self.refreshControl endRefreshing]; //strop refresh symbol
    [self.activityIndicator stopAnimating]; //load symbol stop
}



#pragma mark - Table View Functions

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count; //check how many rows
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MovieCell"]; //Returns a reusable table-view cell object located by its identifier.
    cell.movie = self.movies[indexPath.row];
    //    cell.titleLabel.text = movie.title;
    //    cell.synopsisLabel.text = movie.synopsis;
    
    //
    //    NSDictionary *movie = self.movies[indexPath.row];
    //    cell.titleLabel.text = movie[@"title"];
    //    cell.synopsisLabel.text = movie[@"overview"];
    //
    //    NSString *urlStringSmall = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w200/%@", movie[@"poster_path"]];
    //    NSString *urlStringLarge = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w500/%@", movie[@"poster_path"]];
    //    NSURL *urlSmall = [NSURL URLWithString:urlStringSmall];
    //    NSURL *urlLarge = [NSURL URLWithString:urlStringLarge];
    //    NSURLRequest *requestSmall = [NSURLRequest requestWithURL:urlSmall];
    //    NSURLRequest *requestLarge = [NSURLRequest requestWithURL:urlLarge];
    //
    //    [cell.posterView setImageWithURLRequest:requestSmall placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *smallImage) {
    //
    //        // smallImageResponse will be nil if the smallImage is already available
    //        cell.posterView.alpha = 0.0;
    //        cell.posterView.image = smallImage;
    //
    //        [UIView animateWithDuration:0.3 animations:^{
    //
    //            cell.posterView.alpha = 1.0;
    //
    //        } completion:^(BOOL finished) {
    //
    //            [cell.posterView setImageWithURLRequest:requestLarge placeholderImage:smallImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage * largeImage) {
    //
    //                cell.posterView.image = largeImage;
    //            }
    //                                            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
    //
    //            }];
    //        }];
    //    }
    //                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
    //    }];
    //
    //
    //
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Change the selected background view of the cell.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(tappedCell)];
    
    Movie *movie = self.movies[indexPath.row];
    
    DetailViewController *detailViewController = [segue destinationViewController];
    detailViewController.movie = movie;
    
}




@end
