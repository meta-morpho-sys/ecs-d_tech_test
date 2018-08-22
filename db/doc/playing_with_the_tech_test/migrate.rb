ENV['DB_PWD'] = 'yuliya'

def get_num(s)
    s[/\d+/].to_i
end

def exec(sql)
    puts "EXEC SQL> #{sql}"
    `mysql -h localhost -u root -D test --password=#{ENV['DB_PWD']} -e "#{sql}"`
end

def exec_script(filename)
    puts "RUNNING SCRIPT> #{filename}"
    `mysql -h localhost -u root -D test --password=#{ENV['DB_PWD']} < #{filename}`
end

def get_scripts_to_run(dir, db_version)
   scripts = Dir.entries(dir).select {|filename| get_num(filename) > db_version }
   scripts.sort_by { |filename| get_num(filename) }
end   


def get_db_version
    version_string = exec("select version from versionTable")
    get_num(version_string)
end

def update_db_version(ver)
    exec("truncate versionTable")
    exec("insert into versionTable values ('#{ver}')")
    puts "db version updated to #{ver}"
end

def run_scripts(scripts)
    scripts.each {|filename| puts exec_script(filename) }
end

def upgrade
    current_db_version = get_db_version
    puts "Current db version is #{current_db_version}"
    
    scripts = get_scripts_to_run('.', current_db_version)
    next_version = (scripts.map {|filename| get_num(filename)}).max

    if next_version > current_db_version
        puts "Running upgrade scripts..."
        run_scripts(scripts)
        update_db_version(next_version)
    else
        puts "No scripts with version later than current db version #{current_db_version}"
    end
end

upgrade
