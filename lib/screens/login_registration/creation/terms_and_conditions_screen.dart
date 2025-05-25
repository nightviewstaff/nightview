// TODO Use webView in future.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';

// Privacy Policy content in English
const String privacyPolicyEnglish = '''
Privacy Policy

Nightview is a revolutionary technology company. Our app and services—including nightlife locations, social features, event discovery, and all other services described in this privacy policy—offer intuitive, engaging, and informative ways to explore the city’s nightlife, find the best place to spend the evening, and experience the night like never before! When you use our services, you share certain information with us. Therefore, we want to be fully transparent about the data we collect, how we use it, with whom we share it, and the control options you have over it.

We have strived to formulate this privacy policy in a way that is easy and understandable for all our users, without complicated language or legal terms. Should you wish to dive deeper into the details later, you can always visit our Privacy Center. Here, we intend to provide you with a clear overview of our approach to privacy. For example, our Privacy by Product page contains specific information about the different features and links to support pages with additional guidance. Have further questions? Feel free to contact us.

1. Collected Information
At Nightview, we take your privacy seriously. To deliver our services effectively and provide you with the best user experience, we collect certain information. Here is an overview of the information we collect:
a. Information you provide directly:
- Account Information: When you create a Nightview account, we request basic information such as your name, date of birth, email address, and password.
- Profile Information: This may include your profile picture and additional information you choose to add to your profile.
- Communication: If you contact Nightview directly, e.g., via email, we collect that communication and any information you provide in that context.
b. Information we collect automatically:
- Location Data: To show you relevant nightlife spots nearby, we may collect and use precise location data from your device with your consent.
- Usage Data: This includes information about how you use the app: which places you view, which events you show interest in, and how you interact with other users.
c. Information from third parties:
- Analytics Firms: We may use external service providers to monitor and analyze the use of our service.
Please note that we always strive to collect only what is absolutely necessary to provide you with the best service. If you ever have questions or concerns about your data, you are always welcome to contact us at help@nightview.dk.

2. Use of Information
We collect information to improve our service and provide you with the most relevant and satisfying experience. Here’s how we use the collected information:
a. To deliver, maintain, and improve Nightview:
- Personalization: We use your preferences and behavior patterns to tailor our service, so you get recommendations that match your interests, such as specific nightlife spots or events.
- Communication: Information such as your email address and phone number is used to send you important notifications, news about Nightview, and to respond to your inquiries.
- Security: We use collected information to identify and prevent potential security threats.
b. To measure, analyze, and improve our service:
- Feedback: We use feedback from users to constantly develop and improve Nightview.
c. Marketing and Advertising:
- Targeted Advertising: Based on your interests and behavior in the app, you may receive tailored advertising from nightlife spots or events.
- Analysis: Using third-party analytics firms, we evaluate the effectiveness of our marketing campaigns to ensure we reach our target audience efficiently.
d. Legal Purposes:
- Compliance: We may use the collected information to comply with legal obligations and protect rights, privacy, security, and property, both for Nightview and our users.
- Law Enforcement: In certain cases, we may need to share information in response to a legal request if we believe it is necessary under the law.
When we use your information, we always do so with your security and privacy in mind. Nightview has taken measures to ensure that your information is handled confidentially and securely.

3. Sharing of Information
We believe in protecting your data. Here’s how and why we share the information we collect:
a. With Nightview Users:
- Friend Feature: If you choose to use our friend feature, certain information, such as your username and location (if enabled), may be shared with friends you’ve added on Nightview.
- Feedback and Reviews: When you provide feedback or a review of a nightlife spot, your username will be visible to other users along with your feedback or review.
b. With Third Parties:
- Service Providers: We work with certain third parties that help us improve Nightview, including cloud hosting, email delivery engines, analytics firms, and payment services. These third parties have limited access to your information only to perform these tasks on our behalf and are obligated not to disclose or use it for other purposes.
- Advertising Partners: We may share anonymous data with our advertising partners to show you relevant advertising. Your personal information, such as name or email, will not be shared.
c. Legal Reasons:
- Compliance with Law: We may share your information if we in good faith believe it is necessary to comply with an applicable law, regulation, legal process, or an enforcement request from authorities.
d. New Ownership:
- Mergers or Acquisitions: In the case of a merger, sale of company assets, financing, or acquisition of all or part of our business by another company, we may share your information with the new owner.
We will always strive to inform you if there are significant changes in how we process or share your personal information, and we will always give you the opportunity to opt out of such sharing.

4. Storage and Security of Information
Your data is a valuable resource for us, and we take the protection of this resource seriously. Here are the measures we take and the policies we follow:
a. Retention Period:
- User Data: Nightview stores your personal data as long as your account is active. If you choose to delete your account, your data will be deleted within 30 days, except for data we are legally required to retain for legal, tax, or regulatory reasons. You can always request us to delete your data by sending an email to help@nightview.dk.
b. Security Measures:
- Encryption: All data transmitted between Nightview servers and your device is encrypted using industry-standard encryption techniques.
- Access Control: Only authorized employees have access to personal information, and they are regularly trained in handling such data securely and confidentially.
c. Security Breaches:
- Quick Response: If a security breach occurs that affects your data, we will act quickly to identify the cause and take steps to prevent further unauthorized access. You will be notified as soon as possible in the event of such incidents.
d. Security Reviews and Updates:
- Regular Checks: We conduct regular security reviews and update our infrastructure and security protocols to ensure we meet industry best practices.
Rest assured that while technology and threats evolve, our commitment to protecting your data will remain unwavering.

5. Security
For Nightview, it is crucial to protect our users’ information. Here are the steps we take to ensure your data:
a. Security Protocols:
- SSL/TLS Encryption: All communications between Nightview’s application and our servers are secured using advanced SSL/TLS encryption, ensuring that unauthorized parties cannot intercept or alter data during transmission.
b. Data Center Security:
- High Security: Our servers are located in secure data centers in Europe.
c. Constant Monitoring:
- Intrusion Detection: We periodically check server activity for signs of suspicious behavior.
d. Staff Training:
- Security Education: All our employees undergo regular training in data protection and security regulations to ensure they are updated with best practices.

6. Changes to This Policy
We may update our privacy policy from time to time, and we will always inform you of significant changes.
''';

class TermsAndConditionsScreen extends StatelessWidget {
  static const id = 'terms_and_conditions_screen';

  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: black,
        title: Text('Terms & Conditions', style: kTextStyleH2),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            privacyPolicyEnglish,
            style: const TextStyle(color: white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}

class TermsAndConditionsCheckbox extends StatelessWidget {
  final bool value;
  final void Function(bool?) onChanged;

  const TermsAndConditionsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: primaryColor,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const TermsAndConditionsScreen(),
              ));
            },
            child: const Text(
              'I agree to the Terms and Conditions',
              style: TextStyle(
                color: white,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget buildTermsDialog(BuildContext context, SharedPreferences prefs) {
  return AlertDialog(
    backgroundColor: black,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: white, width: 2),
    ),
    title: Text('Terms & Conditions', style: kTextStyleH2),
    content: SizedBox(
      height: 400,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          privacyPolicyEnglish,
          style: const TextStyle(color: white, fontSize: 14),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () async {
          await prefs.setBool('agreedToTerms', true);
          Navigator.of(context).pop();
        },
        child: const Text('I Agree', style: TextStyle(color: white)),
        style: TextButton.styleFrom(foregroundColor: white),
      ),
    ],
  );
}

class TermsFullScreenDialog extends StatelessWidget {
  const TermsFullScreenDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        title: Text('Terms & Conditions', style: kTextStyleH2),
        backgroundColor: black,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('agreedToTerms', true);
              if (context.mounted) Navigator.of(context).pop();
            },
            child: const Text('I Agree', style: TextStyle(color: white)),
            style: TextButton.styleFrom(foregroundColor: white),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            privacyPolicyEnglish,
            style: const TextStyle(color: white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
