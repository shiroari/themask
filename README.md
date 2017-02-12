# The Mask

The Mask is a simple avatar maker engine based on scalable vector graphics (SVG). 

## How to build

```
$elm package install
$elm make src/app.elm --output dist/elm.js
```

## How to add new features

All the parts are stored under `dist/assets/svg/` folder and divided into subfolders:

* /face
* /eyes
* /eyebrows
* /nose
* /mouth

### Adding a new feature

You can add a new feature in svg format into one of the feature folders with name 00X.svg.
Name must be index from 1 to 999 without any gaps between next and privious index.
Default width and height are 240px.

Then find function `getPalette` in `app.elm` add set `presetSize` to last file index.

For example:

`file /face/001.svg`

```
<svg width="240" height="240" xmlns="http://www.w3.org/2000/svg">
    <path stroke-width="4" stroke="#666" fill="rgb(255, 234, 189)" d="M70 140 C 53 200, 187 200, 170 140"></path>
    <path stroke-width="4" stroke="#666" fill="rgb(255, 234, 189)" d="M70 140 C 43 30, 197 30, 170 140"></path>
</svg>
```

### Adding a new type of feature

In order to add new type of feature you need to create new feature folder and new feature type in `app.elm` file.
Start from adding a new item in tagged union `Feature` and a new case in `getPalette` function for a new type.

Palette type has fields:

* name - The feature type title.
* required - Defines if 
* path - The feature folder started from `/` (e.g. `/eyes`).
* presetSize - Number of svg files in feature folder.
* size - Number of feature variants. If `presetSize` is greater then `size` then engine will try to generate new variants. If you don't need it just make it equals to `presetSize`.

Then follow compilation hints and add all necessary cases in other function.
