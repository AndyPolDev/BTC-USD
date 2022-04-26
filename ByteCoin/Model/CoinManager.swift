import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin(_ coinManager: CoinManager, coin: CoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "B9601434-BD0E-4B44-9338-BE73AE2CB4B0"
    
    let currencyArray = ["AUD","BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
        
    func getCoinPrice(for currency: String) {
        
        let urlString = "\(baseURL)/\(currency)?apikey=B9601434-BD0E-4B44-9338-BE73AE2CB4B0"
        performRequest(with: urlString)
        
        
    }
    
    func performRequest(with urlString: String) {
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    print(error!)
                    return
                }
                if let safeData = data {
                    if let coin = self.parseJSON(safeData) {
                        self.delegate?.didUpdateCoin(self, coin: coin)
                        
                    }
                }
            }
            task.resume()
        }
        
    }
    
    func parseJSON (_ coinData: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let idBase = decodedData.asset_id_base
            let idQuote = decodedData.asset_id_quote
            let rate = decodedData.rate
            
            let coin = CoinModel(idBase: idBase, idQuote: idQuote, rate: rate)
            return coin
        } catch {
            self.delegate?.didFailWithError(error: error)
            print(error)
            return nil
        }
        
    }
    
}
