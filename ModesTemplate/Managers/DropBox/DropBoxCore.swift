//
//  DropBoxCore.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 23.11.2023.
//

import Foundation
import PromiseKit
import SwiftyDropbox

final class DropBoxCore: NSObject {
    
    // MARK: - Publick
    public var client: DropboxClient?
    
    // MARK: - Private
    private let defaults = UserDefaults.standard
    private var isInited = false
    private var access = ""
    
    public func initDropBox() -> Promise<Void> {
        return Promise { complition in
            guard !isInited else { complition.fulfill(()) ; return }

            if let refresh = self.defaults.value(forKey: "refreshToken") as? String {
                self.getToken(refresh_token: refresh).done { access_token in
                    guard let aToken = access_token else {
                        complition.reject(DropBoxInitError.accesTokenError)
                        return
                    }
                    self.client = DropboxClient(accessToken: aToken)
                    self.access = aToken
                    self.isInited = true
                    complition.fulfill(())
                }.catch { error in
                    complition.reject(error)
                }
            } else {
                getReshreshToken(code: DropBoxKeys.token).done { refresh_token in
                    guard let rToken = refresh_token else {
                        self.getToken(refresh_token: DropBoxKeys.refreshToken).done { access_token in
                            guard let aToken = access_token else {
                                complition.reject(DropBoxInitError.accesTokenError)
                                return
                            }
                            self.client = DropboxClient(accessToken: aToken)
                            self.access = aToken
                            self.isInited = true
                            complition.fulfill(())
                        }.catch { error in
                            complition.reject(error)
                        }
                        return
                    }
                    print("🥳refresh - \n\(rToken)")
                    self.defaults.setValue(rToken, forKey: "refreshToken")
                    self.getToken(refresh_token: rToken).done { access_token in
                        guard let aToken = access_token else {
                            complition.reject(DropBoxInitError.accesTokenError)
                            return
                        }
                        self.client = DropboxClient(accessToken: aToken)
                        self.access = aToken
                        self.isInited = true
                        complition.fulfill(())
                    }.catch { error in
                        complition.reject(error)
                    }
                }.catch { error in
                    complition.reject(error)
                }
            }
        }
    }
}

private extension DropBoxCore {
    
    enum DropBoxInitError: Error {
        case accesTokenError
        case refreashTokenError
    }
    
    func getReshreshToken(code: String) -> Promise<String?> {
        return Promise { complition in
            let username = DropBoxKeys.appkey
            let password = DropBoxKeys.appSecret
            let loginString = String(format: "%@:%@", username, password)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()

            let parameters: Data = "code=\(code)&grant_type=authorization_code".data(using: .utf8)!
            let url = URL(string: DropBoxKeys.apiLink)!
            var apiRequest = URLRequest(url: url)
            apiRequest.httpMethod = "POST"
            apiRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
            apiRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            apiRequest.httpBody = parameters

            URLSession.shared.dataTask(with: apiRequest) { data, response, error in
                guard let data = data, error == nil else {
                    complition.reject(error!)
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any], let refreshToken = responseJSON["refresh_token"] as? String {
                    complition.fulfill(refreshToken)
                } else {
                    complition.fulfill(nil)
                }
            }.resume()
        }
    }
    
    func getToken(refresh_token: String) -> Promise<String?> {
        return Promise { complition in
            let username = DropBoxKeys.appkey
            let password = DropBoxKeys.appSecret
            let loginString = String(format: "%@:%@", username, password)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()

            let parameters: Data = "refresh_token=\(refresh_token)&grant_type=refresh_token".data(using: .utf8)!
            let url = URL(string: DropBoxKeys.apiLink)!
            var apiRequest = URLRequest(url: url)
            apiRequest.httpMethod = "POST"
            apiRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
            apiRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            apiRequest.httpBody = parameters

            URLSession.shared.dataTask(with: apiRequest) { data, response, error in
                guard let data = data, error == nil else {
                    complition.reject(error!)
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any], let accessToken = responseJSON["access_token"] as? String {
                    complition.fulfill(accessToken)
                } else {
                    complition.reject(DropBoxInitError.accesTokenError)
                }
            }.resume()
        }
    }
}
