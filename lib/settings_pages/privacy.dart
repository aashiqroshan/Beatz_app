import 'package:beatz_musicplayer/components/styles.dart';
import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    final Refactor refactor = Refactor();
    return Scaffold(
      appBar: AppBar(
        title: refactor.boldfonttxt('Privacy Policy'),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
              "This Privacy Policy describes how we process your personal data at Spotify AB. From now on, we'll call it the 'Policy'.\n\n"
              "It applies to your use of:\n\n"
              "• All Spotify streaming services as a user. For example this includes:\n"
              "  • Your use of Beatz on any device\n"
              "  • The personalisation of your user experience. Watch our personalisation explainer video to learn more about this\n"
              "  • The infrastructure required to provide our services\n"
              "  • Connection of your Spotify account with another application\n"
              "  • Both our free or paid streaming options (each a 'Service Option')\n"
              "• Other Beatz services which include a link to this Policy. These include Spotify websites, Customer Service, and the Community Site.\n\n"
              "From now on, we'll collectively call these the 'Beatz Service'.\n\n"
              "From time to time, we may develop new or offer additional services. They'll also be subject to this Policy, unless stated otherwise when we introduce them.\n\n"
              "This Policy is not...\n\n"
              "• The Spotify Terms of Use, which is a separate document. The Terms of Use outline the legal contract between you and Spotify for using the Spotify Service. It also describes the rules of Spotify and your user rights.\n"
              "• About your use of other Spotify services which have their own privacy policy. Other Spotify services include Anchor, Soundtrap, Megaphone, and the Spotify Live app."),
        ),
      ),
    );
  }
}
