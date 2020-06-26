//
//  ApiUtils.swift
//  UnsplashClone
//
//  Created by 박병준 on 6/26/20.
//  Copyright © 2020 박병준. All rights reserved.
//


import Alamofire

final class ApiUtils{
    
    class func makeUrl(_ additionalURL: String) -> URL?{
        
        let rawURL = "\(apiDomain)/\(additionalURL)"
        return URL(string: rawURL)
        
    }
    
    
    class func makeHeader() -> HTTPHeaders{
        
        
        var header = [String : String]()
        
        header["Content-Type"] = "application/json"
        header["Accept-Version"] = "v1"
        header["Authorization"] = "Client-ID \(USCAccessKey)"
        
        return HTTPHeaders(header)
    }
    
    public class func jsonToString(_ json: [String : Any]) -> String?{
        do{
            let firstForm = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let convertedString = String(data: firstForm, encoding: .utf8)
            return convertedString
        }catch{
            return nil
        }
        
    }
    
    public class func showJson(_ pDic: [String : Any]){
        
        guard let json = try? JSONSerialization.data(withJSONObject: pDic, options: [.prettyPrinted]) else{
            return
        }
        guard let jsonText = String(bytes: json, encoding: String.Encoding.utf8) else{
            return
        }
        print()
        print(jsonText)
        print()
        
    }
    
    public class func stringToJson(_ pData: String) -> [String : Any]?{
        
        guard let uData = pData.data(using: .utf8) else{
            return nil
        }
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: uData, options : .allowFragments) as? [String : Any]
            {
                return jsonArray
            } else {
                return nil
            }
        } catch  {
            return nil
        }
    }
    public class func showDataList(pData: Data){
        guard let jsonList = try? JSONSerialization.jsonObject(with: pData, options: []) as? [[String : Any]] else{
            return
        }
        for json in jsonList {
            self.showJson(json)
        }
    }
    public class func showData(pData: Data){
        guard let json = try? JSONSerialization.jsonObject(with: pData, options: []) as? [String : Any] else{
            return
        }
        self.showJson(json)
    }
    
    
    public class func makeError(resultMsg: String?, errCode: Int? = nil) -> NSError{
        
        var errDic = [String : Any]()
        errDic["result_msg"] = resultMsg
        
        var code = 0
        if let uCode = errCode{
            code = uCode
        }
        let rError = NSError(domain: "", code: code, userInfo: errDic)
        
        return rError
        
    }
}
