import StoreKit
import SwiftUI

@MainActor
class StoreKitManager: ObservableObject {
    @Published var products: [Product] = []
    @Published var purchasedProductIDs: Set<String> = []
    @Published var isLoading = false

    private var updateListenerTask: Task<Void, Never>? = nil

    nonisolated private static let productIDs = [
        "com.soloMeet.tip.small",      // $0.99
        "com.soloMeet.tip.medium",     // $2.99
        "com.soloMeet.tip.large",      // $4.99
        "com.soloMeet.adRemoval"       // 広告除去（1回購入）
    ]

    init() {
        updateListenerTask = listenForTransactions()
        Task {
            await requestProducts()
            await updatePurchasedProducts()
        }
    }

    deinit {
        updateListenerTask?.cancel()
    }

    @MainActor
    func requestProducts() async {
        isLoading = true
        do {
            let storeProducts = try await Product.products(for: Self.productIDs)
            self.products = storeProducts.sorted { $0.price < $1.price }
        } catch {
            print("Failed to fetch products: \(error)")
            self.products = []
        }
        isLoading = false
    }

    @MainActor
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            await updatePurchasedProducts()
        case .userCancelled:
            print("User cancelled purchase")
        case .pending:
            print("Purchase is pending")
        @unknown default:
            print("Unknown purchase result")
        }
    }

    @MainActor
    func updatePurchasedProducts() async {
        var purchasedIDs: Set<String> = []

        for await result in Transaction.currentEntitlements {
            let transaction = try! checkVerified(result)
            purchasedIDs.insert(transaction.productID)
        }

        self.purchasedProductIDs = purchasedIDs
    }

    private func listenForTransactions() -> Task<Void, Never> {
        Task(priority: .background) {
            for await result in Transaction.updates {
                let transaction = try! checkVerified(result)
                await transaction.finish()
                await updatePurchasedProducts()
            }
        }
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified(let unverified, let error):
            print("Unverified transaction: \(error)")
            return unverified
        case .verified(let verified):
            return verified
        }
    }

    func getProduct(for id: String) -> Product? {
        products.first { $0.id == id }
    }

    func isPurchased(_ productID: String) -> Bool {
        purchasedProductIDs.contains(productID)
    }

    func getProductPrice(for id: String) -> String? {
        guard let product = getProduct(for: id) else { return nil }
        return product.displayPrice
    }
}

// Mock products for preview and development
struct MockStoreKitManager: ObservableObject {
    @Published var products: [Product] = []
    @Published var purchasedProductIDs: Set<String> = []
    @Published var isLoading = false

    init() {
        // Mock initialization
    }
}
