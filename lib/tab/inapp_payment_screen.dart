import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:life_track/Contants/appcolors.dart';
import 'package:life_track/Contants/constant.dart';
import 'package:life_track/components/background_gradient_container.dart';
import 'package:life_track/controller/get_plans_controller.dart';
import 'package:provider/provider.dart';
import 'ajhsj.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final GetPlansController controller = Get.put(GetPlansController());

  void _goBack(context) {
    Navigator.pop(context);
  }

  late ProviderModel _appProvider;


  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ProviderModel>(context, listen: false);
    _appProvider = provider;
    inAppStream(provider);

    SchedulerBinding.instance!.addPostFrameCallback((_) async {
      initInApp(provider);
    });
    controller.getData();
  }

  //
  // @override
  // void initState() {
  //   final provider = Provider.of<ProviderModel>(context, listen: false);
  //   _appProvider = provider;
  //
  //   SchedulerBinding.instance!.addPostFrameCallback((_) async {
  //     initInApp(provider);
  //   });
  //   super.initState();
  //   controller.getData();
  // }

  initInApp(provider) async {
    await provider.initInApp();
  }


  inAppStream(provider) async {
    await provider.inAppStream();
  }

  @override
  void dispose() {
    // if (Platform.isIOS) {
    //   var iosPlatformAddition = _appProvider.inAppPurchase
    //       .getPlatformAddition<InAppPurchaseIosPlatformAddition>();
    //   iosPlatformAddition.setDelegate(null);
    // }

    _appProvider.subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderModel>(context);
    double deviceHeight = MediaQuery
        .of(context)
        .size
        .height;
    double deviceWidth = MediaQuery
        .of(context)
        .size
        .width;
    List<Widget> stack = [];
    if (provider.queryProductError == null) {
      stack.add(
        Obx(() {
          return !controller.isDataLoading.value?
              SizedBox.shrink():
           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                // _buildConnectionCheckTile(provider),
                _buildProductList(provider),
              ],
            ),
          );
        }),
      );
    } else {
      stack.add(Center(
        child: Text(provider.queryProductError!),
      ));
    }
    if (provider.purchasePending) {
      stack.add(
        Stack(
          children: [
            Opacity(
              opacity: 0.3,
              child: const ModalBarrier(dismissible: false, color: Colors.grey),
            ),
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      );
    }
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Buy Plans'),
      // ),
      body: BackgroundGradientContainer(
        child: Obx(() {
          return controller.isDataLoading.value ? Column(
            children: [
              SizedBox(height: deviceHeight * 0.05),
              Text('Get Lifetrack PRO', textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700),),
              SizedBox(height: deviceHeight * 0.04),
              Image.asset('assets/images/subscription_plans.png',
                height: 145,),
              SizedBox(height: deviceHeight * 0.05),
              Text(
                'Don\'t loose advanced features', textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),),
              Stack(
                children: stack,
              ),
              Spacer(),
              Container(
                width: deviceWidth,
                child: Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    child: Text('NOT NOW', style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            AppColors.PRIMARY_COLOR),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                                //bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                            )
                        )
                    ),
                    onPressed: () {
                      _goBack(context);
                    },
                  ),
                ),
              ),
            ],
          ) : Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }

  // Card _buildConnectionCheckTile(provider) {
  //   if (provider.loading) {
  //     return Card(child: ListTile(title: const Text('Trying to connect...')));
  //   }
  //   final Widget storeHeader = provider.notFoundIds.isNotEmpty
  //       ? ListTile(
  //       leading: Icon(Icons.block,
  //           color: provider.isAvailable
  //               ? Colors.grey
  //               : ThemeData.light().errorColor),
  //       title: Text('The store is unavailable'))
  //       : ListTile(
  //     leading: Icon(Icons.check, color: Colors.green),
  //     title: Text('The store is available'),
  //   );
  //   final List<Widget> children = <Widget>[storeHeader];
  //
  //   if (!provider.isAvailable) {
  //     children.addAll([
  //       Divider(),
  //       ListTile(
  //         title: Text('Not connected',
  //             style: TextStyle(color: ThemeData.light().errorColor)),
  //         subtitle: const Text(
  //             'Unable to connect to the payments processor. Has this app been configured correctly? See the example README for instructions.'),
  //       ),
  //     ]);
  //   }
  //   return Card(child: Column(children: children));
  // }

  Card _buildProductList(provider) {
    if (provider.loading) {
      return Card(
          child: (
              ListTile(
                  leading: CircularProgressIndicator(),
                  title: Text('Fetching products...' + provider.isAvailable.toString()))));
    }
    if (!provider.isAvailable) {
      return Card();
    }
    // final ListTile productHeader = ListTile(title: Text('Products for Sale'));
    List<ListTile> productList = <ListTile>[];
    // if (provider.notFoundIds.isNotEmpty) {
    //   productList.add(ListTile(
    //     title: Text('Products not found',
    //         style: TextStyle(color: ThemeData.light().errorColor)),
    //   ));
    // }

    // This loading previous purchases code is just a demo. Please do not use this as it is.
    // In your app you should always verify the purchase data using the `verificationData` inside the [PurchaseDetails] object before trusting it.
    // We recommend that you use your own server to verify the purchase data.
    Map<String, PurchaseDetails> purchasesIn =
    Map.fromEntries(purchases.map((PurchaseDetails purchase) {
      if (purchase.pendingCompletePurchase) {
        provider.inAppPurchase.completePurchase(purchase);
      }
      return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
    }));
    productList.addAll(products.map(
          (ProductDetails productDetails) {
        PurchaseDetails? previousPurchase = purchasesIn[productDetails.id];
        return ListTile(
            tileColor: AppColors.PRIMARY_COLOR,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),),
            leading: Icon(Icons.donut_large, size: 50,
              color: Colors.white,),
            title: Text(
              controller.model.value.data![0].name.toString(),
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text(
                  "Type: " + controller.model.value.data![0].subscriptionsType
                      .toString(),

                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),),
                SizedBox(height: 6),
                Text(
                  "Add friends: " +
                      controller.model.value.data![0].addfriends.toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),),
                SizedBox(height: 6),
                Text(
                  "Create group: " +
                      controller.model.value.data![0].creategroup.toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),),
                SizedBox(height: 10),
              ],
            ),
            trailing: previousPurchase != null
                ? IconButton(
                onPressed: () => provider.confirmPriceChange(context),
                icon: Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 40,
                ))
                : /*TextButton(
              child: Text(productDetails.id == kConsumableId &&
                  provider.consumables.length > 0
                  ? "Buy more\n${productDetails.price}"
                  : productDetails.price),
              style: TextButton.styleFrom(
                backgroundColor: Colors.green[800],
                primary: Colors.white,
              ),
              onPressed: () {
                late PurchaseParam purchaseParam;

                if (Platform.isAndroid) {
                  // NOTE: If you are making a subscription purchase/upgrade/downgrade, we recommend you to
                  // verify the latest status of you your subscription by using server side receipt validation
                  // and update the UI accordingly. The subscription purchase status shown
                  // inside the app may not be accurate.
                  final oldSubscription = provider.getOldSubscription(
                      productDetails, purchasesIn);

                  purchaseParam = GooglePlayPurchaseParam(
                      productDetails: productDetails,
                      applicationUserName: null,
                      changeSubscriptionParam: (oldSubscription != null)
                          ? ChangeSubscriptionParam(
                        oldPurchaseDetails: oldSubscription,
                        prorationMode: ProrationMode.immediateWithTimeProration,
                      )
                          : null);
                } else {
                  purchaseParam = PurchaseParam(
                    productDetails: productDetails,
                    applicationUserName: null,
                  );
                }

                if (productDetails.id == kConsumableId) {
                  provider.inAppPurchase.buyConsumable(
                      purchaseParam: purchaseParam,
                      autoConsume: kAutoConsume || Platform.isIOS);
                } else {
                  provider.inAppPurchase
                      .buyNonConsumable(purchaseParam: purchaseParam);
                }


              },
            )*/ GestureDetector(
              onTap: () {
                late PurchaseParam purchaseParam;
                if (Platform.isAndroid) {
                  // NOTE: If you are making a subscription purchase/upgrade/downgrade, we recommend you to
                  // verify the latest status of you your subscription by using server side receipt validation
                  // and update the UI accordingly. The subscription purchase status shown
                  // inside the app may not be accurate.
                  final oldSubscription = provider.getOldSubscription(
                      productDetails, purchasesIn);

                  print(
                      'oldSubscription:::::: ==>' + oldSubscription.toString());
                  print('productDetails:::::: title==>' + productDetails.title);
                  print('productDetails:::::: id==>' + productDetails.id);
                  print('productDetails:::::: price==>' + productDetails.price);
                  print(
                      'productDetails:::::: description==>' + productDetails.description);
                  print(
                      'productDetails:::::: currencyCode==>' + productDetails.currencyCode);
                  print('productDetails:::::: currencySymbol ==>' +
                      productDetails.currencySymbol);


                  purchaseParam = GooglePlayPurchaseParam(
                      productDetails: productDetails,
                      applicationUserName: null,
                      changeSubscriptionParam: (oldSubscription != null) ? ChangeSubscriptionParam(
                        oldPurchaseDetails: oldSubscription,
                        prorationMode: ProrationMode.immediateWithTimeProration,
                      )
                          : null);
                } else {
                  purchaseParam = PurchaseParam(
                    productDetails: productDetails,
                    applicationUserName: null,
                  );
                }

                if (productDetails.id == kConsumableId) {
                  provider.inAppPurchase.buyConsumable(
                      purchaseParam: purchaseParam,
                      autoConsume: kAutoConsume || Platform.isIOS);
                } else {
                  provider.inAppPurchase
                      .buyNonConsumable(purchaseParam: purchaseParam);
                }
              },
              child: Container(
                height: 30,
                width: 80,
                decoration: BoxDecoration(
                    color: AppColors.PRIMARY_COLOR_LIGHT,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(16.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 4,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      )
                    ]),
                child: Center(
                  child: Text(
                    productDetails.id == kConsumableId &&
                        provider.consumables.length > 0
                        ? "Buy more\n${productDetails.price}"
                        : productDetails.price,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: fontFamilyName,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      letterSpacing: 0.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ));
      },
    ));

    return Card(
      elevation: 2,
        color: AppColors.PRIMARY_COLOR,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),),
        child:
        Column(children: <Widget>[
        ] + productList));
  }
}