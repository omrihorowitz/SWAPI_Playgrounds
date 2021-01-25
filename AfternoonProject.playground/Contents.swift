import Foundation

//Part Zero
//Part One
//Part Two
struct Person: Decodable {
    let name: String
    let films: [URL]
}

struct Film: Decodable {
    let title: String?
    let opening_crawl: String?
    let release_date: String?
}

class SwapiService {
    
    static private let baseURL = URL(string: "https://swapi.dev/api/")
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        guard let baseURL = baseURL else { return completion(nil)}
        
        let finalURL = baseURL.appendingPathComponent("people/\(id)")
                
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(nil)
            }
            
            guard let data = data else { return completion(nil)}
            
            do {
                let decoder = JSONDecoder()
                let people = try decoder.decode(Person.self, from: data)
                completion(people)
            } catch {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(nil)
                }

            }.resume()
        }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(nil)
            }
            guard let data = data else { return completion(nil) }
            
            do {
                let decoder = JSONDecoder()
                let films = try decoder.decode(Film.self, from: data)
                return completion(films)
            } catch {
                    print("======== ERROR ========")
                    print("Function: \(#function)")
                    print("Error: \(error)")
                    print("Description: \(error.localizedDescription)")
                    print("======== ERROR ========")
                    return completion(nil)
                }

            }.resume()
    }
}

SwapiService.fetchPerson(id: 10) { (person) in
if let person = person {
    print(person)
    for film in person.films {
        SwapiService.fetchFilm(url: film) { (film) in
            print(film)
            }
        }
    }
}

func fetchFilm(url: URL) {
  SwapiService.fetchFilm(url: url) { (film) in
      if let film = film {
          print(film)
      }
  }
}

