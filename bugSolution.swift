enum NetworkError: Error {
    case badServerResponse
    case dataError
    case unknownError(Error)
}

func fetchData() async throws -> Data {
    let url = URL(string: "https://api.example.com/data")!
    do {
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.badServerResponse
        }
        return data
    } catch let error as URLError {
        switch error.code {
        case .badServerResponse: throw NetworkError.badServerResponse
        case .notConnectedToInternet: throw NetworkError.unknownError(error)
        default: throw NetworkError.unknownError(error)
        }
    } catch {
        throw NetworkError.unknownError(error)
    }
}

Task { 
    do {
        let data = try await fetchData()
        // Process data
    } catch let error {
        switch error {
        case .badServerResponse: print("Bad Server Response")
        case .dataError: print("Data Error")
        case .unknownError(let underlyingError): print("Unknown error: \(underlyingError)")
        }
    }
} 