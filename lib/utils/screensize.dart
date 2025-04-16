import 'package:flutter/material.dart';

double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getTextBoxWidth(BuildContext context) {
  return getScreenWidth(context) / 4;
}

double getRowHeight(BuildContext context) {
  return MediaQuery.of(context).size.height / 8;
}

double getTextBoxHeight(BuildContext context) {
  return getRowHeight(context) / 2;
}
