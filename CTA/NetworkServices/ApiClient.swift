//
//  EventsApiClient.swift
//  CTA
//
//  Created by Amy Alsaydi on 3/16/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation
import NetworkHelper

struct ApiClient {
    
    static func getEvents(searchQuery: String, completeion: @escaping (Result<[Event], AppError>) -> ()) {
        
        var endpoint = ""
        let searchQuery = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "miami"
        
        if searchQuery.isInt { // postal code
            endpoint = "https://app.ticketmaster.com/discovery/v2/events.json?apikey=dVv3v6u0ARHv2nx4bFUkVrNiLcjum7kx&postalCode=\(searchQuery)"
            
            print("is an Int")
        } else { // is city
            endpoint = "https://app.ticketmaster.com/discovery/v2/events.json?apikey=dVv3v6u0ARHv2nx4bFUkVrNiLcjum7kx&city=\(searchQuery)"
        }
  
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
    
    static func getArtObjects(searchQuery: String, completeion: @escaping (Result<[ArtObject], AppError>) -> ()) {
        
        let searchQuery = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "rem"
        
        let endpoint = "https://www.rijksmuseum.nl/api/nl/collection?key=y2n9Aoe8&q=\(searchQuery)"
        
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
                    let search = try JSONDecoder().decode(ArtSearch.self, from: data)
                    let artObjects = search.artObjects
                    completeion(.success(artObjects))
                } catch {
                    completeion(.failure(.decodingError(error)))
                }
            }
        }
        
    
        
        
        
    }
    
    
}
