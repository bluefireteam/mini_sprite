# Mini Sprite

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

Mini sprite is a simple, matrix based format for creating 1bit styled graphics.

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis

<img src="art/logo.png" width="250" />

## Project structure

Mini Sprite is composed of several projects:

### [Mini Sprite](packages/mini_sprite)

The core package contains the engine/platform agnostic code to handle the format for the
sprites and maps.

### [Mini Sprite Editor](packages/mini_sprite_editor)

The flutter application, deployed at [https://minisprit.es](https://minisprit.es), which can be used to design sprites
and maps using the Mini Sprite format.

### [Flame Mini Sprite](packages/flame_mini_sprite)

Provides bridge methods to make it easier to use Mini Sprite inside the
[flame game engine](https://flame-engine.org).

### [Mini Treasure Quest](packages/mini_treasure_quest)

An example game made with Flame and Mini Sprite.

### Get help

Check each link provided above to read the documentation for each package.

Join Bluefire's [discord server](https://discord.gg/pxrBmy4) to ask questions to the team and the community.


## Roadmap

This is the planned roadmap for the tool.

Keep in mind that this is not "written in stone" so it can be changed as new ideas and feedback
comes into play.

Also, this roadmap does not consider bugfixes of any sort, as this is implicitly in the planning,
bug should be fixed as they are discovered (considering their tradeoff between impact and
complexity)

 
### Priorities

 - [ ] Tool stabilization and increase of code coverage: Mini Sprite had a rough couple of weeks before
 its release, some features was rushed in order to get done in time for the Midyear Flame Game Jam
 so some tests were omitted and some features could be re-organized. This is an important
 first step before we start to grown the tool.
 - [ ] Improve Map editor perfomance. One of the feedbacks received during the Game Jam, the map
 editor crashes the app if you try to create a big map (50x20 tiles).
 - [ ] Improve shortcuts support. Mini Sprite Editor already have some shortcuts, but they are very
 unstable, sometimes they work, sometimes they don't, this helps usability a lot and we should find
 a good solution for it before the editor growns more in features.
 - [ ] Create proper infrastructure for the HUB. Having the hub accessible to everybody is
 an important step towards the goal of making Mini Sprite a community powered tool.
 - [ ] Add support to animations.
