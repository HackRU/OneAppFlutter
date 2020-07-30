import 'package:HackRU/defaults.dart';
import 'package:HackRU/ui/pages/about_app/about.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';

void main() {
  testWidgets('About App Test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: About(),
    ));

    final findWebButton = find.widgetWithIcon(
      SocialMediaCard,
      GroovinMaterialIcons.web,
      skipOffstage: false,
    );
    final findGithubButton = find.widgetWithIcon(
      SocialMediaCard,
      FontAwesomeIcons.github,
      skipOffstage: false,
    );
    final findFacebookButton = find.widgetWithIcon(
      SocialMediaCard,
      FontAwesomeIcons.facebookSquare,
      skipOffstage: false,
    );
    final findInstagramButton = find.widgetWithIcon(
      SocialMediaCard,
      FontAwesomeIcons.instagram,
      skipOffstage: false,
    );

    expect(find.text(kAboutApp), findsOneWidget);
    expect(findWebButton, findsOneWidget);
    expect(findGithubButton, findsOneWidget);
    expect(findFacebookButton, findsOneWidget);
    expect(findInstagramButton, findsOneWidget);

    // await tester
    //     .tap(find.widgetWithIcon(SocialMediaCard, GroovinMaterialIcons.web));
    // await tester.pump();
  });
}
