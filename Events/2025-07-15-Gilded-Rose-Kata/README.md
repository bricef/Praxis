# Gilded Rose starting position in Python

For exercise instructions see [INSTRUCTIONS.md](./INSTRUCTIONS.md)


## Setup

Install the required dependencies

```
$ pip install -r requirements.txt
```

## Run the unit tests from the Command-Line

```
$ python -m pytest .
```

## Run the TextTest fixture from the Command-Line

For e.g. 10 days:

```
$ python fixture.py 10
```

You should make sure the command shown above works when you execute it in a terminal before trying to use TextTest (see below).

## Run the fixture tests against a golden copy

```
$ diff <(python fixture.py 10) GOLD_OUTPUT.txt
```

