import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class PrivacyPage extends StatefulWidget {

  @override
  PrivacyPageState createState() => PrivacyPageState();
}

class PrivacyPageState extends State < PrivacyPage > {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Privacy Policy",),
      ),
      body: SingleChildScrollView(
          child: Container(
              child:Column(
                children:<Widget>[

                  ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text("Privacy Policy", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text("Daniel, Cédric, Yassin, Iliass built the Flutter app as a Free app. This SERVICE is provided by Daniel, Cédric, Yassin, Iliass at no cost and is intended for use as is. This page is used to inform visitors regarding my policies with the collection, use, and disclosure of Personal Information if anyone decided to use my Service. If you choose to use my Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used for providing and improving the Service. we will not use or share your information with anyone except as described in this Privacy Policy. The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which is accessible at Flutter unless otherwise defined in this Privacy Policy."),
                    ),

                  ),
                  ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text("Information Collection and Use", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text("For a better experience, while using our Service, I may require you to provide us with certain personally identifiable information, including but not limited to username, email, birthday, . The information that I request will be retained on your device and is not collected by us in any way. The app does use third party services that may collect information used to identify you. Link to privacy policy of third party service providers used by the app: Google Play Service and Firebase Crashlytics"),
                    ),

                  ),

                  ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text("Log Data", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text("I want to inform you that whenever you use my Service, in a case of an error in the app I collect data and information (through third party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing my Service, the time and date of your use of the Service, and other statistics."),
                    ),

                  ),

                  ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text("Service Providers", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text("I may employ third-party companies and individuals due to the following reasons:\n-To facilitate our Service;\n-To provide the Service on our behalf.\n-To perform Service-related services; or\n-To assist us in analyzing how our Service is used.\n-I want to inform users of this Service that these third parties have access to your Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose."),
                    ),

                  ),

                  ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text("Security", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text("I value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and I cannot guarantee its absolute security."),
                    ),

                  ),

                  ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text("Changes to This Privacy Policy", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text("I may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Privacy Policy on this page. This policy is effective as of 2020-12-20"),
                    ),

                  ),

                  ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text("Contact Us", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text("If you have any questions or suggestions about my Privacy Policy, do not hesitate to contact us at firebasehelpme@gmail.com."),
                    ),

                  ),



                ],
              )
          )
      ),

    );

  }
}