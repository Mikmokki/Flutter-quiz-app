# Device-Agnostic Design Course Project I - d474dc5b-41ab-4675-a7f4-7f1ce5aadcc3

Write your documentation for the project below.

## Name of the application

Super Quiz App

## Brief description of the application

Super Quiz App is an application in which you can answer questions from different topics. By answering those, you can gain points to your statistics page that contains correct answers per topic and in total. You can also train your weakest topics in general practice mode to become wellrounded quiz pro. Hope you have fun testing the app.

## 3 key challenges faced during the project

1. I spent way too much time on trying to fit widgets into the left side of the app bar. The problem was that the leading element has limited size leading to overflow errors.
2. Overall design. As the parent element size matters for the placement of children, it was sometimes hard to put the element to the right place.
3. I had a lot of problems with provider tests. The setup of the test app was not that simple at the start but got it eventually. Also mocking the APIs and overriding providers was a big challenging.

## 3 key learning moments from working on the project

1. I found out that the limited size of leading can be fixed by changing leadingWidth, which seems obvious afterwards.
2. With nested providers, one has to be careful how to render to remain the wanted state.
3. I found out that every provider needs to be overridden in the tests to make the component render on a proper way.

## list of dependencies and their versions

```
dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.2
  flutter_riverpod: ^2.4.0
  go_router: ^10.1.2
  http: ^1.1.0
  riverpod: ^2.4.0
  shared_preferences: ^2.2.1
  equatable: ^2.0.5

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0
  test: any
  mocktail: ^0.3.0
  http_mock_adapter: ^0.6.1
flutter:
  uses-material-design: true

```
