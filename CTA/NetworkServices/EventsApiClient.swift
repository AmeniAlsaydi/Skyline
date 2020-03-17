//
//  EventsApiClient.swift
//  CTA
//
//  Created by Amy Alsaydi on 3/16/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation
import NetworkHelper

struct EventsApiClient {
    
    static func getEvents(city: String, searchQuery: String, completeion: @escaping (Result<[Event], AppError>) -> ()) {
       
        let city = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "miami"
        
        let endpoint = "https://app.ticketmaster.com/discovery/v2/events.json?apikey=dVv3v6u0ARHv2nx4bFUkVrNiLcjum7kx&city=\(city)"
         
        
        guard let url = URL(string: endpoint) else {
            completeion(.failure(.badURL(endpoint)))
            return
        }
        
        let request = URLRequest(url: url)
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                completeion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                    let search = try JSONDecoder().decode(EventSearch.self, from: data)
                    let events = search.embedded.events
                    completeion(.success(events))
                } catch {
                    completeion(.failure(.decodingError(error)))
                }
            }
        }
    }
    
    
}
