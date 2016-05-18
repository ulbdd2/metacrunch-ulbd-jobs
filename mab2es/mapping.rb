MAPPING = {
  #_id: { # http://elasticsearch-users.115913.n3.nabble.com/Range-for-id-td4025670.html
  #  index: "not_analyzed"
  #},
  _timestamp: {
    enabled: true,
    #store: true # not needed for query, just to be able to view it with fields: ["*"]
  },
  dynamic_templates: [
    {
      cataloging_date: {
        match: "cataloging_date",
        mapping: {
          type: "date"
        }
      }
    },
    {
      nested_fields: {
        match: "additional_data|relation|secondary_form_superorder|is_part_of",
        match_pattern: "regex",
        mapping: {
          type: "object"
        }
      }
    },
    {
      minimal_analyzed_fields: {
        match: "notation|selection_code",
        match_pattern: "regex",
        mapping: {
          analyzer: "minimal"
        }
      }
    },
    {
      non_analyzed_fields: {
        match: ".+_facet|.+_sort|.+_sort2|ht_number|.+_id|id|ddc|status|superorder",
        match_pattern: "regex",
        mapping: {
          index: "not_analyzed"
        }
      }
    },
    {
      # these fields are display only or have ..._search counterparts
      non_indexed_field: {
        match: "isbn|format|link_to_toc|resource_link|signature|subject|title",
        match_pattern: "regex",
        mapping: {
          index: "no"
        }
      }
    }
  ]
}
