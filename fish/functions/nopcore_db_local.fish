function nopcore_db_local --wraps='mariadb --host=localhost --port=30681 --user=root --password=Z25jkkbZav' --description 'alias nopcore_db_local mariadb --host=localhost --port=30681 --user=root --password=Z25jkkbZav'
  mariadb --host=localhost --port=30681 --user=root --password=Z25jkkbZav $argv
end
