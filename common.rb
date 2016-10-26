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


class DBReader

  def initialize(database_connection_or_url, dataset_proc, options = {})
      @rows_per_fetch = options.delete(:rows_per_fetch) || 1000
      puts @rows_per_fetch

      @db = if database_connection_or_url.is_a?(String)
        Sequel.connect(database_connection_or_url, options)
      else
        database_connection_or_url
      end
      @adapter = @db.adapter_scheme
      @dataset = dataset_proc.call(@db)
  end

  def each(&block)
    return enum_for(__method__) unless block_given?

    if @adapter==:mysql2 
      # mysql2 ignoriert strategy= filter offset wird ab 500000 Datensätzen unerträglich.
      @dataset.stream.each do |row|
        yield(row)
      end
    else
      @dataset.paged_each(:rows_per_fetch=>@rows_per_fetch) do |row|
        yield(row)
      end
    end
    
    self
  end

end
