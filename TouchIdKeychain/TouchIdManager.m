//
//  TouchIdManager.m
//  TouchIdKeychain
//
//  Created by Manish Kumar on 3/3/17.
//  Copyright © 2017 Manish Kumar. All rights reserved.
//

#import "TouchIdManager.h"
#import <Security/Security.h>

@implementation TouchIdManager
+(void)addKeychainPassword:(NSString*)data{
    CFErrorRef error = NULL;
    // Should be the secret invalidated when passcode is removed? If not then use kSecAttrAccessibleWhenUnlocked
    SecAccessControlRef sacObject = SecAccessControlCreateWithFlags(kCFAllocatorDefault,
                                                                    kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
                                                                    kSecAccessControlUserPresence,
                                                                    &error);
    if (sacObject == NULL || error != NULL) {
        NSString *errorString = [NSString stringWithFormat:@"SecItemAdd can't create sacObject: %@", error];
        NSLog(@"Got --%@",errorString);
      
    }
    NSData *secretPasswordTextData = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *attributes = @{
                                 (id)kSecClass: (id)kSecClassGenericPassword,
                                 (id)kSecAttrService: @"SampleService",
                                 (id)kSecValueData: secretPasswordTextData,
                                 (id)kSecUseAuthenticationUI: (id)kSecUseAuthenticationUIAllow,
                                 (id)kSecAttrAccessControl: (__bridge_transfer id)sacObject
                                 };
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OSStatus status1 = SecItemDelete((__bridge CFDictionaryRef)attributes);
        NSString *message1 = [NSString stringWithFormat:@"SecItemDelete status: %@", [self keychainErrorToString:status1]];
        NSLog(@"%@", message1);
        OSStatus status =  SecItemAdd((__bridge CFDictionaryRef)attributes, nil);
        
        NSString *message = [NSString stringWithFormat:@"SecItemAdd status: %@", [self keychainErrorToString:status]];
        NSLog(@"%@", message);
    });

}

+ (NSString *)keychainErrorToString:(OSStatus)error {
    NSString *message = [NSString stringWithFormat:@"%ld", (long)error];
    
    switch (error) {
        case errSecSuccess:
            message = @"success";
            break;
            
        case errSecDuplicateItem:
            message = @"error item already exists";
            break;
            
        case errSecItemNotFound :
            message = @"error item not found";
            break;
            
        case errSecAuthFailed:
            message = @"error item authentication failed";
            break;
            
        default:
            break;
    }
    
    return message;
}
+(NSString*)fetchKeychainPassword:(NSString*)data{
    NSDictionary *query = @{
                            (id)kSecClass: (id)kSecClassGenericPassword,
                            (id)kSecAttrService: @"SampleService",
                            (id)kSecReturnData: @YES,
                            (id)kSecUseOperationPrompt: @"Authenticate to access service password",
                            };
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CFTypeRef dataTypeRef = NULL;
        NSString *message;
        
        OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)(query), &dataTypeRef);
        if (status == errSecSuccess) {
            NSData *resultData = (__bridge_transfer NSData *)dataTypeRef;
            
            NSString *result = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
            
            message = [NSString stringWithFormat:@"Result: %@\n", result];
        }
        else {
            message = [NSString stringWithFormat:@"SecItemCopyMatching status: %@", [self keychainErrorToString:status]];
        }
        NSLog(@"%@",message);
       // [self printMessage:message inTextView:self.textView];
    });
    return @"Manish";
}
@end
