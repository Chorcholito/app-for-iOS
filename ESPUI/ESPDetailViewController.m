//
//  ESPDetailViewController.m
//  EspBlufi
//
//  Created by fanbaoying on 2020/6/10.
//  Copyright © 2020 espressif. All rights reserved.
//

#import "ESPDetailViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "ESPProvisionViewController.h"
#import "BlufiClient.h"
#import "DatabaseManager.h"

typedef enum {
    TagConnect = 6000,
    TagDisconnect,
    TagSecurity,
    TagVersion,
    TagConfigure,
    TagState,
    TagScan,
    TagCustom,
} TagButton;

@interface ESPDetailViewController () <CBCentralManagerDelegate, CBPeripheralDelegate, BlufiDelegate, UITableViewDelegate, UITableViewDataSource, ConfigureParamsDelegate>



@property(strong, nonatomic)UIButton *connectBtn;
@property(strong, nonatomic)UIButton *disConnectBtn;
@property(strong, nonatomic)UIButton *encryptionBtn;
@property(strong, nonatomic)UIButton *versionBtn;
@property(strong, nonatomic)UIButton *configureBtn;
@property(strong, nonatomic)UIButton *stateBtn;
@property(strong, nonatomic)UIButton *scanBtn;
@property(strong, nonatomic)UIButton *customBtn;

@property(strong, nonatomic)UITableView *messageView;
@property(strong, nonatomic)NSMutableArray *messageArray;

@property(strong, nonatomic)BlufiClient *blufiClient;
@property(assign, atomic)BOOL connected;

// Nueva propiedad para la vista de carga
@property(strong, nonatomic)UIView *loadingView;
@property(strong, nonatomic)UILabel *loadingLabel;

@property (strong, nonatomic) NSString *receivedCustomDataString; // Para almacenar los datos como string
@property (strong, nonatomic) NSData *receivedCustomData; // Para almacenar los datos como NSData
@property (strong, nonatomic) NSString *nuevoID; // Propiedad para almacenar la cadena 12345678


@end

@implementation ESPDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = _device.name;
    self.connected = NO;
    // Inicializar customDataString
    self.nuevoID = @"12345678";
    
    // Configurar la vista de carga
    [self setupLoadingView];
    
    // Configurar la vista base
    [self setupBasedView];
    
    // Iniciar la conexión automáticamente al cargar la vista
    [self connect];
}

// Método para configurar la vista de carga
- (void)setupLoadingView {
    self.loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.loadingView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5]; // Fondo semitransparente para mejor visibilidad
    self.loadingView.hidden = YES; // Inicialmente oculta
    [self.view addSubview:self.loadingView];

    // Crear un UIActivityIndicatorView y añadirlo a la loadingView
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    activityIndicator.center = CGPointMake(self.loadingView.center.x, self.loadingView.center.y - 30); // Ajustar la posición
    activityIndicator.color = [UIColor whiteColor]; // Cambiar el color del indicador a blanco
    activityIndicator.hidesWhenStopped = YES;
    [self.loadingView addSubview:activityIndicator];
    [activityIndicator startAnimating]; // Iniciar la animación del indicador de actividad

    self.loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    self.loadingLabel.center = CGPointMake(self.loadingView.center.x, self.loadingView.center.y + 30); // Ajustar la posición
    self.loadingLabel.text = @"Connecting...";
    self.loadingLabel.textAlignment = NSTextAlignmentCenter;
    self.loadingLabel.textColor = [UIColor whiteColor]; // Cambiar el color del texto a blanco
    [self.loadingView addSubview:self.loadingLabel];
}


- (void)setupBasedView {
    UIView *reminderView = [[UIView alloc] initWithFrame:CGRectMake(0, statusHeight + 44, SCREEN_WIDTH, SCREEN_HEIGHT - statusHeight - 164)];
    [self.view addSubview:reminderView];
    
    UIView *operationView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 120, SCREEN_HEIGHT, 100)];
    [self.view addSubview:operationView];
    
    NSArray *operationArr = @[INTER_STR(@"EspBlufi-operation-connect"), INTER_STR(@"EspBlufi-operation-disConnect"), INTER_STR(@"EspBlufi-operation-encryption"), INTER_STR(@"EspBlufi-operation-version"), INTER_STR(@"EspBlufi-operation-provision"), INTER_STR(@"EspBlufi-operation-state"), INTER_STR(@"EspBlufi-operation-scan"), INTER_STR(@"EspBlufi-operation-custom")];
    for (int i = 0; i < operationArr.count; i ++ ) {
        int firstCount = 0;
        int twoCount = 0;
        if (i < 4) {
            firstCount = ((SCREEN_WIDTH - 40) / 4 + 10) * i;
        } else {
            firstCount = ((SCREEN_WIDTH - 40) / 4 + 10) * (i - 4);
            twoCount = 50;
        }
        UIButton *myButton = [[UIButton alloc] initWithFrame:CGRectMake(5 + firstCount, 5 + twoCount, (SCREEN_WIDTH - 40) / 4, 40)];
        [myButton setTitle:operationArr[i] forState:0];
        [myButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        myButton.tag = TagConnect + i;
        [myButton addTarget:self action:@selector(onButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [myButton addTarget:self action:@selector(onButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [myButton addTarget:self action:@selector(onButtonTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
        myButton.layer.cornerRadius = 5.0;
        myButton.clipsToBounds = YES;
        if (i == 0) {
            [self setButton:myButton enable:YES];
        } else {
            [self setButton:myButton enable:NO];
        }
        switch (myButton.tag) {
            case TagConnect:
                self.connectBtn = myButton;
                break;
            case TagDisconnect:
                self.disConnectBtn = myButton;
                break;
            case TagSecurity:
                self.encryptionBtn = myButton;
                break;
            case TagVersion:
                self.versionBtn = myButton;
                break;
            case TagConfigure:
                self.configureBtn = myButton;
                break;
            case TagState:
                self.stateBtn = myButton;
                break;
            case TagScan:
                self.scanBtn = myButton;
                break;
            case TagCustom:
                self.customBtn = myButton;
                break;
            default:
                break;
        }
        [operationView addSubview:myButton];
    }
    
    _messageView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 130)];
    _messageView.backgroundColor = [UIColor colorWithRed:80 green:80 blue:80 alpha:1];
    _messageArray = [[NSMutableArray alloc] init];
    _messageView.delegate = self;
    _messageView.dataSource = self;
    [self.view addSubview:_messageView];
}

- (void)setButton:(UIButton *)button enable:(BOOL)enable {
    if (enable) {
        button.userInteractionEnabled = YES;
        button.backgroundColor = navColor;
        [button setTitleColor:[UIColor whiteColor] forState:0];
    } else {
        button.userInteractionEnabled = NO;
        button.backgroundColor = UICOLOR_RGBA(221, 221, 221, 1);
        [button setTitleColor:[UIColor lightGrayColor] forState:0];
    }
}

- (void)setButton:(UIButton *)button pressed:(BOOL)pressed {
    if (!button.userInteractionEnabled) {
        button.backgroundColor = UICOLOR_RGBA(221, 221, 221, 1);
        [button setTitleColor:[UIColor lightGrayColor] forState:0];
    } else {
        if (pressed) {
            button.backgroundColor = UICOLOR_RGBA(200, 40, 80, 1);
            [button setTitleColor:[UIColor whiteColor] forState:0];
        } else {
            button.backgroundColor = navColor;
            [button setTitleColor:[UIColor whiteColor] forState:0];
        }
    }
}

- (void)onButtonTouchDown:(UIButton *)sender {
    [self setButton:sender pressed:YES];
}

- (void)onButtonTouchUp:(UIButton *)sender {
    [self setButton:sender pressed:NO];
}

- (void)onButtonPressed:(UIButton *)sender {
    sender.selected = !sender.selected;
    switch (sender.tag) {
        case TagConnect:
            [self connect];
            break;
        case TagDisconnect:
            if (_blufiClient) {
                [_blufiClient requestCloseConnection];
            }
            break;
        case TagSecurity:
            [self setButton:sender enable:NO];
            if (_blufiClient) {
                [_blufiClient negotiateSecurity];
            }
            break;
        case TagVersion:
            [self setButton:sender enable:NO];
            if (_blufiClient) {
                [_blufiClient requestDeviceVersion];
            }
            break;
        case TagConfigure:
            [self pushProvision];
            break;
        case TagState:
            [self setButton:sender enable:NO];
            if (_blufiClient) {
                [_blufiClient requestDeviceStatus];
            }
            break;
        case TagScan:
            [self setButton:sender enable:NO];
            if (_blufiClient) {
                [_blufiClient requestDeviceScan];
            }
            break;
        case TagCustom:
            [self setButton:self.customBtn enable:NO];
            [self showCustomDataAlert];
            break;
        default:
            break;
    }
    [self setButton:sender pressed:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    if (!ValidArray(_messageArray)) {
        return cell;
    }
    
    NSString *message = _messageArray[indexPath.row];
    cell.textLabel.text = message;
    cell.textLabel.numberOfLines = 0;
    return cell;
}

- (void)updateMessage:(NSString *)message {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.messageArray addObject:message];
        NSArray *insertIndexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.messageArray.count-1 inSection:0]];
        [self.messageView beginUpdates];
        [self.messageView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
        [self.messageView endUpdates];
        [self.messageView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self->_messageArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }];
}

- (void)connect {
    [self setButton:_connectBtn enable:NO];
    
    // Mostrar la vista de carga
    self.loadingView.hidden = NO;
    self.loadingLabel.text = @"Connecting...";

    // Ocultar botones y vista de mensajes
    [self hideUIElements];
    
    if (_blufiClient) {
        [_blufiClient close];
        _blufiClient = nil;
    }
    
    _blufiClient = [[BlufiClient alloc] init];
    _blufiClient.centralManagerDelete = self;
    _blufiClient.peripheralDelegate = self;
    _blufiClient.blufiDelegate = self;
    [_blufiClient connect:_device.uuid.UUIDString];
}

- (void)hideUIElements {
    self.connectBtn.hidden = YES;
    self.disConnectBtn.hidden = YES;
    self.encryptionBtn.hidden = YES;
    self.versionBtn.hidden = YES;
    self.configureBtn.hidden = YES;
    self.stateBtn.hidden = YES;
    self.scanBtn.hidden = YES;
    self.customBtn.hidden = YES;
    self.messageView.hidden = YES;
}

- (void)showUIElements {
    self.connectBtn.hidden = NO;
    self.disConnectBtn.hidden = NO;
    self.encryptionBtn.hidden = NO;
    self.versionBtn.hidden = NO;
    self.configureBtn.hidden = NO;
    self.stateBtn.hidden = NO;
    self.scanBtn.hidden = NO;
    self.customBtn.hidden = NO;
    self.messageView.hidden = NO;
}

- (void)pushProvision {
    ESPProvisionViewController *pvc = [ESPProvisionViewController new];
    pvc.paramsDelegate = self;
    [self.navigationController pushViewController:pvc animated:YES];
}

- (void)didSetParams:(BlufiConfigureParams *)params {
    if (_blufiClient && _connected) {
        [_blufiClient configure:params];
    }
}

- (void)showCustomDataAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:INTER_STR(@"EspBlufi-custom-data") preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:INTER_STR(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self setButton:self.customBtn enable:self.connected];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:INTER_STR(@"ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setButton:self.customBtn enable:self.connected];
        UITextField *filterTextField = alertController.textFields.firstObject;
        NSString *text = filterTextField.text;
        if (text && text.length > 0 && self.blufiClient) {
            NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
            [self.blufiClient postCustomData:data];
        }
    }]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = INTER_STR(@"EspBlufi-custom-data-hint");
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)onDisconnected {
    if (_blufiClient) {
        [_blufiClient close];
    }
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self setButton:self.connectBtn enable:YES];
        
        [self setButton:self.disConnectBtn enable:NO];
        [self setButton:self.encryptionBtn enable:NO];
        [self setButton:self.versionBtn enable:NO];
        [self setButton:self.configureBtn enable:NO];
        [self setButton:self.stateBtn enable:NO];
        [self setButton:self.scanBtn enable:NO];
        [self setButton:self.customBtn enable:NO];
    }];
}

- (void)onBlufiPrepared {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self setButton:self.connectBtn enable:NO];
        
        [self setButton:self.disConnectBtn enable:YES];
        [self setButton:self.encryptionBtn enable:YES];
        [self setButton:self.versionBtn enable:YES];
        [self setButton:self.configureBtn enable:YES];
        [self setButton:self.stateBtn enable:YES];
        [self setButton:self.scanBtn enable:YES];
        [self setButton:self.customBtn enable:YES];
        
        [self pushProvision];
    }];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    // Mostrar mensaje de conexión exitosa en la vista de carga
    // Mostrar la vista de carga
    self.loadingView.hidden = NO;
    self.loadingLabel.text = @"Connecting...";
    
   
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    // Mostrar mensaje de error y volver a la pantalla de búsqueda de dispositivos
    [self showAlertWithTitle:@"Connection Failed" message:@"Failed to connect to the device." isSuccessful:NO];
    self.connected = NO;
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    // Mostrar mensaje de error y volver a la pantalla de búsqueda de dispositivos
    [self showAlertWithTitle:@"Disconnected" message:@"Device disconnected." isSuccessful:NO];
    self.connected = NO;
}

- (void)blufi:(BlufiClient *)client gattPrepared:(BlufiStatusCode)status service:(CBService *)service writeChar:(CBCharacteristic *)writeChar notifyChar:(CBCharacteristic *)notifyChar {
    NSLog(@"Blufi gattPrepared status:%d", status);
    if (status == StatusSuccess) {
        self.connected = YES;
        [self updateMessage:@"BluFi connection has prepared"];
        [self onBlufiPrepared];
    } else {
        // Mostrar mensaje de error y volver a la pantalla de búsqueda de dispositivos
        [self showAlertWithTitle:@"Error" message:@"Failed to prepare BluFi connection." isSuccessful:NO];
        [self onDisconnected];
    }
}

- (void)blufi:(BlufiClient *)client didNegotiateSecurity:(BlufiStatusCode)status {
    NSLog(@"Blufi didNegotiateSecurity %d", status);
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self setButton:self.encryptionBtn enable:self.connected];
    }];
    if (status == StatusSuccess) {
        [self updateMessage:@"Negotiate security complete"];
    } else {
        [self updateMessage:[NSString stringWithFormat:@"Negotiate security failed: %d", status]];
    }
}

- (void)blufi:(BlufiClient *)client didReceiveDeviceVersionResponse:(BlufiVersionResponse *)response status:(BlufiStatusCode)status {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self setButton:self.versionBtn enable:self.connected];
    }];
    if (status == StatusSuccess) {
        [self updateMessage:[NSString stringWithFormat:@"Receive device version: %@", response.getVersionString]];
    } else {
        [self updateMessage:[NSString stringWithFormat:@"Receive device version error: %d", status]];
    }
}

- (void)blufi:(BlufiClient *)client didPostConfigureParams:(BlufiStatusCode)status {
    if (status == StatusSuccess) {
        [self updateMessage:@"Post configure params complete"];
        // Crear los datos personalizados que deseas enviar
        // Utilizar la propiedad de clase customDataString en lugar del valor literal
          NSData *customData = [self.nuevoID dataUsingEncoding:NSUTF8StringEncoding];

        // Enviar los datos personalizados al ESP32
        [client postCustomData:customData];
        
    } else {
        [self updateMessage:[NSString stringWithFormat:@"Post configure params failed: %d", status]];
    }
}

- (void)blufi:(BlufiClient *)client didReceiveDeviceStatusResponse:(BlufiStatusResponse *)response status:(BlufiStatusCode)status {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self setButton:self.stateBtn enable:self.connected];
    }];
    if (status == StatusSuccess) {
        // Verificar si la conexión WiFi fue exitosa
        if (response.staConnectionStatus == 0) { 
            
            
            // Aquí guardamos los datos en la base de datos
                     NSString *nombreCard = @"equipo1"; // Nombre fijo
                     BOOL primeraConexion = NO; // Valor fijo de primeraConeccion
                     
                     // Guardar en la base de datos
                     [[DatabaseManager sharedManager] saveCardWithID:self.nuevoID
                                                              nombre:nombreCard
                                                      primeraConexion:primeraConexion
                                                               tipo:self.receivedCustomDataString];
                     
            
            
            
            
            
            
            [self updateMessage:@"WiFi connected successfully"];
            [self showAlertWithTitle:@"Connection Successful" message:@"WiFi connected successfully." isSuccessful:YES];
        } else {
            // Manejar el caso donde la conexión WiFi no fue exitosa
            [self updateMessage:@"WiFi connection failed"];
            [self showAlertWithTitle:@"Connection Failed" message:@"WiFi connection failed." isSuccessful:NO];
        }
    } else {
        // Manejar errores en la respuesta del estado del dispositivo
        [self updateMessage:[NSString stringWithFormat:@"Receive device status error: %d", status]];
        [self showAlertWithTitle:@"Error" message:[NSString stringWithFormat:@"Receive device status error: %d", status] isSuccessful:NO];
    }
}

- (void)blufi:(BlufiClient *)client didReceiveDeviceScanResponse:(NSArray<BlufiScanResponse *> *)scanResults status:(BlufiStatusCode)status {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self setButton:self.scanBtn enable:self.connected];
    }];
    if (status == StatusSuccess) {
        NSMutableString *info = [[NSMutableString alloc] init];
        [info appendString:@"Receive device scan results:\n"];
        for (BlufiScanResponse *response in scanResults) {
            [info appendFormat:@"SSID: %@, RSSI: %d\n", response.ssid, response.rssi];
        }
        [self updateMessage:info];
    } else {
        [self updateMessage:[NSString stringWithFormat:@"Receive device scan results error: %d", status]];
    }
}

- (void)blufi:(BlufiClient *)client didPostCustomData:(nonnull NSData *)data status:(BlufiStatusCode)status {
    if (status == StatusSuccess) {
        [self updateMessage:@"Post custom data complete"];
    } else {
        [self updateMessage:[NSString stringWithFormat:@"Post custom data failed: %d", status]];
    }
}

- (void)blufi:(BlufiClient *)client didReceiveCustomData:(NSData *)data status:(BlufiStatusCode)status {
    // Convertir los datos recibidos a una cadena de texto para visualización
    NSString *customString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    // Almacenar los datos recibidos en las propiedades de clase
    self.receivedCustomDataString = customString;
    self.receivedCustomData = data;
    
    // Actualizar la vista de mensajes con los datos recibidos
    [self updateMessage:[NSString stringWithFormat:@"Receive device custom data: %@", customString]];
      
    // Log para ver los datos personalizados en la consola
    NSLog(@"Received custom data: %@", customString);
}

// Método para mostrar una alerta y navegar según el resultado
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message isSuccessful:(BOOL)success {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (success) {
            // Navegar a la pantalla principal
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            // Navegar a la pantalla de búsqueda de dispositivos
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
