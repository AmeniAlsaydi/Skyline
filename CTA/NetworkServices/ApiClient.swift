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
    
    static func getEvents(searchQuery: String, completeion: @escaping (Result<EventSearch, AppError>) -> ()) {
        
        var endpoint = ""
        let searchQuery = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "miami"
        
        if searchQuery.isInt { // postal code
            endpoint = "https://app.ticketmaster.com/discovery/v2/events.json?apikey=dVv3v6u0ARHv2nx4bFUkVrNiLcjum7kx&postalCode=\(searchQuery)"
            
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
                    completeion(.success(search))
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
    
    static func getArtDetail(objectNumber: String, completeion: @escaping (Result<ArtDetail, AppError>) -> ()) {
        
        let endpoint = "https://www.rijksmuseum.nl/api/en/collection/\(objectNumber)?key=y2n9Aoe8"
        
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
                    let search = try JSONDecoder().decode(ArtDetailSearch.self, from: data)
                    let artDetail = search.artObject
                    completeion(.success(artDetail))
                } catch {
                    completeion(.failure(.decodingError(error)))
                }
            }
        }
        
    }
    
    static func getEventDetail(eventId: String, completeion: @escaping (Result<Event, AppError>) -> ()) { // might have to be EventSearch as the reult
        let endpoint = "https://app.ticketmaster.com/discovery/v2/events.json?apikey=dVv3v6u0ARHv2nx4bFUkVrNiLcjum7kx&id=\(eventId)"
        
        
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
                        guard let eventDetails = search.embedded?.events[0] else {
                            print("no event details returned - check apiclient class function.")
                            return
                        }
                           completeion(.success(eventDetails))
                       } catch {
                           completeion(.failure(.decodingError(error)))
                       }
                   }
               }
    }
    
}
