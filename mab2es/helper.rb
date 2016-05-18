def decode_json!(object)
  case object
  when Array
    object.map! do |_value|
      decode_json!(_value)
    end
  when Hash
    object.each do |_key, _value|
      object[_key] = decode_json!(_value)
    end
  when String
    if object.start_with?("{") && object.end_with?("}")
      JSON.parse(object)
    else
      object
    end
  else
    object
  end
end
