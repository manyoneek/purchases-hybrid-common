import Foundation
public enum ProductCategory { case nonSubscription, subscription }
public enum ProductType { case consumable, nonConsumable, nonRenewableSubscription, autoRenewableSubscription }
public struct SubscriptionPeriod { public enum Unit { case day, week, month, year }; public var unit: Unit; public var value: Int }
public struct Discount { public var rc_dictionary: [String:Any] { [:] } }
public class StoreProduct: NSObject {
 public var currencyCode: String? = "USD"
 public var localizedDescription = "fixture"
 public var productIdentifier = "lifetime"
 public var price: NSDecimalNumber = 19.99
 public var localizedPriceString = "$19.99"
 public var localizedTitle = "Lifetime"
 public var pricePerWeek: NSDecimalNumber?
 public var pricePerMonth: NSDecimalNumber?
 public var pricePerYear: NSDecimalNumber?
 public var localizedPricePerWeek: String?
 public var localizedPricePerMonth: String?
 public var localizedPricePerYear: String?
 public var introductoryDiscount: Discount?
 public var discounts: [Discount] = []
 public var subscriptionPeriod: SubscriptionPeriod?
 public var productCategory = ProductCategory.nonSubscription
 public var productType = ProductType.nonConsumable
}
