import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  // attributes
  final int total;
  final int current;
  final int rememberedAmount;
  final int unrememberedAmount;

  const ProgressBar({
    super.key,
    required this.total,
    required this.current,
    required this.rememberedAmount,
    required this.unrememberedAmount,
  });

  @override
  Widget build(BuildContext context) {
    double progress = total > 0 ? (current / total).clamp(0.0, 1.0) : 0.0;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // dynamic size regarding to the current viewport size
          double width = constraints.maxWidth * 0.5;

          if (constraints.maxWidth < 500) {
            return SizedBox(
              width: width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      marker(false, unrememberedAmount),
                      marker(true, rememberedAmount),
                    ],
                  ),
                  line(width, progress),
                ],
              ),
            );
          } else {
            return Row(
              spacing: 7.0,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                marker(false, 6),
                line(width, progress),
                marker(true, 9),
              ],
            );
          }
        },
      ),
    );
  }

  Padding line(double width, double progress) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Stack(
        children: [
          Container(
            height: 12,
            width: width,
            decoration: BoxDecoration(
              color: const Color.fromARGB(115, 96, 125, 139),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: width * progress,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }

  Container marker(bool remembered, int amount) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: remembered ? Color(0xff137D20) : Color(0xffCE0F22),
      ),
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      margin: EdgeInsets.all(5.0),
      alignment: Alignment.center,
      child: Row(
        spacing: 8.0,
        children: [
          Icon(
            remembered ? Icons.check : Icons.close,
            size: 18.0,
            color: Colors.white,
          ),
          Text(
            amount.toString(),
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
