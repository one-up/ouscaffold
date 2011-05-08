ouscaffold
==========

Rails3 scaffold-like generator for ou

    rails g ouscaffold:i18n
    rails g ouscaffold:layout
    rails g ouscaffold:scaffold item name:string price:integer


Customize scaffold templates
Template files copied into lib/templates/ouscaffold/erb/*.html.erb

    rails g ouscaffold:install_scaffold_templates


Scaffold with specified model

    rails g ouscaffold:scaffold Admin::Item name:string price:integer --model=Item


REFERENCES
==========

see other generators

- [rails/rails](http://github.com/rails/rails/)
- [indirect/rails3-generators](http://github.com/indirect/rails3-generators)

TODO
====

- add specs
- not to display depending generators
- implement as-draft option
- i18n except jp

