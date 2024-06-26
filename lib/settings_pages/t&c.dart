import 'package:flutter/material.dart';

class TermsConditions extends StatelessWidget {
  const TermsConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
      ),
      body: const SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please read these Terms of Use (these **"Terms"**) carefully as they govern your access to Beatz\'s personalized services for streaming music and other content, including all of our websites and software applications that incorporate or link to these Terms (collectively, the "Beatz Service") and any music, videos, podcasts, or other material that is made available through the Beatz Service (the "Content").',
            ),
            SizedBox(height: 10),
            Text(
              'Access to the Beatz Service may be subject to additional terms and conditions presented by Beatz, which are hereby incorporated by this reference into these Terms.',
            ),
            SizedBox(height: 10),
            Text(
              'By signing up for, or otherwise accessing, the Beatz Service, you agree to these Terms. If you do not agree to these Terms, then you must not access the Beatz Service.',
            ),
            SizedBox(height: 10),
            Text(
              'Beatz Service Provider\nThe Beatz Service is provided by Beatz AB, Regeringsgatan 19, 111 53, Stockholm, Sweden.',
            ),
            SizedBox(height: 10),
            Text(
              'Age and eligibility requirements\nIn order to access the Beatz Service, you need to (1) be 13 years of age (or the equivalent minimum age in your home country) or older, (2) have parent or guardian consent if you are a minor in your home country; (3) have the power to enter a binding contract with us and not be barred from doing so under any applicable laws, and (4) reside in a country where the Service is available. You also promise that any registration information that you submit to Beatz is true, accurate, and complete, and you agree to keep it that way at all times. Furthermore, Beatz undertakes no liability in relation to a violation of these Terms by you. If you are a minor in your home country, your parent or guardian will need to enter into these Terms on your behalf. You can find additional information regarding minimum age requirements in the registration process. If you do not meet the minimum age requirements then Beatz will be unable to register you as a user.',
            ),
            SizedBox(height: 10),
            Text(
              '2. The Beatz Service Provided by Us\nBeatz Service Options\nWe provide numerous Beatz Service options. Certain Beatz Service options are provided free-of-charge, while other options require payment before they can be accessed (the "Paid Subscriptions"). We may also offer special promotional plans, memberships, or services, including offerings of third-party products and services. We are not responsible for the products and services provided by such third parties.',
            ),
            SizedBox(height: 10),
            Text(
              'The Unlimited Service may not be available to all users. We will explain which services are available to you when you are signing up for the services. If you cancel your subscription to the Unlimited Service, or if your subscription to the Unlimited Service is interrupted (for example, if you change your payment details), you may not be able to re-subscribe for the Unlimited Service. Note that the Unlimited Service may be discontinued in the future, in which case you will no longer be charged for the Service.',
            ),
            SizedBox(height: 10),
            Text(
              'Trials\nFrom time to time, we or others on our behalf may offer trials of Paid Subscriptions for a specified period without payment or at a reduced rate (a "Trial"). By accessing a Beatz Service via a Trial, you agree to the Beatz Premium Promotional Offer Terms.',
            ),
            SizedBox(height: 10),
            Text(
              'Third-Party Applications, Devices and Open Source Software\nThe Beatz Service may be integrated with, or may otherwise interact with, third-party applications, websites, and services ("Third-Party Applications") and third-party personal computers, mobile handsets, tablets, wearable devices, speakers, and other devices ("Devices"). Your use of such Third-Party Applications and Devices may be subject to additional terms, conditions and policies provided to you by the applicable third party. Beatz does not guarantee that Third-Party Applications and Devices will be compatible with the Beatz Service.',
            ),
            SizedBox(height: 10),
            Text(
              'Service Limitations and Modifications\nWe use reasonable care and skill to keep the Beatz Service operational and to provide you with a personalized, immersive audio experience. However, our service offerings and their availability may change from time to time and subject to applicable laws, without liability to you; for example:',
            ),
            SizedBox(height: 10),
            Text(
              'The Beatz Services may experience temporary interruptions due to technical difficulties, maintenance or testing, or updates, including those required to reflect changes in relevant laws and regulatory requirements.',
            ),
            SizedBox(height: 10),
            Text(
              'We aim to evolve and improve our Services constantly, and we may modify, suspend, or stop (permanently or temporarily) providing all or part of the Beatz Service (including particular functions, features, subscription plans and promotional offerings).',
            ),
            SizedBox(height: 10),
            Text(
              'Beatz has no obligation to provide any specific content through the Beatz Service, and Beatz or the applicable owners may remove particular songs, videos, podcasts, and other Content without notice.',
            ),
          ],
        ),
      ),
    );
  }
}
