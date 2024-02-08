import 'package:flutter/material.dart';

class UserTypeModel {
  int? id;
  String? userType;
  String? userTypeValue;
  bool? isSelected;
  Color? bgColor;
  Color? textColor;

  UserTypeModel({this.id, this.userType, this.userTypeValue, this.isSelected, this.bgColor, this.textColor});

  UserTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userType = json['userType'];
    userTypeValue = json['userTypeValue'];
    isSelected = json['isSelected'];
    bgColor = json['bgColor'];
    textColor = json['textColor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userType'] = userType;
    data['userTypeValue'] = userTypeValue;
    data['isSelected'] = isSelected;
    data['bgColor'] = bgColor;
    data['textColor'] = textColor;
    return data;
  }
}
