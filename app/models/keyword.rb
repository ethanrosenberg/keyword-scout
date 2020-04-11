class Keyword < ApplicationRecord

  belongs_to :search
  #after_create :process_children

  #def process_children
    #trimmed_keyword =
    #words = self.base.split(/[^[[:word:]]]+/)
  #end

  def created_at
    self[:created_at].in_time_zone('Pacific Time (US & Canada)').strftime("%B %d, %Y %l:%M %p")
  end

  def updated_at
    self[:updated_at].in_time_zone('Pacific Time (US & Canada)').strftime("%B %d, %Y %l:%M %p")
  end

end
