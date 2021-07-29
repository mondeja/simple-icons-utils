# Usage

These scripts suppose that:

- You have `inkscape` installed (v1.0.0 at least).
- You are in Linux using Bash.

## Install

1. Clone this repository at `simple-icons/utils`. Use next command from
 `simple-icons` directory root:
```
git clone https://github.com/mondeja/simple-icons-review-utils.git utils
```
2. Install SVGO globally with `npm install -g svgo`

## Scripts
### Start a review for a remote branch

```bash
bash utils/start-review.sh "<ICON NAME>" "<BRANCH USERNAME OWNER>" "<BRANCH NAME>"
```

### Scale icon to 24px size and align to center

```bash
bash utils/inkscape-scale-align-center.sh "<ICON PATH>" "<OUTPUT PATH>" 
```

### Open two icons for compare them manually

```bash
bash utils/inkscape-gui-compare.sh [-c] "<BLACK ICON PATH>" "<RED ICON PATH>"
```

### Query icon dimensions

```bash
bash utils/inkscape-dimensions.sh "<ICON PATH>"
```

### Print differences between icons

```bash
bash utils/diff.sh "<PREVIOUS ICON PATH>" "<NEXT ICON PATH>"
```

## Usual workflow

Supposing that you want to review
[this pull](https://github.com/simple-icons/simple-icons/pull/3860) (Twitter
icon correction pull-requested by @service-paradis). You can follow next steps:

1. You are in another branch (could be `develop` or other). Execute:

```bash
bash utils/start-review.sh twitter service-paradis twitter-review
```

This will create the directory `_review/twitter/` and will place the original
`twitter.svg` icon inside it with the name of `original.svg`.

2. You should correct the size and the alignment of the icon. Manually with
Inkscape the following repetitive tasks are followed: block width/height scale
factor, see what is the maximum axis size (width or height), adjust that size
to 24px, go to `Object` -> `Align and distribute`, and center in both axis.
This can be automated by next command:

```bash
bash utils/inkscape-scale-align-center.sh _review/twitter/original.svg _review/twitter/autofixed.svg
```

A new icon will appear at `_review/twitter/autofixed.svg`.

3. We can now compare the pull requested icon with the autogenerated version
using GIT diffs:

```bash
bash utils/diff.sh _review/twitter/autofixed.svg icons/twitter.svg
```

4. If the paths does not match with the new version you can review it manually.
There is another script in this repository that can open both files in Inkscape,
coloring one of them in red, so you don't need to prepare the review manually:

```bash
bash utils/inkscape-gui-compare.sh _review/twitter/autofixed.svg icons/twitter.svg
```

> Note that this workflow can only be used for icons that must be corrected
only, but updates or new icons do not follows this workflow. However, you can
use some of the scripts to make easy repetitive tasks.
