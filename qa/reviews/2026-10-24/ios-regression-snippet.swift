
    func testEmptyPurchaseOptionsFailWithDocumentedAvailabilityError() {
        XCTAssertThrowsError(try SimulatedStoreMockData.productWithoutPurchaseOptions.convertToStoreProduct()) {
            XCTAssertEqual(($0 as NSError).code, ErrorCode.productNotAvailableForPurchaseError.rawValue)
        }
    }

    func testMissingBasePriceFailsWithAvailabilityError() {
        XCTAssertThrowsError(try SimulatedStoreMockData.productWithoutBasePrices.convertToStoreProduct()) {
            XCTAssertEqual(($0 as NSError).code, ErrorCode.productNotAvailableForPurchaseError.rawValue)
        }
    }

    func testNullDescriptionAndMissingDefaultFallBackToOnlyPurchaseOption() throws {
        let source = SimulatedStoreMockData.monthlyProduct
        let product = WebBillingProductsResponse.Product(identifier: source.identifier,
            productType: source.productType, title: source.title, description: nil,
            defaultPurchaseOptionId: nil, purchaseOptions: source.purchaseOptions)
        let result = try product.convertToStoreProduct()
        XCTAssertEqual(result.localizedDescription, "")
        XCTAssertEqual(result.price, Decimal(string: "9.99"))
        XCTAssertEqual(result.subscriptionPeriod, SubscriptionPeriod(value: 1, unit: .month))
    }

    func testZeroPriceOneTimeProductRetainsZeroAndNoSubscriptionPeriod() throws {
        let option = WebBillingProductsResponse.PurchaseOption(
            basePrice: .init(wrappedValue: .init(amountMicros: 0, currency: "USD")),
            base: .init(wrappedValue: nil), trial: .init(wrappedValue: nil), introPrice: .init(wrappedValue: nil))
        let product = WebBillingProductsResponse.Product(identifier: "zero_price", productType: .consumable,
            title: "Zero price", description: nil, defaultPurchaseOptionId: "one", purchaseOptions: ["one": option])
        let result = try product.convertToStoreProduct(locale: Locale(identifier: "en_US"))
        XCTAssertEqual(result.price, 0)
        XCTAssertEqual(result.localizedPriceString, "$0.00")
        XCTAssertEqual(result.productType, .consumable)
        XCTAssertNil(result.subscriptionPeriod)
        XCTAssertNil(result.introductoryDiscount)
    }

    func testQuarterlyBaseAndIncompleteIntroPricePreserveBaseProduct() throws {
        let option = WebBillingProductsResponse.PurchaseOption(
            basePrice: .init(wrappedValue: nil),
            base: .init(wrappedValue: .init(periodDuration: "P3M",
                price: .init(amountMicros: 29_990_000, currency: "USD"), cycleCount: 1)),
            trial: .init(wrappedValue: nil),
            introPrice: .init(wrappedValue: .init(periodDuration: "P1M", price: nil, cycleCount: 2)))
        let product = WebBillingProductsResponse.Product(identifier: "quarterly", productType: .subscription,
            title: "Quarterly", description: nil, defaultPurchaseOptionId: "base", purchaseOptions: ["base": option])
        let result = try product.convertToStoreProduct()
        XCTAssertEqual(result.price, Decimal(string: "29.99"))
        XCTAssertEqual(result.subscriptionPeriod, SubscriptionPeriod(value: 3, unit: .month))
        XCTAssertNil(result.introductoryDiscount)
    }
