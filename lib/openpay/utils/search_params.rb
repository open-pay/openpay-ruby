require 'ostruct'
module OpenpayUtils

  class SearchParams < OpenStruct

    #"?creation[gte]=2013-11-01&limit=2&amount[lte]=100"
    def to_str
      filter = '?'
      self.marshal_dump.each do |attribute, value|
        if attribute =~ /(\w+)_(gte|lte)/
          attribute = "#{$1}[#{$2}]"
        end
        filter << "#{attribute}=#{value}&"
      end
      filter.sub(/\&$/, '')
    end

    alias :to_s :to_str

  end
end
