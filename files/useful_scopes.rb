module UsefulScopes
  def self.included( base )
    base.class_eval do
      if base.respond_to?(:named_scope)
        named_scope :order, lambda { |order, direction| { :order => "#{order} #{direction}" } }
        named_scope :limit, lambda { |limit| { :limit => limit } }
        named_scope :id_not_in, lambda { |ids| { :where => { :id.nin => ids } } }
        named_scope :is_is, lambda { |id| { :where => { :id => BSON::ObjectId.from_string(id) } } }
      end
    end
  end
end