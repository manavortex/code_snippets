class Model < AbstractModel

  # courtesy of http://stackoverflow.com/questions/14124212/remove-duplicate-records-based-on-multiple-columns/34738011#34738011
  def self.dedupe
	duplicate_values = 'value1, value2'
    duplicate_row_values = Model.select(duplicate_values).group(duplicate_values).pluck(:value1, :value2)

    # load the duplicates and order however you wantm and then destroy all but one
    duplicate_row_values.each do |value1, value2|
      Model.where(value1: value1, value2: value2).order(id: :desc)[1..-1].map(&:destroy)
    end

  end

end
