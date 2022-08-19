// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:provider/provider.dart';
// import 'ajhsj.dart';
// import 'inapp_payment_screen.dart';
//
// class ShowPlanes extends StatefulWidget {
//   const ShowPlanes({Key? key}) : super(key: key);
//
//   @override
//   _ShowPlanesState createState() => _ShowPlanesState();
// }
//
// class _ShowPlanesState extends State<ShowPlanes> {
//   late ProviderModel _appProvider;
//
//   @override
//   void initState() {
//     final provider = Provider.of<ProviderModel>(context, listen: false);
//     _appProvider = provider;
//
//     SchedulerBinding.instance!.addPostFrameCallback((_) async {
//       initInApp(provider);
//     });
//
//     super.initState();
//   }
//
//   initInApp(provider) async {
//     await provider.initInApp();
//   }
//   @override
//   void dispose() {
//     // if (Platform.isIOS) {
//     //   var iosPlatformAddition = _appProvider.inAppPurchase
//     //       .getPlatformAddition<InAppPurchaseIosPlatformAddition>();
//     //   iosPlatformAddition.setDelegate(null);
//     // }
//     _appProvider.subscription.cancel();
//     super.dispose();
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<ProviderModel>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ElevatedButton(
//                 style: ButtonStyle(
//                     backgroundColor:
//                     MaterialStateProperty.all<Color>(Colors.green)),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => PaymentScreen()),
//                   );
//                 },
//                 child: Text('Pay')),
//           )
//         ],
//       ),
//       body: ListView(
//         padding: EdgeInsets.all(8),
//         children: [
//           Text(
//             'Non Consumable:',
//             style: TextStyle(fontSize: 20),
//           ),
//           Text(
//             !provider.finishedLoad
//                 ? ''
//                 : provider.removeAds
//                 ? 'You paid for removing Ads.'
//                 : 'You have not paid for removing Ads.',
//             style: TextStyle(
//                 color: provider.removeAds ? Colors.green : Colors.grey,
//                 fontSize: 20),
//           ),
//           Container(
//             height: 30,
//           ),
//           Text(
//             'Silver Subscription:',
//             style: TextStyle(fontSize: 20),
//           ),
//           Text(
//             !provider.finishedLoad
//                 ? ''
//                 : provider.silverSubscription
//                 ? 'You have Silver Subscription.'
//                 : 'You have not paid for Silver Subscription.',
//             style: TextStyle(
//                 color: provider.silverSubscription ? Colors.green : Colors.grey,
//                 fontSize: 20),
//           ),
//           Container(
//             height: 30,
//           ),
//           Text(
//             'Gold Subscription:',
//             style: TextStyle(fontSize: 20),
//           ),
//           Text(
//             !provider.finishedLoad
//                 ? ''
//                 : provider.goldSubscription
//                 ? 'You have Gold Subscription.'
//                 : 'You have not paid for Gold Subscription.',
//             style: TextStyle(
//                 color: provider.goldSubscription ? Colors.green : Colors.grey,
//                 fontSize: 20),
//           ),
//           Container(
//             height: 30,
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Purchased consumables:${provider.consumables.length}',
//                   style: TextStyle(fontSize: 20)),
//               _buildConsumableBox(provider),
//             ],
//           )
//         ],
//       ),
//     );
//   }
//
//   Card _buildConsumableBox(provider) {
//     if (provider.loading) {
//       return Card(
//           child: (ListTile(
//               leading: CircularProgressIndicator(),
//               title: Text('Fetching consumables...'))));
//     }
//     if (!provider.isAvailable || provider.notFoundIds.contains(kConsumableId)) {
//       return Card();
//     }
//
//     final List<Widget> tokens = provider.consumables.map<Widget>((String id) {
//       return GridTile(
//         child: IconButton(
//           icon: Icon(
//             Icons.stars,
//             size: 42.0,
//             color: Colors.orange,
//           ),
//           splashColor: Colors.yellowAccent,
//           onPressed: () {
//             provider.consume(id);
//           },
//         ),
//       );
//     }).toList();
//     return Card(
//         elevation: 0,
//         child: Column(children: <Widget>[
//           GridView.count(
//             crossAxisCount: 5,
//             children: tokens,
//             shrinkWrap: true,
//           )
//         ]));
//   }
// }
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:life_track/controller/get_plans_controller.dart';
import 'package:life_track/repo/user-notification-status_repository.dart';
import 'package:life_track/tab/ajhsj.dart';
import 'package:life_track/tab/change_password.dart';
import 'package:life_track/tab/inapp_payment_screen.dart';
import 'package:life_track/tab/terms_conditions.dart';
import 'package:provider/provider.dart';

import '../Contants/appcolors.dart';
import '../Contants/constant.dart';
import '../components/background_gradient_container.dart';
import 'about_us.dart';
import 'notification_screen.dart';
import 'privacy_policy.dart';

class ShowPlanes extends StatefulWidget {
  const ShowPlanes({Key? key}) : super(key: key);

  @override
  _ShowPlanesState createState() => _ShowPlanesState();
}

class _ShowPlanesState extends State<ShowPlanes> {
  final GetPlansController controller = Get.put(GetPlansController());
  late ProviderModel _appProvider;

  void _goBack(context) {
    Navigator.pop(context);
  }

  void _moveToNotifications(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotificationScreen(),
      ),
    );
  }

  List colors = [Colors.red, Colors.yellow, Colors.blue, Colors.green];


  @override
  void initState() {
    final provider = Provider.of<ProviderModel>(context, listen: false);
    _appProvider = provider;

    SchedulerBinding.instance!.addPostFrameCallback((_) async {
      initInApp(provider);
    });
    super.initState();
    controller.getData();
  }

  initInApp(provider) async {
    await provider.initInApp();
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
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   automaticallyImplyLeading: true,
      //   backgroundColor: AppColors.PRIMARY_COLOR_LIGHT,
      //   title: const Text(
      //     'Subscription Planes',
      //     style: TextStyle(
      //       color: Colors.white,
      //       fontSize: 23,
      //       fontFamily: fontFamilyName,
      //       fontWeight: FontWeight.w500,
      //     ),
      //   ),
      // ),
      body: BackgroundGradientContainer(
        child: SafeArea(
          minimum: const EdgeInsets.only(top: 0),
          child: Obx(() {
            return controller.isDataLoading.value
                ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Stack(
                children: [
                  Container(
                    child: Column(
                      children: [
                        SizedBox(height: deviceHeight * 0.05),
                        Text('Get Lifetrack PRO', style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700),),
                        SizedBox(height: deviceHeight * 0.04),
                        Image.asset('assets/images/subscription_plans.png',
                          height: 145,),
                        SizedBox(height: deviceHeight * 0.05),
                        Text('Don\'t loose advanced features', style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),),
                        SizedBox(height: deviceHeight * 0.06),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.model.value.data!.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 5,
                                color: AppColors.PRIMARY_COLOR,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Icon(Icons.donut_large, size: 50,
                                              color: Colors.white,),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 8,),
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(controller.model.value.data![index].name.toString(), style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),),
                                            SizedBox(height: 4),
                                            Text(
                                              "type: "+controller.model.value.data![index].subscriptionsType.toString(),

                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400),),
                                            SizedBox(height: 4),
                                            Text(
                                              "Add friends: "+controller.model.value.data![index].addfriends.toString(),

                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400),),
                                            SizedBox(height: 4),
                                            Text(
                                              "Create group: "+controller.model.value.data![index].creategroup.toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400),),

                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Text('\$'+controller.model.value.data![index].price.toString(), style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),),
                                          SizedBox(height: 8),
                                          GestureDetector(
                                            onTap: (){
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => PaymentScreen()),
                                              );
                                            },
                                            child: Container(
                                              height: 30,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                  color: AppColors.PRIMARY_COLOR_LIGHT,
                                                  borderRadius: const BorderRadius.all(
                                                    Radius.circular(25.0),
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
                                                child: const Text(
                                                  'Buy',
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
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )/*ListTile(
                                  leading: Icon(Icons.donut_large, size: 50,
                                    color: Colors.white,),
                                  title: Text(controller.model.value.data![index].name.toString(), style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),),
                                  subtitle: Text(
                                    "type: "+controller.model.value.data![index].subscriptionsType.toString()+"\n"+
                                    "Add friends: "+controller.model.value.data![index].addfriends.toString()+"\n"+
                                        "Create group: "+controller.model.value.data![index].creategroup.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),),
                                  trailing: Text('\$'+controller.model.value.data![index].price.toString(), style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),),
                                )*/,
                              );
                            }),

                      ],
                    ),
                  ),
                  Positioned(
                      bottom: 20,
                      right: 0,
                      left: 0,
                      child: Container(
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
                      ))
                ],
              ),
            )
                : Center(child: CircularProgressIndicator());
          }),
        ),
      ),
    );
  }

}
