//
//  AppDelegate.m
//  TapCardCheckoutObjectiveCExample
//
//  Created by Osama Rabie on 01/08/2022.
//

#import "AppDelegate.h"
#import <TapCardCheckOutKit/TapCardCheckOutKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    
    TapCardDataConfiguration* config = [[TapCardDataConfiguration alloc]initWithSdkMode:Sandbox localeIdentifier:@"en" secretKey:[[SecretKey alloc] initWithSandbox:@"" production:@""]];
    
    [[TapCardForumConfiguration shared] configureWithDataConfig:config customTheme:nil customLocalisation:nil onCheckOutReady:^{
        
    } onErrorOccured:^(NSError * error) {
        
    }];
    
    /*let cardDataConfig:TapCardDataConfiguration = .init(sdkMode: .sandbox, localeIdentifier: "en", secretKey: .init(sandbox: "sk_test_yKOxBvwq3oLlcGS6DagZYHM2", production: "sk_live_V4UDhitI0r7sFwHCfNB6xMKp"))
    TapCardForumConfiguration.shared.configure(dataConfig: cardDataConfig) {
        DispatchQueue.main.async { [weak self] in
            self?.loadingIndicator.isHidden = true
        }
    } onErrorOccured: { error in
        DispatchQueue.main.async { [weak self] in
            let uiAlertController:UIAlertController = .init(title: "Error from middleware", message: error?.localizedDescription ?? "", preferredStyle: .actionSheet)
            let uiAlertAction:UIAlertAction = .init(title: "Retry", style: .destructive) { _ in
                self?.configureSDK()
            }
            uiAlertController.addAction(uiAlertAction)
            self?.present(uiAlertController, animated: true)
        }
    }*/
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
