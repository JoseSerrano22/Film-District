//
//  MoviesGridViewController.m
//  Film District
//
//  Created by jose1009 on 6/24/21.
//

#import "MoviesGridViewController.h"
#import "MovieCollectionCell.h"
#import "UIImageView+AFNetworking.h"

@interface MoviesGridViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *movies; //value for movies in api

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end

@implementation MoviesGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    
    [self fetchMovies];
    
    
    //for the collection make it nice in the app
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*) self.collectionView.collectionViewLayout;
    
    
    CGFloat postersPerLine = 2;
    CGFloat itemWidth = self.collectionView.frame.size.width / postersPerLine;
    CGFloat itemHeight = itemWidth *1.5;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
}



- (void)fetchMovies {
    
    
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=9b137635c1a0dc36dc66b234b6c2ce3b&language=en-US"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

//               NSLog(@"%@", dataDictionary);
               
               self.movies = dataDictionary[@"results"]; //recolect results
               [self.collectionView reloadData];
               
               
           }
 
        
       }];
    [task resume];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    MovieCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    
    
    NSDictionary *movie = self.movies[indexPath.item];
    
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/original";
    NSString *posterURLString = movie[@"poster_path" ];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString: posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    
    cell.posterView.image = nil;
    [cell.posterView setImageWithURL: posterURL];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  self.movies.count;
}


@end
