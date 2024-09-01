// DatabaseManager.m
#import "DatabaseManager.h"
#import "AppDelegate.h"

@implementation DatabaseManager

+ (instancetype)sharedManager {
    static DatabaseManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)saveCardWithID:(NSString *)cardID
                 nombre:(NSString *)nombre
         primeraConexion:(BOOL)primeraConexion
                  tipo:(NSString *)tipo {
    NSManagedObjectContext *context = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    
    NSManagedObject *newCard = [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:context];
    [newCard setValue:cardID forKey:@"idCard"];
    [newCard setValue:nombre forKey:@"nombreCard"];
    [newCard setValue:@(primeraConexion) forKey:@"primeraConeccion"];
    [newCard setValue:tipo forKey:@"tipoCard"];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Error al guardar en la base de datos: %@, %@", error, error.userInfo);
    } else {
        NSLog(@"Datos guardados exitosamente en la base de datos.");
    }
}
- (NSArray *)fetchAllCards {
    NSManagedObjectContext *context = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Card"];

    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Error al obtener las tarjetas: %@, %@", error, error.userInfo);
        return @[];
    }
    return result;
}

@end
