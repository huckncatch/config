# You will probably want to list this plugin as the first in your .zshrc.

# This will look for a custom profile for the local machine and each domain or
# subdomain it belongs to. (e.g. com, example.com and foo.example.com)

# Strip .local suffix if present to normalize hostname
# (e.g., both "Skuld" and "Skuld.local" will use the same profile file)
normalized_host=${SHORT_HOST%.local}

parts=(${(s:.:)normalized_host})
for i in {${#parts}..1}; do
  profile=${(j:.:)${parts[$i,${#parts}]}}
  file=$ZSH_CUSTOM/profiles/$profile
  if [ -f $file ]; then
    source $file
  fi
done
