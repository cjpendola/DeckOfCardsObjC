//
//  DVMCard.h
//  DeckOfCardsObjC
//
//  Created by Carlos Pendola on 2/12/19.
//  Copyright © 2019 Carlos Pendola. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DVMCard : NSObject

@property (nonatomic, copy, readonly) NSString *suit;
@property (nonatomic, copy, readonly) NSString *image;

- (instancetype)initWithSuit : (NSString *)suit
                       image : (NSString *)image;

- (instancetype)initWithDictionary : (NSDictionary *)dictionary;



@end

NS_ASSUME_NONNULL_END
