import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'steps/steps.dart';

void main() {
  final config = FlutterTestConfiguration()
    ..features = [RegExp('test_driver/features/user_rating.feature')]
    ..stepDefinitions = [
      GivenIAmOnTheHomePage(),
      WhenISelectAProduct(),
      AndIPressTheLeaveAReviewButton(),
      AndIFillInTheReviewForm(),
      AndISubmitTheReview(),
      ThenIShouldSeeAConfirmationMessage(),
    ]
    ..reporters = [ProgressReporter()]
    ..restartAppBetweenScenarios = true
    ..targetAppPath = "test_driver/run_tests.dart";

  GherkinRunner().execute(config);
}
