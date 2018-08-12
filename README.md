# ECS-D tech test (DevOps)


#### My notes:
1. For the purposes of this test I installed MySQL Community Server - 5.7.23
1. I am using the Sequel gem as an interface to MySQL sever.
2. Had some difficulties while trying to install 'mysql' gem to use as adapter for 'Sequel' gem to interact with MySQL database server. Used gem 'mysql2', instead, after reading article on StackOverflow https://stackoverflow.com/questions/25344661/what-is-the-difference-between-mysql-mysql2-considering-nodejs
3. One way to initialise the DB # DB = Sequel.connect('mysql2://root:yuliya@localhost:3306/tech_test')

#### Next steps:
