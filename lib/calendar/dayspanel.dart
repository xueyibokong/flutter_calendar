import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:calendar/calendar/dates_of_month.dart';

Widget buildWeekTitle(BuildContext context) {
  List _weekTitle = ['一', '二', '三', '四', '五', '六', '日'];
  List<Widget> weekTitlePanel = _weekTitle
      .map((e) => Flexible(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(3.0),
              height: 35,
              child: Text(
                e,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ))
      .toList();
  return Row(
    children: weekTitlePanel,
  );
}

List<Widget> buildDyasPanel(
  BuildContext context,
  DateTime focusDate,
  Map almanac,
  updateFocusDate,
) {
  List<Map> dates = getDatesByCurrentDate(focusDate, almanac);
  List<Widget> weekLintWidgets = [];
  for (var i = 0; i < dates.length / 7; i++) {
    int startI = i * 7;
    int endI = startI + 7;
    List<Flexible> weekLintWidget = dates.getRange(startI, endI).map(
      (e) {
        DateTime origin = e['origin'];
        Map cAlmanac = {};
        try {
          cAlmanac = almanac[origin.format('y-M-d')];
        } catch (err) {/**/}
        String cAlmanacText = '';
        if (cAlmanac['term'] != null && cAlmanac['term'] != '') {
          cAlmanacText = cAlmanac["term"];
        } else if (cAlmanac['lDate'] != null && cAlmanac['lDate'] != '') {
          cAlmanacText = cAlmanac['lDate'];
        }
        String originDate = origin.getDate.toString();
        bool isToday = origin.isToday;
        bool isFoucsDay = origin.isSameDay(focusDate);
        String cAStatus = 'null';
        if (cAlmanac['status'] != null && cAlmanac['status'] != '') {
          cAStatus = cAlmanac['status'];
        }

        return Flexible(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.all(3.0),
            child: GestureDetector(
              onTap: () {
                updateFocusDate(origin);
              },
              child: Opacity(
                opacity: e['inMonth'] ? 1 : 0.55,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                  decoration: BoxDecoration(
                    color: cAStatus == '1'
                        ? const Color.fromRGBO(247, 49, 49, 0.1)
                        : cAStatus == '2'
                            ? const Color.fromARGB(10, 0, 0, 0)
                            : const Color.fromARGB(0, 0, 0, 0),
                    border: Border.all(
                      color: isToday
                          ? const Color.fromARGB(255, 75, 124, 214)
                          : isFoucsDay
                              ? cAStatus == '1'
                                  ? const Color.fromRGBO(243, 134, 134, 1)
                                  : const Color.fromARGB(255, 192, 192, 192)
                              : const Color.fromARGB(0, 75, 124, 214),
                      width: 2.0,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 6,
                        child: (() {
                          if (cAStatus == '1') {
                            return const Text(
                              '休',
                              style: TextStyle(
                                color: Color.fromRGBO(247, 49, 49, 1),
                              ),
                            );
                          } else if (cAStatus == '2') {
                            return const Text(
                              '班',
                            );
                          }
                          return const Text('');
                        })(),
                      ),
                      Flex(
                        direction: Axis.vertical,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                originDate,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: cAStatus == '1' ||
                                          (cAStatus != '2' &&
                                              (origin.getDay == 6 ||
                                                  origin.getDay == 7))
                                      ? const Color.fromRGBO(247, 49, 49, 1)
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 20,
                            alignment: Alignment.center,
                            child: Text(
                              cAlmanacText,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ).toList();
    weekLintWidgets.add(
      Flexible(
        flex: 1,
        child: Row(children: weekLintWidget),
      ),
    );
  }
  return weekLintWidgets;
}
