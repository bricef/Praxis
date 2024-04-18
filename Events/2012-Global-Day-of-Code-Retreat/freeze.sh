#!/bin/bash

npm ls | grep -E '^.{4}\w{1}' | grep -o -E '[a-zA-Z\-]+@[0-9]+\.[0-9]+\.[0-9]+' | grep -v npm


