//
//  Movie.h
//  Film District
//
//  Created by jose1009 on 6/30/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Movie : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *synopsis;
@property (nonatomic, strong) NSString *ratingString;

@property (nonatomic, strong) NSURL *smallPosterURL;
@property (nonatomic, strong) NSURL *largePosterURL;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)moviesWithDictionaries:(NSArray *)dictionaries;

@end

typedef void (^FetchMoviesCompletionHandler)(NSArray<Movie *> *movies, NSError *error);

@interface Networker : NSObject


@end

NS_ASSUME_NONNULL_END
