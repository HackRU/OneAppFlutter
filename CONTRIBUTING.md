## Contribution Guidelines

1. Clone the repository by doing `git clone https://github.com/HackRU/OneAppFlutter.git`
2. Open the folder you created (which is called `OneAppFlutter`) in your desired IDE (Android Studio, Visual Studio Code, Intellij, etc.)
3. Now, run the app by doing `flutter run`
4. Contributors should follow `Git Style Guide`(https://github.com/agis/git-style-guide), `Linter` (https://pub.dartlang.org/packages/linter), and `DartFmt` (https://www.dartlang.org/guides/language/effective-dart/style)
5. Creat a new `branch`, add features to the app, write detailed discription of your implementation, and then make a pull request.

### To learn about Flutter App Development:

- `Flutter Official Website`: [https://flutter.io]
- `Lab`: [Write your first Flutter app](https://flutter.io/docs/get-started/codelab)
- `Cookbook`: [Useful Flutter samples](https://flutter.io/docs/cookbook)
- `Online Documentation`: [https://flutter.io/docs], which offers tutorials,
samples, guidance on mobile development, and a full API reference.
- `Tools`: [https://www.dartlang.org/tools] for you to utilize

### Running Tests (For HackRU Architects)
1. Have command line `dart` installed
2. Setup test users and use the test endpoint in hackru-service
3. `export LCS_USER="<username>"` for LCS_USER, LCS_PASSWORD, LCS_USER2, LCS_PASSWORD2
  - lcs user should have the director role
4. `cd lib && dart test.dart`
