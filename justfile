# # What's a justfile?
#
#  A modern analogue of `make` intended for use as a task runner: fewer arcane
#  behaviors and footguns, more things that work the way you'd expect from a 
#  modern programming tool --- e.g. it does some static checking, error messages
#  are often quite good, and you can pass arguments to tasks.
#
#  - https://github.com/casey/just
#  - https://just.systems/man/en/


# # How do I use just in general?
#
# ```sh
# > just --list
# Available recipes:
#     annotate src-path=default-annotate-src-path tgt-path=default-annotate-tgt-path
#     build
#     build-grammar
#     install-node-deps
#     parse src-path=default-parse-src-path tgt-path=default-parse-tgt-path
#     serve
#     watch
#     watch-grammar
# > just build
# <...>
# > just parse examples/simple.logo examples/simple-ast.logo
# <...>
# > just parse  # same as above because of defaults
# <...>
# ```


# # How do I use *this* justfile?
#
# ## Initial setup
#
# ### Nix + direnv 
# 
# The flake provisions the following dependencies of the project:
#    - nodejs 18
#    - esbuild
#    - eslint
#    - vsce
#    - the typescript compiler
# ...plus two dependencies I've added.
#    - just
#    - jq
#  
#  Finally, the `langium` npm package is not available via nixpkgs, so 
#  `just install-node-deps` --- together with `layout node` in `.envrc` --- 
#  installs that locally in ./node_modules while still making `langium`
#  available inside the flake+direnv managed shell.
# 
# ```sh
# > cd /to/repo/root
# > cp .envrc.tmpl ./.envrc
# > direnv allow
# > nix-direnv-reload
# > just install-node-deps
# ```
#
# ### Non-Nix +/- non-direnv
#
# ¯\_(ツ)_/¯ 


# To see development deps this installs (locally), run 
#   npm list -depth 0 -dev true
# from within a devShell 
install-node-deps:
  npm ci --include=dev



build:  # npm run build
  #npm run build = 
  #  npm run clean && npm run build:web && npm run build:extension
  #   where
  #     clean = shx rm -rf ./public &&
  #             shx -rf ./out
  #       where shx is an executable provided by shelljs intended to provide 
  #             cross-platform versions of Unix shell commands
  #
  #     build:web = npm run build:tsc &&
  #                 npm run prepare:public && 
  #                 npm run build:worker && 
  #                 node scripts/copy-monaco-assets.mjs
  #       where build:tsc      = tsc -b tsconfig.json
  #             prepare:public = node scripts/prepare-public.mjs
  #             build:worker   = esbuild --minify ./out/language-server/main-browser.js --bundle --format=iife --outfile=./public/minilogo-server-worker.js
  #
  #     build:extension = npm run esbuild:extension && 
  #                       npm run esbuild:ls
  #       where esbuild:extension = esbuild ./src/extension.ts --bundle --outfile=out/extension.cjs --external:vscode --format=cjs --platform=node
  #             esbuild:ls        = esbuild ./src/language-server/main.ts --bundle --outfile=out/language-server/main.cjs --format=cjs --platform=node
  npm run build


build-grammar:  # npm run langium:generate
  # npm run langium:generate = langium generate
  npm run langium:generate


watch-grammar:  # npm run langium:watch
  # npm run langium:watch = langium generate --watch
  npm run langium:watch


watch:  # npm run watch
  # npm run watch = tsc -b tsconfig.json --watch
  npm run watch


default_parse_src_path := 'examples/simple.logo'
default_parse_tgt_path := 'examples/simple-ast.logo'
parse src-path=default_parse_src_path tgt-path=default_parse_tgt_path: # (≈ npm run generate:test) ≝ ./bin/minilogo.js generate <SRC/PATH/TO/BASENAME.logo> <AST/PATH/TO/BASENAME-ast.json>
  ./bin/minilogo.js generate {{src-path}} > {{tgt-path}}


default_annotate_src_path := 'examples/simple.logo'
default_annotate_tgt_path := 'examples/simple-cmds.logo'
annotate src-path=default_annotate_src_path tgt-path=default_annotate_tgt_path:
  ./bin/minilogo.js generate-cmds {{src-path}} > {{tgt-path}}


serve:  # npm run serve
  # npm run serve = node ./out/web/app.js
  npm run serve
