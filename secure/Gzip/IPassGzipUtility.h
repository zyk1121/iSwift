
#import <Foundation/Foundation.h>

@interface IPassGzipUtility : NSObject

// 数据压缩
+ ( NSData *)iPassCompressData:( NSData *)uncompressedData;

// 数据解压缩
+ ( NSData *)deiPassCompressData:( NSData *)compressedData;

@end
