import 'package:flutter/material.dart';

final _icon = <String, IconData>{
  'add_alert': Icons.add_alert,
  'assignment_late':Icons.assignment_late,
  'add_box':Icons.add_box,
  'person':Icons.person,
  'assignment': Icons.assignment,
  'message': Icons.message,
  'home':Icons.home,
  'sms_failed': Icons.sms_failed,
  'person_outline':Icons.person_outline,
  'location_on': Icons.location_on,
  'add_location': Icons.add_location
};

Icon getIcon (String nombreIcono){
  return Icon(_icon[nombreIcono]);
}