import 'package:flutter/material.dart';

class HelpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: [
              Text('#color — white, black, green, blue, ...'),
              Text('+sleep — sleep, sleepy, sleepless, ...'),
              Text('-one — one, gone, alone, ...'),
              Text('!car — car.'),
            ],
          );
        },
      ),
      icon: Icon(Icons.help_outline_outlined),
      tooltip: 'Show help',
    );
  }
}
