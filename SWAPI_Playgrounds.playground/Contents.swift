import UIKit

struct Person: Decodable {
    let name: String
    let films: [URL]
 }

struct Film: Decodable {
    let title: String
    //let characters: [URL]
}

class ModelController {
    
    //MARK: - Properties
    static let baseURL = URL(string: "https://swapi.dev/api/")
    static let filmsEndpoint = "films"
    static let peopleEndpoint = "people"
    
    //MARK: - Fetch Person
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        
        //Step 1
        guard let baseURL = baseURL else {return completion(nil)}
        let peopleURL = baseURL.appendingPathComponent(peopleEndpoint)
        let finalURL = peopleURL.appendingPathComponent(String(id))
        
        //Step 2
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            //Step 3
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
            
            //Step 4
            guard let data = data else {return completion(nil)}

            //Step 5
            do {
                let decoder = JSONDecoder()
                let person = try decoder.decode(Person.self, from: data)
                
                return completion(person)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
        }.resume()
    }
    
    //MARK: - Fetch Films
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        
        //Step 1
        //guard let baseURL = baseURL else {return completion(nil)}
        //let finalURL = baseURL.appendingPathComponent(filmsEndpoint)
        
        //Step 2
        URLSession.shared.dataTask(with: url) { data, _, error in
            //Step 3
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
            
            //Step 4
            guard let data = data else {return completion(nil)}
            
            //Step 5
            do {
                let decoder = JSONDecoder()
                let film = try decoder.decode(Film.self, from: data)
                
                return completion(film)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
        }.resume()
    }
    
}//End of class

ModelController.fetchPerson(id: 10) { person in
    if let personPrinted = person {
        print(personPrinted)
        let filmURLs: [URL] = personPrinted.films
        
        for film in filmURLs{
            ModelController.fetchFilm(url: film) { film in
                if let filmPrinted = film {
                    print(filmPrinted)
                }
            }
        }
    }
}

