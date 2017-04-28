# aegypius/repoman

repoman is a [portage](http://en.wikipedia.org/wiki/Portage_(software) tool to check
an overlay for best practice and deprecation.

It's used on [aegypius](https://github.com/aegypius/overlay) overlay to run tests on [travis-ci](https://travis-ci.org)

It should work with most of continuous integration platforms that can run docker containers.

## Volume

- /overlay

## Usage

    docker pull aegypius/repoman
    docker run -v /path/to/overlay:/overlay aegypius/repoman

You can found more information by running

    docker run -it aegypius/repoman repoman --help

## Example 

- https://travis-ci.org/aegypius/overlay
