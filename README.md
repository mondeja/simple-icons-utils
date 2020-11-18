# Usage

These scripts suppose tha:

- You have a directory named `_review` located at `simple-icons` directory root.
- You have `inkscape` installed.
- You are in Linux using Bash.

## Install

1. Install https://github.com/juanfran/svgo-inkscape
2. Replace the default `inkscape-svgo.inx` with the file in this directory.
3. Clone this repository at `simple-icons/utils`. Use next command from
 `simple-icons` directory root:
```
git clone https://github.com/mondeja/simple-icons-review-utils.git utils
```

## Scripts
### Start a review for a remote branch

```bash
bash utils/start-review.sh "<ICON NAME>" "<BRANCH USERNAME OWNER>" "<BRANCH NAME>"
```

### Scale icon to 24px size and align to center

```bash
bash utils/inkscape-scale-align-center.sh "<PATH TO ICON>" "<PATH TO OUTPUT>" 
```
