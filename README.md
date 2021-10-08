# The Index

![Index CI/CD](https://github.com/wsloth/Index/workflows/Index%20CI/CD/badge.svg)

The Index is a simple Hacker News reader app which is focused on making you read less, by only showing you the top stories of the last 24 hours.

![screenshot of app](/docs/screenshot.png)

## Developing

1. Install Flutter
1. Clone the project
1. Restore Flutter dependencies
1. `flutter run`, select your device and go!

# Refreshing mechanism

- First time opening = setting the base time
- After 24h of opening the app, an auto-refresh will happen
- Volume number is updated each refresh, so you would have Volume no. 5 after 5 refreshes
- Timestamp of refresh becomes the edition number: _"Thursday, 12 September, 17:45 Edition"_
- Manual refresh should be a little harder to do, maybe first with a popup informing of the time until next edition

## Home layout

- Header
- "Frontpage" section (top 5/10 of the past 24 hours)
- "Around the web" section, including the rest of the articles
- "Come back tomorrow for the latest news, directly from the index!" when reaching the end
  - _(Or refresh, and get the latest directly)_

## Article detail page

- On opening an article, a webview opens (when external link)
  - If possible, scrape site for data to be rendered in the app itself. Maybe this could be done for commonly occurring providers
- Bottom sheet can slide open, revealing comment section

## TODO

- Infinite scrolling / lazy loading (https://pub.dev/packages/infinite_scroll_pagination)
- Multiple news sources ?
  - Auto-filter out duplicate articles, accumulate score
- Settings, personalisation, filtering
  - Setting when the content should be re-fetched (optionally this could happen during the first setup flow)
- Authenticating with HN/Reddit/etc
  - Post voting
  - Saving/bookmarking
- Clickthrough to user
- In app store review after x times of using the app (https://pub.dev/packages/in_app_review)
- Proper testing
