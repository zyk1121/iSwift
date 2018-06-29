
#import <Foundation/Foundation.h>

@class NSString;

@interface NSData (IPassEncryption)

- (NSData *)iPassAES256EncryptWithKey:(NSString *)key;   //加密
- (NSData *)iPassAES256DecryptWithKey:(NSString *)key;   //解密

@end
