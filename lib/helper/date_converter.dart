
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateConverter {
  static String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm:ss').format(dateTime);
  }

  static String estimatedDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  static DateTime convertStringToDatetime(String dateTime) {
    return DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").parse(dateTime);
  }

  static DateTime isoStringToLocalDate(String dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').parseUtc(dateTime);
  }

  static String isoStringToLocalTime(String dateTime) {
    debugPrint("***** datetime $dateTime");
    return DateFormat('hh:mm a').format(DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').parseUtc(dateTime).toLocal());
  }

  static String isoStringToLocalTimeOnly(String dateTime) {
    debugPrint("***** datetime $dateTime");
    return DateFormat('hh:mm a').format(isoStringToLocalDate(dateTime));
  }

  static String convertGlobalTimeToLocal(String globalTime){
    //Parse the global time to Datetime object
    DateTime globalDateTime = DateTime.parse(globalTime);

    //Convert it to local timezone
    DateTime localDateTime = globalDateTime.toUtc();

    // Create the format as my requirement
    final format = DateFormat('hh:mm a');

    String localTime = format.format(localDateTime);

    return localTime;
  }

  /// Chat
  static DateTime isoChatToLocalDate(String dateTime) {
    return DateTime.parse(dateTime);
  }

  static String isoChatToLocalTimeOnly(String timeStamp) {
    // Parse the date string into a DateTime object
    DateTime dateTime = DateTime.parse(timeStamp);

    // Extract date and time components
    String formattedDate = "${dateTime.year}-${dateTime.month.toString()
        .padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    String formattedTime = "${dateTime.hour.toString().padLeft(
        2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second
        .toString().padLeft(2, '0')}.${dateTime.microsecond.toString().padLeft(
        6, '0')}";

    return DateFormat('hh:mm a', 'en_US').format(DateFormat('HH:mm:ss.SSS').parse(formattedTime));
  }


  static String isoStringToLocalAMPM(String dateTime) {
    return DateFormat('a').format(isoStringToLocalDate(dateTime));
  }


  static String localDateTime(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy').format(dateTime.toUtc());
  }

  static String dateToDateTime(DateTime dateTime) {
    return DateFormat('dd MMMM yyyy').format(dateTime);
  }

  static String isoStringLocalDateOnly(String dateTime) {
    return DateFormat('dd MMM yyyy').format(isoStringToLocalDate(dateTime));
  }

  static String visitorDate(String date) {
    return DateFormat('dd MMM yy').format(DateTime.parse(date));
  }

  static String infoLiveDateTime(DateTime dateTime) {
    var isoTime = dateTime.toUtc().toIso8601String();
    infoLiveTime(isoTime);
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  // static String infoLiveDateTime(DateTime dateTime) {
  //   var isoTime = dateTime.toUtc().toIso8601String();
  //   infoLiveTime(isoTime);
  //   return  dateTime.toUtc().toIso8601String();
  //
  // }

  static String infoLiveTime(String isoDate) {
    // final moonLanding = DateTime.utc(dateTime.millisecond, 02, 20, 20, 18, 04);
    // final isoDate = moonLanding.toIso8601String();
    print("object-> ${isoDate.toString()}"); // 1969-07-20T20:18:04.000Z

    // String isoTime = '2023-04-11T10:30:00Z'; // ISO time in UTC

    // Create a DateTime object from the ISO time
    DateTime dateTime = DateTime.parse(isoDate);

    // Convert the DateTime object to local time
    DateTime localTime = dateTime.toLocal();

    // Format the local time as a string
    String formattedLocalTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(
        localTime);

    print('ISO time: $isoDate');
    print('Local time: $formattedLocalTime');
    return formattedLocalTime;
  }

  static String convertIsoTimeToLocalDateTime(String isoTime) {
    // Create a DateTime object from the ISO time
    DateTime dateTime = DateTime.parse(isoTime);

    // Convert the DateTime object to local time
    DateTime localTime = dateTime.toLocal();

    // Format the local time as a string
    String formattedLocalTime = DateFormat('yyyy-MM-dd hh:mm a').format(
        localTime);

    print('ISO time: $isoTime');
    print('Local time: $formattedLocalTime');
    return formattedLocalTime;
  }


  /// for subscription
  static String convertSubscriptionDate(String isoTime) {
    DateTime dateTime = DateTime.parse(isoTime);
    DateTime localTime = dateTime.toLocal();
    String formattedLocalTime = DateFormat('MMM dd, yyyy, hh:mm a').format(
        localTime);
    return formattedLocalTime;
  }

  static DateTime convertStringToDate(String dateTime) {
    return DateFormat("yyyy-MM-dd").parse(dateTime);
  }

  /// for transaction
  static DateTime convertStringToDateTime(String dateTime) {
    return DateFormat("dd MMM yyyy").parse(dateTime);
  }

  static String isoStringToLocalDateOnly(String dateTime) {
    return DateFormat('dd MMM yyyy').format(isoStringToLocalDate(dateTime));
  }

  static int getDayToRecoverLeft(String timeStr) {
    DateTime currentDateTime = DateTime.now().subtract(
        const Duration(days: 30));
    DateTime specificDate = DateFormat('dd MMM yyyy').parse(
        isoStringToLocalDateOnly(timeStr));
    Duration difference = currentDateTime.difference(specificDate);
    int days = difference.inDays.abs();
    return days;
  }

  static int getUserNameUpdateTime(String timeStr) {
    DateTime currentDateTime = DateTime.now().subtract(const Duration(days: 31));
    DateTime specificDate = DateFormat('yyyy-MM-dd').parse(timeStr);
    Duration difference = currentDateTime.difference(specificDate);
    int days = difference.inDays.abs();
    return days;
  }

  /// for donation
  static String isoStringToDateDonation(String dateTime) {
    return DateFormat('dd MMM yy').format(isoStringToLocalDate(dateTime));
  }

  static String localDateToIsoString(DateTime dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(dateTime.toUtc());
  }


  static int getDifference(String timeStr) {
    final now = DateTime.now();
    final time = DateFormat('h:mm a').parse(timeStr);

    DateTime givenTime = DateTime(
        now.year, now.month, now.day, now.hour * 60 + now.minute);

    final timeInMinutes = time.hour * 60 + time.minute;
    final nowInMinutes = givenTime.hour * 60 + givenTime.minute;

    return timeInMinutes - nowInMinutes;
  }

  static int getDayLeft(String timeStr) {
    DateTime currentDateTime = DateTime.now();
    DateTime specificDate = DateFormat('yyyy-MM-dd').parse(timeStr);
    Duration difference = currentDateTime.difference(specificDate);
    int days = difference.inDays;
    return days;
  }


  static int getTimeDifference(String timeStr) {
    DateFormat inputFormat = DateFormat("HH:mm dd-MM-yyyy");
    DateTime inputDateTime = inputFormat.parse(timeStr);
    DateTime now = DateTime.now();
    Duration difference = now.difference(inputDateTime);

    debugPrint("***** ${difference.inMinutes}");
    return difference.inMinutes;
  }


  static String convertInfoLive(String time) {
    return DateFormat('MMM dd').format(DateFormat('yyyy-MM-dd').parse(time));
  }

  static String convertInfoLiveTime(String time) {
    return DateFormat.jm().format(DateFormat("hh:mm:ss").parse(time));
  }

  static String getChatFormatDate(String date) {
    var localDate = DateTime.parse(date).toLocal();
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    var inputDate = inputFormat.parse(localDate.toString());

    /// outputFormat - convert into format you want to show.
    var outputFormat = DateFormat('hh:mma');
    var outputDate = outputFormat.format(inputDate).toLowerCase();
    return outputDate.toString();
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


  static String getTimeDifferenceFromNow(String date) {
    var localDate = DateTime.parse(date).toLocal();
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    var inputDate = inputFormat.parse(localDate.toString());
    Duration difference = DateTime.now().difference(inputDate);
    if (difference.inMinutes < 1) {
      return "Just now";
    } else if (difference.inHours < 1) {
      return "${difference.inMinutes}m";
    } else if (difference.inHours < 24) {
      if ((difference.inHours).round() > 1) {
        return "${(difference.inHours).round()}h";
      } else {
        return "${(difference.inHours).round()}h";
      }
    } else if (difference.inDays < 30) {
      if ((difference.inDays).round() <= 1) {
        return "${(difference.inDays).round()}d";
      } else {
        return DateFormat('dd MMM').format(
            DateFormat('yyyy-MM-dd').parse(date).toLocal());
      }
    } else {
      return DateFormat('dd MMM').format(
          DateFormat('yyyy-MM-dd').parse(date).toLocal());
    }
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

  static String getTimeDifferenceNow(String date) {
    var localDate = DateTime.parse(date).toLocal();
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    var inputDate = inputFormat.parse(localDate.toString());
    final fiftyDaysAgo = inputDate.subtract(const Duration(hours: -6));
    Duration difference = DateTime.now().difference(fiftyDaysAgo);
    if (difference.inMinutes < 1) {
      return "Just now";
    } else if (difference.inHours < 1) {
      return "${difference.inMinutes}m";
    } else if (difference.inHours < 24) {
      if ((difference.inHours).round() > 1) {
        return "${(difference.inHours).round()}h";
      } else {
        return "${(difference.inHours).round()}h";
      }
    } else if (difference.inDays < 30) {
      if ((difference.inDays).round() > 1) {
        return "${(difference.inDays).round()}d";
      } else {
        return "${(difference.inDays).round()}d";
      }
    } else if (difference.inDays >= 30 && difference.inDays <= 365) {
      if ((difference.inDays / 30).round() > 1) {
        return "${(difference.inDays / 30).round()}mon";
      } else {
        return "${(difference.inDays / 30).round()}mon";
      }
    } else {
      if ((difference.inDays / 365).round() > 1) {
        return "${(difference.inDays / 365).round()}y";
      } else {
        return "${(difference.inDays / 365).round()}y";
      }
    }
  }


  static int howMuchTime(String date) {
    var localDate = DateTime.parse(date).toLocal();
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    var inputDate = inputFormat.parse(localDate.toString());
    final fiftyDaysAgo = inputDate.subtract(const Duration(hours: -6));
    Duration difference = DateTime.now().difference(fiftyDaysAgo);
    return (difference.inDays).round();
  }

  /// for comment
  static String getTimeForComments(String date) {
    // DateTime tempDate = DateFormat("yyyy-MM-dd HH:mm").parse(dateTime);
    var localDate = DateTime.parse(date).toLocal();
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    var inputDate = inputFormat.parse(localDate.toString());
    Duration difference = DateTime.now().difference(inputDate);
    if (difference.inMinutes < 1) {
      return "Just now";
    } else if (difference.inHours < 1) {
      return "${difference.inMinutes} m";
    } else if (difference.inHours < 24) {
      if ((difference.inHours).round() > 1) {
        return "${(difference.inHours).round()} h";
      } else {
        return "${(difference.inHours).round()} h";
      }
    } else if (difference.inDays < 30) {
      if ((difference.inDays).round() > 1) {
        return "${(difference.inDays).round()} d";
      } else {
        return "${(difference.inDays).round()} d";
      }
    } else if (difference.inDays >= 30 && difference.inDays <= 365) {
      if ((difference.inDays / 30).round() > 1) {
        return "${(difference.inDays / 30).round()} mon";
      } else {
        return "${(difference.inDays / 30).round()} mon";
      }
    } else {
      if ((difference.inDays / 365).round() > 1) {
        return "${(difference.inDays / 365).round()} y";
      } else {
        return "${(difference.inDays / 365).round()} y";
      }
    }
  }

  static String? convertViews(String currentBalance) {
    try {
      int value = int.parse(currentBalance);
      if (value > 999 && value < 1000000) {
        return (value / 1000).toStringAsFixed(1) + 'k';
      } else if (value > 1000000) {
        return (value / 1000000).toStringAsFixed(1) + 'M';
      } else{
        return value.toString();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return '';
  }

  String? _lastOnlineTime;

  String? get lastOnlineTime => _lastOnlineTime;

  convertTime(String time) {
    final now = DateTime.now();
    final decoded = jsonDecode(time);
    final data = DateTime.parse(decoded);
    var difference = now.difference(data);
    _lastOnlineTime = (difference.inDays == 0)
        ? (difference.inHours == 0)
        ? difference.inMinutes.abs().toString() + " Minutes Ago"
        : difference.inHours.abs().toString() + " Hours Ago"
        : difference.inDays.abs().toString() + " Days Ago";
  }

  static int minBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to
        .difference(from)
        .inSeconds / 60).round();
  }

  static int getDifFromNow(String date, int limitTime) {
    var startedDate = DateTime.parse(date).toLocal();
    var finishedDate = startedDate.add(Duration(minutes: limitTime));

    DateTime currentTime = DateTime.now();

    var remainingTime = finishedDate.difference(currentTime);
    return remainingTime.inSeconds;
  }

  static int getDifNow(String date) {
    var targetDate = DateTime.parse(date).toLocal();
    var createAtDateInMiliSeconds = targetDate.millisecondsSinceEpoch;
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    var inputDate = inputFormat.parse(targetDate.toString());

    DateTime time = DateTime.now();
    var currentDateInMilliSeconds = time.millisecondsSinceEpoch;

    var diff = currentDateInMilliSeconds - createAtDateInMiliSeconds;
    debugPrint(
        "diff -> $diff  $currentDateInMilliSeconds   $createAtDateInMiliSeconds");


    var diffInSec = (diff / 1000).round();
    // Duration difference = DateTime.now().difference(inputDate);
    // final fiftyDaysAgo = DateTime.now().subtract(Duration(hours: -difference.inMinutes));
    // Duration def = DateTime.now().difference(fiftyDaysAgo);
    return diffInSec;
  }

  static String getDuration(int duration) =>
      duration < 60 ? '00:' + (duration.toString()) : (duration ~/ 60)
          .toString() + ':' + (duration % 60).toString();

  static String minAndSecTime(int sec) {
    Duration duration = Duration(seconds: sec);
    int totalMinutes = duration.inMinutes;
    int minutes = totalMinutes % 60;
    int seconds = duration.inSeconds - totalMinutes * 60;
    String formattedDuration = "${minutes.toString().padLeft(2, '0')}:${seconds
        .toString().padLeft(2, '0')}";
    return formattedDuration;
  }

  static String formatMinutesAndSeconds(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    String formattedTime = '$minutes:${seconds.toString().padLeft(2, '0')}';
    return formattedTime;
  }
}