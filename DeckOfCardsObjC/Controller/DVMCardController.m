//
//  DVMCardController.m
//  DeckOfCardsObjC
//
//  Created by Carlos Pendola on 2/12/19.
//  Copyright © 2019 Carlos Pendola. All rights reserved.
//
#import "DVMCardController.h"
#import "DVMCard.h"

//static NSString * const baseURLString = @"https://deckofcardsapi.com/api/deck/new/draw/";

@implementation DVMCardController

+ (instancetype)sharedController
{
    static DVMCardController *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[DVMCardController alloc] init];
    });
    return sharedController;
}

- (void)drawNewCard:(NSInteger)numberOfCards completion:(void (^)(NSArray<DVMCard *> *, NSError *))completion
{
    //NSURL *baseURL = [NSURL URLWithString:baseURLString];
    NSString *cardCount = [@(numberOfCards) stringValue];
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:[DVMCardController baseURL] resolvingAgainstBaseURL:true];
    
    NSURLQueryItem *queryItem = [NSURLQueryItem queryItemWithName:@"count" value:cardCount];
    urlComponents.queryItems = @[queryItem];
    NSURL *searchURL = urlComponents.URL;
    
    [[[NSURLSession sharedSession] dataTaskWithURL:searchURL completionHandler:^(NSData * data, NSURLResponse *response, NSError * error) {
        
        if (error) {
            NSLog(@"there was an error  %s: %@, %@", __PRETTY_FUNCTION__, error, [error localizedDescription]);
            return completion(nil, [NSError errorWithDomain:@"there was an error fetching json" code:(NSInteger)-1 userInfo:nil]);
        }
        
        if (!data) {
            NSLog(@"Error fetching data %s: %@, %@" ,  __PRETTY_FUNCTION__, error, [error localizedDescription]);
            return completion(nil, [NSError errorWithDomain:@"Error fetching data" code:(NSInteger)-1 userInfo:nil]);
        }
        
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
        if (!jsonDictionary || ![jsonDictionary isKindOfClass:[NSDictionary class]]) {
            NSLog(@"Error parsing json dictionary %s: %@, %@", __PRETTY_FUNCTION__, error, [error localizedDescription]);
            return completion(nil, [NSError errorWithDomain:@"ErrorDomain" code:(NSInteger)-1 userInfo:nil]);
        }
        
        NSArray *cardsArray = jsonDictionary[@"cards"];
        NSMutableArray *cardsPlaceholder = [NSMutableArray array];
        
        for (NSDictionary *cardDictionary in cardsArray) {
            DVMCard *card = [[DVMCard alloc] initWithDictionary: cardDictionary];
            [cardsPlaceholder addObject: card];
        }
        completion(cardsPlaceholder, nil);
    
    }]resume];
}


- (void)fetchCardImage:(DVMCard *)card completion:(void (^)(UIImage *, NSError * ))completion
{
    NSURL *imageURL = [NSURL URLWithString:card.image];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:imageURL completionHandler:^(NSData * data, NSURLResponse *  response, NSError * error) {
        
        if (error) {
            NSLog(@"there was an error  %s: %@, %@", __PRETTY_FUNCTION__, error, [error localizedDescription]);
            return completion(nil, [NSError errorWithDomain:@"there was an error fetching json" code:(NSInteger)-1 userInfo:nil]);
        }
        
        if (!data) {
            NSLog(@"Error fetching image %s: %@, %@" ,  __PRETTY_FUNCTION__, error, [error localizedDescription]);
            return completion(nil, [NSError errorWithDomain:@"Error fetching image" code:(NSInteger)-1 userInfo:nil]);
        }
        
        UIImage *image = [UIImage imageWithData:data];
        completion(image, nil);
        
    }]resume];
}

+ (NSURL *)baseURL
{
    return [NSURL URLWithString:@"https://deckofcardsapi.com/api/deck/new/draw/"];
}


@end
