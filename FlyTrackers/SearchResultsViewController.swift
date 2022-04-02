//
//  SearchResultsViewController.swift
//  FlyTrackers
//
//  Created by Elliott Larsen on 3/20/22.
//

import UIKit

/* ---- testing with weather api that has nested array dictionary
struct Weather: Decodable {
    let main: String
    let description: String
    let icon: String
    
}
struct WeatherResponse: Decodable { //one container info
    var temperature: Double = 0
    var humidity: Double = 0
    var pressure: Double = 0
    //add element/prperty for that weather container
    var weather: [Weather] = [Weather]()
    
    private enum WeatherResponseKeys: String, CodingKey {
        case main
        //add map to weather key from json
        case weather
    }
    
    private enum MainKeys: String, CodingKey {
        case temperature = "temp"
        case humidity
        case pressure
    }
    
    init(from decoder: Decoder) throws {
        if let weatherResponseContainer = try? decoder.container(keyedBy: WeatherResponseKeys.self) {
            if let mainContainer = try? weatherResponseContainer.nestedContainer(keyedBy: MainKeys.self, forKey: .main) {
                self.temperature = try mainContainer.decode(Double.self, forKey: .temperature)
                self.humidity = try mainContainer.decode(Double.self, forKey: .humidity)
                self.pressure = try mainContainer.decode(Double.self, forKey: .pressure)
            }
            //in weather response function
            //decode the weather array from json
            //into the weather structure
//            self.weather = try weatherResponseContainer.decode([Weather].self, forKey: WeatherResponseKeys.weather)
            self.weather = try weatherResponseContainer.decode([Weather].self, forKey: WeatherResponseKeys.weather)
        }
    }
    
}
........................*/

class SearchResultsViewController: UIViewController {
    
    var flights = [[String:Any]]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "http://api.aviationstack.com/v1/flights?access_key=92eac302688758c89b558139206b9eb2")!

        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    
                 self.flights = dataDictionary["data"] as! [[String: Any]]

                    // TODO: Get the array of movies
                    // TODO: Store the movies in a property to use elsewhere
                    // TODO: Reload your table view data
//                 print(dataDictionary)
                 
                 //---atempt to output flight name
                 print(self.flights[0]["airline"]["name"])
                 
                 
             }
        }
        task.resume()
/*------testing of weather api with nested array dictionary
 guard let url = URL(string: "https://samples.openweathermap.org/data/2.5/weather?q=London,uk&appid=b6907d289e10d714a6e88b30761fae22") else {
     fatalError("incorrect URL")
 }
//        guard let url = URL(string: "http://api.aviationstack.com/v1/flights?access_key=92eac302688758c89b558139206b9eb2") else {
//            fatalError("incorrect URL")
//        }
 
        URLSession.shared.dataTask(with: url) {data, _ , _ in
            if let data = data {
                let weatherResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data)
                if let weatherResponse = weatherResponse {
                    print(weatherResponse)
                    print(weatherResponse.weather[0])
                    //assign globals here
                }
            }
        }.resume()
....................................................*/
       
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
