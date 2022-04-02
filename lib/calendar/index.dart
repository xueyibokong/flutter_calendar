import 'package:flutter/material.dart';
import 'package:dart_date/dart_date.dart';

import 'package:calendar/calendar/toospanel.dart';
import 'package:calendar/calendar/dayspanel.dart';

import 'package:calendar/calendar/fetch.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _focusDate = DateTime.now();
  Map _focusAlmanac = {
    'animal': '',
    'lMonth': '',
    'lDate': '',
    'gzDate': '',
    'gzMonth': '',
    'gzYear': '',
    'avoid': '', // 避免
    'suit': '', // 适合
    'term': '', // 节日
    'value': '' // 节气
  };
  Map _almanac = {};

  _updateFocusDate(DateTime val) async {
    if (val.getMonth != _focusDate.getMonth ||
        val.getYear != _focusDate.getYear) {
      // 月份切换
      final cAlmanacMap = await getAlmanac(val);
      setState(() {
        _almanac = cAlmanacMap;
      });
    }
    setState(() {
      _focusDate = val;
    });
    _updateFocusAlmanac(val);
    return _focusDate;
  }

  void _updateFocusAlmanac(DateTime val) async {
    setState(() {
      _focusAlmanac = _almanac[val.format('y-M-d')];
    });
  }

  getAlmanac(val) async {
    try {
      var res = await fetchAlmanacOpts(val);
      print('万年历fetch成功!');
      List cAlmanac = res['data']?[0]?['almanac'];
      Map cAlmanacMap = {};
      for (var item in cAlmanac) {
        String key = item['year'] + '-' + item['month'] + '-' + item['day'];
        cAlmanacMap[key] = item;
      }
      return cAlmanacMap;
    } catch (err) {
      return err;
    }
  }

  @override
  void initState() {
    super.initState();
    // 初始化时获取一次 almanac 数据
    getAlmanac(_focusDate).then((cAlmanacMap) {
      setState(() {
        _almanac = cAlmanacMap;
      });
      _updateFocusAlmanac(_focusDate);
    });
  }

  String _holidaySelectedVal = 'null';
  void _updateHolidaySelectedVal(String v) {
    setState(() {
      _holidaySelectedVal = v;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> happyDays = ['除夕', '春节', '劳动节', '元旦', '端午', '中秋', '国庆'];
    Color _deputyColor = const Color.fromRGBO(78, 110, 242, 1);
    String _focusAlmanacTermOrValueText = '';
    if (_focusAlmanac['term'] != null && _focusAlmanac['term'] != '') {
      _focusAlmanacTermOrValueText = _focusAlmanac['term'];
      if (happyDays.any((item) => _focusAlmanac['term'].contains(item))) {
        _deputyColor = const Color.fromARGB(255, 243, 72, 72);
      }
    } else if (_focusAlmanac['value'] != null && _focusAlmanac['value'] != '') {
      _focusAlmanacTermOrValueText = _focusAlmanac['value'];
    }
    return Scaffold(
      body: Center(
        child: Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    child: Flex(
                      direction: Axis.vertical,
                      children: [
                        ToolBar(
                          updateFocusDate: _updateFocusDate,
                          focusDate: _focusDate,
                          holidaySelectedVal: _holidaySelectedVal,
                          updateHolidaySelectedVal: _updateHolidaySelectedVal,
                        ),
                        buildWeekTitle(context),
                        ...buildDyasPanel(
                          context,
                          _focusDate,
                          _almanac,
                          _updateFocusDate,
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 140,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: _deputyColor,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 45,
                        alignment: Alignment.center,
                        child: Text(
                          _focusDate.format('y-MM-dd'),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _focusDate.format('d'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 45,
                          ),
                        ),
                      ),
                      Container(
                        height: 22,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _focusAlmanac['lMonth'] +
                              '月' +
                              _focusAlmanac['lDate'],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      Container(
                        height: 22,
                        alignment: Alignment.center,
                        child: Text(
                          '${_focusAlmanac['gzYear']} ${_focusAlmanac['animal']}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      Container(
                        height: 22,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          '${_focusAlmanac["gzMonth"]}月 ${_focusAlmanac["gzDate"]}日',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      Offstage(
                        offstage: _focusAlmanacTermOrValueText == '',
                        child: Container(
                          height: 22,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            '· $_focusAlmanacTermOrValueText',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.only(top: 10.0),
                          color: const Color.fromRGBO(255, 255, 255, 0.15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      child: const Text(
                                        '宜',
                                        style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: ListView(
                                        children: [
                                          ...(() {
                                            return _focusAlmanac['suit']
                                                .split('.')
                                                .map((item) {
                                              return Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  item,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              );
                                            });
                                          })(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      child: const Text(
                                        '忌',
                                        style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: ListView(
                                        children: [
                                          ...(() {
                                            return _focusAlmanac['avoid']
                                                .split('.')
                                                .map((item) {
                                              return Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  item,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              );
                                            });
                                          })(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
