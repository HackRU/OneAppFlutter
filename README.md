# One App Flutter

The Official HackRU Flutter App

Feel free to show some :heart: and :star: the repo to support the project.

![GitHub closed issues](https://img.shields.io/github/issues-closed/HackRU/OneAppFlutter)
![GitHub closed pull requests](https://img.shields.io/github/issues-pr-closed-raw/HackRU/OneAppFlutter)
![GitHub](https://img.shields.io/github/license/HackRU/OneAppFlutter)

<img align="right" src="./screenshots/hackru_red.png" height="200">

## Description
*What is the purpose of this project?*

A cross-platform mobile application for hackers, organizers, mentors, and sponsors at the HackRU. HackRU is a 24-hour hackathon at Rutgers University. Hackers would be able to get announcements, a QR code for checking, food, t-shirts, as well as see the schedule and map for the hackathon. Organizers & Volunteers would be able to scan hacker's qr code for check-in, food, t-shirts, etc. In backend, we utilize qr scanning data for analytics that can be used after or even during the hackathon. Any more ideas to expand this project are always welcome.

<img src="screenshots/new_design_1.png" height="420em" />
<img src="screenshots/new_design_2.png" height="420em" />

## Inspiration
*How did this project come to be?*

We had started using an inhouse hybrid mobile application to keep track of analytics to get a better idea of how certain aspects of the hackathon were running such as food consumption and optimization for checkin. This project expanded into a public native mobile application so hackers had easier access to their QR code as well as organizers with their scanners. Additional information of the hackathon were incorporated so that everyone would be able to stay up to date on events that are happeneing wherever they may be in the venue.

## Style Guide
We use `dartfmt` style guide for this project. Follow these guidelines for the IDE setup --> [Dart Formatting](https://flutter.dev/docs/development/tools/formatting)

Dartfmt: (format dart code)

$ `pub global activate dart_style`

$ `dartfmt file.dart` (for a specific file)


## Installation Guide
First, install *Flutter* and *Dart* on your machine by following these guidelines: [Get Started](https://flutter.dev/docs/get-started/install)

1. `git clone https://github.com/HackRU/OneAppFlutter.git`
2. `cd OneAppFlutter`  (find OneAppFlutter directory on your machine)
3. `flutter doctor`    (make sure everything is installed correctly)
3. `flutter pub get`   (it's like `npm install`)
4. `flutter run`       (it's like `npm start`)

### Want to Contribute?:
- Creat a new `branch` and then make a pull request.
- Make sure you follow `dartfmt` style guides as mentioned above
- Contributors should also follow [Git Style Guide](https://github.com/agis/git-style-guide)

To learn about Flutter App Development:

- [Flutter Website: https://flutter.io]
- [Libraries: https://pub.dartlang.org/]
- [Lab: Write your first Flutter app](https://flutter.io/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.io/docs/cookbook)
- [Official Documentation: (https://flutter.io/docs)], which offers tutorials,
- [Learn Flutter Class: (https://www.appbrewery.co/courses/intro-to-flutter)]
samples, guidance on mobile development, and a full API reference.
- ⭑ Working Examples+Tutorials+Libraries [https://github.com/Solido/awesome-flutter]

### Running Backend tests
1. also have command line dart installed
2. setup test users and use the test endpoint in hackru-service
3. `export LCS_USER="<username>"` for LCS_USER, LCS_PASSWORD, LCS_USER2, LCS_PASSWORD2
  - lcs user should have the director role
4. `cd lib && dart test.dart`

### For Users
* For Android: Search for `HackRU` app
* For iOS: Search for `HackRU Official` app

### Follow Us On
<a href="https://www.facebook.com/theHackRU/"><img src="https://webstockreview.net/images/facebook-clipart-favicon.png" width="40"></a>
<a href="https://www.instagram.com/thehackru/"><img src="https://i.pinimg.com/originals/a2/5f/4f/a25f4f58938bbe61357ebca42d23866f.png" width="40"></a>
<a href="https://hackru.org/"><img src="https://raw.githubusercontent.com/HackRU/OneAppFlutter/master/screenshots/appIconImage.png" width="40"></a>
