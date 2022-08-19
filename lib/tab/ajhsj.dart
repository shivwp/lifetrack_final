import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:flutter/foundation.dart';
import 'package:life_track/Utils.dart';
import 'package:life_track/repo/update-user-subscription_repository.dart';

import 'consumables.dart';
//import for AppStorePurchaseDetails
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
//import for SKProductWrapper
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

List<PurchaseDetails> purchases = [];
List<ProductDetails> products = [];
const bool kAutoConsume = true;
const String kConsumableId = 'mothly_subs';
const String kUpgradeId = 'non_consumable';
const String kSilverSubscriptionId = 'silver_subscription';
const String kGoldSubscriptionId = 'gold_subscription';
const List<String> _kProductIds = <String>[
  kConsumableId,
  kUpgradeId,
  kSilverSubscriptionId,
  kGoldSubscriptionId,
];


class ProviderModel with ChangeNotifier {
  final InAppPurchase inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> subscription;
  List<String> notFoundIds = [];
  List<String> consumables = [];
  bool isAvailable = false;
  bool purchasePending = false;
  bool loading = true;
  String? queryProductError;

  String? purchaseId;



  Future<void> initInApp() async {
    final Stream<List<PurchaseDetails>> purchaseUpdated = inAppPurchase.purchaseStream;
    subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      subscription.cancel();
    }, onError: (error) {
print('object 01');
      updateUserSubscription(
          'error',
          products[0].id.toString(),
          products[0].price.toString(),
          DateTime.now().millisecond.toString(),
          products[0].currencyCode.toString(),
          products[0].currencySymbol.toString()).then((value) {
        if(value.status){
          showToast(value.message);
        }
        return null;
      });

       showToast('hello error');
      // handle error here.
    });
    await initStoreInfo();
    await verifyPreviousPurchases();
  }
  Future<void> inAppStream() async {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        inAppPurchase.purchaseStream;
    subscription = purchaseUpdated.listen((purchaseDetailsList) {

    }, onDone: () {
      subscription.cancel();
    }, onError: (error) {
      print('object 02');
      updateUserSubscription(
          'error',
          products[0].id.toString(),
          products[0].price.toString(),
          DateTime.now().millisecond.toString(),
          products[0].currencyCode.toString(),
          products[0].currencySymbol.toString()).then((value) {
        if(value.status){
          showToast(value.message);
        }
        return null;
      });

      showToast('hello everyone');
      // handle error here.
    });

  }
  verifyPreviousPurchases() async {
    await inAppPurchase.restorePurchases();
    await Future.delayed(const Duration(milliseconds: 100), () {
      for (var pur in purchases) {
        if (pur.productID.contains('non_consumable')) {
          removeAds = true;
        }
        if (pur.productID.contains('silver_subscription')) {
          silverSubscription = true;
        }

        if (pur.productID.contains('gold_subscription')) {
          goldSubscription = true;
        }
      }

      finishedLoad = true;
    });

    notifyListeners();
  }

  bool _removeAds = false;
  bool get removeAds => _removeAds;
  set removeAds(bool value) {
    _removeAds = value;
    notifyListeners();
  }

  bool _silverSubscription = false;
  bool get silverSubscription => _silverSubscription;
  set silverSubscription(bool value) {
    _silverSubscription = value;
    notifyListeners();
  }

  bool _goldSubscription = false;
  bool get goldSubscription => _goldSubscription;
  set goldSubscription(bool value) {
    _goldSubscription = value;
    notifyListeners();
  }

  bool _finishedLoad = false;
  bool get finishedLoad => _finishedLoad;
  set finishedLoad(bool value) {
    _finishedLoad = value;
    notifyListeners();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailableStore = await inAppPurchase.isAvailable();
    if (!isAvailableStore) {
      isAvailable = isAvailableStore;
      products = [];
      purchases = [];
      notFoundIds = [];
      consumables = [];
      purchasePending = false;
      loading = false;
      return;
    }

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
      inAppPurchase
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    ProductDetailsResponse productDetailResponse =
    await inAppPurchase.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      queryProductError = productDetailResponse.error!.message;
      isAvailable = isAvailableStore;
      products = productDetailResponse.productDetails;
      purchases = [];
      notFoundIds = productDetailResponse.notFoundIDs;
      consumables = [];
      purchasePending = false;
      loading = false;
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      queryProductError = null;
      isAvailable = isAvailableStore;
      products = productDetailResponse.productDetails;
      purchases = [];
      notFoundIds = productDetailResponse.notFoundIDs;
      consumables = [];
      purchasePending = false;
      loading = false;
      return;
    }

    List<String> consumableProd = await ConsumableStore.load();
    isAvailable = isAvailableStore;
    products = productDetailResponse.productDetails;
    notFoundIds = productDetailResponse.notFoundIDs;
    consumables = consumableProd;
    purchasePending = false;
    loading = false;
    notifyListeners();
  }

  Future<void> consume(String id) async {
    await ConsumableStore.consume(id);
    final List<String> consumableProd = await ConsumableStore.load();
    consumables = consumableProd;
    notifyListeners();
  }

  void showPendingUI() {
    purchasePending = true;
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {
    print('object 03');
    updateUserSubscription(
        purchaseDetails.status.toString(),
        products[0].id.toString(),
        products[0].price.toString(),
        DateTime.now().millisecond.toString(),
        products[0].currencyCode.toString(),
        products[0].currencySymbol.toString()).then((value) {
      if(value.status){
        showToast(value.message);
      }
      return null;
    });
    showToast('message 0006'+purchaseDetails.toString());
    // IMPORTANT!! Always verify purchase details before delivering the product.
    if (purchaseDetails.productID == kConsumableId) {
      await ConsumableStore.save(purchaseDetails.purchaseID!);
      List<String> consumableProd = await ConsumableStore.load();
      purchasePending = false;
      consumables = consumableProd;
    } else {
      purchases.add(purchaseDetails);
      purchasePending = false;
    }
  }

  void handleError(IAPError error) {
    print('object 04');
    updateUserSubscription(
        'error',
        products[0].id.toString(),
        products[0].price.toString(),
        DateTime.now().millisecond.toString(),
        products[0].currencyCode.toString(),
        products[0].currencySymbol.toString()).then((value) {
      if(value.status){
        showToast(value.message);
      }
      return null;
    });
    showToast('message 0005'+error.toString());
    purchasePending = false;
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    print('object 05');
    updateUserSubscription(
        purchaseDetails.status.toString(),
        products[0].id.toString(),
        products[0].price.toString(),
        DateTime.now().millisecond.toString(),
        products[0].currencyCode.toString(),
        products[0].currencySymbol.toString()).then((value) {
      if(value.status){
        showToast(value.message);
      }
      return null;
    });

    showToast('message 0004'+purchaseDetails.toString());
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    print('object 06');
    updateUserSubscription(
        purchaseDetails.status.toString(),
        products[0].id.toString(),
        products[0].price.toString(),
        DateTime.now().millisecond.toString(),
        products[0].currencyCode.toString(),
        products[0].currencySymbol.toString()).then((value) {
      if(value.status){
        showToast(value.message);
      }
      return null;
    });

    showToast('message 0003'+purchaseDetails.toString());
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        purchaseId = purchaseDetails.productID.toString();
        print('object 07');
        updateUserSubscription(
            purchaseDetails.status.toString(),
            products[0].id.toString(),
            products[0].price.toString(),
            DateTime.now().millisecond.toString(),
            products[0].currencyCode.toString(),
            products[0].currencySymbol.toString()).then((value) {
          if(value.status){
            showToast(value.message);
          }
          return null;
        });

        showToast('message 0001'+purchaseDetails.toString());
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          purchaseId = purchaseDetails.productID.toString();
          print('object 08');
          updateUserSubscription(
              purchaseDetails.status.toString(),
              products[0].id.toString(),
              products[0].price.toString(),
              DateTime.now().millisecond.toString(),
              products[0].currencyCode.toString(),
              products[0].currencySymbol.toString()).then((value) {
            if(value.status){
              showToast(value.message);
            }
            return null;
          });

          showToast('message 0002'+purchaseDetails.toString());
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased || purchaseDetails.status == PurchaseStatus.restored) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            purchaseId = purchaseDetails.productID.toString();
            deliverProduct(purchaseDetails);
            print('object 09');
            updateUserSubscription(
                'purchased',
                products[0].id.toString(),
                products[0].price.toString(),
                DateTime.now().millisecond.toString(),
                products[0].currencyCode.toString(),
                products[0].currencySymbol.toString()).then((value) {
                  if(value.status){
                    showToast(value.message);
                  }
              return null;
            });

            showToast('purchased restored');
          } else {
            _handleInvalidPurchase(purchaseDetails);
            purchaseId = purchaseDetails.productID.toString();

            print('object 10');
            updateUserSubscription(
                purchaseDetails.status.toString(),
                products[0].id.toString(),
                products[0].price.toString(),
                DateTime.now().millisecond.toString(),
                products[0].currencyCode.toString(),
                products[0].currencySymbol.toString()).then((value) {
              if(value.status){
                showToast(value.message);
              }
              return null;
            });
            return;
          }
        }
        if (Platform.isAndroid) {
          if (!kAutoConsume && purchaseDetails.productID == kConsumableId) {
            purchaseId = purchaseDetails.productID.toString();
            final InAppPurchaseAndroidPlatformAddition androidAddition =
            inAppPurchase.getPlatformAddition<
                InAppPurchaseAndroidPlatformAddition>();
            await androidAddition.consumePurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          purchaseId = purchaseDetails.productID.toString();
          await inAppPurchase.completePurchase(purchaseDetails);
          if (purchaseDetails.productID == 'consumable_product') {
            print('================================You got coins');
          }
          verifyPreviousPurchases();
        }
      }
    });
  }

  Future<void> confirmPriceChange(BuildContext context) async {
    if (Platform.isAndroid) {

      showToast('SKU VALUE  :: ' +purchaseId.toString());
      final InAppPurchaseAndroidPlatformAddition androidAddition = inAppPurchase.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      var priceChangeConfirmationResult = await androidAddition.launchPriceChangeConfirmationFlow(
        sku: purchaseId.toString(),
      );
      if (priceChangeConfirmationResult.responseCode == BillingResponse.ok) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Price change accepted'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            priceChangeConfirmationResult.debugMessage ??
                "Price change failed with code ${priceChangeConfirmationResult.responseCode}",
          ),
        ));
      }
    }
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
      inAppPurchase
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }
  }

  GooglePlayPurchaseDetails? getOldSubscription(
      ProductDetails productDetails, Map<String, PurchaseDetails> purchases) {
    GooglePlayPurchaseDetails? oldSubscription;
    if (productDetails.id == kSilverSubscriptionId &&
        purchases[kGoldSubscriptionId] != null) {
      oldSubscription =
      purchases[kGoldSubscriptionId] as GooglePlayPurchaseDetails;
    } else if (productDetails.id == kGoldSubscriptionId &&
        purchases[kSilverSubscriptionId] != null) {
      oldSubscription =
      purchases[kSilverSubscriptionId] as GooglePlayPurchaseDetails;
    }
    return oldSubscription;
  }

// bool removeAds = false;

void removeAdsFunc(newValue) {
  removeAds = newValue;
  notifyListeners();
}

}

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}