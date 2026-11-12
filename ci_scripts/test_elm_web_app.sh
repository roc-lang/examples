#!/usr/bin/env bash

# End-to-end test of examples/ElmWebApp: runs the Roc backend, serves the Elm frontend with
# elm reactor and checks with headless Firefox that the page shows the message from the backend.
# Usage: ./ci_scripts/test_elm_web_app.sh
# Expects examples/ElmWebApp/backend and examples/ElmWebApp/frontend/elm.js to be built.
# Requires firefox, geckodriver, curl and jq.

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

elm="$(./ci_scripts/get_elm.sh)"
readonly elm

cd examples/ElmWebApp

readonly expected="Hi, Elm! This is from Roc: 🎁"
readonly webdriver="http://localhost:4444"

# Firefox logs a lot of noise, so its output is only shown if the test fails.
geckodriver_log="$(mktemp)"
readonly geckodriver_log

pids=()
session=""
cleanup() {
  local status=$?
  if [ -n "$session" ]; then
    curl --silent --request DELETE "$webdriver/session/$session" >/dev/null || true
  fi
  kill "${pids[@]}" 2>/dev/null || true
  if [ "$status" -ne 0 ]; then
    echo "geckodriver and Firefox output:" >&2
    cat "$geckodriver_log" >&2
  fi
  rm -f "$geckodriver_log"
}
trap cleanup EXIT

./backend &
pids+=("$!")
(cd frontend && exec "$elm" reactor --port 8001) &
pids+=("$!")
geckodriver --port 4444 --log warn >"$geckodriver_log" 2>&1 &
pids+=("$!")

# get URL [CURL_ARGS...], retries until the server is up
get() {
  curl --fail --silent --show-error --retry 20 --retry-connrefused --retry-delay 1 "$@"
}

# webdriver METHOD PATH [JSON_BODY], see https://www.w3.org/TR/webdriver2/
webdriver() {
  local args=(--fail-with-body --silent --show-error --request "$1" "$webdriver$2")
  if [ "$#" -gt 2 ]; then
    args+=(--header "Content-Type: application/json" --data "$3")
  fi
  curl "${args[@]}"
}

# The backend must allow the origin of the frontend, otherwise the browser blocks the response.
headers="$(get http://localhost:8000 --dump-header - --output /dev/null)"
if ! grep -qi "^access-control-allow-origin: http://localhost:8001" <<<"$headers"; then
  echo "Error: backend response lacks the expected CORS header:" >&2
  echo "$headers" >&2
  exit 1
fi

get http://localhost:8001/index.html --output /dev/null
get "$webdriver/status" --output /dev/null

session="$(webdriver POST /session '{"capabilities":{"alwaysMatch":{"moz:firefoxOptions":{"args":["-headless"]}}}}' | jq -r .value.sessionId)"
webdriver POST "/session/$session/url" '{"url":"http://localhost:8001/index.html"}' >/dev/null

# The page shows "Loading..." until the backend has responded.
text=""
for _ in $(seq 50); do
  text="$(webdriver POST "/session/$session/execute/sync" '{"script":"return document.body.innerText","args":[]}' | jq -r .value)"
  if [ "$text" = "$expected" ]; then
    echo "The Elm frontend shows: $text"
    exit 0
  fi
  sleep 0.2
done

echo "Error: expected the page to show \"$expected\", but it shows: $text" >&2
exit 1
