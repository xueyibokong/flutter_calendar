import 'package:dart_date/dart_date.dart';

getDatesByCurrentDate(
  DateTime currentDate,
  Map almanac,
) {
  List<Map> dates = [];
  DateTime startDate = currentDate.startOfMonth;
  int startDateOfWeekDay = startDate.getWeekday;
  DateTime endDate = currentDate.endOfMonth;
  int endDateOfWeekDay = endDate.getWeekday;
  int dayLength = currentDate.getDaysInMonth;

  // pre Month
  for (var p = 1; p < startDateOfWeekDay; p++) {
    DateTime date = startDate.subDays(p);
    Map dayObject = {'inMonth': false, 'origin': date};
    dates.insert(0, dayObject);
  }

  // current Month
  for (var c = 0; c < dayLength; c++) {
    DateTime date = startDate.addDays(c);
    Map dayObject = {'inMonth': true, 'origin': date};
    dates.add(dayObject);
  }

  // next Month
  int hasLen = dates.length;
  for (var n = 1; n <= 42 - hasLen; n++) {
    DateTime date = endDate.addDays(n);
    Map dayObject = {'inMonth': false, 'origin': date};
    dates.add(dayObject);
  }

  return dates;
}
