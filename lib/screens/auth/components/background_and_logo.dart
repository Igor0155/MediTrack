import 'package:flutter/material.dart';

Widget backgroundAndLogo({isMaxHeight = false}) {
  return Builder(builder: (context) {
    return Container(
      width: double.infinity,
      height: isMaxHeight ? double.infinity : 320,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: isMaxHeight
              ? null
              : const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Image(height: isMaxHeight ? 500 : 200, image: const AssetImage('images/medtrack_logo.png'))],
      ),
    );
  });
}
