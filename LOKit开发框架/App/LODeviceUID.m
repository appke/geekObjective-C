
//
//  LODeviceUID.m
//  Foundation
//
//  Created by 方立立 on 2016/10/26.
//
//

#import "LODeviceUID.h"
#import <UIKit/UIKit.h>

@interface LODeviceUID() {
    NSString *uidKey_;
}

@end

@implementation LODeviceUID

@synthesize uid = _uid;

#pragma mark - Public methods
+ (LODeviceUID *)currentDevice
{
    static LODeviceUID *currentDevice_ = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentDevice_ = [[self alloc] initWithKey:@"LODeviceUID"];
    });
    return currentDevice_;
}

#pragma mark - Instance methods

- (id)initWithKey:(NSString *)key {
    self = [super init];
    if (self) {
        uidKey_ = key;
    }
    return self;
}

/*! Returns the Device UID.
 The UID is obtained in a chain of fallbacks:
 - Keychain
 - NSUserDefaults
 - Apple IFV (Identifier for Vendor)
 - Generate a random UUID if everything else is unavailable
 At last, the UID is persisted if needed to.
 */
- (NSString *)uid {
    if (!_uid) {
        _uid = [self valueForKeychainKey:uidKey_ service:uidKey_];
        if (!_uid) _uid = [self valueForUserDefaultsKey:uidKey_];
        if (!_uid) _uid = [self appleIDFV];
        if (!_uid) _uid = [self randomUUID];
        [self save];
    }
    
    return _uid;
}

/*! Persist UID to NSUserDefaults and Keychain, if not yet saved
 */
- (void)save {
    if (![self valueForUserDefaultsKey:uidKey_]) {
        [self setValue:self.uid forUserDefaultsKey:uidKey_];
    }
    if (![self valueForKeychainKey:uidKey_ service:uidKey_]) {
        [self setValue:self.uid forKeychainKey:uidKey_ inService:uidKey_];
    }
}

#pragma mark - Keychain methods
/*! Create as generic NSDictionary to be used to query and update Keychain items.
 *  param1
 *  param2
 */
- (NSMutableDictionary *)keychainItemForKey:(NSString *)key service:(NSString *)service {
    NSMutableDictionary *keychainItem = [[NSMutableDictionary alloc] init];
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleAlways;
    keychainItem[(__bridge id)kSecAttrAccount] = key;
    keychainItem[(__bridge id)kSecAttrService] = service;
    return keychainItem;
}

/*! Sets
 *  param1
 *  param2
 */
- (OSStatus)setValue:(NSString *)value forKeychainKey:(NSString *)key inService:(NSString *)service {
    NSMutableDictionary *keychainItem = [self keychainItemForKey:key service:service];
    keychainItem[(__bridge id)kSecValueData] = [value dataUsingEncoding:NSUTF8StringEncoding];
    return SecItemAdd((__bridge CFDictionaryRef)keychainItem, NULL);
}

- (NSString *)valueForKeychainKey:(NSString *)key service:(NSString *)service {
    OSStatus status;
    NSMutableDictionary *keychainItem = [self keychainItemForKey:key service:service];
    keychainItem[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
    keychainItem[(__bridge id)kSecReturnAttributes] = (__bridge id)kCFBooleanTrue;
    CFDictionaryRef result = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, (CFTypeRef *)&result);
    if (status != noErr) {
        return nil;
    }
    NSDictionary *resultDict = (__bridge_transfer NSDictionary *)result;
    NSData *data = resultDict[(__bridge id)kSecValueData];
    if (!data) {
        return nil;
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

#pragma mark - NSUserDefaults methods

- (BOOL)setValue:(NSString *)value forUserDefaultsKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)valueForUserDefaultsKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

#pragma mark - UID Generation methods

- (NSString *)appleIDFA {
    NSString *ifa = nil;
    Class ASIdentifierManagerClass = NSClassFromString(@"ASIdentifierManager");
    if (ASIdentifierManagerClass) { // a dynamic way of checking if AdSupport.framework is available
        SEL sharedManagerSelector = NSSelectorFromString(@"sharedManager");
        id sharedManager = ((id (*)(id, SEL))[ASIdentifierManagerClass methodForSelector:sharedManagerSelector])(ASIdentifierManagerClass, sharedManagerSelector);
        SEL advertisingIdentifierSelector = NSSelectorFromString(@"advertisingIdentifier");
        NSUUID *advertisingIdentifier = ((NSUUID* (*)(id, SEL))[sharedManager methodForSelector:advertisingIdentifierSelector])(sharedManager, advertisingIdentifierSelector);
        ifa = [advertisingIdentifier UUIDString];
    }
    return ifa;
}

- (NSString *)appleIDFV {
    if(NSClassFromString(@"UIDevice") && [UIDevice instancesRespondToSelector:@selector(identifierForVendor)]) {
        // only available in iOS >= 6.0
        return [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    return nil;
}

- (NSString *)randomUUID {
    if(NSClassFromString(@"NSUUID")) {
        return [[NSUUID UUID] UUIDString];
    }
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef cfuuid = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
    CFRelease(uuidRef);
    NSString *uuid = [((__bridge NSString *) cfuuid) copy];
    CFRelease(cfuuid);
    return uuid;
}

@end
