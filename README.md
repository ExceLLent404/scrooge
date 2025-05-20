# Scrooge — your personal accountant.

[![Ruby Code Style](https://img.shields.io/badge/Code_Style-Standard-gold?logo=ruby&logoColor=red)](https://github.com/standardrb/standard)
[![CI](https://github.com/excellent404/scrooge/actions/workflows/ci.yml/badge.svg)](https://github.com/excellent404/scrooge/actions/workflows/ci.yml)
[![Codecov](https://codecov.io/gh/ExceLLent404/scrooge/graph/badge.svg?token=TDRCIU5B6V)](https://codecov.io/gh/ExceLLent404/scrooge)

Scrooge is an app that helps you manage your personal finances.
- Track all your accounts in different currencies.
- Record your income and expenses and group them into categories.
- Find the transactions you need easily using different filters.
- View your total capital amount with up-to-date currency exchange rates.
- Find out the total amount of your income and expenses for any period, as well as by category.

[👀 View the live demo](https://scrooge.onrender.com/) (_it may take a long time on first request_)

![App screenshot](images/screenshot.png)

## 🛠️ Stack

![Ruby](https://img.shields.io/badge/Ruby_3+-white?style=flat-square&logo=ruby&logoColor=CC342D) ![Rails](https://img.shields.io/badge/Rails_7+-white?style=flat-square&logo=ruby-on-rails&logoColor=CC0000)

![Turbo](https://img.shields.io/badge/Turbo-white?style=flat-square&logo=turbo&logoColor=5CD8E5) ![Stimulus](https://img.shields.io/badge/Stimulus-white?style=flat-square&logo=stimulus&logoColor=77E8B9) ![Bulma](https://img.shields.io/badge/Bulma-white?style=flat-square&logo=bulma&logoColor=00D1B2) ![Font Awesome](https://img.shields.io/badge/Font_Awesome-white?style=flat-square&logo=fontawesome&logoColor=538DD7)

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-white?style=flat-square&logo=postgresql&logoColor=4169E1) ![Redis](https://img.shields.io/badge/Redis-white?style=flat-square&logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAxMjggMTI4Ij48cGF0aCBmaWxsPSIjQTQxRTExIiBkPSJNMTIxLjggOTMuMWMtNi43IDMuNS00MS40IDE3LjctNDguOCAyMS42LTcuNCAzLjktMTEuNSAzLjgtMTcuMyAxUzEzIDk4LjEgNi4zIDk0LjljLTMuMy0xLjYtNS0yLjktNS00LjJWNzhzNDgtMTAuNSA1NS44LTEzLjJjNy44LTIuOCAxMC40LTIuOSAxNy0uNXM0Ni4xIDkuNSA1Mi42IDExLjl2MTIuNWMwIDEuMy0xLjUgMi43LTQuOSA0LjR6Ii8+PHBhdGggZmlsbD0iI0Q4MkMyMCIgZD0iTTEyMS44IDgwLjVDMTE1LjEgODQgODAuNCA5OC4yIDczIDEwMi4xYy03LjQgMy45LTExLjUgMy44LTE3LjMgMS01LjgtMi44LTQyLjctMTcuNy00OS40LTIwLjlDLS4zIDc5LS41IDc2LjggNiA3NC4zYzYuNS0yLjYgNDMuMi0xNyA1MS0xOS43IDcuOC0yLjggMTAuNC0yLjkgMTctLjVzNDEuMSAxNi4xIDQ3LjYgMTguNWM2LjcgMi40IDYuOSA0LjQuMiA3Ljl6Ii8+PHBhdGggZmlsbD0iI0E0MUUxMSIgZD0iTTEyMS44IDcyLjVDMTE1LjEgNzYgODAuNCA5MC4yIDczIDk0LjFjLTcuNCAzLjgtMTEuNSAzLjgtMTcuMyAxQzQ5LjkgOTIuMyAxMyA3Ny40IDYuMyA3NC4yYy0zLjMtMS42LTUtMi45LTUtNC4yVjU3LjNzNDgtMTAuNSA1NS44LTEzLjJjNy44LTIuOCAxMC40LTIuOSAxNy0uNXM0Ni4xIDkuNSA1Mi42IDExLjlWNjhjMCAxLjMtMS41IDIuNy00LjkgNC41eiIvPjxwYXRoIGZpbGw9IiNEODJDMjAiIGQ9Ik0xMjEuOCA1OS44Yy02LjcgMy41LTQxLjQgMTcuNy00OC44IDIxLjYtNy40IDMuOC0xMS41IDMuOC0xNy4zIDFDNDkuOSA3OS42IDEzIDY0LjcgNi4zIDYxLjVzLTYuOC01LjQtLjMtNy45YzYuNS0yLjYgNDMuMi0xNyA1MS0xOS43IDcuOC0yLjggMTAuNC0yLjkgMTctLjVzNDEuMSAxNi4xIDQ3LjYgMTguNWM2LjcgMi40IDYuOSA0LjQuMiA3Ljl6Ii8+PHBhdGggZmlsbD0iI0E0MUUxMSIgZD0iTTEyMS44IDUxYy02LjcgMy41LTQxLjQgMTcuNy00OC44IDIxLjYtNy40IDMuOC0xMS41IDMuOC0xNy4zIDFDNDkuOSA3MC45IDEzIDU2IDYuMyA1Mi44Yy0zLjMtMS42LTUuMS0yLjktNS4xLTQuMlYzNS45czQ4LTEwLjUgNTUuOC0xMy4yYzcuOC0yLjggMTAuNC0yLjkgMTctLjVzNDYuMSA5LjUgNTIuNiAxMS45djEyLjVjLjEgMS4zLTEuNCAyLjYtNC44IDQuNHoiLz48cGF0aCBmaWxsPSIjRDgyQzIwIiBkPSJNMTIxLjggMzguM0MxMTUuMSA0MS44IDgwLjQgNTYgNzMgNTkuOWMtNy40IDMuOC0xMS41IDMuOC0xNy4zIDFTMTMgNDMuMyA2LjMgNDAuMXMtNi44LTUuNC0uMy03LjljNi41LTIuNiA0My4yLTE3IDUxLTE5LjcgNy44LTIuOCAxMC40LTIuOSAxNy0uNXM0MS4xIDE2LjEgNDcuNiAxOC41YzYuNyAyLjQgNi45IDQuNC4yIDcuOHoiLz48cGF0aCBmaWxsPSIjZmZmIiBkPSJNODAuNCAyNi4xbC0xMC44IDEuMi0yLjUgNS44LTMuOS02LjUtMTIuNS0xLjEgOS4zLTMuNC0yLjgtNS4yIDguOCAzLjQgOC4yLTIuN0w3MiAyM3pNNjYuNSA1NC41bC0yMC4zLTguNCAyOS4xLTQuNHoiLz48ZWxsaXBzZSBmaWxsPSIjZmZmIiBjeD0iMzguNCIgY3k9IjM1LjQiIHJ4PSIxNS41IiByeT0iNiIvPjxwYXRoIGZpbGw9IiM3QTBDMDAiIGQ9Ik05My4zIDI3LjdsMTcuMiA2LjgtMTcuMiA2Ljh6Ii8+PHBhdGggZmlsbD0iI0FEMjExNSIgZD0iTTc0LjMgMzUuM2wxOS03LjZ2MTMuNmwtMS45Ljh6Ii8+PC9zdmc+) ![S3](https://img.shields.io/badge/S3-white?style=flat-square&logo=amazons3&logoColor=569A31)

![RSpec](https://img.shields.io/badge/RSpec-white?style=flat-square&logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAxMjggMTI4Ij48cGF0aCBkPSJNNDcuMzA1IDEyNS44ODNjLTE2LjEyMS00LjIyNy0yOC43MDMtMTMuNjU2LTM4LjA2My0yOC41MjgtMy40NDEtNS40NjQtMy41LTcuMzk0LS4zNC0xMS4yNSAyLjM4My0yLjkxIDIuNTItMi45NCA3Ljk5My0xLjY3NSA0LjM5NCAxLjAxMSA2LjAwMyAxLjk5MiA3LjY0OCA0LjY1MiAzLjE5NSA1LjE2OCAxMi45MDIgMTMuODY3IDE4Ljc0NiAxNi43OTcgMTguMDQ3IDkuMDQ3IDQwLjAzNSA1LjMyIDU0LjE5NS05LjE4NCAzLjA4Mi0zLjE1MiA2LjIyNy03LjIzOCA2Ljk4OS05LjA4Mi43NjEtMS44NCAxLjczNC0zLjM0NyAyLjE2LTMuMzQ3LjQyNiAwIDEuNjY4IDEuOTc2IDIuNzU4IDQuMzlsMS45NzYgNC4zOSA1LjIxNS0uNjE2YzYuMDktLjcyMyA2LjA5NC0uNTUxLjEwNiA4LjQ3Mi03LjcyMyAxMS42MzMtMjIuNTIgMjEuNzc4LTM3LjE4IDI1LjQ4OS04LjYwNiAyLjE4LTIyLjgwOSAxLjk1My0zMi4yMDMtLjUwOHptMCAwIiBmaWxsPSIjNmRlMWZhIi8+PHBhdGggZD0iTTQ4LjAyMyA4MC45NDVDMzkuNzUgNzAuOTAyIDMyIDYwLjc1OCAzMC43OTcgNTguMzk1bC0yLjE5Mi00LjI5IDguODc1LTguOTE3IDguODcyLTguOTIyaDM0LjIzbDguOTMgOC45OCA4LjkzMyA4Ljk4LTIuNDA2IDQuMDg3Yy0yLjkwMiA0LjkyNS0zMS4xOTUgNDAuNzU3LTMyLjI0MiA0MC44MzUtLjQwNi4wMjgtNy41MDQtOC4xNjQtMTUuNzc0LTE4LjIwM3ptMCAwIiBmaWxsPSIjZmU0MDVmIi8+PHBhdGggZD0iTTExMS4xNTYgODQuNzkzYy0yLjA5NC00LjMxMy0yLjIzLTUuNDIyLTEuMTY0LTkuNjQ1LjY2LTIuNjI1Ljk5Ni05LjAyNy43NS0xNC4yMy0uMzc5LTcuODg3LTEuMDA4LTEwLjU4Mi0zLjgtMTYuMjU0LTYuNTItMTMuMjQ2LTE3LjMxLTIyLjQxOC0zMC41OS0yNi4wMTZsLTYuOTA3LTEuODY3IDIuNzgyLTMuNjQ4YzIuNzQyLTMuNTk0IDIuNzUzLTMuNzAzLjk2NC03LjQ1Ny0xLTIuMDk0LTEuNTU4LTQuMDYzLTEuMjQyLTQuMzhDNzMuMTAyLjE0MiA4NS4wMiAzLjUgOTIuNjggNy4xNDJjMTAuOTU4IDUuMjEgMjIuODU2IDE3LjAzIDI4LjI0MyAyOC4wNTggNy4wODYgMTQuNTEyIDguNzQ2IDI5LjQwMyA0Ljk0MSA0NC4yNzgtMS4xNzIgNC41OTMtMi4yNTQgOC40NDktMi4zOTggOC41NjYtLjE0NS4xMjEtMi40NDIuNTMxLTUuMTA2LjkxOGwtNC44MzYuNzAzem0wIDAiIGZpbGw9IiM5N2YwZmYiLz48cGF0aCBkPSJNMy4zMjggODUuMTM3Yy00LjEyMS0xMC44NC00LjE5NS0yOS41Mi0uMTYtNDEuNDAzIDguMjUtMjQuMyAzMC42MDUtNDEuNzg1IDU1LjUtNDMuNDFsOC0uNTIzIDIuNDQ1IDQuMzk0IDIuNDUgNC4zOTUtMi45MzQgNC4wODJjLTIuNzMgMy43OTctMy40NzMgNC4xNjQtMTAuNzY2IDUuMjk3LTEwLjgzNiAxLjY4Ny0xOC43NSA1LjY5NS0yNi40NzIgMTMuNDIyLTEzLjA1OSAxMy4wNTgtMTYuODAxIDI4Ljg1NS0xMS40ODUgNDguNS42MyAyLjMzMi40NDIgMi40OTYtMi4xNCAxLjg2N2wtNS4yODYtMS4yODVjLTEuOTQ5LS40NzMtMy4wMzUuMjIyLTUuMjg1IDMuMzg2TDQuMzYgODcuODQ4em0wIDAiIGZpbGw9IiM0MGRhZjQiLz48L3N2Zz4K) ![Capybara](https://img.shields.io/badge/Capybara_+_Selenium-white?style=flat-square&logo=selenium&logoColor=43B02A)

![Sidekiq](https://img.shields.io/badge/Sidekiq-white?style=flat-square&logo=sidekiq&logoColor=B1003E)

![Docker](https://img.shields.io/badge/Docker-white?style=flat-square&logo=docker&logoColor=2496ED) ![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-white?style=flat-square&logo=githubactions&logoColor=2088FF) ![Render](https://img.shields.io/badge/Render-white?style=flat-square&logo=render&logoColor=000000)

## 👨‍💻 How to run demo locally

> **Prerequisites:** You must have [Docker](https://docs.docker.com/engine/install/) and [Docker Compose](https://docs.docker.com/compose/install/) installed on your computer and approximately 2.7GB of free space.

1. Clone or download the project repository.
2. Open the project folder in the terminal.
3. Setup the application by running the following command:

```bash
docker compose run --rm web bash -c "bin/setup && yarn build && yarn build:css"
```

The first launch may take a long time (about 6 min) as it is necessary to build the application and download additional Docker images.

4. _Optional step._ Update the exchange rates if you want it to be up to date.

> You need to register on the [Open Exchange Rates](https://openexchangerates.org/signup/free) and get an `App ID`. It's free.

Create the appropriate environment variable:

```bash
cat .env.example > .env
```

and specify your `App ID` as the variable value. Then run:

```bash
docker compose run --rm web rails money:update_exchange_rates
```

5. Start the application:

```bash
docker compose run --rm --service-ports web rails server -b 0.0.0.0
```

The application will be available on [localhost:3000](http://localhost:3000/).

_Restrictions:_

1. The application will not send real emails. All sent emails are available on [/letter_opener](http://localhost:3000/letter_opener) page.
2. If you skipped the fourth step, the exchange rates will be static as defined in the [configuration](config/initializers/money.rb).

---

6. _Optional step._ Remove the application and clear the space it takes up:

> **Warning:** These commands may remove Docker-specific data you need. Use with caution.

```bash
docker compose down --remove-orphans --rmi all --volumes && \
docker builder prune && \
cd .. && rm -rf scrooge/
```
