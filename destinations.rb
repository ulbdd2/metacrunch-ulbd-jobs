#require "retries"
class SolrWriter
  def initialize(solr_url)
    @url = solr_url
    @solr = nil
    @docs = {:added =>0,:deleted=>0}
    #@solr = RSolr.connect :url => solr_url
  end
  
  def write(data)
    @solr = RSolr.connect :url => @url
    begin
      puts "SolrWriter.write"
      if data.is_a?(Array) then
        added = []
        deleted = []
        data.each do |dt|
          puts dt[:status]
          if dt[:status].strip=="DELETED" then
            deleted << dt[:json]
          else
            added << dt[:json]
          end
        end
        @docs[:added] = @docs[:added] + added.length
        @docs[:deleted] = @docs[:deleted] + deleted.length
        @solr.add(added, :add_attributes => {:commitWithin=>60000})
        @solr.delete_by_id(deleted, :add_attributes => {:commitWithin=>60000})
      else
        if data[:status].strip=="DELETED" then
          @docs[:deleted] = @docs[:deleted] + 1
          @solr.delete_by_id(data[:json])
        else
          @docs[:added] = @docs[:added] + 1
          @solr.add(data, :add_attributes => {:commitWithin=>60000})
        end
      end
      puts @docs
    rescue Net::ReadTimeout, Errno::EPIPE => e
      puts "SolrWriter: #{e.message}, #{data.length}"
    end
  end

  
  def close
    @solr = RSolr.connect :url => @url, :read_timeout => 720
    puts "SolrWriter.close"
    @solr.commit
    puts "SolrWriter.committed"
    #@solr.optimize
    puts "SolrWriter.optimized"
  end
end
