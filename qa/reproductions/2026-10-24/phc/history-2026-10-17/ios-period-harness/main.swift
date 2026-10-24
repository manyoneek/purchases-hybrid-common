import Foundation
import RevenueCat
let p = StoreProduct()
let fields = ["pricePerWeek", "pricePerMonth", "pricePerYear", "pricePerWeekString", "pricePerMonthString", "pricePerYearString"]
let result = p.rc_dictionary
let missing = fields.filter { result[$0] == nil }
let nulls = fields.filter { result[$0] is NSNull }
p.pricePerWeek = 1; p.pricePerMonth = 2; p.pricePerYear = 24
p.localizedPricePerWeek = "$1"; p.localizedPricePerMonth = "$2"; p.localizedPricePerYear = "$24"
let present = fields.filter { p.rc_dictionary[$0] != nil }
let summary: [String:Any] = ["missingFields":missing,"nullFields":nulls,"presentControlFields":present,"expectedNullCount":6]
print(String(data:try JSONSerialization.data(withJSONObject:summary,options:[.sortedKeys]),encoding:.utf8)!)
