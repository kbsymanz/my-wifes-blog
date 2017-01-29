# My Wife's Blog

This is a simple Electron app with the front-end code written in Elm 0.18 that
allows my wife to manage her blog. I wrote her blog with MetalSmith, though I
didn't take into account that although I was quite comfortable editing in
Markdown to create posts, she was not. This project is my attempt to correct
the error of my ways.

## Warning: Hard-code ahead

In order to get this done a bit faster, there are some things that are
"hard-coded" for my wife's blog such as CSS and the structure of the posts,
etc. If you use this, you will need to adjust accordingly for your needs. This
is not a general purpose blogging app.

## Installation

- Requires NodeJS so a recent LTS version of that first.
   - I like to use `nvm`[1] to manage NodeJS but use what you want.
- Run `npm install` in the top-level directory of the project.
- Install Elm: `npm install -g elm`
- Run `elm-package install`
- Run `./build`

Finally, start the application with `./run`

[1] [nvm](https://github.com/creationix/nvm)

## Setup

Before it will actually do anything, you need to use the application to set
the settings. It assumes that there is a location on a server somewhere to
which posts and images can be SFTPed and a command may be triggered via SSH to
activate the new post on the server. It is outside of the scope of this
project to specify how any of that is done - that is up to you.

There also needs to be local directories that are dedicated to post and image
files, which should be specified in the settings screen.

Finally, there are a number of SSH and security details to setup to make
remote communication with the server possible.

Note that the CSS and Template fields are not used yet.

## License

This is under the MIT license. See the LICENSE.md file for details.

