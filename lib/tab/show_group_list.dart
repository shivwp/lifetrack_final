import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_track/Contants/appcolors.dart';
import 'package:life_track/Contants/constant.dart';
import 'package:life_track/components/background_gradient_container.dart';
import 'package:life_track/controller/group_list_controller.dart';
import 'package:life_track/tab/single_group_details.dart';

class GroupsList extends StatefulWidget {
  const GroupsList({Key? key}) : super(key: key);

  @override
  State<GroupsList> createState() => _GroupsListState();
}

class _GroupsListState extends State<GroupsList> {
  final GroupListController controller = Get.put(GroupListController());


  @override
  void initState() {
    super.initState();
    controller.showGroupsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundGradientContainer(
        child: Obx(() {
          return controller.isDataLoading.value
              ?  controller.model.value.data!.isEmpty ? Center(child: Text('No groups found', style: TextStyle(color: Colors.white),)) : ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: controller.model.value.data!.length,
            itemBuilder: (context, index) {
              // Uint8List? image = contacts![index].photo;
              // String num = (contacts![index].phones.isNotEmpty) ? (contacts![index].phones.first.number) : "--";
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.model.value.data![index].groupname.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: fontFamilyName,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          // Text(
                          //   controller.model.value.data![index].descrption.toString(),
                          //   style: TextStyle(
                          //     color: Colors.white,
                          //     fontSize: 16,
                          //     fontFamily: fontFamilyName,
                          //     fontWeight: FontWeight.w400,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    // Checkbox(
                    //   value: value,
                    //   onChanged: (bool? newValue) {
                    //     setState(() {
                    //       value = newValue!;
                    //     });
                    //   },
                    // ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          var groupId = controller.model.value.data![index].id.toString();
                          Get.to(SingleGroupDetail(),arguments: [groupId]);

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => const SingleGroupDetail()),
                          // );


                          // print("COntact card:::::::==>${contacts![index].name.first} ");
                          // print("COntact card:::::::==>${contacts![index].phones[0].number} ");

                          // if (contacts![index].emails.isEmpty) {
                          //   GlobalKey<FormState> _formKey = GlobalKey<FormState>();
                          //   showDialog(
                          //       context: context,
                          //       builder: (BuildContext context) {
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
                          //                       width: MediaQuery.of(context).size.width,
                          //                       decoration: BoxDecoration(
                          //                           color:Colors.white.withOpacity(0.2),
                          //                           border: Border(
                          //                               bottom: BorderSide(color: Colors.grey.withOpacity(0.3))
                          //                           )
                          //                       ),
                          //                       child: Center(child: Text("Enter email", style:TextStyle(color: Colors.black54, fontWeight: FontWeight.w700, fontSize: 20, fontStyle: FontStyle.italic, fontFamily: "Helvetica"))),
                          //                     ),
                          //                     Padding(
                          //                       padding: EdgeInsets.all(16.0),
                          //                       child: Container(
                          //                           height: 50,
                          //                           decoration: BoxDecoration(
                          //                               border: Border.all(color: Colors.grey.withOpacity(0.2) )
                          //                           ),
                          //                           child: Row(
                          //                             crossAxisAlignment: CrossAxisAlignment.start,
                          //                             children: [
                          //                               Expanded(
                          //                                 flex:1,
                          //                                 child: Container(
                          //                                   width: 30,
                          //                                   child: Center(child: Icon(Icons.email_outlined, size: 30,color:Colors.grey.withOpacity(0.4))),
                          //                                   decoration: BoxDecoration(
                          //                                       border: Border(
                          //                                           right: BorderSide(color: Colors.grey.withOpacity(0.2))
                          //                                       )
                          //                                   ),
                          //                                 ),
                          //                               ),
                          //                               Expanded(
                          //                                 flex: 4,
                          //                                 child: TextFormField(
                          //                                   controller: emailController,
                          //                                   decoration: InputDecoration(
                          //                                       hintText: "E-mail",
                          //                                       contentPadding: EdgeInsets.only(left:20),
                          //                                       border: InputBorder.none,
                          //                                       focusedBorder: InputBorder.none,
                          //                                       errorBorder: InputBorder.none,
                          //                                       hintStyle: TextStyle(color:Colors.black26, fontSize: 18, fontWeight: FontWeight.w500 )
                          //                                   ),
                          //
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
                          //                           width:MediaQuery.of(context).size.width,
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
                          //                           child: Center(child: Text("Submit", style: TextStyle(color:Colors.white70, fontSize: 20, fontWeight: FontWeight.w800),)),
                          //                         ),
                          //                         onTap: () {
                          //                           if (_formKey.currentState!.validate()) {
                          //                             addFriends(emailController.text).then((value) {
                          //
                          //                               Fluttertoast.showToast(msg: value.message, backgroundColor: AppColors.PRIMARY_COLOR);
                          //                               if(value.status==false){
                          //                                 share();
                          //
                          //                               }
                          //                               return null;
                          //                             });
                          //                             // _formKey.currentState.save();
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
                          // } else {
                          //   addFriends(contacts![index].emails[0].address).then((value) {
                          //     Fluttertoast.showToast(
                          //         msg: value.message,
                          //         backgroundColor: AppColors.PRIMARY_COLOR);
                          //     return null;
                          //   });
                          // }
                        },
                        child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.white,),
                      ),
                    ),
                  ],
                ),
              );
            },
          )
              : Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }
}
