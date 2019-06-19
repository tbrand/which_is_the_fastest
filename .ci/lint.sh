RETVAL=0

if [[ ${LANGUAGE} == "csharp" ]] ; then
  sudo apt-get -qy install astyle
  find ${DIRECTORY} -type f -name '*.cs' > /tmp/list.txt
  while read file ; do
    astyle --mode=cs ${file}
    retval=$?
    if [[ $retval -ne 0 ]]; then
      RETVAL=${retval}
    fi
  done < /tmp/list.txt
  RETVAL=$?
fi

if [[ ${LANGUAGE} == "elixir" ]] ; then
  find ${DIRECTORY} -type f -name '*.exs' -or -name '*.ex' > /tmp/list.txt
  while read file ; do
    mix format ${file}
    retval=$?
    if [[ $retval -ne 0 ]]; then
      RETVAL=${retval}
    fi
  done < /tmp/list.txt
  RETVAL=$?
fi

if [[ ${LANGUAGE} == "scala" ]] ; then
  curl -Lo coursier https://git.io/coursier-cli && chmod +x coursier && sudo install coursier /usr/bin
  sudo coursier bootstrap org.scalameta:scalafmt-cli_2.12:2.0.0-RC5 \
    -r sonatype:snapshots \
    -o /usr/local/bin/scalafmt --standalone --main org.scalafmt.cli.Cli
  scalafmt ${DIRECTORY} --test
  RETVAL=$?
fi

if [[ ${LANGUAGE} == "cpp" ]] ; then
  find ${DIRECTORY} -type f -name '*.cpp' > /tmp/list.txt
  while read file ; do
    clang-format -i ${file}
    [[ ! -n `git ls-files --modified` ]]
    retval=$?
    if [[ $retval -ne 0 ]]; then
      RETVAL=${retval}
    fi
  done < /tmp/list.txt
  RETVAL=$?
fi

if [[ ${LANGUAGE} == "php" ]] ; then
  composer global require friendsofphp/php-cs-fixer
  ~/.config/composer/vendor/bin/php-cs-fixer fix php --rules=@PSR1,@PSR2
  RETVAL=$?
fi

if [[ ${LANGUAGE} == "python" ]] ; then
  pip install black
  black ${DIRECTORY} --check
  RETVAL=$?
fi

if [[ ${LANGUAGE} == "c" ]] ; then
  find ${DIRECTORY} -type f -name '*.c' > /tmp/list.txt
  while read file ; do
    echo "Linting ${file}"
    clang-format -i ${file}
    [[ ! -n `git ls-files --modified` ]]
    retval=$?
    if [[ $retval -ne 0 ]]; then
      RETVAL=${retval}
    fi
  done < /tmp/list.txt
  RETVAL=$?
fi

if [[ ${LANGUAGE} == "nim" ]] ; then
  sudo apt-get -qy install nim
  cd `mktemp -d`
  git clone https://github.com/nim-lang/Nim .
  git checkout master
  cd nimpretty
  nim c nimpretty.nim  
  find ${DIRECTORY} -type f -name '*.nim' -or -name '*.nimble'  > /tmp/list.txt
  while read file ; do
    nimpretty ${file}
    retval=$?
    if [[ $retval -ne 0 ]]; then
      RETVAL=${retval}
    fi
  done < /tmp/list.txt
  RETVAL=$?
fi

if [[ ${LANGUAGE} == "java" ]] ; then
  find ${DIRECTORY} -type f -name '*.java' > /tmp/list.txt
  while read file ; do
    clang-format --style=google ${file}
    [[ ! -n `git ls-files --modified` ]]
    retval=$?
    if [[ $retval -ne 0 ]]; then
      RETVAL=${retval}
    fi
  done < /tmp/list.txt
  RETVAL=$?
fi

if [[ ${LANGUAGE} == "objc" ]] ; then
  find ${DIRECTORY} -type f -name '*.m' > /tmp/list.txt
  while read file ; do
    clang-format -i ${file}
    [[ ! -n `git ls-files --modified` ]]
    retval=$?
    if [[ $retval -ne 0 ]]; then
      RETVAL=${retval}
    fi
  done < /tmp/list.txt
  RETVAL=$?
fi

if [[ ${LANGUAGE} == "ruby" ]] ; then
  gem install rubocop
  echo "Linting directory ${DIRECTORY} from `pwd`"
  rubocop ${DIRECTORY}
  RETVAL=$?
fi

if [[ ${LANGUAGE} == "crystal" ]] ; then
  curl -sSL https://dist.crystal-lang.org/apt/setup.sh | sudo bash
  curl -sL "https://keybase.io/crystal/pgp_keys.asc" | sudo apt-key add -
  echo "deb https://dist.crystal-lang.org/apt crystal main" | sudo tee /etc/apt/sources.list.d/crystal.list
  sudo apt-get update
  sudo apt install crystal
  crystal tool format --check ${DIRECTORY}
  RETVAL=$?
fi

if [[ ${LANGUAGE} == "go" ]] ; then
  go get golang.org/x/lint/golint
  golint -set_exit_status=true ${DIRECTORY}
  RETVAL=$?
fi

if [[ ${LANGUAGE} == "swift" ]] ; then
  swiftlint lint ${DIRECTORY}
  RETVAL=$?
fi

if [[ ${LANGUAGE} == "rust" ]] ; then
  rustup component add rustfmt --toolchain stable-x86_64-unknown-linux-gnu
  find ${DIRECTORY} -type f -name '*.rs' > /tmp/list.txt
  while read file ; do
    rustfmt --check ${file}
    retval=$?
    if [[ $retval -ne 0 ]]; then
      RETVAL=${retval}
    fi
  done < /tmp/list.txt
  RETVAL=$?
fi

if [[ ${LANGUAGE} == "javascript" ]] ; then
  npm -g install prettier
  prettier --check "${DIRECTORY}/**/*.{js,json}"
  RETVAL=$?
fi

exit ${RETVAL}
