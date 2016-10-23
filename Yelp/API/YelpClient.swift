//
//  YelpClient.swift
//  Yelp
//
//  Created by Chau Vo on 10/17/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//{
//    "access_token": "O9gb95VqEYLCvgiIwIhA5JKs4PK0QH-WWl0f03B0GzZmqPNsfamzOUcbqgCBT3FmHXh3FaW8iTAL1YumbMOukPgTbWlbuImk_1eoAdR-v_GVvjISNRmVST3m3UsIWHYx",
//    "expires_in": 15551999,
//    "token_type": "Bearer"
//App ID
//5ZeLFqosCUBkdExt1qnmtA
//App Secret
//e3rmm7eUa3c3OMJ4fa2HKA2hf1eJJARjMnMgpEp9333hoZyRY088qzFdWWhx5wgA
//}

//

import AFNetworking
import BDBOAuth1Manager

// You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
let yelpConsumerKey = "PSuRiciyxMbXtRwl1sQQ4Q"
let yelpConsumerSecret = "jd5nR5Lk6K9gbW7OhRjdBmYZMy8"
let yelpToken = "m3Q7hl92TgeZAsvlqQCAc6k8f9snWIMS"
let yelpTokenSecret = "pNMgL2Ek2XwP6YdafFQ95bS7ahY"

//let appID = "5ZeLFqosCUBkdExt1qnmtA"
//let appSecret = "e3rmm7eUa3c3OMJ4fa2HKA2hf1eJJARjMnMgpEp9333hoZyRY088qzFdWWhx5wgA"
//let appAccessToken = "O9gb95VqEYLCvgiIwIhA5JKs4PK0QH-WWl0f03B0GzZmqPNsfamzOUcbqgCBT3FmHXh3FaW8iTAL1YumbMOukPgTbWlbuImk_1eoAdR-v_GVvjISNRmVST3m3UsIWHYx"

class YelpClient: BDBOAuth1RequestOperationManager {
    var accessToken: String!
    var accessSecret: String!

    static var _shared: YelpClient?
    static func shared() -> YelpClient! {
        if _shared == nil {
            _shared = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        }
        return _shared
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        let baseUrl = URL(string: "https://api.yelp.com/v2/")
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);

        let token = BDBOAuth1Credential(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }

//    func search(with term: String, completion: @escaping ([Business]?, Error?) -> ()) -> AFHTTPRequestOperation {
//        return search(with: term, sort: nil, categories: nil, deals: nil, distanceInMeter: nil, completion: completion)
//    }

    func search(with term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, distanceInMeter radius: Float?, offset: Int, completion: @escaping ([Business]?, Error?) -> ()) -> AFHTTPRequestOperation {
        // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api

        // Default the location to San Francisco
        var parameters: [String : AnyObject] = ["term": term as AnyObject, "ll": "37.785771,-122.406165" as AnyObject]

        if sort != nil {
            parameters["sort"] = sort!.rawValue as AnyObject?
        }

        if categories != nil && categories!.count > 0 {
            parameters["category_filter"] = (categories!).joined(separator: ",") as AnyObject?
        }

        if deals != nil {
            parameters["deals_filter"] = deals! as AnyObject?
        }
        
        if radius != nil {
            let maxRadius: Float = 40000
            let minRadius: Float = 0
            var useRadius = radius
            if radius! > maxRadius {
                useRadius = maxRadius
            } else if radius! < minRadius {
                useRadius = minRadius
            }
            parameters["radius_filter"] = useRadius! as AnyObject?
        }
        
        parameters["offset"] = offset as AnyObject

        print("parameters: \(parameters)")

        return self.get("search", parameters: parameters, success: { (operation: AFHTTPRequestOperation, response: Any) in
            if let response = response as? NSDictionary {
                let dictionaries = response["businesses"] as? [NSDictionary]
                if dictionaries != nil {
                    completion(Business.businesses(array: dictionaries!), nil)
                }
            }
            }, failure: { (operation: AFHTTPRequestOperation?, error: Error) in
                completion(nil, error)
        })!
    }
}
