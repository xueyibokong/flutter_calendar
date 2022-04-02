import 'package:flutter/material.dart';

class Select extends StatelessWidget {
  Select({
    Key? key,
    required this.child,
    required this.items,
    this.onChanged,
  }) : super(key: key);
  Widget child;
  List<Map<String, dynamic>> items = [];
  final onChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      offset: const Offset(0, 35),
      // elevation: 10,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
        padding: const EdgeInsets.fromLTRB(8.0, 6.0, 8.0, 0),
        height: 35,
        child: child,
        decoration: BoxDecoration(
          border: Border.all(
            // 设置单侧边框的样式
            color: const Color.fromARGB(255, 141, 141, 141),
            width: 2.0,
            style: BorderStyle.solid,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
      itemBuilder: (BuildContext context) => [
        ...items.map(
          (item) {
            return PopupMenuItem(
              height: 18,
              child: Text(
                item['label'] as String,
              ),
              value: item['value'],
            );
          },
        ).toList()
      ],
      onSelected: (v) {
        onChanged(v);
      },
    );
  }
}
