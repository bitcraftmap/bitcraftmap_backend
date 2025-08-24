#!/usr/bin/env bash

read -p "Enter your email: " email
curl -X POST -vvv "https://api.bitcraftonline.com/authentication/request-access-code?email=${email}"

read -p "Enter the access code: " code
curl -X POST -vvv "https://api.bitcraftonline.com/authentication/authenticate?email=${email}&accessCode=${code}"

echo "Note : don't share the code"