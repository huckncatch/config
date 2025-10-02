# node
if [[ "$DEBUG_STARTUP" == "1" ]]; then
  echo ${0:A}
fi

if [[ -o interactive ]]; then
  # node package manager
  alias nrt='npm run transpile'
  alias nrs='npm run start'
  alias nrts='nrt && nrs'
  alias nrtest='npm run test'

  alias npmlatest='npm install -g npm@latest'
fi
