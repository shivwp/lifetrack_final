import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:life_track/Contants/appcolors.dart';
import 'package:life_track/controller/contact_list_controller.dart';
import 'package:life_track/controller/get_friends_controller.dart';
import 'package:life_track/controller/group_list_controller.dart';
import 'package:life_track/models/contact_list_response.dart';
import 'package:life_track/repo/add_friend_repository.dart';
import 'package:life_track/repo/create_group_repository.dart';
import 'package:life_track/tab/friend_detail.dart';

import '../Contants/constant.dart';
import '../components/background_gradient_container.dart';

class AddGroup extends StatefulWidget {
  const AddGroup({Key? key}) : super(key: key);

  @override
  _AddGroupState createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  // final ContactListController contactListController  =Get.put(ContactListController());

  final GetFriendsController controller = Get.put(GetFriendsController());
  final GroupListController groupListController = Get.put(GroupListController());

  final TextEditingController groupName = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  // List<Contact>? contacts;
  // List<Contact> _searchResult = [];

  // bool _isChecked = true;
  List<String> userChecked = [];

  @override
  void initState() {
    super.initState();
    controller.getFriendsdata();
    // getContact();
  }

  // onSearchTextChanged(String text) async {
  //   _searchResult.clear();
  //   if (text.isEmpty) {
  //     setState(() {});
  //     return;
  //   }
  //
  //   contacts!.forEach((contact) {
  //     if (contact.name.first.toLowerCase().toString().contains(text))
  //       _searchResult.add(contact);
  //   });
  //
  //   setState(() {});
  // }
  // getContact() async {
  //   if (await FlutterContacts.requestPermission()) {
  //     contacts = await FlutterContacts.getContacts(
  //         withProperties: true, withPhoto: true);
  //     print(contacts);
  //     setState(() {});
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery
        .of(context)
        .size
        .height;
    double deviceWidth = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.PRIMARY_COLOR_LIGHT,
        title: const Text(
          'Add Groups',
          style: TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontFamily: fontFamilyName,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: BackgroundGradientContainer(
        child: SafeArea(
            minimum: EdgeInsets.only(top: 0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: groupName,
                    decoration: InputDecoration(
                      // prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Group name',
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      suffixIcon: IconButton(
                        onPressed: groupName.clear,
                        icon: const Icon(Icons.clear),
                      ),
                    ),
                    // onChanged: onSearchTextChanged,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: fontFamilyName,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'From Contacts',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontFamily: fontFamilyName,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Obx(() {
                    return controller.isDataLoading.value
                        ? ListView.separated(
                      shrinkWrap:true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: controller.model.value.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          minVerticalPadding: 16,
                          title: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                //backgroundImage: AssetImage('assets/images/defaultuser.png'),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(100)),
                                  child: Image.network(
                                    controller.model.value.data![index].userImage.toString(),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                radius: 30.0,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: Text(
                                  controller.model.value.data![index].firstName.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: fontFamilyName,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              // IconButton(
                              //   color: Colors.white,
                              //   icon: controller.model.value.data![index].reviewMassge=='Very Sad' ? FaIcon(FontAwesomeIcons.faceFrown)
                              //       : controller.model.value.data![index].reviewMassge=='Sad' ? FaIcon(FontAwesomeIcons.faceFrownOpen)
                              //       : controller.model.value.data![index].reviewMassge=='Ok' ? Icon(Icons.add_reaction_outlined)
                              //       : controller.model.value.data![index].reviewMassge=='Happy' ? FaIcon(FontAwesomeIcons.faceSmile)
                              //       : controller.model.value.data![index].reviewMassge=='Very happy'  ? FaIcon(FontAwesomeIcons.faceSmileBeam)
                              //       : Icon(Icons.add_reaction_outlined),
                              //   onPressed: () {
                              //     print('Emoji clicked');
                              //   },
                              // ),
                              // IconButton(
                              //   color: Colors.white,
                              //   icon: const Icon(Icons.navigate_next),
                              //   onPressed: () {
                              //     Navigator.push(
                              //       context, MaterialPageRoute(
                              //       builder: (context) => const FriendsDetail(),
                              //     ),
                              //     );
                              //   },
                              // )
                              // Checkbox(value: checkBoxValue,
                              //     activeColor: Colors.green,
                              //     onChanged:(bool newValue){
                              //       setState(() {
                              //         checkBoxValue = newValue;
                              //       });
                              //       Text('Remember me');
                              //     }),
                              controller.model.value.data![index].privacySetting.groupAccess==false
                                  ? Text('Private\nAccess',style: TextStyle(fontSize: 8,color: Colors.white),)
                                  : Checkbox(
                                  checkColor: AppColors.PRIMARY_COLOR,
                                  activeColor: Colors.white,
                                  hoverColor: Colors.white,
                                  side: BorderSide(
                                    color: Colors.white, //your desire colour here
                                    width: 1.5,
                                  ),
                                  value: userChecked.contains(controller.model.value.data![index].userId.toString()),
                                  onChanged: (newValue){
                                    _onSelected( newValue!, controller.model.value.data![index].userId.toString());
                                  })
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider(
                          height: 8,
                          thickness: 4,
                          color: AppColors.PRIMARY_COLOR,
                        );
                      },
                    )
                        : Center(child: CircularProgressIndicator());
                  }),
                ),

                Spacer(),
                GestureDetector(
                  onTap: (){
                    if(groupName.text.isEmpty){
                      Fluttertoast.showToast(
                          msg:'group name mandatory',
                          backgroundColor: AppColors.PRIMARY_COLOR);
                    }else{
                      EasyLoading.show();
                      createGroup(
                          groupName.text.toString(), '',
                          userChecked).then((value) {
                        if(value.status==true){
                          EasyLoading.dismiss();
                          groupListController.showGroupsData();
                          Fluttertoast.showToast(
                              msg:value.message!,
                              backgroundColor: AppColors.PRIMARY_COLOR);
                          Get.back();
                        }else if(value.status==false){
                          EasyLoading.dismiss();
                          Fluttertoast.showToast(
                              msg:value.message!,
                              backgroundColor: AppColors.PRIMARY_COLOR);
                        }
                        return null;
                      });
                    }
                  },
                  child: Container(
                    height: 47,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.90,
                    decoration: BoxDecoration(
                        color: AppColors.PRIMARY_COLOR,
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
                      child: Text(
                        'Create Group',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: fontFamilyName,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          letterSpacing: 0.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16,),
              ],
            )

        ),
      ),
    );
  }
  void _onSelected(bool selected, String dataName) {
    if (selected == true) {
      setState(() {
        userChecked.add(dataName);
        print(":::add:::"+userChecked.toString());
      });
    } else {
      setState(() {
        print(":::remove:::"+dataName.toString());
        userChecked.remove(dataName);
        print(":::add:::"+userChecked.toString());
      });
    }
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Example share',
        text: 'Example share text',
        linkUrl: 'https://flutter.dev/',
        chooserTitle: 'Example Chooser Title');
  }

}

/*class ListRowWidget extends StatelessWidget {
  const ListRowWidget( {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 16,
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            //backgroundImage: AssetImage('assets/images/defaultuser.png'),
            child: Image.asset(
              'assets/images/man.png',
              fit: BoxFit.contain,
              height: 40,
              width: 40,
            ),
            radius: 30.0,
          ),
          const SizedBox(
            width: 12,
          ),
          const Expanded(
            child: Text(
              'Friends Name',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: fontFamilyName,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Container(
            height: 47,
            width: 87,
            decoration: BoxDecoration(
                color: AppColors.PRIMARY_COLOR,
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
              child: GestureDetector(
                onTap: () {},
                child: const Text(
                  'Add',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: fontFamilyName,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    letterSpacing: 0.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}*/
