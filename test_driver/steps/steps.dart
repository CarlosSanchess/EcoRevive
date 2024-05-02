import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

Future<FlutterDriver> getDriver() async {
  return await FlutterDriver.connect();
}

StepDefinitionGeneric GivenIAmOnTheHomePage() {
  return given<FlutterWorld>(
    'I am on the Home page',
        (context) async {
      final driver = await getDriver();
      await driver.waitFor(find.text('Home'));
      await driver.close();
    },
  );
}

StepDefinitionGeneric WhenISelectAProduct() {
  return when<FlutterWorld>(
    'I select a product',
        (context) async {
      final driver = await getDriver();
      await driver.tap(find.byValueKey('productKey'));
      await driver.close();
    },
  );
}

StepDefinitionGeneric AndIPressTheLeaveAReviewButton() {
  return and<FlutterWorld>(
    'I press the "Leave a Review" button',
        (context) async {
      final driver = await getDriver();
      await driver.tap(find.byValueKey('leaveReviewButtonKey'));
      await driver.close();
    },
  );
}

StepDefinitionGeneric AndIFillInTheReviewForm() {
  return and2<double, String, FlutterWorld>(
    'I fill in the review form with a rating of {double} stars and feedback {string}',
        (rating, feedback, context) async {
      final driver = await getDriver();
      await driver.tap(find.text(rating.toString()));
      await driver.tap(find.byValueKey('feedbackField'));
      await driver.enterText(feedback);
      await driver.close();
    },
  );
}

StepDefinitionGeneric AndISubmitTheReview() {
  return and<FlutterWorld>(
    'I submit the review',
        (context) async {
      final driver = await getDriver();
      await driver.tap(find.byValueKey('submitButton'));
      await driver.close();
    },
  );
}

StepDefinitionGeneric ThenIShouldSeeAConfirmationMessage() {
  return then1<String, FlutterWorld>(
    'I should see a confirmation message {string}',
        (message, context) async {
      final driver = await getDriver();
      await driver.waitFor(find.text(message));
      await driver.close();
    },
  );
}

