import 'package:barassage_app/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ServicesHelper {
  static String getFormattedPrice(dynamic price) {
    final formatCurrency = NumberFormat('#,##0', 'en_US');
    int _price = 0;
    if (price is int) {
      _price = price;
    } else if (price is double) {
      _price = price.toInt();
    } else if (price is String) {
      _price = int.parse(price);
    }
    String formattedPrice = formatCurrency.format(_price);
    return formattedPrice;
  }

  static Color getColorStatus(bool status) {
    return status ? Colors.green : AppColors.greyFair;
  }

  static String getTextStatus(bool status) {
    return status ? 'En ligne' : 'Inactive';
  }
}
