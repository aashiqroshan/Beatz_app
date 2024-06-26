import 'package:beatz_musicplayer/components/styles.dart';
import 'package:beatz_musicplayer/settings_pages/privacy.dart';
import 'package:beatz_musicplayer/settings_pages/share.dart';
import 'package:beatz_musicplayer/settings_pages/t&c.dart';
import 'package:beatz_musicplayer/settings_pages/version.dart';
import 'package:beatz_musicplayer/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final Refactor refactor = Refactor();
    return Scaffold(
      appBar: AppBar(
        title: const Text('SETTINGS'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          const CircleAvatar(
            maxRadius: 80,
            backgroundImage: AssetImage('assets/images/me.jpg'),
          ),
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                refactor.boldfonttxt('Dark Mode'),
                Switch(
                  value: Provider.of<ThemeProvider>(context, listen: false)
                      .isDarkMode,
                  onChanged: (value) =>
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme(),
                )
              ],
            ),
          ),
          refactor.settings(
              context: context,
              title: 'Terms & Conditions',
              icons: FontAwesomeIcons.scroll,
              pageReq: const TermsConditions()),
          refactor.settings(
              context: context,
              title: 'Privacy Policy',
              icons: FontAwesomeIcons.shieldHalved,
              pageReq: const PrivacyPolicy()),
          refactor.settings(
              context: context,
              title: 'Share App',
              icons: FontAwesomeIcons.share,
              pageReq: const Sharethis()),
          refactor.settings(
              context: context,
              title: 'Version 1.12.6',
              icons: Icons.check,
              pageReq: const Versionpage()),
        ],
      ),
    );
  }
}
