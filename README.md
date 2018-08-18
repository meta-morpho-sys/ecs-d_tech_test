# ECS-D tech test (DevOps)

#### Instructions for use:

###### To install the tech-test:
 
   ```
    $ git clone https://github.com/meta-morpho-sys/ecs-d_tech_test
    $ cd ecs-d_tech_test
    $ bundle install
   ```
 
 ###### Running
 
   ```
    Usage: ./DB_upgrade dir user host db_name db_password
   ```
   
   
 ###### Example of invoking of the script from the CL.
 
   ```
    $ ./DB_upgrade.rb db/upgrade_scripts root localhost test yuliya
   ```
 
 
 ###### To run the internal tests
   ```
    $ bundle exec rspec
   ```

#### Technologies (Ruby gems) used:
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
1. I am using the Sequel gem as an interface to MySQL server. It takes 'mysql' gem as adapter to interact with MySQL. 
2. There were difficulties during the installation 'mysql' gem. Used gem 'mysql2', instead, after reading article on StackOverflow https://stackoverflow.com/questions/25344661/what-is-the-difference-between-mysql-mysql2-considering-nodejs
3. One way to initialise the DB is

   ```
   DB = Sequel.connect('mysql2://user:password@host:port/db_name')
   ```
   
   for example:
   
   ```
   DB = Sequel.connect('mysql2://root:yuliya@localhost:3306/tech_test')
   ```


#### Next steps:
1. Refactoring and better naming.
2. Error handling
3. Progress messages

