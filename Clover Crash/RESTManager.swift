//
//  RESTManager.swift
//  Clover Crash
//
//  Created by Davide De Franceschi on 05/12/2015.
//  Copyright © 2015 Boppl Ltd. All rights reserved.
//

import Foundation



enum RESTError: ErrorType {
	case Response, Data, JSONParsing, JSONContent
}
func getMenu(completion: (() throws -> [MenuModel.Product]) -> ()) -> NSURLSessionDataTask {
	let requestURL = NSURL(string: "https://hack.boppl.me/api/menu?merchant_id=VW84GMYHDGGRE")!
	let request = NSURLRequest(URL: requestURL, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 5)
	let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
		if let error = error {
			completion({ throw error })
			return
		}
		
		guard
			let response = response as? NSHTTPURLResponse where
				response.statusCode / 100 == 2
		else {
			completion({ throw RESTError.Response })
			return
		}
		
		guard
			let data = data where
				!data.isEmpty
		else {
			completion({ throw RESTError.Data })
			return
		}
		
		guard let json = try? JSON(decodedFromData: data) else {
			completion({ throw RESTError.JSONParsing })
			return
		}
		
		guard let products = json.asArray?.flatMap({ try? MenuModel.Product(json: $0) }) else {
			completion({ throw RESTError.JSONContent })
			return
		}
		
		completion({ products })
	}
	task.resume()
	return task
}
func orderProductWithIdentifier(productIdentifier: String) {
	let requestURL = NSURL(string: "https://hack.boppl.me/api/order?merchant_id=VW84GMYHDGGRE")!
	let request = NSMutableURLRequest(URL: requestURL, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 5)
	request.HTTPMethod = "POST"
	request.setValue("application/json", forHTTPHeaderField: "Content-Type")
	let body: JSON = ["sku": .StringValue(productIdentifier)]
	request.HTTPBody = body.encodeToData()
	let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
		if let error = error {
			print("POST Order error:", error)
			return
		}
		guard
			let response = response as? NSHTTPURLResponse where
			response.statusCode / 100 == 2
		else {
			print("POST Order response error")
			return
		}
	}
	task.resume()
}

