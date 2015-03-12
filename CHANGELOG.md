## 2.1.4

* Fix munit self-test dependency in package.js (nothing important)

## 2.1.3

* Update practicalmeteor:loglevel dependency to 1.2.0_1
* api.imply practicalmeteor:loglevel
* Change default timeouts from 5 seconds to 30 seconds

## 2.1.2

* Rename package from spacejamio:munit to practicalmeteor:munit.

## 2.1.1

* Fix documentation and update changelog.

## 2.1.0

* Fix async describe tests to enable reporting of exceptions in async callbacks.

## 2.0.2

* Fix nested describes issues.

## 2.0.1

* Fix practicalmeteor:chai settings bug.

## 2.0.0

* Update README to fix documentation bug regarding async tests, where usage description was incorrect.
* Update practicalmeteor:chai and practicalmeteor:sinon dependencies to latest versions.
* Update required meteor version to 0.9.3
* Update README to include only JavaScript examples and add tests for all the examples in the README.

### Breaking changes

* Remove the try property from 'it' tests, since it is actually not needed, and it's usage and documentation were incorrect.

## 1.0.0

* Update required meteor version to 0.9.0
* Add package to meteor new packaging system
