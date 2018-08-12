# ECS-D tech test (DevOps)

#### Technologies used:
For testing: 
- [rspec_sequel_matchers](rspec_sequel_matchers)
- [RSpec](https://github.com/rspec/rspec)
- [Simplecov](https://github.com/colszowka/simplecov)
- [Simplecov-console](https://github.com/chetan/simplecov-console)

For the script:
- [mysql2](https://github.com/brianmario/mysql2)
- [rubocop](https://github.com/rubocop-hq/rubocop)
- [Sequel](https://github.com/jeremyevans/sequel )


#### My notes:
1. For the purposes of this test I installed MySQL Community Server - 5.7.23
1. I am using the Sequel gem as an interface to MySQL sever. It takes 'mysql' gem as adapter to interact with MySQL. 
2. There were difficulties during the installation 'mysql' gem. Used gem 'mysql2', instead, after reading article on StackOverflow https://stackoverflow.com/questions/25344661/what-is-the-difference-between-mysql-mysql2-considering-nodejs
3. One way to initialise the DB # DB = Sequel.connect('mysql2://root:yuliya@localhost:3306/tech_test')


#### Next steps:
1. Provide for an dynamic access to the directory that will be passed as a parameter from outside.
2. Provide a dynamic access to the files that need to be run according to the version delta.


