
import Foundation
import StoreKit
import Pushwoosh
import Adjust

protocol IAPManagerProtocol_MWP: AnyObject {
    func infoAlert_MWP(title: String, message: String)
    func goToTheApp_MWP(type: PremiumMainController_MWPStyle)
    func failed()
}

class IAPManager_MWP: NSObject, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    
    static let shared = IAPManager_MWP()
    weak var  transactionsDelegate: IAPManagerProtocol_MWP?
    
    public var localizablePrice = "$4.99"
    public var productBuy : PremiumMainController_MWPStyle = .mainProduct
    public var productBought: [PremiumMainController_MWPStyle] = [.unlockContentProduct,.unlockFuncProduct]
    
    private var inMain: SKProduct?
    private var inUnlockContent: SKProduct?
    private var inUnlockFunc: SKProduct?
    private var inUnlockOther: SKProduct?
    
    private var mainProduct = Configurations_MWP.mainSubscriptionID
    private var unlockContentProduct = Configurations_MWP.unlockContentSubscriptionID
    private var unlockFuncProduct = Configurations_MWP.unlockFuncSubscriptionID
    private var unlockOther = Configurations_MWP.unlockerThreeSubscriptionID
    
    private var secretKey = Configurations_MWP.subscriptionSharedSecret
    
    private var isRestoreTransaction = true
    private var restoringTransactionProductId: [String] = []
    
    private var isProductsLoad: Bool = false
    
    private let iapError      = NSLocalizedString("error_iap", comment: "")
    private let prodIDError   = NSLocalizedString("inval_prod_id", comment: "")
    private let restoreError  = NSLocalizedString("faledRestore", comment: "")
    private let purchaseError = NSLocalizedString("notPurchases", comment: "")
    
    public func loadProductsFunc_MWP() {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        guard !isProductsLoad else { return }
        SKPaymentQueue.default().add(self)
        let request = SKProductsRequest(productIdentifiers:[mainProduct,unlockContentProduct,unlockFuncProduct,unlockOther])
        request.delegate = self
        request.start()
    }
    
    
    public func doPurchase_MWP() {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        switch productBuy {
        case .mainProduct:
            processPurchase_MWP(for: inMain, with: Configurations_MWP.mainSubscriptionID)
        case .unlockContentProduct:
            processPurchase_MWP(for: inUnlockContent, with: Configurations_MWP.unlockContentSubscriptionID)
        case .unlockFuncProduct:
            processPurchase_MWP(for: inUnlockFunc, with: Configurations_MWP.unlockFuncSubscriptionID)
        case .unlockOther:
            processPurchase_MWP(for: inUnlockOther, with: Configurations_MWP.unlockerThreeSubscriptionID)
        }
    }
    
    public func localizedPrice_MWP() -> String {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        guard NetworkStatusMonitor_MWP.shared.isNetworkAvailable else { return localizablePrice }
        switch productBuy {
          case .mainProduct:
            processProductPrice_MWP(for: inMain)
          case .unlockContentProduct:
            processProductPrice_MWP(for: inUnlockContent)
          case .unlockFuncProduct:
            processProductPrice_MWP(for: inUnlockFunc)
        case .unlockOther:
            processProductPrice_MWP(for: inUnlockOther)
        }
        return localizablePrice
    }
    
    private func getCurrentProduct_MWP() -> SKProduct? {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        switch productBuy {
        case .mainProduct:
            return self.inMain
        case .unlockContentProduct:
            return self.inUnlockContent
        case .unlockFuncProduct:
            return self.inUnlockFunc
        case .unlockOther:
            return self.inUnlockOther
        }
    }
    
    private func processPurchase_MWP(for product: SKProduct?, with configurationId: String) {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        guard let product = product else {
            self.transactionsDelegate?.infoAlert_MWP(title: iapError, message: prodIDError)
            return
        }
        if product.productIdentifier.isEmpty {
            
            self.transactionsDelegate?.infoAlert_MWP(title: iapError, message: prodIDError)
        } else if product.productIdentifier == configurationId {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        }
    }
    
    
    public func doRestore_MWP() {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        guard isRestoreTransaction else { return }
        SKPaymentQueue.default().restoreCompletedTransactions()
        isRestoreTransaction = false
    }
    
    
    private func completeRestoredStatusFunc_MWP(restoreProductID : String, transaction: SKPaymentTransaction) {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        if restoringTransactionProductId.contains(restoreProductID) { return }
        restoringTransactionProductId.append(restoreProductID)
        
        validateSubscriptionWithCompletionHandler_MWP(productIdentifier: restoreProductID) { [weak self] result in
            guard let self = self else {
                return
            }
            
            self.restoringTransactionProductId.removeAll {$0 == restoreProductID}
            if result {
                
                if let mainProd = self.inMain, restoreProductID == mainProd.productIdentifier {
                    self.transactionsDelegate?.goToTheApp_MWP(type: productBuy)
                    trackSubscription(transaction: transaction, product: mainProd)
                    
                }
                else if let firstProd = self.inUnlockFunc, restoreProductID == firstProd.productIdentifier {
                    trackSubscription(transaction: transaction, product: firstProd)
                    
                }
                else if let unlockContent = self.inUnlockContent, restoreProductID == unlockContent.productIdentifier {
                    trackSubscription(transaction: transaction, product: unlockContent)
                    
                }
            } else {
                self.transactionsDelegate?.infoAlert_MWP(title: self.restoreError, message: self.purchaseError)
            }
        }
    }
    
    
    public func completeAllTransactionsFunc_MWP() {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        let transactions = SKPaymentQueue.default().transactions
        for transaction in transactions {
            let transactionState = transaction.transactionState
            if transactionState == .purchased || transactionState == .restored {
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }
    
    // Ваша собственная функция для проверки подписки.
    public func validateSubscriptionWithCompletionHandler_MWP(productIdentifier: String,_ resultExamination: @escaping (Bool) -> Void) {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        SKReceiptRefreshRequest().start()
        
        guard let receiptUrl = Bundle.main.appStoreReceiptURL,
              let receiptData = try? Data(contentsOf: receiptUrl) else {
            pushwooshSetSubTag_MWP(value: false)
            resultExamination(false)
            return
        }
        
        let receiptDataString = receiptData.base64EncodedString(options: [])
        
        let jsonRequestBody: [String: Any] = [
            "receipt-data": receiptDataString,
            "password": self.secretKey,
            "exclude-old-transactions": true
        ]
        
        let requestData: Data
        do {
            requestData = try JSONSerialization.data(withJSONObject: jsonRequestBody)
        } catch {
            print("Failed to serialize JSON: \(error)")
            pushwooshSetSubTag_MWP(value: false)
            resultExamination(false)
            return
        }
#warning("replace to release")
        //#if DEBUG
        let url = URL(string: "https://sandbox.itunes.apple.com/verifyReceipt")!
        //#else
        //        let url = URL(string: "https://buy.itunes.apple.com/verifyReceipt")!
        //#endif
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = requestData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Failed to validate receipt: \(error) IAPManager_MWP")
                self.pushwooshSetSubTag_MWP(value: false)
                resultExamination(false)
                return
            }
            
            guard let data = data else {
                print("No data received from receipt validation IAPManager_MWP")
                self.pushwooshSetSubTag_MWP(value: false)
                resultExamination(false)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let latestReceiptInfo = json["latest_receipt_info"] as? [[String: Any]] {
                    for receipt in latestReceiptInfo {
                        if let receiptProductIdentifier = receipt["product_id"] as? String,
                           receiptProductIdentifier == productIdentifier,
                           let expiresDateMsString = receipt["expires_date_ms"] as? String,
                           let expiresDateMs = Double(expiresDateMsString) {
                            let expiresDate = Date(timeIntervalSince1970: expiresDateMs / 1000)
                            if expiresDate > Date() {
                                DispatchQueue.main.async {
                                    self.pushwooshSetSubTag_MWP(value: true)
                                    resultExamination(true)
                                }
                                return
                            }
                        }
                    }
                }
            } catch {
                print("Failed to parse receipt data 🔴: \(error) IAPManager_MWP")
            }
            
            DispatchQueue.main.async {
                self.pushwooshSetSubTag_MWP(value: false)
                resultExamination(false)
            }
        }
        task.resume()
    }
    
    
    func validateSubscriptions_MWP(productIdentifiers: [String], completion: @escaping ([String: Bool]) -> Void) {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        var results = [String: Bool]()
        let dispatchGroup = DispatchGroup()
        
        for productIdentifier in productIdentifiers {
            dispatchGroup.enter()
            validateSubscriptionWithCompletionHandler_MWP(productIdentifier: productIdentifier) { isValid in
                results[productIdentifier] = isValid
                if isValid {
                    if productIdentifier == Configurations_MWP.unlockFuncSubscriptionID {
                        self.productBought.append(.unlockFuncProduct)
                    }
                    if productIdentifier == Configurations_MWP.unlockContentSubscriptionID {
                        self.productBought.append(.unlockContentProduct)
                    }
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(results)
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        Pushwoosh.sharedInstance().sendSKPaymentTransactions(transactions)
        for transaction in transactions {
            if let error = transaction.error as NSError?, error.domain == SKErrorDomain {
                switch error.code {
                case SKError.paymentCancelled.rawValue:
                    print("User cancelled the request IAPManager_MWP")
                case SKError.paymentNotAllowed.rawValue, SKError.paymentInvalid.rawValue, SKError.clientInvalid.rawValue, SKError.unknown.rawValue:
                    print("This device is not allowed to make the payment IAPManager_MWP")
                default:
                    break
                }
            }
            
            switch transaction.transactionState {
            case .purchased:
                if let product = getCurrentProduct_MWP() {
                    if transaction.payment.productIdentifier == product.productIdentifier {
                        SKPaymentQueue.default().finishTransaction(transaction)
                        trackSubscription(transaction: transaction, product: product)
                        if transaction.payment.productIdentifier == Configurations_MWP.unlockFuncSubscriptionID {
                            productBought.append(.unlockFuncProduct)
                        } else if transaction.payment.productIdentifier == Configurations_MWP.unlockContentSubscriptionID {
                            productBought.append(.unlockContentProduct)
                        }
                        transactionsDelegate?.goToTheApp_MWP(type: productBuy)
                    }
                }
            case .failed:
//                if let error = transaction.error as NSError? {
//                    if error.code != SKError.paymentCancelled.rawValue, error.code != SKError.p{
//                        transactionsDelegate?.infoAlert_MWP(title: "error", message: "something went wrong")
//                    }
//                }
                transactionsDelegate?.failed()
                SKPaymentQueue.default().finishTransaction(transaction)

                print("Failed IAPManager_MWP")
                
            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                completeRestoredStatusFunc_MWP(restoreProductID: transaction.payment.productIdentifier, transaction: transaction)
                
            case .purchasing, .deferred:
                print("Purchasing IAPManager_MWP")
                
            default:
                print("Default IAPManager_MWP")
            }
        }
        completeAllTransactionsFunc_MWP()
    }
    
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        print("requesting to product IAPManager_MWP")
        
        if let invalidIdentifier = response.invalidProductIdentifiers.first {
            print("Invalid product identifier:", invalidIdentifier , "IAPManager_MWP")
        }
        
        guard !response.products.isEmpty else {
            print("No products available IAPManager_MWP")
            return
        }
        
        response.products.forEach({ productFromRequest in
            switch productFromRequest.productIdentifier {
            case Configurations_MWP.mainSubscriptionID:
                inMain = productFromRequest
            case Configurations_MWP.unlockContentSubscriptionID:
                inUnlockContent = productFromRequest
            case Configurations_MWP.unlockFuncSubscriptionID:
                inUnlockFunc = productFromRequest
            case Configurations_MWP.unlockerThreeSubscriptionID:
                inUnlockOther = productFromRequest
            default:
                print("error IAPManager_MWP")
                return
            }
            isProductsLoad = true
            print("Found product: \(productFromRequest.productIdentifier) IAPManager_MWP")
        })
    }
    
    private func processProductPrice_MWP(for product: SKProduct?) {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        guard let product = product else {
            self.localizablePrice = "4.99 $"
            return
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = product.priceLocale
        
        if let formattedPrice = numberFormatter.string(from: product.price) {
            self.localizablePrice = formattedPrice
        } else {
            self.localizablePrice = "4.99 $"
        }
    }
    
    private func pushwooshSetSubTag_MWP(value : Bool) {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        var tag = Configurations_MWP.mainSubscriptionPushTag
        
        switch productBuy {
        case .mainProduct:
            print("continue IAPManager_MWP")
        case .unlockContentProduct:
            tag = Configurations_MWP.unlockContentSubscriptionPushTag
        case .unlockFuncProduct:
            tag = Configurations_MWP.unlockFuncSubscriptionPushTag
        case .unlockOther:
            tag = Configurations_MWP.unlockerThreeSubscriptionPushTag
        }
        
        Pushwoosh.sharedInstance().setTags([tag: value]) { error in
            if let err = error {
                print(err.localizedDescription)
                print("send tag error IAPManager_MWP")
            }
        }
    }
    
    private func trackSubscription(transaction: SKPaymentTransaction, product: SKProduct) {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        if let receiptURL = Bundle.main.appStoreReceiptURL,
           let receiptData = try? Data(contentsOf: receiptURL) {
            
            let price = NSDecimalNumber(decimal: product.price.decimalValue)
            let currency = product.priceLocale.currencyCode ?? "USD"
            let transactionId = transaction.transactionIdentifier ?? ""
            let transactionDate = transaction.transactionDate ?? Date()
            let salesRegion = product.priceLocale.regionCode ?? "US"
            
            if let subscription = ADJSubscription(price: price, currency: currency, transactionId: transactionId, andReceipt: receiptData) {
                subscription.setTransactionDate(transactionDate)
                subscription.setSalesRegion(salesRegion)
                Adjust.trackSubscription(subscription)
            }
        }
    }
}
