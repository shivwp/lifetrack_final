import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:life_track/models/pages_response.dart';
import 'package:life_track/repo/pages_repository.dart';

import '../Contants/appcolors.dart';
import '../Contants/constant.dart';
import '../components/background_gradient_container.dart';

class TermsConditions extends StatefulWidget {
  const TermsConditions({Key? key}) : super(key: key);

  @override
  _TermsConditionsState createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
  late Future<ModelPagesResponse> futureAlbum;


  @override
  void initState() {
    super.initState();
    futureAlbum = getPages('terms-conditions');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.PRIMARY_COLOR_LIGHT,
        title: const Text(
          'Terms & Conditions',
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
          minimum: const EdgeInsets.only(top: 0),
          child: FutureBuilder<ModelPagesResponse>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      children: [
                        Html(data: snapshot.data!.data!.title,style: {
                          "body": Style(
                              color: Colors.white
                            // fontSize: FontSize(18.0),
                            // fontWeight: FontWeight.bold,
                          ),
                        },),
                        Html(data: snapshot.data!.data!.description,style: {
                          "body": Style(
                              color: Colors.white
                            // fontSize: FontSize(18.0),
                            // fontWeight: FontWeight.bold,
                          ),
                        },),
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}

