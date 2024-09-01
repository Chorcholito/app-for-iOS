//  AppDelegate.h
//  EspBlufi
//
//  Created by fanbaoying on 2020/6/9.
//  Copyright © 2020 espressif. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h> // Añadir esta línea para importar CoreData

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// Añadir esta propiedad
@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext; // Declaración del método para guardar el contexto

@end
