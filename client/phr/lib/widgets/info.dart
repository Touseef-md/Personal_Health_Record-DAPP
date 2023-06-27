import 'package:flutter/material.dart';

class InfoWidget extends StatelessWidget {
  final String text;

  const InfoWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(
          20,
        ),
      ),
      height: 60,
      width: 350,
      alignment: Alignment.center,
      // color: Colors.black,
      // margin: EdgeInsets.symmetric(horizontal: 5),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
            // height: 2,
            ),
      ),
    );
  }
}
