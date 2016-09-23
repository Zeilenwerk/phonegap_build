# by Andrea Pavoni, http://andreapavoni.com/blog/2013/4/create-recursive-openstruct-from-a-ruby-hash/
# and Gabriel Mazetto, https://gist.github.com/brodock/fb2167d61154d9158196

require 'ostruct'

class JsonStruct < OpenStruct
  def initialize(hash = nil)
    @table = {}
    @hash_table = {}

    return unless hash
    hash.each do |k, v|
      recursive_initializer(v) if v.is_a?(Array)

      @table[k.to_sym] = (v.is_a?(Hash) ? self.class.new(v) : v)
      @hash_table[k.to_sym] = v
      new_ostruct_member(k)
    end
  end

  def to_h
    @hash_table
  end

  protected

  def recursive_initializer(item)
    item.collect! do |val|
      if val.is_a?(Hash)
        self.class.new(val)
      elsif val.is_a?(Array)
        recurse.call(val)
      else
        val
      end
    end
  end
end
