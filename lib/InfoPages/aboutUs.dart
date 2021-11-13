import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:library_app/ScreenService/AboutUsService.dart';
import 'package:library_app/ScreenService/AuthenticationService.dart';
import 'package:library_app/ScreenService/LoadingScreens/sendemail.dart';
import 'package:library_app/Services/UIServices.dart';
import 'package:library_app/variables.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

var nameController = TextEditingController(),
    emailController = TextEditingController(),
    subjectController = TextEditingController(),
    messageController = TextEditingController();
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
bool loading = false;

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    //! FUNCTION FOR SENDING EMAIL
    Future sendEmail({
      required String name,
      required String email,
      required String subject,
      required String message,
    }) async {
      final serviceId = 'service_c5gaghb';
      final templateId = 'template_gwixyuv';
      final userId = 'user_K1O3yuCrqJUEDru3j777v';
      final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
      try {
        await http.post(
          url,
          headers: {
            'origin': 'http://localhost',
            'Content-Type': 'application/json',
          },
          body: json.encode(
            {
              'service_id': serviceId,
              'template_id': templateId,
              'user_id': userId,
              'template_params': {
                'name_sender': name,
                'email_sender': email,
                'user_subject': subject,
                'message': message,
              },
            },
          ),
        );
        setState(() => loading = false);
        print('Email sent');
        nameController.text = '';
        emailController.text = '';
        subjectController.text = '';
        messageController.text = '';
      } catch (e) {
        print(e);
      }
    }

    final _formKey = GlobalKey<FormState>();

    var mainBody = Container(
      decoration: AboutUsService.screenBG,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        key: _scaffoldKey,
        body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                UIServices.makeSpace(100),
                AboutUsService.makeHeadingText("ABOUT US", 40),
                //! SCROLL VIEW
                Container(
                  margin: EdgeInsets.only(top: 50),
                  padding: EdgeInsets.only(left: 20),
                  width: double.infinity,
                  height: 550,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        AboutUsService.rowItem(
                            'assets/Animations/DeveloperAnimation.json',
                            'Development',
                            'This whole app took about 3 full month to complete and is developed by 1 guy. The development process is a gruelling experience, but the end result of this app is worth the price.',
                            30),
                        AboutUsService.rowItem(
                            'assets/Animations/OurTeamAnimation.json',
                            'Our Team',
                            'We have a list of made up team member, although this app is only made by 1 guy. I designed, code, and do all the neccessary research to get this app to a working state.',
                            50),
                        AboutUsService.rowItem(
                            'assets/Animations/vision.json',
                            'Our Vision',
                            'The goal of this app is to ensure that user will never forget a book that they have read in the past, becuase for a reader, that experience is an unpleasant one.',
                            50),
                        AboutUsService.rowItem(
                            'assets/Animations/service.json',
                            'Service',
                            'I will be handling all of the user service, or any concern that they may have. User can just send me an email, and I will respond to them to ensure a good user experience and the continual growth of this app.',
                            50),
                      ],
                    ),
                  ),
                ),
                UIServices.customDivider(Variables.themePurple),
                UIServices.makeSpace(20),
                //! OUR TEAM
                AboutUsService.makeHeadingText("Meet Our Team", 30),
                UIServices.makeSpace(30),
                Container(
                  padding: EdgeInsets.only(bottom: 30, top: 30),
                  decoration: AboutUsService.getInTouchDecor,
                  child: Column(
                    children: [
                      AboutUsService.meetTheTeamContainer(
                          'assets/images/CEO.png',
                          'Jürgen Walter',
                          'CEO & Founder',
                          20,
                          'assets/images/germany.png'),
                      AboutUsService.meetTheTeamContainer(
                          'assets/images/Co-Founder.png',
                          'Dromos Alexios',
                          'Co-Founder',
                          10,
                          'assets/images/greece.png'),
                      AboutUsService.meetTheTeamContainer(
                          'assets/images/manager.png',
                          'Ingrid Anastasia',
                          'Manager',
                          10,
                          'assets/images/norway.png'),
                      AboutUsService.meetTheTeamContainer(
                          'assets/images/developer.png',
                          'Bjørn Oddvaren',
                          'Developer',
                          15,
                          'assets/images/denmark.png'),
                      AboutUsService.meetTheTeamContainer(
                          'assets/images/developer2.png',
                          'E.Olivia Sinclair',
                          'Developer',
                          20,
                          'assets/images/canada.png'),
                    ],
                  ),
                ),
                UIServices.customDivider(Variables.themePurple),
                //! GET IN TOUCH
                UIServices.makeSpace(30),
                AboutUsService.makeHeadingText("Let's get in touch!", 30),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: AboutUsService.getInTouchDecor,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AboutUsService.makeTextField(
                            nameController, "Enter your name ..."),
                        AboutUsService.makeTextField(
                            emailController, "Enter your email ..."),
                        AboutUsService.makeTextField(
                            subjectController, "Enter subject ..."),
                        AboutUsService.makeMessageTextField(
                            messageController, "Write your message ..."),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                          ),
                          child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate() == true) {
                                setState(() => loading = true);
                                await sendEmail(
                                  name: nameController.text,
                                  email: emailController.text,
                                  subject: subjectController.text,
                                  message: messageController.text,
                                );
                              } else {
                                LoginPageService.showEmptyTextBoxPopup(context);
                              }
                            },
                            child: Text(
                              "Send!",
                              style: TextStyle(
                                color: Variables.themePurple,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                UIServices.customDivider(Variables.themePurple),
                UIServices.makeSpace(20),
                AboutUsService.makeHeadingText(
                    "Copyright © - Bunthong / 2021", 20),
                UIServices.makeSpace(20),
              ],
            ),
          ),
        ),
      ),
    );

    return loading == true ? SendEmailLoading() : mainBody;
  }
}
