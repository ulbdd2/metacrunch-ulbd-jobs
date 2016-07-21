class SolrWriter
  def initialize(solr_url)
    @solr = RSolr.connect :url => solr_url
  end
  
  def write(data)
    if data.is_a?(Array)
      puts "Array"
      data.each_slice(1000) {|dt| @solr.add(dt)}
    else
      puts "kein Array"
      @solr.add(data)
    end
  end
  
  def close
    @solr.commit
    @solr.optimize
    @solr.close
  end
end
