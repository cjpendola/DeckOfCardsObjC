//
//  DVMCardController.h
//  DeckOfCardsObjC
//
//  Created by Carlos Pendola on 2/12/19.
//  Copyright © 2019 Carlos Pendola. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DVMCard;   //!!!!IMPORTANTE!!!!

NS_ASSUME_NONNULL_BEGIN

@interface DVMCardController : NSObject

+ (instancetype)sharedController;

- (void) drawNewCard:(NSInteger)numberOfCards completion:(void(^) (NSArray<DVMCard *> *cards, NSError *error))completion;

- (void)fetchCardImage:(DVMCard *)card completion:(void(^) (UIImage *image, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
