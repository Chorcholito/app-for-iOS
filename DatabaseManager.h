//
//  DatabaseManager.h
//  EspBlufi
//
//  Created by Jorge Diaz on 25.08.2024.
//  Copyright © 2024 espressif. All rights reserved.
//

#ifndef DatabaseManager_h
#define DatabaseManager_h
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DatabaseManager : NSObject

+ (instancetype)sharedManager;

- (void)saveCardWithID:(NSString *)cardID
                 nombre:(NSString *)nombre
         primeraConexion:(BOOL)primeraConexion
                  tipo:(NSString *)tipo;

@end


#endif /* DatabaseManager_h */
