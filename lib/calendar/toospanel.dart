import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dart_date/dart_date.dart';

import 'package:calendar/calendar/fetch.dart';

class ToolBar extends StatefulWidget {
  const ToolBar({
    Key? key,
    required this.updateFocusDate,
    required this.focusDate,
    required this.holidaySelectedVal,
    required this.updateHolidaySelectedVal,
  }) : super(key: key);
  final DateTime focusDate;
  final String holidaySelectedVal;
  final updateFocusDate;
  final updateHolidaySelectedVal;

  @override
  State<ToolBar> createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> {
  late Map sourceData = {};
  late List years = [];
  late Map hOfYearMap = {};
  late List hOfYear = [];

  void yearSelectFn(int v) {
    widget.updateFocusDate(widget.focusDate.setYear(v));
    widget.updateHolidaySelectedVal('null');
    print(v);
    setState(() {
      hOfYear = hOfYearMap[v.toString()];
    });
    print(hOfYear);
  }

  void monthSelectFn(int v) {
    widget.updateFocusDate(widget.focusDate.setMonth(v));
    widget.updateHolidaySelectedVal('null');
  }

  void holidaySelectFn(String v) {
    widget.updateHolidaySelectedVal(v);
    if (v == 'null') {
      return;
    }
    List<String> ymd = v.split('-');
    widget.updateFocusDate(
      DateTime(int.parse(ymd[0]), int.parse(ymd[1]), int.parse(ymd[2])),
    );
  }

  void backToday() async {
    DateTime fDate = await widget.updateFocusDate(DateTime.now());
    widget.updateHolidaySelectedVal('null');
    setState(() {
      hOfYear = hOfYearMap[fDate.getYear.toString()];
    });
  }

  @override
  void initState() {
    super.initState();
    print('init State');
    fetchHolidaysTitleOpts().then(
      (res) {
        print('数据fetch成功!');
        setState(() {
          sourceData = res['data'][0];
          sourceData['holiday'].forEach((item) {
            String year = item['list']?[0]?['date'].substring(0, 4);
            hOfYearMap[year] = item['list'];
            years.add(int.parse(year));
          });
          hOfYear = hOfYearMap[widget.focusDate.getYear.toString()];
        });
      },
    ).catchError((err) {
      print('数据fetch失败!$err');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 10, 4, 10),
      child: Row(
        children: [
          buildYearSelect(),
          IconButton(
            iconSize: 14,
            splashRadius: 18,
            hoverColor: const Color.fromRGBO(0, 0, 0, 0),
            highlightColor: const Color.fromRGBO(0, 0, 0, 0),
            color: const Color.fromARGB(206, 172, 172, 172),
            onPressed: () {
              widget.updateFocusDate(widget.focusDate.subMonths(1));
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
            ),
          ),
          buildMonthSelect(),
          IconButton(
            iconSize: 14,
            splashRadius: 18,
            hoverColor: const Color.fromRGBO(0, 0, 0, 0),
            highlightColor: const Color.fromRGBO(0, 0, 0, 0),
            color: const Color.fromARGB(206, 172, 172, 172),
            onPressed: () {
              widget.updateFocusDate(widget.focusDate.addMonths(1));
            },
            icon: const Icon(
              Icons.arrow_forward_ios,
            ),
          ),
          Expanded(flex: 1, child: buildHolidaySelect()),
          InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(6.0)),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 238, 238, 238),
                  borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  border: Border.all(
                    color: const Color.fromARGB(86, 168, 168, 168),
                  )),
              child: const Text(
                '回到今天',
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 42, 42, 42),
                ),
              ),
            ),
            onTap: () {
              backToday();
            },
          ),
        ],
      ),
    );
  }

  Widget buildYearSelect() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
      width: 120,
      child: DropdownButtonFormField(
        style: const TextStyle(
          fontSize: 14,
          color: Color.fromARGB(255, 42, 42, 42),
        ),
        focusColor: const Color.fromRGBO(1, 1, 1, 0),
        decoration: const InputDecoration(
          isCollapsed: true,
          contentPadding: EdgeInsets.all(8.0),
          label: Text('Holiday'),
          border: OutlineInputBorder(),
        ),
        value: widget.focusDate.getYear,
        items: years
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text('$e月'),
              ),
            )
            .toList(),
        onChanged: (Object? value) {
          yearSelectFn(value as int);
        },
      ),
    );
  }

  Widget buildMonthSelect() {
    List<int> list = List.generate(12, (int v) => v + 1);
    return Container(
      width: 115,
      padding: const EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
      child: DropdownButtonFormField(
        style: const TextStyle(
          fontSize: 14,
          color: Color.fromARGB(255, 42, 42, 42),
        ),
        focusColor: const Color.fromRGBO(1, 1, 1, 0),
        decoration: const InputDecoration(
          isCollapsed: true,
          contentPadding: EdgeInsets.all(8.0),
          label: Text('Month'),
          border: OutlineInputBorder(),
        ),
        value: widget.focusDate.getMonth,
        items: list
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text('$e月'),
              ),
            )
            .toList(),
        onChanged: (Object? value) {
          monthSelectFn(value as int);
        },
      ),
    );
  }

  Widget buildHolidaySelect() {
    List<DropdownMenuItem<Object>> items = hOfYear.map(
      (e) {
        return DropdownMenuItem(
          value: e['date'],
          child: Text(e['name']),
        );
      },
    ).toList();
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 0, 25, 0),
      child: DropdownButtonFormField(
        style: const TextStyle(
          fontSize: 14,
          color: Color.fromARGB(255, 42, 42, 42),
        ),
        focusColor: const Color.fromRGBO(1, 1, 1, 0),
        decoration: const InputDecoration(
          isCollapsed: true,
          contentPadding: EdgeInsets.all(8.0),
          label: Text('Holiday'),
          border: OutlineInputBorder(),
        ),
        value: widget.holidaySelectedVal,
        items: [
          const DropdownMenuItem(
            value: 'null',
            child: Text('假期安排'),
          ),
          ...items
        ],
        onChanged: (Object? value) {
          holidaySelectFn(value as String);
        },
      ),
    );
  }
}
