//
//  BDFileSystem.m
//  Bedim
//
//  Created by Victor Gama on 15/10/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import <dirent.h>
#import <sys/stat.h>
#import <Cocoa/Cocoa.h>
#import "BDFileSystem.h"
#import "BDUtility.h"

@implementation BDFileSystem

+ (unsigned long long)getFolderSize:(NSString *)folderPath {
    char *dir = (char *)[folderPath fileSystemRepresentation];
    DIR *cd;
    
    struct dirent *dirInfo;
    long lastChar;
    struct stat linfo;
    unsigned long long totalSize = 0;
    
    cd = opendir(dir);
    if(!cd) {
        return 0;
    }
    
    while((dirInfo = readdir(cd)) != NULL) {
        if(strcmp(dirInfo->d_name, ".") == 0 || strcmp(dirInfo->d_name, "..") == 0) {
            continue;
        }
        
        char *dName;
        dName = (char *)malloc(strlen(dir) + strlen(dirInfo->d_name) + 2);
        
        if(!dName) {
            // OOM?
            break;
        }
        
        strcpy(dName, dir);
        lastChar = strlen(dir) - 1;
        if(lastChar >= 0 && dir[lastChar] != '/') {
            strcat(dName, "/");
        }
        strcat(dName, dirInfo->d_name);
        
        if(lstat(dName, &linfo) == -1) {
            free(dName);
            continue;
        }
        
        if(S_ISDIR(linfo.st_mode)) {
            if(!S_ISLNK(linfo.st_mode)) {
                totalSize += [self getFolderSize:[NSString stringWithUTF8String:dName]];
            }
            free(dName);
        } else {
            if(S_ISREG(linfo.st_mode)) {
                totalSize += linfo.st_size;
            } else {
                free(dName);
            }
        }
    }
    
    closedir(cd);
    return totalSize;
}

+ (BOOL)isBedimDomainImage:(NSString *)name {
    return [name hasPrefix:[self cachePath]];
}

+ (NSString *)cachePathForImageWithPath:(NSString *)original {
    return [[self cachePath] stringByAppendingPathComponent:[BDUtility digestString:original]];
}

+ (NSString *)cachePath {
    NSString *path = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    if ([paths count]) {
        NSString *bundleName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
        path = [[paths objectAtIndex:0] stringByAppendingPathComponent:bundleName];
        if(![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:nil]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return path;
}

+ (void)clearCache {
    NSFileManager *fs = [NSFileManager defaultManager];
    NSString *path = [self cachePath];
    BOOL success = [fs removeItemAtPath:path error:nil];
    if(success) {
        [fs createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

@end
