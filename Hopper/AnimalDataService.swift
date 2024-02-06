import Foundation

struct Animal: Identifiable, Decodable {
    let id: Int
    let name: String
    let image: String
}

class AnimalDataService {
    func fetchAnimalData(completion: @escaping ([Animal]?) -> Void) {
        guard let url = URL(string: "https://your-api-endpoint/animals") else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching animals: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                let animals = try JSONDecoder().decode([Animal].self, from: data)
                completion(animals)
            } catch {
                print("Error decoding animals: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }
}
