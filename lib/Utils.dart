


import 'package:fluttertoast/fluttertoast.dart';

import 'Contants/appcolors.dart';

void showToast(message){
  Fluttertoast.showToast(
      msg: message ?? 'Something went wrong!',
      backgroundColor: AppColors.PRIMARY_COLOR_LIGHT);
}