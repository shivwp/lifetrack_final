import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:life_track/Contants/appcolors.dart';
import 'package:life_track/controller/contact_list_controller.dart';
import 'package:life_track/models/contact_list_response.dart';
import 'package:life_track/repo/add_friend_repository.dart';

import '../Contants/constant.dart';
import '../components/background_gradient_container.dart';

class AddFriend extends StatefulWidget {
  const AddFriend({Key? key}) : super(key: key);

  @override
  _AddFriendState createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  // final ContactListController contactListController  =Get.put(ContactListController());
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  List<Contact>? contacts;
  List<Contact> _searchResult = [];

  bool value = false;


  @override
  void initState() {
    super.initState();
    getContact();
  }
  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    contacts!.forEach((contact) {
      if (contact.name.first.toLowerCase().toString().contains(text))
        _searchResult.add(contact);
    });

    setState(() {});
  }


  getContact() async {
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      print(contacts);
      setState(() {});
    }
  }

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
          'Add Friends',
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
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Search',
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      suffixIcon: IconButton(
                        onPressed: _searchController.clear,
                        icon: const Icon(Icons.clear),
                      ),
                    ),
                    onChanged: onSearchTextChanged,
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
                Expanded(
                  child: (contacts) == null
                      ? Center(child: CircularProgressIndicator())
                      : _searchResult.length != 0 || _searchController.text.isNotEmpty
                      ? ListView.builder(
                    itemCount: _searchResult.length,
                    itemBuilder: (context, i) {
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
                              child: Text(
                                _searchResult[i].name.first ,
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
                                  onTap: () {
                                    print("COntact card:::::::==> "+_searchResult[i].name.first.toString() );
                                    print("COntact card:::::::==> "+_searchResult[i].phones[0].number.toString() );

                                    if (_searchResult[i].emails.isEmpty) {
                                      GlobalKey<FormState> _formKey = GlobalKey<FormState>();
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              contentPadding: EdgeInsets.zero,
                                              content: Stack(
                                                children: <Widget>[
                                                  Form(
                                                    key: _formKey,
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: <Widget>[
                                                        Container(
                                                          height: 60,
                                                          width: MediaQuery.of(context).size.width,
                                                          decoration: BoxDecoration(
                                                              color:Colors.white.withOpacity(0.2),
                                                              border: Border(
                                                                  bottom: BorderSide(color: Colors.grey.withOpacity(0.3))
                                                              )
                                                          ),
                                                          child: Center(child: Text("Enter email", style:TextStyle(color: Colors.black54, fontWeight: FontWeight.w700, fontSize: 20, fontStyle: FontStyle.italic, fontFamily: "Helvetica"))),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.all(16.0),
                                                          child: Container(
                                                              height: 50,
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(color: Colors.grey.withOpacity(0.2) )
                                                              ),
                                                              child: Row(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Expanded(
                                                                    flex:1,
                                                                    child: Container(
                                                                      width: 30,
                                                                      child: Center(child: Icon(Icons.email_outlined, size: 30,color:Colors.grey.withOpacity(0.4))),
                                                                      decoration: BoxDecoration(
                                                                          border: Border(
                                                                              right: BorderSide(color: Colors.grey.withOpacity(0.2))
                                                                          )
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 4,
                                                                    child: TextFormField(
                                                                      controller: emailController,
                                                                      decoration: InputDecoration(
                                                                          hintText: "E-mail",
                                                                          contentPadding: EdgeInsets.only(left:20),
                                                                          border: InputBorder.none,
                                                                          focusedBorder: InputBorder.none,
                                                                          errorBorder: InputBorder.none,
                                                                          hintStyle: TextStyle(color:Colors.black26, fontSize: 18, fontWeight: FontWeight.w500 )
                                                                      ),

                                                                    ),
                                                                  )
                                                                ],
                                                              )
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.all(20.0),
                                                          child: GestureDetector(
                                                            child: Container(
                                                              width:MediaQuery.of(context).size.width,
                                                              height: 55,
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
                                                              child: Center(child: Text("Submit", style: TextStyle(color:Colors.white70, fontSize: 20, fontWeight: FontWeight.w800),)),
                                                            ),
                                                            onTap: () {
                                                              if (_formKey.currentState!.validate()) {
                                                                addFriends(emailController.text).then((value) {

                                                                  Fluttertoast.showToast(msg: value.message, backgroundColor: AppColors.PRIMARY_COLOR);
                                                                  if(value.status==false){
                                                                    share();

                                                                  }
                                                                  return null;
                                                                });
                                                                // _formKey.currentState.save();
                                                              }
                                                            },
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                    } else {
                                      addFriends(_searchResult[i].emails[0].address).then((value) {
                                        Fluttertoast.showToast(
                                            msg: value.message,
                                            backgroundColor: AppColors.PRIMARY_COLOR);
                                        return null;
                                      });
                                    }
                                  },
                                  child: Text(
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
                    },
                  )
                      : ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: contacts!.length,
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
                              child: Text(
                                "${contacts![index].name.first}",
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
                            GestureDetector(
                              onTap: (){
                                print("COntact card:::::::==>${contacts![index].name.first} ");
                                print("COntact card:::::::==>${contacts![index].phones[0].number} ");

                                if (contacts![index].emails.isEmpty) {
                                  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          contentPadding: EdgeInsets.zero,
                                          content: Stack(
                                            children: <Widget>[
                                              Form(
                                                key: _formKey,
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                    Container(
                                                      height: 60,
                                                      width: MediaQuery.of(context).size.width,
                                                      decoration: BoxDecoration(
                                                          color:Colors.white.withOpacity(0.2),
                                                          border: Border(
                                                              bottom: BorderSide(color: Colors.grey.withOpacity(0.3))
                                                          )
                                                      ),
                                                      child: Center(child: Text("Enter email", style:TextStyle(color: Colors.black54, fontWeight: FontWeight.w700, fontSize: 20, fontStyle: FontStyle.italic, fontFamily: "Helvetica"))),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.all(16.0),
                                                      child: Container(
                                                          height: 50,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(color: Colors.grey.withOpacity(0.2) )
                                                          ),
                                                          child: Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Expanded(
                                                                flex:1,
                                                                child: Container(
                                                                  width: 30,
                                                                  child: Center(child: Icon(Icons.email_outlined, size: 30,color:Colors.grey.withOpacity(0.4))),
                                                                  decoration: BoxDecoration(
                                                                      border: Border(
                                                                          right: BorderSide(color: Colors.grey.withOpacity(0.2))
                                                                      )
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 4,
                                                                child: TextFormField(
                                                                  controller: emailController,
                                                                  decoration: InputDecoration(
                                                                      hintText: "E-mail",
                                                                      contentPadding: EdgeInsets.only(left:20),
                                                                      border: InputBorder.none,
                                                                      focusedBorder: InputBorder.none,
                                                                      errorBorder: InputBorder.none,
                                                                      hintStyle: TextStyle(color:Colors.black26, fontSize: 18, fontWeight: FontWeight.w500 )
                                                                  ),

                                                                ),
                                                              )
                                                            ],
                                                          )
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(20.0),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          if (_formKey.currentState!.validate()) {

                                                            addFriends(emailController.text).then((value) {
                                                              Fluttertoast.showToast(
                                                                  msg: value.message,
                                                                  backgroundColor: AppColors.PRIMARY_COLOR);

                                                              if(value.status==true) {
                                                                Get.back();
                                                                Fluttertoast.showToast(
                                                                    msg: value.message,
                                                                    backgroundColor: AppColors.PRIMARY_COLOR);
                                                              } else if(value.status==false){
                                                                Get.back();
                                                                print(" not work");
                                                                share();
                                                                // Fluttertoast.showToast(
                                                                //     msg: value
                                                                //         .message,
                                                                //     backgroundColor: AppColors
                                                                //         .PRIMARY_COLOR);
                                                              }
                                                              return null;
                                                            });
                                                          }
                                                        },
                                                        child: Container(
                                                          width:MediaQuery.of(context).size.width,
                                                          height: 55,
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
                                                          child: Center(child: Text("Submit", style: TextStyle(color:Colors.white70, fontSize: 20, fontWeight: FontWeight.w800),)),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                } else {
                                  addFriends(contacts![index].emails[0].address).then((value) {
                                    Fluttertoast.showToast(
                                        msg: value.message,
                                        backgroundColor: AppColors.PRIMARY_COLOR);
                                    return null;
                                  });
                                }
                              },
                              child: Container(
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
                                  child: Text(
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
                     
                    },
                  ),
                ),
              ],
            )

        ),
      ),
    );
  }
  Future<void> share() async {
    await FlutterShare.share(
        title: 'Example share',
        text: 'Example share text',
        linkUrl: 'https://www.google.com/search?gs_ssp=eJzj4tVP1zc0TDPIMcqwqMowYLRSNagwtjRLSTJOMkk2Tk4DASuDimTDRONEC8ski0QzE4OkZEsv0dT8ispihcwSheL8nNKSzPw8hZycAgB4zxhd&q=eoxys+it+solution+llp&oq=eoxys&aqs=chrome.1.69i57j46i39i175i199j46i175i199i512j0i10i512j0i512j69i60l3.2579j0j7&sourceid=chrome&ie=UTF-8',
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
