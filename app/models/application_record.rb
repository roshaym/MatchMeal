class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  # Remove this line
  # self.table_name = 'application_records'
end
