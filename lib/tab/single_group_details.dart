import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:life_track/Contants/appcolors.dart';
import 'package:life_track/Contants/constant.dart';
import 'package:life_track/components/background_gradient_container.dart';
import 'package:life_track/controller/group_list_controller.dart';
import 'package:life_track/controller/single_group_controller.dart';
import 'package:life_track/repo/create_group_repository.dart';
import 'package:life_track/repo/delete_group_repository.dart';
import 'package:life_track/repo/remove_group_member_repository.dart';
import 'package:life_track/tab/add_member_group.dart';

class SingleGroupDetail extends StatefulWidget {
  const SingleGroupDetail({Key? key}) : super(key: key);

  @override
  State<SingleGroupDetail> createState() => _SingleGroupDetailState();
}

class _SingleGroupDetailState extends State<SingleGroupDetail> {

  final SingleGroupController controller = Get.put(SingleGroupController());

  final GroupListController groupListController = Get.put(GroupListController());


  final TextEditingController groupName = TextEditingController();
  var groupId;
  var userId;
  List<String> userChecked = [];

  void handleClick(String value) {
    switch (value) {
      // case 'Edit Group':
      //   buildEditPopupDialog(context);
      //   break;
      case 'Delete group':
        EasyLoading.show();
        deleteGroup(groupId).then((value) {
          if(value.status==true){
            Fluttertoast.showToast(
                msg:value.message!,
                backgroundColor: AppColors.PRIMARY_COLOR);
            groupListController.showGroupsData();
            EasyLoading.dismiss();
            Get.back();
          }else if(value.status==false){
            EasyLoading.dismiss();
            Fluttertoast.showToast(
                msg:value.message,
                backgroundColor: AppColors.PRIMARY_COLOR);
          }
          return null;
        });
        break;
      case 'Add member':
        _moveToAddMemberIngroupScreen(context);
        break;
    }
  }

  void handleClickMember(String value) {
    switch (value) {
      case 'Delete member':
        EasyLoading.show();
        removeGroupeMember(groupId, userId).then((value) {
          if(value.status==true){
            EasyLoading.dismiss();
            Fluttertoast.showToast(
                msg:value.message,
                backgroundColor: AppColors.PRIMARY_COLOR);
            controller.getData();

          }else if(value.status==false){
            EasyLoading.dismiss();
            Fluttertoast.showToast(
                msg:value.message,
                backgroundColor: AppColors.PRIMARY_COLOR);
          }
          return null;
        });
        break;
    }
  }

  void _moveToAddMemberIngroupScreen(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMemberGroup(groupId),
      ),
    );
  }

  // buildEditPopupDialog(BuildContext context) {
  //   return showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //         return AlertDialog(
  //           contentPadding: EdgeInsets.zero,
  //           content: Stack(
  //             children: <Widget>[
  //               Form(
  //                 key: _formKey,
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: <Widget>[
  //                     Container(
  //                       height: 60,
  //                       width: MediaQuery
  //                           .of(context)
  //                           .size
  //                           .width,
  //                       decoration: BoxDecoration(
  //                           color: Colors.white.withOpacity(0.2),
  //                           border: Border(
  //                               bottom: BorderSide(
  //                                   color: Colors.grey.withOpacity(0.3))
  //                           )
  //                       ),
  //                       child: Center(
  //                           child: Text("Edit Group Name", style: TextStyle(
  //                               color: Colors.black54,
  //                               fontWeight: FontWeight.w700,
  //                               fontSize: 20,
  //                               fontStyle: FontStyle.italic,
  //                               fontFamily: "Helvetica"))),
  //                     ),
  //                     Padding(
  //                       padding: EdgeInsets.all(16.0),
  //                       child: Container(
  //                           height: 50,
  //                           decoration: BoxDecoration(
  //                               border: Border.all(
  //                                   color: Colors.grey.withOpacity(0.2))
  //                           ),
  //                           child: Row(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Expanded(
  //                                 flex: 4,
  //                                 child: TextField(
  //                                   controller: groupName,
  //                                   decoration: InputDecoration(
  //                                     // prefixIcon: const Icon(Icons.search),
  //                                     filled: true,
  //                                     fillColor: Colors.white,
  //                                     border: OutlineInputBorder(
  //                                       borderRadius: BorderRadius.circular(10),
  //                                       borderSide: BorderSide.none,
  //                                     ),
  //                                     hintText: 'Group name',
  //                                     floatingLabelAlignment: FloatingLabelAlignment
  //                                         .start,
  //                                     suffixIcon: IconButton(
  //                                       // onPressed: groupName.clear,
  //                                       onPressed: () {},
  //                                       icon: const Icon(Icons.clear),
  //                                     ),
  //                                   ),
  //                                   // onChanged: onSearchTextChanged,
  //                                   style: const TextStyle(
  //                                     color: Colors.black,
  //                                     fontSize: 16,
  //                                     fontFamily: fontFamilyName,
  //                                     fontWeight: FontWeight.normal,
  //                                   ),
  //                                 ),
  //                               )
  //                             ],
  //                           )
  //                       ),
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.all(20.0),
  //                       child: GestureDetector(
  //                         child: Container(
  //                           width: MediaQuery
  //                               .of(context)
  //                               .size
  //                               .width,
  //                           height: 55,
  //                           decoration: BoxDecoration(
  //                               color: AppColors.PRIMARY_COLOR,
  //                               borderRadius: const BorderRadius.all(
  //                                 Radius.circular(25.0),
  //                               ),
  //                               boxShadow: [
  //                                 BoxShadow(
  //                                   color: Colors.black.withOpacity(0.2),
  //                                   spreadRadius: 4,
  //                                   blurRadius: 10,
  //                                   offset: const Offset(0, 3),
  //                                 )
  //                               ]),
  //                           child: Center(child: Text("Submit",
  //                             style: TextStyle(color: Colors.white70,
  //                                 fontSize: 20,
  //                                 fontWeight: FontWeight.w800),)),
  //                         ),
  //                         onTap: () {
  //                           if (groupName.text.isEmpty) {
  //                             Fluttertoast.showToast(
  //                                 msg: 'group name mandatory to edit',
  //                                 backgroundColor: AppColors.PRIMARY_COLOR);
  //                           } else {
  //                             editGroup(
  //                                 groupName.text.toString(), 'groupId', '',
  //                                 userChecked).then((value) {
  //                               if (value.status == true) {
  //                                 Fluttertoast.showToast(
  //                                     msg: value.message!,
  //                                     backgroundColor: AppColors.PRIMARY_COLOR);
  //                               } else if (value.status == false) {
  //                                 Fluttertoast.showToast(
  //                                     msg: value.message!,
  //                                     backgroundColor: AppColors.PRIMARY_COLOR);
  //                               }
  //                               return null;
  //                             });
  //                           }
  //                         },
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    return BackgroundGradientContainer(
      child: Obx(() {
        if(controller.isDataLoading.value){
          groupId = controller.model.value.data!.id.toString();
        }
        return controller.isDataLoading.value
            ? Scaffold(
          appBar: AppBar(
            elevation: 1,
            automaticallyImplyLeading: true,
            backgroundColor: AppColors.PRIMARY_COLOR_LIGHT,
            title: Text(
              controller.model.value.data!.groupname.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontFamily: fontFamilyName,
                fontWeight: FontWeight.w500,
              ),
            ),
            actions: <Widget>[
              PopupMenuButton<String>(
                onSelected: handleClick,
                itemBuilder: (BuildContext context) {
                  return {'Delete group', 'Add member'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ],
            centerTitle: true,
          ),
          body: BackgroundGradientContainer(
            child: SafeArea(
              minimum: const EdgeInsets.only(top: 0),
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                itemCount: controller.model.value.data!.memberData.length,
                itemBuilder: (context, index) {
                  userId = controller.model.value.data!.memberData[index].userId.toString();
                  return controller.model.value.data!.memberData.length==0 ? Text('No member Found'):ListTile(
                    minVerticalPadding: 16,
                    title: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          //backgroundImage: AssetImage('assets/images/defaultuser.png'),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(100)),
                            child: Image.network(
                              controller.model.value.data!.memberData[index].userImage.toString(),
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
                            controller.model.value.data!.memberData[index].firstName.toString(),
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
                        controller.model.value.data!.createBy.toString()==controller.model.value.data!.memberData[index].userId.toString()
                            ? SizedBox.shrink()
                            : PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert, color: Colors.white,),
                          onSelected: handleClickMember,
                          itemBuilder: (BuildContext context) {
                            return {'Delete member'}.map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Text(choice),
                              );
                            }).toList();
                          },
                        ),
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
              ),
            ),
          ),
        )
            : Center(child: CircularProgressIndicator());
      }),
    );
  }
}
