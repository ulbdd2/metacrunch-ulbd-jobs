def get_last_record(database, user, password, table, column)
  db = Sequel.connect(database, :user=>user, :password=>password)
  result = db[table.to_sym].max(column.to_sym)
  db.disconnect
  return result
  #return "004848415"
end

def create_index(database,user,password, table, column)
  db = Sequel.connect(database, :user=>user, :password=>password)
  if !db.indexes(table.to_sym)[(table + '_' + column + '_index').to_sym]
    db.add_index(table.to_sym, column.to_sym)
  end
  db.disconnect
end

def enable_debug()
  begin
    require "pry"
    have_pry=true
  rescue LoadError
    have_pry=false
  end
  binding.pry if have_pry && ENV['DEBUG']=="1"
end