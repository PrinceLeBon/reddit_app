# reddit_app

A Flutter project to work with Reddit api and Oauth2.0 authentication
- [API documentation](https://www.reddit.com/dev/api)
- [OAuth2 with Reddit documentation](https://github.com/reddit-archive/reddit/wiki/OAuth2)

## Installation

1. Make sure you have Flutter installed on your computer.
2. Download or clone this repository to your computer.
3. Open the project in your favorite code editor.
4. Run the command `flutter pub get` in the terminal to install the dependencies.
5. Connect your mobile device or run an emulator.
6. Launch the application or run the `flutter run` command in the terminal to run the application on
   your device.

## Features

- Authentication to the Reddit API with the OAuth2 protocol (Reddit implements two Authorization
  grant, the Implicit grant flow and the Authorization Code flow. We use the Authorization Code flow
  for this project.)
  > https://github.com/PrinceLeBon/reddit_app/assets/102158487/92dda67f-f3e7-433e-80f2-04eba9ec3526
- Display the user’s profile. The bare minimum is to display the profile picture, username, and
  description.
- Display posts from the subreddits the user is subbed to
- Search for subreddits
- Display a subreddit basic information. The bare minimum is to display the name, title, number of
  subscribers, description, and header image
- Display posts from a subreddit
  > https://github.com/PrinceLeBon/reddit_app/assets/102158487/77bacf97-749b-4e4c-ab73-1503c91dbf24
- Subscribe/Unsubscribe to a subreddit
  > https://github.com/PrinceLeBon/reddit_app/assets/102158487/ea0a1742-8125-4ee4-8684-71d2f273a6c9

## Known issues

Log Out doesn't work yet

## Contribution

How to Contribute I would love to receive contributions to this project! If you would like to
contribute, please follow these steps:

- Step 1: Identify a problem or opportunity to contribute

- Step 2: Fork the deposit Once you have identified a problem or opportunity for contribution, you
  need to create your own copy of the repository (called a "fork")

- Step 3: Set up your development environment After forking the repository, you need to configure
  your development environment to be able to work on the project. Please see
  the [README.md](https://github.com/PrinceLeBon/reddit_app/blob/main/README.md) file for
  instructions on how to install dependencies and set up your environment.

- Step 4: Write code Now that you have set up your development environment, you can start writing
  code to solve the problem or add new features.

- Step 5: Submit a pull request Once you have finished writing code, you can submit a pull request
  to get your code into the main repository. To do this, you need to click the "New pull request"
  button on your fork page on Github, select your fork as the source and the main repository as the
  target, and then click the "Create pull request" button. Be sure to provide a detailed description
  of what you have done and any additional information needed to understand your contribution.

- Step 6: Discuss and integrate Other contributors and project maintainers will discuss your
  contribution and may make comments and suggestions to improve your code. Once you have received
  feedback, you can take it into account and make the necessary changes. If everything is in order,
  your contribution will be integrated into the main repository.

## License

[MIT License](https://opensource.org/licenses/MIT). This project is released under the MIT license,
which means that you can use, copy, modify and distribute the source code freely.
