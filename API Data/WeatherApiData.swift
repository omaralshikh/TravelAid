//
//  WeatherApiData.swift
//  TravelAid
//
//  Created by Omar on 11/1/20.
//  Copyright © 2020 Omar Alshikh. All rights reserved.
//

import Foundation

let myApiKey = "5ee7984f70cfa62d9eea1cdbaaed542d"

// Declare nationalParkFound as a global mutable variable accessible in all Swift files

var weatherData = WeatherStruct(id: UUID(), forecast: [ForecastStruct](), name: "", latitude: 0.0, longitude: 0.0, country: "")


fileprivate var previousParkName = ""

public func getApiDataBycityName(parkName: String) {
    
    // Avoid executing this function if already done for the same park name
    if parkName == previousParkName {
        return
    } else {
        previousParkName = parkName
    }
    
    /*
     Create an empty instance of NationalPark struct defined in NationalPark.swift
     Assign its unique id to the global variable nationalParkFound
     */
    weatherData = WeatherStruct(id: UUID(), forecast: [ForecastStruct](), name: "", latitude: 0.0, longitude: 0.0, country: "")
    
    
    // Replace all occurrences of space with + in national park name
    let searchquery = parkName.replacingOccurrences(of: " ", with: "+")
    
    let apiSearchQuery = "https://api.openweathermap.org/data/2.5/forecast?q=\(searchquery)&units=imperial&appid=\(myApiKey)"
    // https://api.openweathermap.org/data/2.5/forecast?q=paris,fr&units=imperial&appid=GET-YOUR-OWN-API-KEY
    
    /*
     *********************************************
     *   Obtaining API Search Query URL Struct   *
     *********************************************
     */
    
    var apiQueryUrlStruct: URL?
    
    if let urlStruct = URL(string: apiSearchQuery) {
        apiQueryUrlStruct = urlStruct
    } else {
        // nationalParkFound will have the initial values set as above
        return
    }
    
    /*
     *******************************
     *   HTTP GET Request Set Up   *
     *******************************
     */
    
    let headers = [
        "x-api-key": myApiKey,
        "accept": "application/json",
        "cache-control": "no-cache",
        "connection": "keep-alive",
        "host": "api.openweathermap.org"
    ]
    
    let request = NSMutableURLRequest(url: apiQueryUrlStruct!,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 60.0)
    
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers
    
    /*
     *********************************************************************
     *  Setting Up a URL Session to Fetch the JSON File from the API     *
     *  in an Asynchronous Manner and Processing the Received JSON File  *
     *********************************************************************
     */
    
    /*
     Create a semaphore to control getting and processing API data.
     signal() -> Int    Signals (increments) a semaphore.
     wait()             Waits for, or decrements, a semaphore.
     */
    let semaphore = DispatchSemaphore(value: 0)
    
    URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        /*
         URLSession is established and the JSON file from the API is set to be fetched
         in an asynchronous manner. After the file is fetched, data, response, error
         are returned as the input parameter values of this Completion Handler Closure.
         */
        
        // Process input parameter 'error'
        guard error == nil else {
            semaphore.signal()
            return
        }
        
        // Process input parameter 'response'. HTTP response status codes from 200 to 299 indicate success.
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            semaphore.signal()
            return
        }
        
        // Process input parameter 'data'. Unwrap Optional 'data' if it has a value.
        guard let jsonDataFromApi = data else {
            semaphore.signal()
            return
        }
        
        //------------------------------------------------
        // JSON data is obtained from the API. Process it.
        //------------------------------------------------
        do {
            /*
             Foundation framework’s JSONSerialization class is used to convert JSON data
             into Swift data types such as Dictionary, Array, String, Number, or Bool.
             */
            let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi,
                                                                options: JSONSerialization.ReadingOptions.mutableContainers)
            
            /*
             JSON object with Attribute-Value pairs corresponds to Swift Dictionary type with
             Key-Value pairs. Therefore, we use a Dictionary to represent a JSON object
             where Dictionary Key type is String and Value type is Any (instance of any type)
             */
            var jsonDataDictionary = Dictionary<String, Any>()
            
            if let jsonObject = jsonResponse as? [String: Any] {
                jsonDataDictionary = jsonObject
            } else {
                semaphore.signal()
                return
            }
            
            //-----------------------
            // Obtain Data JSON Array
            //-----------------------
            
            var dataJsonArray = [Any]()
            if let jArray = jsonDataDictionary["list"] as? [Any] {
                dataJsonArray = jArray
            } else {
                semaphore.signal()
                return
            }
            
            /*
             API returns the following for invalid national park name
             {"total":"0","data":[],"limit":"50","start":"1"}
             */
            if dataJsonArray.isEmpty {
                semaphore.signal()
                return
            }
            
            var casts = [ForecastStruct]()
            // Iterate over all the national parks returned
            for weather in dataJsonArray {
                
                let forecast = weather as! [String: Any]
                
                //----------------
                // Initializations
                //----------------
                
                
                var dt_txt = ""
                
                if let datetxt = forecast["dt_txt"] as? String {
                    dt_txt = datetxt
                }
                // main read
                var dataJsonArray2 =  Dictionary<String, Any>()
                
                
                
                if let jArray2 = forecast["main"] as? [String: Any] {
                    dataJsonArray2 = jArray2
                } else {
                    //                    semaphore.signal()
                    //                    return
                }
                
                var dataJsonArray23 = [Any]()
                
                var dataJsonArray999 =  Dictionary<String, Any>()
                
                
                if let jArray23 = forecast["weather"] as? [Any] {
                    dataJsonArray23 = jArray23
                    if let obj = dataJsonArray23[0] as? [String: Any] {
                        dataJsonArray999 = obj
                    }
                } else {
                    //                    semaphore.signal()
                    //                    return
                }
                
                if dataJsonArray2.isEmpty {
                    semaphore.signal()
                    return
                }
                
                
                var temp_min = 0.0, temp_max = 0.0, humidity = 0
                
                if let minTemp = dataJsonArray2["temp_min"] as? Double {
                    temp_min = minTemp
                }
                
                //-------------------
                // Obtain State Names
                //-------------------
                
                if let maxTemp = dataJsonArray2["temp_max"] as? Double {
                    temp_max = maxTemp
                }
                
                if let hum = dataJsonArray2["humidity"] as? Int {
                    humidity = hum
                }
                
                //} // for loop 2jsonarray
                
                
                
                
                var icon = "", description = ""
                
                if let rawUrl = dataJsonArray999["icon"] as? String {
                    
                    // Remove all occurrences of backslash in national park website URL
                    let cleanedUrl = rawUrl.replacingOccurrences(of: "\\", with: "")
                    icon = cleanedUrl
                }
                
                if let Description = dataJsonArray999["description"] as? String {
                    description = Description
                }
                
                let cast = ForecastStruct(id: UUID(), icon: icon, description: description, temp_min: temp_min, temp_max: temp_max, humidity: humidity, dt_txt: dt_txt)
                casts.append(cast)
                
                
            }
            
            
            // } // for loop 23json array
            
            var dataJsonArray4 = Dictionary<String, Any>()
            if let jArray4 = jsonDataDictionary["city"] as? [String: Any] {
                dataJsonArray4 = jArray4
            } else {
                semaphore.signal()
                return
            }
            
            /*
             API returns the following for invalid national park name
             {"total":"0","data":[],"limit":"50","start":"1"}
             */
            if dataJsonArray4.isEmpty {
                semaphore.signal()
                return
            }
            
            
            
            var name = "", country = "", latitude = 0.0, longitude = 0.0
            var dataJsonArray55 =  Dictionary<String, Any>()
            if let jArray2 = dataJsonArray4["coord"] as? [String: Any] {
                dataJsonArray55 = jArray2
                // "latLong":"lat:36.17280161, long:-112.6836024"
                
                if  let lat = dataJsonArray55["lat"] as? Double{
                    latitude = lat
                }
                
                if  let lon = dataJsonArray55["lon"] as? Double{
                    longitude = lon
                }
                
                
            }
            
            if let Name = dataJsonArray4["name"] as? String {
                name = Name
            }
            
            if let Country = dataJsonArray4["country"] as? String {
                country = Country
            }
            
            
            
            /*
             Create an instance of NationalPark struct, dress it up with the values obtained from the API,
             and set its id to the global variable nationalParkFound
             */
            weatherData = WeatherStruct(id: UUID(), forecast: casts, name: name, latitude: latitude, longitude: longitude, country: country)
            
            
            
        } catch {
            semaphore.signal()
            return
        }
        
        semaphore.signal()
    }).resume()
    
    /*
     The URLSession task above is set up. It begins in a suspended state.
     The resume() method starts processing the task in an execution thread.
     
     The semaphore.wait blocks the execution thread and starts waiting.
     Upon completion of the task, the Completion Handler code is executed.
     The waiting ends when .signal() fires or timeout period of 60 seconds expires.
     */
    
    _ = semaphore.wait(timeout: .now() + 60)
    
    
    
}

