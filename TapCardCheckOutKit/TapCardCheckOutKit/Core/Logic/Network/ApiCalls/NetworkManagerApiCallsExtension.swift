//
//  NetworkManagerApiCallsExtension.swift
//  TapCardCheckOutKit
//
//  Created by Osama Rabie on 22/03/2022.
//

import Foundation
import CommonDataModelsKit_iOS
import TapCardVlidatorKit_iOS

internal extension NetworkManager {
    
    
    /// Responsible for making the network calls needed to boot the SDK like init and payment options
    /// - Parameter onCheckoutRead: A block to execure upon completion
    /// - Parameter onErrorOccured: A block to execure upon error
    func configSDK(onCheckOutReady: @escaping () -> () = {},onErrorOccured: @escaping(Error?)->() = {_ in}) {
        
        // As per the backend logic, we will have to hit Config, then Init.
        
        // Create the Config request with the configured data from the user
        let configRequest = sharedNetworkManager.createConfigRequestModel()
        
        // Change the model into a dictionary
        guard let bodyDictionary = NetworkManager.convertModelToDictionary(configRequest, callingCompletionOnFailure: { error in
            return
        }) else { return }
        
        
        sharedNetworkManager.makeApiCall(routing: .ConfigAPI, resultType: TapConfigResponseModel.self, body: .init(body: bodyDictionary), httpMethod: .POST) { [weak self] (session, result, error) in
            guard let configModel:TapConfigResponseModel = result as? TapConfigResponseModel else { self?.handleError(error: "Unexpected error when parsing into TapConfigResponseModel")
                return }
            // Let us store the config object for further access
            self?.handleConfigResponse(configModel: configModel)
            // We got the middleware token, now let us init the SDK and get the merchant and payment types details
            self?.initialiseSDKFromAPI(onCheckOutReady: onCheckOutReady)
        } onError: { (session, result, errorr) in
            onErrorOccured(errorr)
            self.handleError(error: errorr)
        }
    }
    
    /// Responsible for making the network calls needed to boot the SDK like init and payment options
    /// /// - Parameter onCheckoutRead: A block to execure upon completion
    /// - Parameter onErrorOccured: A block to execure upon error
    func initialiseSDKFromAPI(onCheckOutReady: @escaping () -> () = {} ,onErrorOccured: @escaping(Error?)->() = {_ in}) {
        // As per the backend logic, we will have to hit INIT
        sharedNetworkManager.makeApiCall(routing: .InitAPI, resultType: TapInitResponseModel.self, httpMethod: .POST) { [weak self] (session, result, error) in
            guard let initModel:TapInitResponseModel = result as? TapInitResponseModel else { self?.handleError(error: "Unexpected error when parsing into TapInitResponseModel")
                return }
            self?.handleInitResponse(initModel: initModel)
            onCheckOutReady()
        } onError: { (session, result, errorr) in
            onErrorOccured(errorr)
            self.handleError(error: errorr)
        }
    }
    
    /**
     Respinsiboe for calling create token for a card api
     - Parameter cardTokenRequest: The cardToken request model to be called with
     - Parameter onResponseReady: A block to call when getting the response
     - Parameter onErrorOccured: A block to call when an error occured
     */
    func callCardTokenAPI(cardTokenRequestModel:TapCreateTokenRequest, onResponeReady: @escaping (Token) -> () = {_ in}, onErrorOccured: @escaping(Error)->() = {_ in}) {
        
        // Change the model into a dictionary
        guard let bodyDictionary = NetworkManager.convertModelToDictionary(cardTokenRequestModel, callingCompletionOnFailure: { error in
            onErrorOccured(error.debugDescription)
            return
        }) else { return }
        
        // Call the corresponding api based on the transaction mode
        // Perform the retrieve request with the computed data
        sharedNetworkManager.makeApiCall(routing: cardTokenRequestModel.route, resultType: Token.self, body: .init(body: bodyDictionary),httpMethod: .POST, urlModel: .none) { (session, result, error) in
            // Double check all went fine
            guard let parsedResponse:Token = result as? Token else {
                onErrorOccured("Unexpected error parsing into token")
                return
            }
            // Execute the on complete block
            onResponeReady(parsedResponse)
        } onError: { (session, result, errorr) in
            // In case of an error we execute the on error block
            onErrorOccured(errorr.debugDescription)
        }
    }
    
    
    /// Retrieves BIN number details for the given `binNumber` and calls `completion` when request finishes.
    ///
    /// - Parameters:
    ///   - binNumber: First 6 digits of the card.
    ///   - completion: Completion that will be called when request finishes.
    func callBinLookup(for binNumber: String?, onResponeReady: @escaping (TapBinResponseModel) -> () = {_ in}, onErrorOccured: @escaping(Error)->() = {_ in}) {
        // check if we have to call the api or not
        guard let binNumber = binNumber,
              shouldWeCallBinLookUpAgain(with: binNumber) else { return }
        
        let bodyModel = ["bin":binNumber]
        
        // Perform the retrieve request with the computed data
        binLookUpInProcessNumber =  binNumber
        
        sharedNetworkManager.makeApiCall(routing: TapNetworkPath.bin, resultType: TapBinResponseModel.self, body: .init(body: bodyModel), httpMethod: .POST) { [weak self] (session, result, error) in
            // Double check all went fine
            guard let parsedResponse:TapBinResponseModel = result as? TapBinResponseModel else {
                onErrorOccured("Unexpected error parsing bin details")
                return
            }
            // Execute the on complete block
            onResponeReady(parsedResponse)
            // Store it for further access
            self?.handleBinResponse(binResponseModel: parsedResponse)
        } onError: { (session, result, errorr) in
            // In case of an error we execute the on error block
            onErrorOccured(errorr.debugDescription)
        }
        
    }
    
    
    /**
     Handles the result of the config api by storing it in the right place to be further processed
     - Parameter configModel: The response model from backend we need to deal with
     */
    func handleConfigResponse(configModel:TapConfigResponseModel) {
        // Store the config model for further access
        sharedNetworkManager.dataConfig.configModelResponse = configModel
    }
    
    /**
     Handles the response of init api call. Stores the data for further access
     - Parameter initModel: The init response model from the latest INIT api call
     */
    func handleInitResponse(initModel: TapInitResponseModel) {
        sharedNetworkManager.dataConfig.sdkSettings = initModel.data
        sharedNetworkManager.dataConfig.paymentOptions = initModel.cardPaymentOptions.paymentOptions
    }
    
    /**
     Handles the response of binlookup api call. Stores the data for further access
     - Parameter binResponseModel: The bin look up response model from the latest  api call
     */
    func handleBinResponse(binResponseModel: TapBinResponseModel) {
        sharedNetworkManager.dataConfig.tapBinLookUpResponse = binResponseModel
    }
    
    
    /**
     Handles error occured during an api call
     - Parameter error: The occured error
     */
    func handleError(error: Error?) {
        print(error ?? "Unknown error occured")
    }
    
    
    /// Converts Encodable model into its dictionary representation. Calls completion closure in case of failure.
    ///
    /// - Parameters:
    ///   - model: Model to encode.
    ///   - completion: Failure completion closure.
    ///   - response: Response object in case of success. Here - always nil.
    ///   - error: Error in case of failure. If the closure is called it will never become nil.
    /// - Returns: Dictionary.
    static func convertModelToDictionary(_ model: Encodable, callingCompletionOnFailure completion: CompletionOnFailure) -> [String: Any]? {
        
        var modelDictionary: [String: Any]
        
        do {
            modelDictionary = try model.tap_asDictionary()
        }
        catch let error {
            
            completion(TapSDKKnownError(type: .serialization, error: error, response: nil, body: model))
            return nil
        }
        
        return modelDictionary
    }
    
    
    typealias CompletionOnFailure = (TapSDKError?) -> Void
    
}
