import 'package:barassage_app/config/app_colors.dart';
import 'package:flutter/material.dart';

class ServicesHelper {
  static double getFormattedPrice(dynamic price) {
    if (price is int) {
      return price.toDouble();
    }
    return price;
  }

  static Color getColorStatus(bool status) {
    return status ? Colors.green : AppColors.greyFair;
  }

  static String getTextStatus(bool status) {
    return status ? 'En ligne' : 'Inactive';
  }
}
