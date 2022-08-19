import 'package:flutter/material.dart';

import '../Contants/appcolors.dart';

class BackgroundGradientContainer extends StatelessWidget {
  const BackgroundGradientContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      height: deviceHeight,
      width: deviceWidth,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomRight,
          colors: [
            AppColors.PRIMARY_COLOR_LIGHT,
            AppColors.PRIMARY_COLOR,
            Colors.black
          ],
        ),
      ),
      child: child,
    );
  }
}
