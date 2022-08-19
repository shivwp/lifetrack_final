import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:life_track/Contants/appcolors.dart';
import 'package:life_track/Contants/constant.dart';
import 'package:life_track/components/background_gradient_container.dart';
import 'package:life_track/controller/notification_controller.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  final GetNotificationController notificationController = Get.put(
      GetNotificationController());


  @override
  void initState() {
    super.initState();
    notificationController.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.PRIMARY_COLOR_LIGHT,
        title: Image.asset(
          'assets/images/splash_logo.png',
          width: 159,
          height: 50,
        ),
        centerTitle: true,
      ),
      body: BackgroundGradientContainer(
        child: SafeArea(
          minimum: const EdgeInsets.only(top: 0),
          child: Obx(() {
            return notificationController.isDataLoading.value
                 ? notificationController.model.value.data!.length==0?Center(child: Text('No notification found',style: TextStyle(fontSize: 18,color: Colors.white),)):ListView.builder(
                shrinkWrap: true,
                itemCount: notificationController.model.value.data!.length,
                itemBuilder: (context, index) {
                  final DateFormat formatter = DateFormat('yyyy-MM-dd');
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              width: 65,
                              height: 70,
                              child: CircleAvatar(
                              child: Image.asset('assets/icon/app_icon.png'),
                              ),),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      notificationController.model.value.data![index].title.toString(),
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      notificationController.model.value.data![index].description.toString(),
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                  DateFormat.yMMMMd().format(DateTime.parse(notificationController.model.value.data![index].noticeDate.toString()))
                  ,
                                        style: TextStyle(
                                            fontSize: 11, color: Colors.white))
                                  ],
                                )),
                          ],
                        ),
                        Divider(
                          height: 19,
                          color: Colors.white,
                          thickness: 1,
                          indent: 15,
                          endIndent: 8,
                        )
                      ],
                    ),
                  );
                })
                : Center(child: CircularProgressIndicator());
          }),
        ),
      ),
    );
  }
}
