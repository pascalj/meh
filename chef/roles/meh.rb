name "meh"
description "setup for meh development"
run_list(
  "recipe[meh::preinstall]",
  "recipe[mysql::server]",
  "recipe[git]",
  "recipe[ruby_build]",
  "recipe[rbenv::user]",
  "recipe[rbenv::vagrant]",
  "recipe[meh::postinstall]"
)
