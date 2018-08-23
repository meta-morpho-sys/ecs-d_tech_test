#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'ostruct'
require 'io/console'
require_relative '../app'


options = {}

opt_parser = OptionParser.new do |opts|
  opts.banner = 'Cool thingy: your tool to upgrade your database'.upcase
  opts.define_head 'Usage: ./upgrade_launch -d -u -h -n -p'
  opts.separator ''
  opts.separator 'Example:'
  opts.separator './upgrade_launch.rb -d ../db/upgrade_scripts -u root -h localhost -n ecs_d -p'
  opts.separator 'Password prompt:'
  opts.separator ''
  opts.separator 'Options:'

  opts.on('-d', '--dir DIR', 'Scripts directory') do |dir|
    options[:dir] = dir
  end

  opts.on('-u', '--user USER', 'User name') do |user|
    options[:user] = user
  end

  opts.on('-h', '--host HOST', 'Database hosts') do |host|
    options[:host] = host
  end

  opts.on('-n', '--db_name DB_NAME', 'Database name') do |name|
    options[:database] = name
  end

  opts.on('-p', '--db_pwd', 'Database password') do
    puts 'Password: '
    options.merge!(password: STDIN.noecho(&:gets).chomp)
  end

  opts.on_tail('-?', '--help', 'Show this message') do
    puts opts
    exit
  end
end

opt_parser.parse(ARGV)

if ARGV.length != 9
  puts ARGV.length
  puts opt_parser.help
  exit(1)
else
  p options
  db = Database.new(**options)
  db.upgrade
end
