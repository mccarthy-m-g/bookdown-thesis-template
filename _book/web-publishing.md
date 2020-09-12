# Web Publishing

One of the easiest ways to share and get feedback on your thesis is by publishing it as its own website. bookdown---in tandem with GitHub and Netlify---makes this easy to do, even if you don't have prior experience with web publishing:

1. Complete Steps 1-6 in [Getting Started With Git][With Git (Recommended)].
2. Create a Netlify account, using your GitHub account to sign up.
3. Create a new Netlify site without connecting to Git by dragging an empty folder into the "Want to deploy a new site without connecting to Git? Drag and drop your site folder here" box.
4. Add your [Netlify API ID](https://docs.netlify.com/cli/get-started/#link-with-an-environment-variable) and a [Netlify Authorization Token](https://docs.netlify.com/cli/get-started/#obtain-a-token-in-the-netlify-ui) to your [GitHub Secrets](https://docs.github.com/en/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets) in your repository.
5. Delete the `renv` folder from the project, install the renv package `install.packages("renv")`, run `renv::snapshot()` locally, then commit the `renv.lock` file to your repository.
6. GitHub Actions???

## GitHub Actions with renv

```{}
# from https://github.com/DavisVaughan/r-extensions/blob/master/.github/workflows/bookdown.yaml
on:
  push:
    branches: master

name: bookdown

jobs:
  build:
    runs-on: ${{ matrix.config.os }}
    name: ${{ matrix.config.os }} (${{ matrix.config.r }})

    strategy:
      fail-fast: false
      matrix:
        config:
          - {os: macOS-latest, r: '4.0.0'}
    
    steps:
      - name: Checkout repo
        uses: actions/checkout@master

      - name: Setup R
        uses: r-lib/actions/setup-r@master
        with:
          r-version: ${{ matrix.config.r }}

      - name: Install pandoc and pandoc citeproc
        run: |
          brew install pandoc
          brew install pandoc-citeproc
      
      - name: Cache Renv packages
        uses: actions/cache@v1
        with:
          path: ~/Library/Application Support/renv
          key: r-3-${{ hashFiles('renv.lock') }}
          restore-keys: r-3-

      - name: Cache bookdown results
        uses: actions/cache@v1
        with:
          path: _bookdown_files
          key: bookdown-${{ hashFiles('**/*Rmd') }}
          restore-keys: bookdown-

      - name: Install packages
        run: |
          R -e 'install.packages("renv")'
          R -e 'renv::restore()'
          
      - name: Install PhantomJS
        run: R -e 'webshot::install_phantomjs()'
      
      - name: Build site
        run: Rscript -e 'bookdown::render_book("index.Rmd", quiet = TRUE)'

      - name: Install npm
        uses: actions/setup-node@v1

      - name: Deploy to Netlify
        # NETLIFY_AUTH_TOKEN and NETLIFY_SITE_ID added in the repo's secrets
        env:
          NETLIFY_AUTH_TOKEN: ${{ secrets.NETLIFY_AUTH_TOKEN }}
          NETLIFY_SITE_ID: ${{ secrets.NETLIFY_SITE_ID }}
        run: |
          npm install netlify-cli -g
          netlify deploy --prod --dir _book
```

## GitHub Actions without renv

```{}
on:
  push:
    branches: master

name: bookdown

jobs:
  build:
    runs-on: macOS-latest
    env:
      GITHUB_PAT: ${{ secrets.GITHUB_TOKEN }}
    steps:
      - name: Checkout repo
        uses: actions/checkout@v2

      - name: Setup R
        uses: r-lib/actions/setup-r@master

      - name: Install pandoc and pandoc citeproc
        run: |
          brew install pandoc
          brew install pandoc-citeproc

      - name: Cache Renv packages
        uses: actions/cache@v1
        with:
          path: $HOME/.local/share/renv
          key: r-${{ hashFiles('renv.lock') }}
          restore-keys: r-

      - name: Cache bookdown results
        uses: actions/cache@v1
        with:
          path: _bookdown_files
          key: bookdown-${{ hashFiles('**/*Rmd') }}
          restore-keys: bookdown-

      - name: Install packages
        run: |
          R -e 'install.packages("renv")'
          R -e 'renv::restore()'

      - name: Build site
        run: Rscript -e 'bookdown::render_book("index.Rmd", quiet = TRUE)'

      - name: Install npm
        uses: actions/setup-node@v1

      - name: Deploy to Netlify
        # NETLIFY_AUTH_TOKEN and NETLIFY_SITE_ID added in the repo's secrets
        env:
          NETLIFY_AUTH_TOKEN: ${{ secrets.NETLIFY_AUTH_TOKEN }}
          NETLIFY_SITE_ID: ${{ secrets.NETLIFY_SITE_ID }}
        run: |
          npm install netlify-cli -g
          netlify deploy --prod --dir _book
```
