//
//  DPRArtistController.m
//  Favorite Artists
//
//  Created by Dennis Rudolph on 1/24/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

#import "DPRArtistController.h"
#import "DPRArtist.h"

@implementation DPRArtistController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _artists = [[NSMutableArray alloc] initWithArray:@[]];
    }
    return self;
}

- (void)searchArtistByName:(NSString *)name completion:(void (^)(DPRArtist *artist, NSError *error))completion {
    NSURL *baseURL = [NSURL URLWithString:@"https://www.theaudiodb.com/api/v1/json/1/search.php"];
    NSURLComponents *components = [NSURLComponents componentsWithURL:baseURL resolvingAgainstBaseURL:YES];
    
    NSURLQueryItem *searchItem = [NSURLQueryItem queryItemWithName:@"s" value:name];
    [components setQueryItems:@[searchItem]];
    
    NSURL *url = components.URL;
    NSLog(@"URL: %@", url);
    
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"1");
            completion(nil, error);
            return;
        }
        
        NSError *jsonError = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (jsonError) {
            NSLog(@"2");
            completion(nil, jsonError);
            return;
        }
        
        if (![dictionary isKindOfClass:[NSDictionary class]]) {
            NSLog(@"JSON was not a dictionary as expected");
            completion(nil, [[NSError alloc] init]);
            return;
        }

        NSArray *artistsArray = dictionary[@"artists"];
        
        if (artistsArray && [artistsArray count] > 0) {
            NSDictionary *dictionary = artistsArray[0];
            
            DPRArtist *artist = [[DPRArtist alloc] initWithDictionary:dictionary];
            completion(artist, nil);
        } else {
            NSLog(@"Could not find an artist by the name of %@", name);
            completion(nil, nil);
        }
    }] resume];
}

- (void)saveArtists {
    NSURL *documentURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *artistURL = [documentURL URLByAppendingPathComponent:@"myArtists"];
    NSMutableArray *saveArray = [[NSMutableArray alloc] init];
    for (DPRArtist *artist in self.artists) {
        [saveArray addObject:[artist toDictionary]];
    }
    [saveArray writeToURL:artistURL atomically:YES];
}

- (void)loadArtists {
    NSURL *documentURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSURL *artistURL = [documentURL URLByAppendingPathComponent:@"myArtists"];
    
    NSArray *array = [[NSArray alloc] initWithContentsOfURL:artistURL];
    for (NSDictionary *artistDictionary in array) {
        DPRArtist *artist = [[DPRArtist alloc] initWithDictionary:artistDictionary];
        [self.artists addObject:artist];
    }
}

@end
