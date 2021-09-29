//
//  NetworkRouter.swift
//  PracticalTask-Anami
//
//  Created by Anami on 29/09/21.
//

import Foundation
import Alamofire
import SVProgressHUD

class ServiceManager<T:Codable> {
    typealias completionHandler = (_ Responce:Codable) -> Void
    
    // MARK: -  Variables 
    var HandleResponse = true
    private var Manager: Session!
    
    init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        config.urlCache = nil
        config.timeoutIntervalForRequest = 1000
        
        Manager = Alamofire.Session(configuration: config)
    }
    
    // MARK: -  API call 
    func MakeAPICall(httpMethod:HTTPMethod, params: [String:Any]?, loaderEnabled: Bool, CompletionHandler:@escaping completionHandler) {
        
        if NetworkReachabilityManager()?.isReachable ?? false {
            var finalUrl = APIRequest.PrefixBaseUrl
            finalUrl = finalUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            
            guard let url = URL.init(string: finalUrl) else {
                return
            }
            
            print("URL:-\(finalUrl)")
            print("Parameters:-\(params ?? [:])")
            
            if loaderEnabled {
                self.showSpinner()
            }
            
            Manager.request(url, method: httpMethod, parameters: params).responseData { (Response) in
                if loaderEnabled {
                    self.hideProgressView()
                }
                
                switch Response.result {
                case .success(let data):
                    guard let Dic = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else { return }
                    print("Response:-\(Dic as? [String:Any] ?? [:])")

                    let ResponseToSend: UserDataModel
                    do {
                        ResponseToSend = try JSONDecoder().decode(UserDataModel.self, from: data)
                        print(ResponseToSend)
                        
                        if self.HandleResponse {
                            self.hideProgressView()
                            CompletionHandler(ResponseToSend)
                        } else {
                            self.hideProgressView()
                            CompletionHandler(ResponseToSend)
                        }
                    }
                    
                    catch let DecodingError.dataCorrupted(context) {
                        print(context)
                        print(Networking.KeyErrorMessage)
                    } catch let DecodingError.keyNotFound(key, context) {
                        print("Key '\(key)' not found:\(context.debugDescription)")
                        print("codingPath:\(context.codingPath)")
                        print(Networking.KeyErrorMessage)
                    } catch let DecodingError.valueNotFound(value, context) {
                        print("Value '\(value)' not found:\(context.debugDescription)")
                        print("codingPath:\(context.codingPath)")
                        print(Networking.KeyErrorMessage)
                    } catch let DecodingError.typeMismatch(type, context)  {
                        print("Type '\(type)' mismatch:\(context.debugDescription)")
                        print("codingPath:\(context.codingPath)")
                        print(Networking.KeyErrorMessage)
                    } catch {
                        print("Error:-\(error.localizedDescription)")
                        print(Networking.KeyErrorMessage)
                    }
                case .failure(let error):
                    print("Error:-\(error)")
                    break
                }
            }
        } else {
            self.hideProgressView()
            print(Networking.KeyNoInternetMessage)
        }
    }
    
    // MARK: -  Show Progress Spinner 
    func showSpinner() {
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setForegroundColor(#colorLiteral(red: 0.0862745098, green: 0.8666666667, blue: 0.8431372549, alpha: 1.0))
        SVProgressHUD.setBackgroundColor(#colorLiteral(red: 0.1607843137, green: 0.1568627451, blue: 0.1764705882, alpha: 1))
        SVProgressHUD.show()
    }
    
    // MARK: -  Hide Progress Spinner 
    func hideProgressView() {
        SVProgressHUD.dismiss()
    }
}
