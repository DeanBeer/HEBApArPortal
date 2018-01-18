module NRB
  module FromJSONHash
    def self.extended(mod)
      mod.instance_eval %Q{
        def from_json_hash(hash)
          raise RuntimeError.new("JSON_ARGS not defined in #{mod}") unless const_defined? :JSON_ARGS
          new *const_get(:JSON_ARGS).collect { |i| hash[i] }
        end
      }
    end
  end
end
