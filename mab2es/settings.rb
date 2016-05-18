# http://www.fullscale.co/blog/2013/03/04/preserving_specific_characters_during_tokenizing_in_elasticsearch.html
SETTINGS = {
  "index": {
    "number_of_shards": 1,
    "number_of_replicas": 2
  },
  "analysis": {
    "analyzer": {
      "default": {
        "type": "custom",
        "tokenizer": "whitespace",
        "filter": [
          "standard",
          "lowercase",
          "ubpb_pattern_replace_<",
          "ubpb_pattern_replace_>",
          "ubpb_pattern_replace_ä",
          "ubpb_pattern_replace_ö",
          "ubpb_pattern_replace_ü",
          "ubpb_pattern_replace_ß",
          "asciifolding",
          "ubpb_word_delimiter_index",
          "ubpb_stop"
        ]
      },
      "default_search": {
        "type": "custom",
        "tokenizer": "whitespace",
        "filter": [
          "standard",
          "lowercase",
          "ubpb_pattern_replace_<",
          "ubpb_pattern_replace_>",
          "ubpb_pattern_replace_ä",
          "ubpb_pattern_replace_ö",
          "ubpb_pattern_replace_ü",
          "ubpb_pattern_replace_ß",
          "asciifolding",
          "ubpb_word_delimiter_search",
          "ubpb_stop"
        ]
      },
      "minimal": {
        "type": "custom",
        "tokenizer": "whitespace",
        "filter": [
          "standard",
          "lowercase",
          "ubpb_word_delimiter_index"
        ]
      }
    },
    "filter": {
      "ubpb_pattern_replace_<": {
        "type": "pattern_replace",
        "pattern": "<",
        "replacement": ""
      },
      "ubpb_pattern_replace_>": {
        "type": "pattern_replace",
        "pattern": ">",
        "replacement": ""
      },
      "ubpb_pattern_replace_ä": {
        "type": "pattern_replace",
        "pattern": "ä",
        "replacement": "ae"
      },
      "ubpb_pattern_replace_ö": {
        "type": "pattern_replace",
        "pattern": "ö",
        "replacement": "oe"
      },
      "ubpb_pattern_replace_ü": {
        "type": "pattern_replace",
        "pattern": "ü",
        "replacement": "ue"
      },
      "ubpb_pattern_replace_ß": {
        "type": "pattern_replace",
        "pattern": "ß",
        "replacement": "ss"
      },
      "ubpb_stop": {
        "type": "stop",
        "stopwords": ["_english_", "_german_"]
      },
      "ubpb_word_delimiter_index": {
        "type": "word_delimiter",
        "catenate_all": true,
        "preserve_original": true,
        "split_on_numerics": false,
        "type_table": ["+ => ALPHA", "# => ALPHA", ". => ALPHA"]
      },
      "ubpb_word_delimiter_search": {
        "type": "word_delimiter",
        "generate_word_parts": false,
        "generate_number_parts": false,
        "catenate_all": true,
        "split_on_case_change": true,
        "preserve_original": false,
        "split_on_numerics": false,
        "stem_english_possessive": false,
        "type_table": ["+ => ALPHA", "# => ALPHA", ". => ALPHA"]
      }
    }
  }
}
