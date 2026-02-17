import SwiftUI
import StoreKit

struct PremiumView: View {
    @StateObject private var storeKit = StoreKitManager()
    @State private var selectedProductID: String?
    @State private var showPurchaseAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(alignment: .center, spacing: 12) {
                        Image(systemName: "cup.and.saucer.fill")
                            .font(.system(size: 48))
                            .foregroundColor(Color(#colorLiteral(red: 0.243, green: 0.157, blue: 0.137, alpha: 1)))

                        Text("店主を応援しよう！")
                            .font(.system(size: 24, weight: .bold, design: .default))

                        Text("ソロ会議を支えてくださりありがとうございます。\nあなたのサポートが開発を続けるための力になります。")
                            .font(.system(size: 14, weight: .regular, design: .default))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(20)
                    .background(Color(#colorLiteral(red: 1, green: 0.976, blue: 0.773, alpha: 0.2)))
                    .cornerRadius(12)

                    // Tip options
                    VStack(alignment: .leading, spacing: 12) {
                        Text("コーヒーを奢る☕")
                            .font(.system(size: 18, weight: .bold, design: .default))

                        VStack(spacing: 12) {
                            ForEach(storeKit.products.filter { $0.id.contains("tip") }, id: \.id) { product in
                                PremiumOptionView(
                                    product: product,
                                    isSelected: selectedProductID == product.id,
                                    action: {
                                        selectedProductID = product.id
                                        Task {
                                            await purchaseProduct(product)
                                        }
                                    }
                                )
                            }
                        }
                    }

                    // Ad removal option
                    VStack(alignment: .leading, spacing: 12) {
                        Text("広告を除去する📵")
                            .font(.system(size: 18, weight: .bold, design: .default))

                        if let adRemovalProduct = storeKit.products.first(where: { $0.id == "com.soloMeet.adRemoval" }) {
                            if storeKit.isPurchased("com.soloMeet.adRemoval") {
                                VStack(spacing: 12) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            HStack {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(.green)

                                                Text("常連客パス")
                                                    .font(.system(size: 16, weight: .semibold, design: .default))
                                            }

                                            Text("広告が表示されなくなります")
                                                .font(.system(size: 12, weight: .regular, design: .default))
                                                .foregroundColor(.secondary)
                                        }

                                        Spacer()

                                        Text("購入済み")
                                            .font(.system(size: 12, weight: .semibold, design: .default))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color.green)
                                            .cornerRadius(4)
                                    }
                                    .padding(16)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                                }
                            } else {
                                PremiumOptionView(
                                    product: adRemovalProduct,
                                    isSelected: selectedProductID == adRemovalProduct.id,
                                    action: {
                                        selectedProductID = adRemovalProduct.id
                                        Task {
                                            await purchaseProduct(adRemovalProduct)
                                        }
                                    }
                                )
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("ご注意")
                            .font(.system(size: 14, weight: .semibold, design: .default))

                        VStack(alignment: .leading, spacing: 4) {
                            Text("• 購入はApple IDに紐づいてます")
                                .font(.system(size: 12, weight: .regular, design: .default))
                                .foregroundColor(.secondary)

                            Text("• キャンセルはいつでも可能です")
                                .font(.system(size: 12, weight: .regular, design: .default))
                                .foregroundColor(.secondary)

                            Text("• サーバーの維持と開発に使用されます")
                                .font(.system(size: 12, weight: .regular, design: .default))
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(16)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)

                    Spacer()
                }
                .padding(16)
            }
            .background(Color(#colorLiteral(red: 0.98, green: 0.96, blue: 0.92, alpha: 1)))
            .navigationTitle("サポート")
            .navigationBarTitleDisplayMode(.inline)
        }
        .alert("購入", isPresented: $showPurchaseAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
        .onAppear {
            Task {
                await storeKit.requestProducts()
            }
        }
    }

    private func purchaseProduct(_ product: Product) async {
        do {
            try await storeKit.purchase(product)
            alertMessage = "ご購入ありがとうございます！"
            showPurchaseAlert = true
        } catch {
            alertMessage = "購入処理中にエラーが発生しました: \(error.localizedDescription)"
            showPurchaseAlert = true
        }
    }
}

struct PremiumOptionView: View {
    let product: Product
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(getProductName(product.id))
                        .font(.system(size: 16, weight: .semibold, design: .default))
                        .foregroundColor(.black)

                    Spacer()

                    Text(product.displayPrice)
                        .font(.system(size: 16, weight: .semibold, design: .default))
                        .foregroundColor(Color(#colorLiteral(red: 0.243, green: 0.157, blue: 0.137, alpha: 1)))
                }

                Text(getProductDescription(product.id))
                    .font(.system(size: 12, weight: .regular, design: .default))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(16)
            .background(isSelected ? Color(#colorLiteral(red: 1, green: 0.976, blue: 0.773, alpha: 0.5)) : Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? Color(#colorLiteral(red: 0.243, green: 0.157, blue: 0.137, alpha: 1)) : Color.gray.opacity(0.2),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
        }
    }

    private func getProductName(_ id: String) -> String {
        switch id {
        case "com.soloMeet.tip.small":
            return "☕ ホットコーヒー"
        case "com.soloMeet.tip.medium":
            return "☕☕ カプチーノ"
        case "com.soloMeet.tip.large":
            return "☕☕☕ エスプレッソ"
        case "com.soloMeet.adRemoval":
            return "常連客パス"
        default:
            return "商品"
        }
    }

    private func getProductDescription(_ id: String) -> String {
        switch id {
        case "com.soloMeet.tip.small":
            return "小さな応援をありがとう！"
        case "com.soloMeet.tip.medium":
            return "いつもの応援をありがとう！"
        case "com.soloMeet.tip.large":
            return "大きな応援をありがとう！"
        case "com.soloMeet.adRemoval":
            return "広告なしで快適にご利用できます"
        default:
            return ""
        }
    }
}

#Preview {
    PremiumView()
}
