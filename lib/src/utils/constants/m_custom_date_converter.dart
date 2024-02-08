
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyDateConverter {

  static String dateToDateTime(DateTime dateTime) {
    return DateFormat('dd MMMM yyyy').format(dateTime);
  }

  static String dateForApiCall(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  static String dayMonthYearConvert(String dateTime) {
    DateTime date = DateFormat("yyyy-MM-dd", "en_US").parse(dateTime);
    return DateFormat("dd MMMM yyyy").format(date);
  }


  static DateTime convertStringToDate(String dateTime) {
    return DateFormat("yyyy-MM-dd").parse(dateTime);
  }

  static String infoLiveDateTime(DateTime dateTime) {
    //  var isoTime = dateTime.toUtc().toIso8601String();
    // // infoLiveTime(isoTime);
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  static String getChatListDateTime(String date) {
    var localDate = DateTime.parse(date).toLocal();
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    var inputDate = inputFormat.parse(localDate.toString());

    /// outputFormat - convert into format you want to show.
    var outputFormat = DateFormat('hh:mm a');
    var outputDate = outputFormat.format(inputDate);
    return outputDate.toString();
  }

  static String? convertViews(String currentBalance) {
    try {
      int value = int.parse(currentBalance);
      if (value > 999 && value < 1000000) {
        return '${(value / 1000).toStringAsFixed(1)}k';
      } else if (value > 1000000) {
        return '${(value / 1000000).toStringAsFixed(1)}M';
      } else{
        return value.toString();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return '';
  }


  static String formatMinutesAndSeconds(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    String formattedTime = '$minutes:${seconds.toString().padLeft(2, '0')}';
    return formattedTime;
  }


  static int calculateAge(String birthDate) {
    DateTime today = DateTime.now();
    DateTime birthday = DateFormat('yyyy-MM-dd').parse(birthDate);
    int age = today.year - birthday.year;

    // Check if the birthday has occurred this year
    if (today.month < birthday.month || (today.month == birthday.month && today.day < birthday.day)) {
      age--;
    }
    return age;
  }



  static String getTimeConvertWithText(String date) {
    // DateTime tempDate = DateFormat("yyyy-MM-dd HH:mm").parse(dateTime);
    var localDate = DateTime.parse(date).toLocal();
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    var inputDate = inputFormat.parse(localDate.toString());
    Duration difference = DateTime.now().difference(inputDate);
    if (difference.inMinutes < 1) {
      return "Just now";
    } else if (difference.inHours < 1) {
      return "${difference.inMinutes}m ago";
    } else if (difference.inHours < 24) {
      if ((difference.inHours).round() > 1) {
        return "${(difference.inHours).round()}h ago";
      } else {
        return "${(difference.inHours).round()}h ago";
      }
    } else if (difference.inDays < 30) {
      if ((difference.inDays).round() > 1) {
        return "${(difference.inDays).round()}d ago";
      } else {
        return "${(difference.inDays).round()}d ago";
      }
    } else if (difference.inDays >= 30 && difference.inDays <= 365) {
      if ((difference.inDays / 30).round() > 1) {
        return "${(difference.inDays / 30).round()}mon ago";
      } else {
        return "${(difference.inDays / 30).round()}mon ago";
      }
    } else {
      if ((difference.inDays / 365).round() > 1) {
        return "${(difference.inDays / 365).round()}y ago";
      } else {
        return "${(difference.inDays / 365).round()}y ago";
      }
    }
  }

}
