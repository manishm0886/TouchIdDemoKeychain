//
//  TouchIdManager.h
//  TouchIdKeychain
//
//  Created by Manish Kumar on 3/3/17.
//  Copyright © 2017 Manish Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TouchIdManager : NSObject

+(void)addKeychainPassword:(NSString*)data;
+(NSString*)fetchKeychainPassword:(NSString*)data;

@end
