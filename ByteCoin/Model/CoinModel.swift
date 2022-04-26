import Foundation

struct CoinModel {
    let idBase: String
    let idQuote: String
    let rate: Double
    
    var rateString: String {
        return String(format: "%.1f", rate)
    }
}
