//
//  DebugLog.h
//  Bedim
//
//  Created by Victor Gama on 16/10/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#ifndef DebugLog_h
#define DebugLog_h

#ifdef DEBUG
    #define Debug(...) NSLog(__VA_ARGS__);
#else
    #define Debug(...) while(false){};
#endif
#endif /* DebugLog_h */
