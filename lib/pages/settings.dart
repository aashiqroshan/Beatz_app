import 'package:beatz_musicplayer/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SETTINGS'),
      ),
      body: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.all(25),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Dark Mode',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Switch(
                value: Provider.of<ThemeProvider>(context,listen: false).isDarkMode,
                onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme(),)
          ],
        ),
      ),
    );
  }
}
