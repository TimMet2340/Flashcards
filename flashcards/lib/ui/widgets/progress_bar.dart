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
                      marker(context, false, unrememberedAmount),
                      marker(context, true, rememberedAmount),
                    ],
                  ),
                  line(context, width, progress),
                ],
              ),
            );
          } else {
            return Row(
              spacing: 7.0,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                marker(context, false, unrememberedAmount),
                line(context, width, progress),
                marker(context, true, rememberedAmount),
              ],
            );
          }
        },
      ),
    );
  }

  Padding line(BuildContext context, double width, double progress) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Stack(
        children: [
          Container(
            height: 12,
            width: width,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: width * progress,
            height: 12,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }

  Container marker(BuildContext context, bool remembered, int amount) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: remembered
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.error,
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
            color: Theme.of(context).colorScheme.onSecondary,
          ),
          Text(
            amount.toString(),
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
