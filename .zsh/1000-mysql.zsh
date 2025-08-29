#!/bin/zsh

###
 # MySQL Configurations
 #
 # @since Jan 16, 2023
 # @since Nov 9, 2024 No longer using mysql
 ##

# Always backup my mariadb db, just in case.
mysqldump -u root --all-databases > "$HOME/.mariadb.bak.sql" 2>&1 &!

reset-mysql () {

	# Fix issue where PHP 8.1 can't access the WordPress DB.
	# mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '';"
}

