# frozen_string_literal: true

name 'pyenv'

run_list 'test::system_install'

cookbook 'pyenv', path: '.'
cookbook 'test', path: './test/fixtures/cookbooks/test'

named_run_list :system_install, 'test::system_install'
named_run_list :user_install, 'test::dokken', 'test::user_install'
named_run_list :dokken, 'test::dokken'
