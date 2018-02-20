require 'active_record/connection_adapters/mysql_adapter'
class ActiveRecord::ConnectionAdapters::MysqlAdapter
 NATIVE_DATABASE_TYPES[:primary_key] = "int(11) auto_increment PRIMARY KEY"
end
