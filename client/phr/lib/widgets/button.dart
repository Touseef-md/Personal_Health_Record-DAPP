import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  String text;
  final Function() onPress;
  ButtonWidget({
    super.key,
    required this.text,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 10,
      ),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          fixedSize: Size(
            150,
            60,
          ),
        ),
        onPressed: () {
          onPress();
          // loginUsingMetamask(context);
        },
        child: Text(
          text,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }
}
