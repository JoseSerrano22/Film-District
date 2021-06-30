//
//  Movie.m
//  Film District
//
//  Created by jose1009 on 6/30/21.
//

#import "Movie.h"

@implementation Movie


- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    self.title = dictionary[@"title"];
    self.synopsis = dictionary[@"overview"];
    
    // rating string
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.#"];
    self.ratingString = [NSString stringWithFormat:@"%.1f", [dictionary[@"vote_average"] floatValue]]; // or split it up to be cleaner
    
    NSString *urlStringSmall = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w200/%@", dictionary[@"poster_path"]];
    NSString *urlStringLarge = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w500/%@", dictionary[@"poster_path"]];
    
    self.smallPosterURL = [NSURL URLWithString:urlStringSmall];
    self.largePosterURL = [NSURL URLWithString:urlStringLarge];
    
    return self;
}

+ (NSArray *)moviesWithDictionaries:(NSArray *)dictionaries {
    // Implement this function
    NSMutableArray *movies = [[NSMutableArray alloc ] init];
    for (NSDictionary *dictionary in dictionaries) {
        Movie *movie = [[Movie alloc] initWithDictionary:dictionary];
        [movies addObject:movie];
    }
    return movies;
}

@end

