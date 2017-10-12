//
//  main.m
//  sdwx-pc-js
//
//  Created by 张元科 on 2017/8/30.
//  Copyright © 2017年 SDJG. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        NSString *path = @"./sdjgwx.js";
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSString *str = [data base64EncodedStringWithOptions:0];
        NSLog(@"%@\n",str);
    }
    return 0;
}
