//
//  NSURLValidation.swift
//  CircularDesigns
//
//  Created by Kiranbabu Rajanala on 10/28/16.
//  Copyright © 2016 Kiranbabu Rajanala. All rights reserved.
//

import Foundation
import UIKit

extension NSURL
{
    struct ValidationQueue {
        static var queue = OperationQueue()
    }
    
    class func validateUrl(urlString: String?, completion:@escaping (_ success: Bool, _ urlString: String? , _ error: NSString) -> Void)
    {
        // Description: This function will validate the format of a URL, re-format if necessary, then attempt to make a header request to verify the URL actually exists and responds.
        // Return Value: This function has no return value but uses a closure to send the response to the caller.
        
        var formattedUrlString : String?
        
        // Ignore Nils & Empty Strings
        if (urlString == nil || urlString == "")
        {
            completion(false, nil, "URL String was empty")
            return
        }
        
        // Ignore prefixes (including partials)
        let prefixes = ["http://www.", "https://www.", "www."]
        for prefix in prefixes
        {
            if ((prefix.range(of:urlString!, options: NSString.CompareOptions.caseInsensitive, range: nil, locale: nil)) != nil){
                completion(false, nil, "Url String was prefix only")
                return
            }
        }
        
        // Ignore URLs with spaces
        let range = urlString!.rangeOfCharacter(from: NSCharacterSet.whitespaces)
        if range != nil {
            completion(false, nil, "Url String cannot contain whitespaces")
            return
        }
        
        // Check that URL already contains required 'http://' or 'https://', prepend if it does not
        formattedUrlString = urlString
        if (!formattedUrlString!.hasPrefix("http://") && !formattedUrlString!.hasPrefix("https://"))
        {
            formattedUrlString = "http://"+urlString!
        }
        
        // Check that an NSURL can actually be created with the formatted string
        if let validatedUrl = NSURL(string: formattedUrlString!)
        {
            // Test that URL actually exists by sending a URL request that returns only the header response
            let request = NSMutableURLRequest(url: validatedUrl as URL)
            request.httpMethod = "HEAD"
            ValidationQueue.queue.cancelAllOperations()
            
            NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: ValidationQueue.queue, completionHandler:{ (response: URLResponse?, data: Data?, error: Error?) -> Void in
                let url = request.url!.absoluteString
                
                // URL failed - No Response
                if (error != nil)
                {
                    completion(false, url, "The url: \(url) received no response" as NSString)
                    return
                }
                
                // URL Responded - Check Status Code
                if let urlResponse = response as? HTTPURLResponse
                {
                    if ((urlResponse.statusCode >= 200 && urlResponse.statusCode < 400) || urlResponse.statusCode == 405)// 200-399 = Valid Responses, 405 = Valid Response (Weird Response on some valid URLs)
                    {
                        completion(true, url, "The url: \(url) is valid!" as NSString)
                        return
                    }
                    else // Error
                    {
                        completion(false, url, "The url: \(url) received a \(urlResponse.statusCode) response" as NSString)
                        return
                    }
                }
            })
        }
    }
}
